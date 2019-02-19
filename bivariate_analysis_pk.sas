data Kaggle.Train2;
set kaggle.train ;
TotalSF=  TotalBsmtSF+ _1stFlrSF	+ _2ndFlrSF;
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


/*
proc corr data=Kaggle.Train2  PEARSON
plots(only maxpoints= 300000)= matrix(histogram);
var _1stFlrSF	_2ndFlrSF	_3SsnPorch BsmtFinSF1	BsmtFinSF2 BsmtUnfSF EnclosedPorch	GarageArea	GarageYrBlt	GrLivArea		
LotArea		LowQualFinSF	MasVnrArea	MiscVal	OpenPorchSF	PoolArea	
ScreenPorch	TotalBsmtSF	WoodDeckSF	YearBuilt	YearRemodAdd  TotalSF;
title Analyss ;
run;
*/

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
