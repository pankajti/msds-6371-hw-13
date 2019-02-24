
data Kaggle.Train_ana;
set kaggle.train  ;
TotalSF=  TotalBsmtSF + _1stFlrSF	+ _2ndFlrSF;
result = GrLivArea - ( _1stFlrSF	+ _2ndFlrSF);
sum_sf =_1stFlrSF	+ _2ndFlrSF;
log_sale_price = log(SalePrice);
TotalSF2 =  GrLivArea+TotalBsmtSF ;
/*if GrLivArea > 2000 then delete;*/
run;

proc glmselect data=kaggle.train_ana;
class MSZoning LotFrontage Street Alley LotShape LandContour Utilities 
		LotConfig LandSlope Neighborhood Condition1 Condition2 BldgType HouseStyle 
		RoofStyle RoofMatl Exterior1st Exterior2nd MasVnrType ExterQual ExterCond 
		Foundation BsmtQual BsmtCond BsmtExposure BsmtFinType1 BsmtFinType2 Heating 
		HeatingQC CentralAir Electrical KitchenQual Functional FireplaceQu GarageType 
		GarageFinish GarageQual GarageCond PavedDrive PoolQC Fence MiscFeature 
		SaleType SaleCondition;
model SalePrice =   _1stFlrSF	_2ndFlrSF	_3SsnPorch BsmtFinSF1	BsmtFinSF2	BsmtUnfSF	EnclosedPorch	
GarageArea	GarageYrBlt	GrLivArea		
LotArea		LowQualFinSF	MasVnrArea	MiscVal	OpenPorchSF	PoolArea	
ScreenPorch	TotalBsmtSF	WoodDeckSF	YearBuilt	YearRemodAdd  
MSZoning LotFrontage 
Street Alley LotShape LandContour Utilities 
		LotConfig LandSlope Neighborhood Condition1 Condition2 BldgType HouseStyle 
		RoofStyle RoofMatl Exterior1st Exterior2nd MasVnrType ExterQual ExterCond 
		Foundation BsmtQual BsmtCond BsmtExposure BsmtFinType1 BsmtFinType2 Heating 
		HeatingQC CentralAir Electrical KitchenQual Functional FireplaceQu GarageType 
		GarageFinish GarageQual GarageCond PavedDrive PoolQC Fence MiscFeature 
		SaleType SaleCondition / selection =stepwise (stop =cv) 
cvmethod= RANDOM(5) stats=ADJRSQ details=summary; 
run;

