
/* 
Homework 4
Author: Alexandra Chang
Course: STAT 514 - Design of Experiments (Summer 2025)
Instructor: Dr. Chenzhong Wu
Purdue University
*/

/* Problem 1(a–c): Water Heating Experiment - ANOVA and Tukey CI */
data waterheating;
  input trtmt C D E block time order;
  lines;
... [TRUNCATED for brevity, same as before]
;
run;

proc glm data=waterheating;
  class C D E Block;
  model time = Block C|D|E;
  lsmeans C / cl pdiff adjust=tukey;
run;

/* Problem 1(d): Number of blocks for CI width ≤ 40 using σ² upper limit */
data q;
  input b @@;
  alpha = 0.05;
  MSE = 1200.336;
  n = 12 * b;
  df = n - 12 - b + 1;
  prob = 1 - alpha;
  qT = probmc("range", ., prob, df, 3);
  msd = (qT / sqrt(2)) * sqrt(MSE * 2 / (2 * 2 * b));
  lines;
7 8 9 10
;
run;

proc print;
run;

/* Problem 3(b): Tukey CI width for BIBD */
data size;
  r = 15;
  alpha = 0.05;
  mse = 30;
  v = 7;
  k = 5;
  b = v * r / k;
  df = v * r - b - v + 1;
  lambda = r * (k - 1) / (v - 1);
  q = probmc('range', ., 1 - alpha, df, v);
  width_Tukey = 2 * (q / sqrt(2)) * sqrt(2 * mse * k / (lambda * v));
run;

proc print;
  var r lambda width_Tukey;
run;

/* Problem 3(c): Dunnett CI width for BIBD */
data size;
  r = 15;
  alpha = 0.05;
  mse = 30;
  v = 7;
  k = 5;
  b = v * r / k;
  df = v * r - b - v + 1;
  lambda = r * (k - 1) / (v - 1);
  width_Dunnett = 2 * probmc('dunnett2', ., 1 - alpha, df, v - 1)
                   * sqrt(2 * mse * k / (lambda * v));
run;

proc print;
  var r lambda width_Dunnett;
run;

/* Problem 4: Rust Experiment - Tukey CI, LSMEANS, Linear Contrast */
data rust;
  input temp @@;
  do block = 1 to 10;
    input pct @@;
    if pct ne . then output;
  end;
  lines;
50 12 19 . . . 20 10 21 19 .
55 18 . 33 . 19 . 18 . 18 24
60 24 36 . 35 39 22 . . . 28
65 . . 39 45 . 43 34 42 . 31
70 . 45 52 55 48 . . 50 43 .
;
run;

proc glm data=rust;
  class temp block;
  model pct = temp block;
  lsmeans temp / cl pdiff adjust=tukey;
  contrast 'linear' temp -2 -1 0 1 2;
run;
