
data Kaggle.Train_ana;
set kaggle.train  ;
log_sale_price = log(SalePrice);
if GrLivArea > 4000 then delete;
drop BsmtFinSF1   BsmtFinSF2  BsmtUnfSF ;
run;

data Kaggle.merged_data;
set kaggle.train_ana kaggle.test;
TotalSF2 =  GrLivArea+TotalBsmtSF ;
 

proc glm data=Kaggle.merged_data     plots=All;
class  GarageArea Neighborhood ExterQual ExterCond KitchenQual PoolQC  ;
model log_sale_price =  OverallQual TotalSF2 GarageArea Neighborhood ExterQual ExterCond KitchenQual PoolQC;
output out = results  p= predict ;
run;



 
data result_custom_selection ;
set results;
if predict > 0 then SalePrice=exp(Predict);
if Predict <0 then SalePrice = 179321; /*TODO add averg function*/
keep id salePrice;
where id > 1460;



proc print data = result_custom_selection;
run;