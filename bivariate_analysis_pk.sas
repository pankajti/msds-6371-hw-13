data Kaggle.Train2;
set kaggle.train ;
TotalSF=  TotalBsmtSF + _1stFlrSF	+ _2ndFlrSF;
TotalSF2=  GrLivArea+TotalBsmtSF ;
total_gr_base = GrLivArea + BsmtFinSF1;
log_sale_price= log(salePrice);
if GrLivArea > 4000 then delete;
aaa = 1 if aa

run;


proc corr data=Kaggle.Train2 rank PEARSON
plots(only)= scatter(alpha=.05 );
var GrLivArea TotalSF2 BsmtFinSF1	BsmtFinSF2 BsmtUnfSF EnclosedPorch	GarageArea TotalBsmtSF	WoodDeckSF	YearBuilt	YearRemodAdd  ;
with  		SalePrice	log_sale_price	;
title Analyss ;
run;

proc corr data=Kaggle.Train2 rank PEARSON
plots(only)= scatter(alpha=.05 );
var TotalSF2 ;
with  		SalePrice	log_sale_price	;
title Analyss ;
run;

proc univariate data=kaggle.train2; 
	var log_sale_price; 	histogram / normal lognormal kernel; 	
	output out=Parameters mean=mean std=std; 
	qqplot / normal(mu=est sigma=est); run;

proc univariate data=kaggle.train2; 
	var salePrice; 	histogram / normal lognormal kernel; 	
	output out=Parameters mean=mean std=std; 
	qqplot / normal(mu=est sigma=est); run;
	
	
proc sgscatter data=Kaggle.Train2 ;
matrix   _1stFlrSF	_2ndFlrSF	_3SsnPorch BsmtFinSF1	BsmtFinSF2 BsmtUnfSF EnclosedPorch	GarageArea
	GarageYrBlt	GrLivArea		
LotArea		LowQualFinSF	MasVnrArea		OpenPorchSF	PoolArea	
ScreenPorch	TotalBsmtSF	WoodDeckSF	YearBuilt	YearRemodAdd   total_gr_base 
  SalePrice  ;
run;
	
	
proc corr data=Kaggle.Train2  PEARSON
plots(only maxpoints= 3000000)= matrix(histogram nvar =ALL);
var _1stFlrSF	_2ndFlrSF	_3SsnPorch BsmtFinSF1	BsmtFinSF2 BsmtUnfSF EnclosedPorch	GarageArea	GarageYrBlt	GrLivArea		
LotArea		LowQualFinSF	MasVnrArea	MiscVal	OpenPorchSF	PoolArea	
ScreenPorch	TotalBsmtSF	WoodDeckSF	YearBuilt	YearRemodAdd  TotalSF total_gr_base 
 TotalSF2 SalePrice log_sale_price ;
title Analyss ;
run;


/*
proc corr data=Kaggle.Train2 rank PEARSON
plots(only)= scatter(alpha=.05 );
var SalePrice ;
with  	_1stFlrSF	_2ndFlrSF	_3SsnPorch BsmtFinSF1	BsmtFinSF2	BsmtUnfSF	EnclosedPorch	GarageArea	GarageYrBlt	
GrLivArea		
LotArea		LowQualFinSF	MasVnrArea	MiscVal	OpenPorchSF	PoolArea	
ScreenPorch	TotalBsmtSF	WoodDeckSF	YearBuilt	YearRemodAdd  TotalSF;
title Analyss ;
run;
*/



proc corr data=Kaggle.Train2 rank PEARSON
plots(only)= scatter(alpha=.05 );
var SalePrice ;
with  	_1stFlrSF	_2ndFlrSF	_3SsnPorch BsmtFinSF1	BsmtFinSF2	;
title Analyss ;
run;



proc corr data=Kaggle.Train2 rank PEARSON
plots(only)= scatter(alpha=.05 );
var SalePrice ;
with  		BsmtUnfSF	EnclosedPorch	GarageArea	GarageYrBlt	GrLivArea		;
title Analyss ;
run;

proc corr data=Kaggle.Train2 rank PEARSON
plots(only)= scatter(alpha=.05 );
var SalePrice ;
with  	LotArea		LowQualFinSF	MasVnrArea	MiscVal	OpenPorchSF	;
title Analyss ;
run;

proc corr data=Kaggle.Train2 rank PEARSON
plots(only)= scatter(alpha=.05 );
var SalePrice ;
with  		PoolArea	
ScreenPorch	TotalBsmtSF	WoodDeckSF	YearBuilt	YearRemodAdd  TotalSF;
title Analyss ;
run;

proc corr data=Kaggle.Train2 rank PEARSON
plots(only)= scatter(alpha=.05 );
var SalePrice ;
with  YearRemodAdd  TotalSF;
title Analyss ;
run;


ods graphics /imagefmt=pdf ;

proc corr data=Kaggle.Train2  PEARSON
plots(only maxpoints= 3000000)= matrix(histogram nvar =ALL);
var _1stFlrSF	_2ndFlrSF	_3SsnPorch BsmtFinSF1	BsmtFinSF2 BsmtUnfSF EnclosedPorch	GarageArea	GarageYrBlt	GrLivArea		
LotArea		LowQualFinSF	MasVnrArea	MiscVal	OpenPorchSF	PoolArea	
ScreenPorch	TotalBsmtSF	WoodDeckSF	YearBuilt	YearRemodAdd  TotalSF ;
title Analyss ;
run;


   
   
proc corr data=Kaggle.Train2  PEARSON
plots(only maxpoints= 300000)= matrix(histogram);
var _1stFlrSF	_2ndFlrSF	_3SsnPorch BsmtFinSF1	BsmtFinSF2 BsmtUnfSF ;
title Analyss ;
run;


proc corr data=Kaggle.Train2  PEARSON
plots(only maxpoints= 300000)= matrix(histogram);
var  EnclosedPorch	GarageArea	GarageYrBlt	GrLivArea		;
title Analyss ;
run;


proc corr data=Kaggle.Train2  PEARSON
plots(only maxpoints= 300000)= matrix(histogram);
var   		LotArea		LowQualFinSF	MasVnrArea	MiscVal	OpenPorchSF	;
title Analyss ;
run;

proc corr data=Kaggle.Train2  PEARSON
plots(only maxpoints= 300000)= matrix(histogram);
var   		 	PoolArea	ScreenPorch	TotalBsmtSF	WoodDeckSF	YearBuilt	;
title Analyss ;
run;

proc corr data=Kaggle.Train2  PEARSON
plots(only maxpoints= 300000)= matrix(histogram);
var  	YearRemodAdd  TotalSF;
title Analyss ;
run;
