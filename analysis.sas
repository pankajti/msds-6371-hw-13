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

/* get summary information on the trained data */
proc contents data=kaggle.train;

/* histogram on sales price */
proc univariate data=kaggle.train;
	histogram / normal;
run;

/* sgscatter of numeric data */
proc sgscatter data=kaggle.train;
   matrix _numeric_ / diagonal=(kernel histogram);
run;

/* Sale price is right tailed, look at log value of it */
data logTrain;
	set kaggle.train;
	logSalePrice = log(SalePrice);
run;
proc univariate;
	histogram logSalePrice;
run;
