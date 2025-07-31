
/*********************************************************************/
/*  HW7_AlexandraChang.sas                                           */
/*  STAT 514 – Design of Experiments, Summer 2025                     */
/*  Alexandra Chang                                                   */
/*  Homework 7                                                        */
/*********************************************************************/

/*-----------------------------------------------------------*/
/*  1. Paper Towel Experiment (Table 9.9, p.303)              */
/*     Treatments: 6 level combinations; covariate = rate    */
/*-----------------------------------------------------------*/
data papertowel;
  input run trtmt AB drops time area rate absorb;
  lines;
1 2 12 89 50 121.00 1.780 0.7355
2 4 22 28 15  99.00 1.867 0.2828
3 2 12 47 22 121.00 2.136 0.3884
4 1 11 82 42 121.00 1.952 0.6777
5 5 31 54 30 123.75 1.800 0.4364
6 1 11 74 37 121.00 2.000 0.6116
7 4 22 29 14  99.00 2.071 0.2929
8 6 32 80 41 123.75 1.951 0.6465
9 3 21 25 11  99.00 2.273 0.2525
10 3 21 27 12  99.00 2.250 0.2727
11 6 32 83 40 123.75 2.075 0.6707
12 5 31 41 19 123.75 2.158 0.3313
;
run;

proc print data=papertowel;
  title "Paper Towel Data";
run;

proc glm data=papertowel;
  class trtmt;
  model absorb = trtmt rate / solution;
  title "1(b) ANCOVA: Absorbency Adjusted for Drop Rate";
run;

/*-----------------------------------------------------------*/
/*  2. Video Game Experiment (Latin Square, p.426)           */
/*     Rows=Order, Columns=Day, Treatments=trtmt           */
/*-----------------------------------------------------------*/
data video;
  input order day trtmt y;
  lines;
1 1 1 94
1 2 3 100
1 3 4 98
1 4 2 101
1 5 5 112
2 1 3 103
2 2 2 111
2 3 1 51
2 4 5 110
2 5 4 90
3 1 4 114
3 2 1 75
3 3 5 94
3 4 3 85
3 5 2 107
4 1 5 100
4 2 4 74
4 3 2 70
4 4 1 93
4 5 3 106
5 1 2 106
5 2 5 95
5 3 3 81
5 4 4 90
5 5 1 73
;
run;

proc print data=video;
  title "Video Game Data";
run;

proc glm data=video;
  class order day trtmt;
  model y = order day trtmt / solution;
  lsmeans trtmt / pdiff=all cl adjust=tukey;
  title "2(b) Tukey Simultaneous 95% CIs for Treatment Differences";
run;
