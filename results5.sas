data Kaggle.Train_ana;
set kaggle.train  ;
TotalSF=  TotalBsmtSF + _1stFlrSF	+ _2ndFlrSF;
result = GrLivArea - ( _1stFlrSF	+ _2ndFlrSF);
sum_sf =_1stFlrSF	+ _2ndFlrSF;
log_sale_price = log(SalePrice);

if GrLivArea > 4000 then delete;
run;



data Kaggle.merged_data;
set kaggle.train_ana kaggle.test;
TotalSF2 =  GrLivArea+TotalBsmtSF ;
 


proc glm data=Kaggle.merged_data     plots=All;
class  BldgType  Neighborhood ExterQual  BsmtQual BsmtExposure KitchenQual Functional ;
model SalePrice = GarageArea LotArea YearBuilt YearRemodAdd  TotalSF2
					BldgType  Neighborhood ExterQual  BsmtQual BsmtExposure KitchenQual Functional ; 
output out = results  p= predict ;
run;


data result5 ;
set results;
if predict > 0 then SalePrice=Predict;
if Predict <0 then SalePrice =10000;
keep id salePrice;
where id > 1460;

data result_analysis ;
set results;
if predict > 0 then SalePrice=Predict;
if Predict <0 then SalePrice =10000;
keep id SalePrice  GarageArea LotArea YearBuilt YearRemodAdd  TotalSF2
					BldgType  Neighborhood ExterQual  BsmtQual BsmtExposure KitchenQual Functional;
where id > 1460;


proc print data = result_analysis;
run;