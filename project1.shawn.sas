/* ---------------------------------------------------------
 * Shawn Jung (shawnj@mail.smu.edu)
 * 
 * Unit 13 - PROJECT #1
 * --------------------------------------------------------- */

/* importing the training data set as 'TRAIN' */

PROC IMPORT OUT= TRAIN DATAFILE= "/home/shawnj0/sasuser.v94/data/kaggle_train.csv" 
            DBMS=CSV REPLACE;
     GETNAMES=YES;
RUN;

/* subsetting and filtering three neighborhoods as 'C21AMES' set */
/* the outliers, SqFt over 4000 are included */ 

DATA C21AMES;
  SET TRAIN(WHERE=(Neighborhood = 'NAmes' OR Neighborhood = 'Edwards' OR Neighborhood = 'BrkSide'));
  GrLiv100sqft = ROUND(GrLivArea/100); /* defining 100sqft unit Living Area value */
  KEEP Id Neighborhood GrLivArea GrLiv100sqft SalePrice;
RUN;

/* visually inspect if transformation is required. */
/* I concluded we do not need to */
PROC SGPLOT DATA = C21AMES;
  SCATTER X = GrLiv100sqft Y = SalePrice / GROUP=Neighborhood;
RUN;

/* model building with BrkSide as the reference */
/* exp(sales price)  = b0 + b1*Edwards + b2*NAmes + b3*GrLivSqft + b4*Edwards*GrLivSqft + b5*NAmes*GrLivSqft */

/* model fitting */

PROC GLM DATA = C21AMES;
  CLASS Neighborhood (ref = 'BrkSide');
  MODEL SalePrice = GrLiv100sqft | Neighborhood / solution clparm;
RUN;

/* Three neighborhoods showed statistically significant interaction with the living room area sqft */
/* exp(sales price)  = 19457.36 + 68798.94*Edwards + 53955.07*NAmes + 8768.79*GrLivSqft - 5788.67*Edwards*GrLivSqft - 3251.60*NAmes*GrLivSqft */
  

/* it is time to check the assumptions */
PROC GLM DATA = C21AMES PLOTS=ALL;
  CLASS Neighborhood;
  MODEL SalePrice = GrLiv100sqft | Neighborhood / solution;
RUN;

/* judging from scatter plot, qq plot and histogram of residuals, there is no evidence that the residuals do not follow a normal distribution with constant variance */
/* But I'm concerned with high Leverage with 4000+ sqft outliers. So re-run modeling without outliers this time */

DATA C21AMES2;
  SET TRAIN(WHERE=((Neighborhood = 'NAmes' OR Neighborhood = 'Edwards' OR Neighborhood = 'BrkSide') AND GrLivArea < 4000));
  GrLiv100sqft = ROUND(GrLivArea/100); /* defining 100sqft unit Living Area value */
  KEEP Id Neighborhood GrLivArea GrLiv100sqft SalePrice;
RUN;

/* model fitting */
PROC GLM DATA = C21AMES2;
  CLASS Neighborhood (ref = 'BrkSide');
  MODEL SalePrice = GrLiv100sqft | Neighborhood / solution clparm;
RUN;

/* The slope/intercept for Edwards are not statistically significant to BrkSide */
/* So we will consider to combine Edwards and BrkSide with new data set C21AMES3 */
  
/* New model fitting in progress with C21AMES3 */
