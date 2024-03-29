## Search for the USS Scorpion in a 400-cell region

## Establish tent-shaped prior probability distribution over 400 cells
x  <- seq(0.001,0.999,length.out=400)
op  <- ((x<=0.5)*4*x + (x>0.5)*(4-4*x)) / sum(((x<=0.5)*4*x + (x>0.5)*(4-4*x)))

## Secretly place the USS Scorpion 
Y  <- rep(0,400)
## According to the priors
Y[min(which(runif(1) < cumsum(op)))]  <- 1
## Or alternatives
## Y[1]  <- 1
## Y[int(400*runif(1)+1)]  <- 1

plot(op,main="Priors: density")
points(which(Y==1),op[which(Y==1)], col="yellow", bg="yellow", pch=21)
dev.new()
plot(cumsum(op),main="Priors: cumulative")
dev.new()


## Undetected at the start
Z  <- rep(0,400)

## Constant probability of detection on a search in a positive cell
dpa  <- 0.46
## dp  <- rep(dpa,400)
## Variable probability of detection on a search in a positive cell
## Try playing with dp to make some searches "more costly" (lower
## probability of detection in a positive cell) than others
## with average probability as above
dp  <- seq(dpa-0.20,dpa+0.20,length.out=400)
plot(dp,ylim=c(0,1), main="Detection Probability if Present")
dev.new()


## Track the history of occurrence probability for every cell
progress  <- op
## Track the number of searches of each cell
cellsearches  <- Z
## Track the total number of cells searched
search = 0 


## Search the most probable cell
## Stop if detected, otherwise update probabilities and continue
while(max(Z)==0) {
    search = search + 1                                           ## Update search count
    (curcell  <- min(which(op==max(op))))                         ## Most probable cell (lower numbered cell if tied)
    plot(op,main="Updated probability density")                   ## Show current state of occurrence probabilities
    points(curcell,op[curcell],col="red", bg="red", pch=21)       ## Highlight current cell
    points(which(Y==1),op[which(Y==1)], col="yellow", bg="yellow", pch=21)
    cellsearches[curcell] = cellsearches[curcell] + 1             ## Update count of cell searches
    Z[curcell]  <- ifelse(Y[curcell]*(runif(1)<dp[curcell]),1,0)  ## Do we find the Scorpion in the current cell?
                                                                  ## If Scorpion not found, update probabilities
    if(max(Z)==0){
        op1  <- (1 - dp[curcell]) * op[curcell] /  (1 - dp[curcell] * op[curcell])
        op  <- op / (1 - dp[curcell] * op[curcell])
        op[curcell]  <- op1
        progress = rbind(progress,op)                             ## Update history of occurrence probabilities
    }
}

dev.new()
plot(op,main="Updated probability density")                       ## Show current state of occurrence probabilities
points(curcell,op[curcell],col="red", bg="red", pch=21)           ## Highlight current cell

print("Gotcha!")
curcell
search
cellsearches[curcell]
## cellsearches
dev.new()
plot(progress[,curcell], main="History of probabilities for the actual location", ylab="Probability")
dev.new()
plot(cellsearches, main="Number of searches for each cell")
points(curcell,cellsearches[curcell],col="red", bg="red", pch=21) ## Highlight current cell
