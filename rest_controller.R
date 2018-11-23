# make the model
source("make_model.R")

#* @get /get_products
get_products <- function(mmid){

mmid <- as.integer(mmid)

CustomerId <- CustomerId[as.integer(names(recc_predicted@items)), V1 := .I]

rn <- as.integer(CustomerId[CustomerID == mmid][,2])

vvv <- recc_predicted@items[[rn]]

vvv <- rownames(model_details$sim)[vvv]

products <- itemCode[vvv]

products[StockCode %in% kampanjvaror]$StockCode
}
