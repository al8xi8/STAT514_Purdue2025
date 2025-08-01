
/* 
Homework 2
Author: Alexandra Chang
Course: STAT 514 - Design of Experiments (Summer 2025)
Instructor: Dr. Chenzhong Wu
Purdue University
*/

/* Problem 1(a–d): Trout Experiment - Sample means and variance upper bound */
data trout;
  do sulfa = 1 to 4;
    do rep = 1 to 10;
      input hemo @@;
      output;
    end;
  end;
  lines;
6.7 7.8 5.5 8.4 7.0 7.8 8.6 7.4 5.8 7.0
9.9 8.4 10.4 9.3 10.7 11.9 7.1 6.4 8.6 10.6
10.4 8.1 10.6 8.7 10.7 9.1 8.8 8.1 7.8 8.0
9.3 9.3 7.2 7.8 9.3 10.2 8.7 8.6 9.3 7.2
;
run;

proc means data=trout mean;
  class sulfa;
  var hemo;
run;

proc glm data=trout;
  class sulfa;
  model hemo = sulfa;
  ods output OverallANOVA=anova;
run;

data upper_limit;
  set anova;
  if Source = "Error" then do;
    chi = 23.2686; * Chi-sq 36, 0.95;
    upper = SumSq / chi;
  end;
run;

proc print data=upper_limit;
  var DF SumSq upper;
run;

/* Problem 2(a–b): Heart-Lung Pump ANOVA and 90% CI upper bound */
data heart;
  input order RPM y;
  lines;
1 5 3.540 2 1 1.158 3 1 1.128 4 2 1.686 5 5 3.480
6 5 3.510 7 3 2.328 8 3 2.340 9 3 2.298 10 4 2.982
11 3 2.328 12 1 1.140 13 4 2.868 14 5 3.504 15 3 2.340
16 2 1.740 17 1 1.122 18 1 1.128 19 5 3.612 20 2 1.740
;
run;

proc glm data=heart;
  class RPM;
  model y = RPM;
  ods output OverallANOVA=anova_heart;
run;

data upper_heart;
  set anova_heart;
  if Source = "Error" then do;
    chi = 8.5468; * Chi-sq 0.9, df=15;
    upper = SumSq / chi;
  end;
run;

proc print data=upper_heart;
  var DF SumSq upper;
run;

/* Problem 3: Diet Experiment - Power calculation (already included) */
data power;
  input r @@;
  v = 3; diff = 4; sigma = 6; alpha = 0.05;
  df1 = v - 1; df2 = v * (r - 1);
  ncp = r * diff**2 / (2 * sigma**2);
  Falpha = finv(1 - alpha, df1, df2);
  power = 1 - probf(Falpha, df1, df2, ncp);
  lines;
20 30 50 55 56 57 58 59 60
;
run;

proc print;
  var r power;
run;

/* Problem 4: Battery Experiment - One-way ANOVA */
data battery;
  input typebat lifeuc order;
  lines;
1 611 1 2 923 2 1 537 3 4 476 4 1 542 5 1 593 6
2 794 7 3 445 8 4 569 9 2 827 10 2 898 11 3 490 12
4 480 13 3 384 14 4 460 15 3 413 16
;
run;

proc glm data=battery;
  class typebat;
  model lifeuc = typebat;
  lsmeans typebat / cl;
run;

/* Problem 5(a–d): Multiple Comparisons - Bonferroni, Scheffé, Tukey, Dunnett */
data w;
  m = 3;
  alpha = 0.05;
  v = 4;
  n = 16;
  df = n - v;
  bon = tinv(1 - alpha / (2 * m), df);
  scheffe = sqrt((v - 1) * finv(1 - alpha, v - 1, df));
  tukey = probmc("range", ., 1 - alpha, df, v) / sqrt(2);
  dunnett = probmc("dunnett2", ., 1 - alpha, df, v - 1);
run;

proc print data=w;
run;

/* Problem 6(a–c): Trout Experiment Part 2 - Trend, Dunnett, and CI width */
data trout;
  do sulfa = 1 to 4;
    do rep = 1 to 10;
      input hemo @@;
      output;
    end;
  end;
  lines;
6.7 7.8 5.5 8.4 7.0 7.8 8.6 7.4 5.8 7.0
9.9 8.4 10.4 9.3 10.7 11.9 7.1 6.4 8.6 10.6
10.4 8.1 10.6 8.7 10.7 9.1 8.8 8.1 7.8 8.0
9.3 9.3 7.2 7.8 9.3 10.2 8.7 8.6 9.3 7.2
;
run;

proc glm data=trout;
  class sulfa;
  model hemo = sulfa;
  estimate "linear trend" sulfa -3 -1 1 3;
  lsmeans sulfa / cl adjust=dunnett alpha=0.01;
run;

/* Problem 6(c): Sample size for Dunnett width < 2 using MSE upper limit */
data size;
  input r @@;
  alpha = 0.05;
  v = 4;
  MSE = 2.2022;
  n = v * r;
  df = n - v;
  prob = 1 - alpha;
  w = probmc("dunnett2", ., prob, df, v - 1);
  msd = w * sqrt(MSE * 2 / r);
  lines;
10 15 20 25 26
;
run;

proc print data=size;
run;
