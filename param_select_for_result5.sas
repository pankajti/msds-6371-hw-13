
data Kaggle.Train_ana;
set kaggle.train  ;
TotalSF=  TotalBsmtSF + _1stFlrSF	+ _2ndFlrSF;
result = GrLivArea - ( _1stFlrSF	+ _2ndFlrSF);
sum_sf =_1stFlrSF	+ _2ndFlrSF;
log_sale_price = log(SalePrice);
TotalSF2 =  GrLivArea+TotalBsmtSF ;
if GrLivArea > 4000 then delete;

run;



proc glmselect data=kaggle.train_ana;
class MSZoning LotFrontage Street Alley LotShape LandContour Utilities 
		LotConfig LandSlope Neighborhood Condition1 Condition2 BldgType HouseStyle 
		RoofStyle RoofMatl Exterior1st Exterior2nd MasVnrType ExterQual ExterCond 
		Foundation BsmtQual BsmtCond BsmtExposure BsmtFinType1 BsmtFinType2 Heating 
		HeatingQC CentralAir Electrical KitchenQual Functional FireplaceQu GarageType 
		GarageFinish GarageQual GarageCond PavedDrive PoolQC Fence MiscFeature 
		SaleType SaleCondition;
model SalePrice =   		_3SsnPorch 	  EnclosedPorch	
GarageArea	GarageYrBlt			
LotArea		LowQualFinSF	MasVnrArea	MiscVal	OpenPorchSF	PoolArea	
ScreenPorch		WoodDeckSF	YearBuilt	YearRemodAdd    
 TotalSF2 
MSZoning LotFrontage 
Street Alley LotShape LandContour Utilities 
		LotConfig LandSlope Neighborhood Condition1 Condition2 BldgType HouseStyle 
		RoofStyle RoofMatl Exterior1st Exterior2nd MasVnrType ExterQual ExterCond 
		Foundation BsmtQual BsmtCond BsmtExposure BsmtFinType1 BsmtFinType2 Heating 
		HeatingQC CentralAir Electrical KitchenQual Functional FireplaceQu GarageType 
		GarageFinish GarageQual GarageCond PavedDrive PoolQC Fence MiscFeature 
		SaleType SaleCondition / selection=stepwise(stop =cv) 
cvmethod= RANDOM(5) stats=ADJRSQ details=summary; 
run;

proc reg data=kaggle.train_ana   ;
class RoofStyle(ref = 'FLAT');
model SalePrice =   _1stFlrSF	_2ndFlrSF	_3SsnPorch BsmtFinSF1	BsmtFinSF2 BsmtUnfSF EnclosedPorch	
GarageArea
	GarageYrBlt			
LotArea		LowQualFinSF	MasVnrArea		OpenPorchSF	PoolArea	
ScreenPorch	TotalBsmtSF	WoodDeckSF	YearBuilt	YearRemodAdd    / tol vif collin;   ;
output out = results  p= predict ;
run;

proc glmmod data=Kaggle.Train_ana outdesign=GLMDesign outparm=GLMParm;
   class MSZoning Ally  ;
   model SalePrice =MSZoning  _1stFlrSF _2ndFlrSF 
   BsmtFinSF1 GarageArea LotArea MasVnrArea ScreenPorch TotalBsmtSF YearBuilt YearRemodAdd ;
run;


 /*proc print data=GLMDesign; run;*/
proc print data=GLMParm; run; 