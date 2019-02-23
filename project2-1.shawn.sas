/* ---------------------------------------------------------
 * Shawn Jung (shawnj@mail.smu.edu)
 * 
 * Unit 13 - PROJECT #2 Forward Selection 
 * --------------------------------------------------------- */

/* importing the training data set as 'kaggle.train' */
/* In this task, I would not add or delete any variables except the log transformation of SalePrice */

PROC IMPORT OUT= kaggle.train DATAFILE= "/home/shawnj0/sasuser.v94/data/kaggle_train.csv" 
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
PROC IMPORT OUT= kaggle.test DATAFILE= "/home/shawnj0/sasuser.v94/data/kaggle_test.csv" 
            DBMS=csv REPLACE;
     GETNAMES=YES;
run;

/* pre-process Test data */
DATA kaggle.test;
  SET kaggle.test;
  SalePrice = .;
  logSalePrice = .;
RUN;

/* Model selection based on train data set */
PROC GLMSELECT DATA=kaggle.train;
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
		MasVnrArea BsmtFinSF1 BsmtFinSF2 BsmtUnfSF TotalBsmtSF '1stFlrSF'n 
		'2ndFlrSF'n LowQualFinSF GrLivArea BsmtFullBath BsmtHalfBath FullBath 
		HalfBath BedroomAbvGr KitchenAbvGr TotRmsAbvGrd Fireplaces GarageYrBlt 
		GarageCars GarageArea WoodDeckSF OpenPorchSF EnclosedPorch '3SsnPorch'n 
		ScreenPorch PoolArea MiscVal MoSold YrSold
	
	/ SELECTION=FORWARD;
RUN;

/* Prediction with the selected variables */

/* Extract Kaggle upload list */
