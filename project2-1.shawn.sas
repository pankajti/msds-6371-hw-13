/* ---------------------------------------------------------
 * Shawn Jung (shawnj@mail.smu.edu)
 * 
 * Unit 13 - PROJECT #2 Forward Selection 
 * --------------------------------------------------------- */

/* importing the training data set as 'kaggle.train' */
/* In this task, I would not add or delete any variables except the log transformation of SalePrice */

PROC IMPORT OUT= kaggle.train DATAFILE= "/folders/myfolders/Data/kaggle_train.csv" 
            DBMS=CSV REPLACE;
     GETNAMES=YES;
RUN;

/* pre-process Train data */
/* We need to merge what Jeff did for 'NA' */
DATA kaggle.train;
  SET kaggle.train;
  logSalePrice = log(SalePrice);
  IF GrLivArea > 4000 THEN DELETE;
RUN;

/* importing the test data set as 'kaggle.test' */
PROC IMPORT OUT= kaggle.test DATAFILE= "/folders/myfolders/Data/kaggle_test.csv" 
            DBMS=csv REPLACE;
     GETNAMES=YES;
run;

/* pre-process Test data */
DATA kaggle.test;
  SET kaggle.test;
  SalePrice = .;
  logSalePrice = .;
RUN;

/* merging train and test data sets */
DATA kaggle.merged_data;
  SET kaggle.train kaggle.test;
RUN;

/* Model selection based on train data set */
PROC GLMSELECT DATA=kaggle.merged_data;
  CLASS MSZoning LotFrontage Street Alley LotShape LandContour Utilities 
		LotConfig LandSlope Neighborhood Condition1 Condition2 BldgType HouseStyle 
		RoofStyle RoofMatl Exterior1st Exterior2nd MasVnrType ExterQual ExterCond 
		Foundation BsmtQual BsmtCond BsmtExposure BsmtFinType1 BsmtFinType2 Heating 
		HeatingQC CentralAir Electrical KitchenQual Functional FireplaceQu GarageType 
		GarageFinish GarageQual GarageCond PavedDrive PoolQC Fence MiscFeature 
		SaleType SaleCondition;
  MODEL logSalePrice = 
    MSZoning LotFrontage Street Alley LotShape LandContour Utilities 
		LotConfig LandSlope Neighborhood Condition1 Condition2 BldgType HouseStyle 
		RoofStyle RoofMatl Exterior1st Exterior2nd MasVnrType ExterQual ExterCond 
		Foundation BsmtQual BsmtCond BsmtExposure BsmtFinType1 BsmtFinType2 Heating 
		HeatingQC CentralAir Electrical KitchenQual Functional FireplaceQu GarageType 
		GarageFinish GarageQual GarageCond PavedDrive PoolQC Fence MiscFeature 
		SaleType SaleCondition
	MSSubClass LotArea OverallQual OverallCond YearBuilt YearRemodAdd 
		MasVnrArea BsmtFinSF1 BsmtFinSF2 BsmtUnfSF TotalBsmtSF _1stFlrSF
		_2ndFlrSF LowQualFinSF GrLivArea BsmtFullBath BsmtHalfBath FullBath 
		HalfBath BedroomAbvGr KitchenAbvGr TotRmsAbvGrd Fireplaces GarageYrBlt 
		GarageCars GarageArea WoodDeckSF OpenPorchSF EnclosedPorch _3SsnPorch
		ScreenPorch PoolArea MiscVal MoSold YrSold
	
	/ SELECTION=FORWARD(stop=CV) CVMETHOD=RANDOM(5) STATS=adjrsq;
    output out = results p=predict;
RUN;



data results5;
set results;
if predict > 0 then SalePrice = exp(predict);
if predict <0 then SalePrice = 179321;
keep Id SalePrice;
where Id > 1460;

proc print data = results5;
run;
