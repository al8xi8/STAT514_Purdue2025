
/* 
Homework 3
Author: Alexandra Chang
Course: STAT 514 - Design of Experiments (Summer 2025)
Instructor: Dr. Chenzhong Wu
Purdue University
*/

/* Problem 2(c–f): Reaction Time Experiment - ANOVA, interaction, and CIs */
data react;
  input Order trtmt cue time y;
  lines;
1 6 2 3 0.256
2 6 2 3 0.281
3 2 1 2 0.167
4 6 2 3 0.258
5 2 1 2 0.182
6 5 2 2 0.283
7 4 2 1 0.257
8 5 2 2 0.235
9 1 1 1 0.204
10 1 1 1 0.170
11 5 2 2 0.260
12 2 1 2 0.187
13 3 1 3 0.202
14 4 2 1 0.279
15 4 2 1 0.269
16 3 1 3 0.198
17 3 1 3 0.236
18 1 1 1 0.181
;
run;

proc glm data=react;
  class cue time;
  model y = cue time cue*time;
  lsmeans time / cl pdiff;
  estimate "auditory - visual at time = 5 sec" cue 1 -1 cue*time 1 0 0 -1 0 0;
run;

/* Problem 3: Two-Way Main Effects Model - Estimability (no SAS code needed) */
/* Answered in written form only — TRUE/FALSE evaluations for parameter estimability */

/* Problem 4(b): Sample Size for Simultaneous CIs (Tukey-adjusted) */
data samplesize;
  input r @@;
  a = 2;
  b = 4;
  mse = 25;
  alpha = 0.10;
  prob = 1 - alpha;
  df = a * b * r - a - b + 1;
  qT = probmc('range', ., prob, df, b);
  width = 2 * (qT / sqrt(2)) * sqrt(mse * 2 / (a * r));
  lines;
5 6 7 8
;
run;

proc print;
  var r width;
run;

/* Problem 5(a–e): Coating Experiment - ANOVA and Interactions */
data coating1;
  do A=2,1;
    do B=2,1;
      do C=2,1;
        do D=2,1;
          input y @@;
          output;
        end;
      end;
    end;
  end;
  lines;
5.95 4.57 4.03 2.17 3.43 1.02 4.25 2.13
12.28 9.57 6.73 6.07 8.49 4.92 6.95 5.31
;
run;

proc glm data=coating1;
  class A B C D;
  model y = A B C D A*B A*C A*D B*C B*D C*D;
  lsmeans B*C;
  lsmeans B / cl pdiff;
run;

/* Problem 5(e): 90% Upper Confidence Limit for Error Variance */
data variance_upper_limit;
  input SSE DF ChiSq;
  upper_var = SSE / ChiSq;
  lines;
1.3517812 5 1.610308
;
run;

proc print data=variance_upper_limit;
run;
