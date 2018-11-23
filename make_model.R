# make model
library(recommenderlab)
library(data.table)
data <- fread("data.csv")

df_train_ori <- dcast(data, CustomerID ~ StockCode,
                      value.var = 'Quantity', fun.aggregate = sum, fill = 0)

CustomerId <- df_train_ori[,1]

df_train_ori <- df_train_ori[, -c(1,3504:3508)]

for (i in names(df_train_ori))
  df_train_ori[is.na(get(i)), (i):=0]

setkeyv(data, c('StockCode', 'Description'))
itemCode <- unique(data[, c('StockCode')])
setkeyv(data, NULL)

kampanjvaror <- sample(itemCode$StockCode, 50)

df_train <- as.matrix(df_train_ori)
df_train <- df_train[rowSums(df_train) > 5, colSums(df_train) > 5] 
df_train <- binarize(as(df_train, "realRatingMatrix"), minRatin = 1)

which_train <- sample(x = c(TRUE, FALSE),
                      size = nrow(df_train),
                      replace = TRUE, prob = c(0.8, 0.2))

x <- df_train[which_train]

recc_model <- Recommender(data = x, method = "IBCF", parameter = list(method = 'Jaccard'))
#model_details <- getModel(recc_model)

## recommend songs to a user
recc_predicted <- predict(object = recc_model, newdata = y, n = 4065, type = "topNList")


