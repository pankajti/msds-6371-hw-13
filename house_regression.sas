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
 


proc reg data=kaggle.train_ana   ;
model log_sale_price = _3SsnPorch EnclosedPorch	
GarageArea	GarageYrBlt	GrLivArea		
LotArea		LowQualFinSF	MasVnrArea	MiscVal	OpenPorchSF	PoolArea	
ScreenPorch		WoodDeckSF	YearBuilt	YearRemodAdd  TotalSF2  
  / tol vif collin;   ;
output out = results  p= predict ;
run;


proc glmselect data=Kaggle.merged_data;
class MSZoning LotFrontage Street Alley LotShape LandContour Utilities 
		LotConfig LandSlope Neighborhood Condition1 Condition2 BldgType HouseStyle 
		RoofStyle RoofMatl Exterior1st Exterior2nd MasVnrType ExterQual ExterCond 
		Foundation BsmtQual BsmtCond BsmtExposure BsmtFinType1 BsmtFinType2 Heating 
		HeatingQC CentralAir Electrical KitchenQual Functional FireplaceQu GarageType 
		GarageFinish GarageQual GarageCond PavedDrive PoolQC Fence MiscFeature 
		SaleType SaleCondition;
model log_sale_price =  _3SsnPorch 	EnclosedPorch	
GarageArea	GarageYrBlt	GrLivArea		
LotArea		LowQualFinSF	MasVnrArea	MiscVal	OpenPorchSF	PoolArea	
ScreenPorch		WoodDeckSF	YearBuilt	YearRemodAdd  TotalSF2 
MSZoning LotFrontage 
Street Alley LotShape LandContour Utilities 
		LotConfig LandSlope Neighborhood Condition1 Condition2 BldgType HouseStyle 
		RoofStyle RoofMatl Exterior1st Exterior2nd MasVnrType ExterQual ExterCond 
		Foundation BsmtQual BsmtCond BsmtExposure BsmtFinType1 BsmtFinType2 Heating 
		HeatingQC CentralAir Electrical KitchenQual Functional FireplaceQu GarageType 
		GarageFinish GarageQual GarageCond PavedDrive PoolQC Fence MiscFeature 
		SaleType SaleCondition / selection= stepwise (stop =cv) 
cvmethod= RANDOM(5) stats=ADJRSQ details=summary;
output out = results  p= predict ; 
run;


/*
proc glm data=Kaggle.merged_data     plots=All;
class  Neighborhood BsmtQual KitchenQual  ;
model GrLivArea Neighborhood BsmtQual KitchenQual ; 
output out = results  p= predict ;
run;

*/

data result_stepwise_selection ;
set results;
if predict > 0 then SalePrice=exp(Predict);
if Predict <0 then SalePrice = 179321; /*TODO add averg function*/
keep id salePrice;
where id > 1460;

/*
data result_for_analysis ;
set results;
if predict > 0 then SalePrice=Predict;
if Predict <0 then SalePrice =179321;
keep id SalePrice  BsmtFinSF1 GrLivArea TotalBsmtSF YearBuilt Neighborhood BldgType BsmtQual BsmtExposure KitchenQual ;
where id > 1460;
*/

proc print data = result_stepwise_selection;
run;