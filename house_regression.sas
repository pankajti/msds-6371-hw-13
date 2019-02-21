data Kaggle.Train2;
set kaggle.train ;

/* TotalSF=  TotalBsmtSF + _1stFlrSF	+ _2ndFlrSF;*/
result = GrLivArea - ( _1stFlrSF	+ _2ndFlrSF);
sum_sf =_1stFlrSF	+ _2ndFlrSF;
keep  result GrLivArea _1stFlrSF _2ndFlrSF LowQualFinSF sum_sf;

run;

proc print data=Kaggle.Train2;
run;

proc reg data=kaggle.train2;
class ;
model SalePrice =_1stFlrSF	_2ndFlrSF	_3SsnPorch BsmtFinSF1 /selection = FORWARD;
run;
