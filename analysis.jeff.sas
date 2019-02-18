/* ---------------------------------------------------------
 * Jeff Washburn (washburnj@mail.smu.edu)
 * 
 * Unit 13 - kaggle
 * --------------------------------------------------------- */


ods graphics on;
ods trace on;

/* read in the data */
proc print data=kaggle.train;
run;

/*
Data Exploration
	- Variable Identification
		x DataFrame size and shape
		x Label
		x Features (Numeric, Categorical) (find missing values)

	- Univariate Analysis
		x Label (histograms, qqplots)
		x Numeric features
		x Categorical features

	- Bivariate Analysis
		- Numeric features
		- Categorical features
		- Correlation Matrix
Data Manipulation
	- Label Manipulation
	- Cutting Outliers
	- Impute missing values
	- Create new features
	- Turn some numeric features into categorical features
	- Correct Feature Skewness
	- Create Dummy Variables
*/

/*============================ D A T A   E X P L O R A T I O N ===============================*/
/* 
 * Variable Identification - DataFrame size and shape also Features (Numeric, Categorical),
 * and Label identification
 * 
 * Get summary information on the trained data
 * 
 * Results:
 * 	- Label = SalePrice
 * 	- 1460 Observations, 81 columns
 *   	- 80 Features (36 numeric, 44 categorical)
 *   	- Label is "SalePrice" (1 numeric)
 */
proc contents details order=varnum data=kaggle.train;

/*
 * Missing values - numerical data
 * 
 * Find missing numerical data using:
 * 	- kaggle.train.Describe Missing Data-numerical.ctk
 * 
 * Results:
 * 	- Feature		Number of missing values
 * 	- GarageYrBlt	81
 * 	- MasVnrArea	8
 */

/*
 * Missing values - categorical data
 * 
 * Found missing categorical data using:
 * 	- kaggle.train_naremoved.Describe Missing Data-categorical.ctk
 * 
 * Results
 * 	- There are missing values from kaggle.train, but not showing up because they are "NA"
 * 	- Need to convert the NA's to blanks first
 * 		- Reference site to convert: https://communities.sas.com/t5/SAS-Procedures/Import-Excel-file-with-missing-values/td-p/456213
 * 		- Steps to convert:
 * 			1) convert NA to ""
 * 			2) Used kaggle.train_naremoved.Describe Missing Data-categorical.ctk
 * 	- Found 17 categorical features with missing (NA) values
 */
data kaggle.train_naremoved ;
	set kaggle.train;
	array change_Char _Character_;
	do over change_Char ;
	if strip(change_Char)="NA" then change_Char=" ";
	end;
run;

/* 
 * Univariate Analysis - Analyze Label
 * 
 * Analyze Label (SalePrice) and plot Histogram, qqplot
 * 
 * Results:
 * 	- Histogram with normal distribution and kernel smoothing density plots
 * 	- data is right skewed
 * 	- log tranformation needed
 */
proc univariate data=kaggle.train_naremoved;
	var SalePrice;
	histogram / normal lognormal kernel;
	output out=Parameters mean=mean std=std;
	qqplot / normal(mu=est sigma=est);
run;


/* 
 * Univariate Analysis - Analyze Numeric features (37 features)
 * 
 * Analyzied numerical data using: 
 * 	- kaggle.train.Characterize Data.ctk
 * 
 * Results
 * 	- Show the following metrics for each numerical category
 * 	"Variable	N	N Miss	Minimum	Mean	Median	Maximum	Std Dev"
 * 	- Histograms with normal distribution and kernel smoothing density plots
 * 	- not many of the features follow normal distribution
 * 	
 */
title "Descriptive Statistics for Numeric Variables";
proc means data=kaggle.train_naremoved n nmiss min mean median max std;
	var Id MSSubClass LotArea OverallQual OverallCond YearBuilt YearRemodAdd 
		MasVnrArea BsmtFinSF1 BsmtFinSF2 BsmtUnfSF TotalBsmtSF '1stFlrSF'n 
		'2ndFlrSF'n LowQualFinSF GrLivArea BsmtFullBath BsmtHalfBath FullBath 
		HalfBath BedroomAbvGr KitchenAbvGr TotRmsAbvGrd Fireplaces GarageYrBlt 
		GarageCars GarageArea WoodDeckSF OpenPorchSF EnclosedPorch '3SsnPorch'n 
		ScreenPorch PoolArea MiscVal MoSold YrSold SalePrice;
title "Descriptive Statistics for Numeric Variables - Histograms";
proc univariate data=KAGGLE.train_naremoved noprint;
	histogram Id MSSubClass LotArea OverallQual OverallCond YearBuilt YearRemodAdd 
		MasVnrArea BsmtFinSF1 BsmtFinSF2 BsmtUnfSF TotalBsmtSF '1stFlrSF'n 
		'2ndFlrSF'n LowQualFinSF GrLivArea BsmtFullBath BsmtHalfBath FullBath 
		HalfBath BedroomAbvGr KitchenAbvGr TotRmsAbvGrd Fireplaces GarageYrBlt 
		GarageCars GarageArea WoodDeckSF OpenPorchSF EnclosedPorch '3SsnPorch'n 
		ScreenPorch PoolArea MiscVal MoSold YrSold SalePrice / normal kernel;
run;

/* 
 * Univariate Analysis - Analyze Categorical features (44 features)
 * 
 * Analyzed categorical data using:
 * 	- kaggle.train.Characterize Data.ctk
 * 
 * Results
 * 	- Table view and histogram of each categorical variable.  
 * 	- This shows the missing values for each category
 * 
 */
title "Frequencies for Categorical Variables";
proc freq data=KAGGLE.TRAIN_NAREMOVED;
	tables MSZoning LotFrontage Street Alley LotShape LandContour Utilities 
		LotConfig LandSlope Neighborhood Condition1 Condition2 BldgType HouseStyle 
		RoofStyle RoofMatl Exterior1st Exterior2nd MasVnrType ExterQual ExterCond 
		Foundation BsmtQual BsmtCond BsmtExposure BsmtFinType1 BsmtFinType2 Heating 
		HeatingQC CentralAir Electrical KitchenQual Functional FireplaceQu GarageType 
		GarageFinish GarageQual GarageCond PavedDrive PoolQC Fence MiscFeature 
		SaleType SaleCondition / plots=(freqplot) missing;
run;


/*============================ D A T A   M A N I P U L A T I O N ===============================*/

/* Sale price is right tailed, look at log value of it */
data logTrain;
	set kaggle.train;
	logSalePrice = log(SalePrice);
run;
proc univariate;
	histogram logSalePrice;
run;
