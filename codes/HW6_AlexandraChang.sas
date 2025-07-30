
/*********************************************************************/
/*  HW6_AlexandraChang.sas                                           */
/*  STAT 514 – Design of Experiments, Summer 2025                     */
/*  Alexandra Chang                                                   */
/*  Homework 6                                                        */
/*********************************************************************/

/*-----------------------------------------------------------*/
/*  1. Viscosity Experiment (Table 18.10, p. 695)             */
/*     Three-way nested factors: A = sample,                  */
/*     B = aliquot(A), C = subaliquot(B(A)), replicate = 2    */
/*-----------------------------------------------------------*/
data viscosity;
  do A = 1 to 2;            /* sample */
    do B = 1 to 10;         /* aliquot nested in A */
      do C = 1 to 2;        /* subaliquot nested in B(A) */
        do rep = 1 to 2;    /* two replicate measurements */
          input y @@;      /* read one viscosity value */
          output;
        end;
      end;
    end;
  end;
  drop rep;                 /* remove loop counter */
datalines;
59.8 59.4 58.2 63.5
66.6 63.9 61.8 62.0
64.9 68.8 66.3 63.5
62.7 62.2 62.9 62.8
59.5 61.0 54.6 61.5
69.0 69.0 60.6 61.8
64.5 66.8 60.2 57.4
61.6 56.6 64.5 62.3
64.5 61.3 72.7 72.4
65.2 63.9 60.8 61.2
59.8 61.2 60.0 65.0
65.0 65.8 64.5 64.5
65.0 65.2 65.5 63.5
62.5 61.9 60.9 61.5
59.8 60.9 56.0 57.2
68.8 69.0 62.5 62.0
65.2 65.6 61.0 59.3
59.6 58.5 62.3 61.5
61.0 64.0 73.0 71.7
65.0 64.0 62.0 63.0
;
run;

proc print data=viscosity(obs=10);
  title "Viscosity Data (first 10 obs)";
run;

proc glm data=viscosity;
  class A B C;
  model y = A B(A) C(B(A));
  random A B(A) C(B(A)) / test;
  title "Three-way Nested ANOVA: Viscosity";
run;

/*-----------------------------------------------------------*/
/*  2. Cigarette Experiment (p. 760)                          */
/*     A = Tar (whole-plot), B = Brand, C = Age,             */
/*     D = B×C combined, WP = whole plot ID (1–10)          */
/*-----------------------------------------------------------*/
data cigarett;
  input WP A @@;            /* whole-plot ID, Tar */
  do SP = 1 to 6;           /* six cigarettes per WP */
    input B C time @@;      /* Brand, Age, burn time */
    D = 10*B + C;           /* combined split-plot factor */
    output;
  end;
datalines;
1 1  2 2 301  1 1 326  2 3 260  1 3 290  1 2 312  2 1 292
2 2  1 1 329  1 2 331  1 3 285  2 1 306  2 2 258  2 3 276
3 2  2 2 290  1 1 380  1 2 335  1 3 309  2 3 243  2 1 334
4 2  1 1 321  2 1 337  2 3 275  1 2 316  1 3 307  2 2 250
5 2  2 2 308  1 1 345  2 1 307  2 3 288  1 3 321  1 2 330
6 1  1 1 344  2 3 283  2 1 281  2 2 261  1 3 307  1 2 292
7 1  2 1 274  1 3 310  1 2 304  2 2 279  2 3 277  1 1 330
8 1  1 3 302  1 2 325  2 2 301  1 1 338  2 3 270  2 1 297
9 2  1 2 323  1 3 334  2 3 265  1 1 326  2 2 269  2 1 297
10 1  2 3 309  1 3 314  2 2 259  1 1 344  2 1 310  1 2 322
;
run;

proc print data=cigarett(obs=12);
  title "Cigarette Data (first 12 obs)";
run;

/* 2(a) Split-plot: Tar vs D, whole-plot error = WP(A) */
proc mixed data=cigarett;
  class WP A D;
  model time = A D;
  random WP(A);
  title "2(a): Test of Tar Effect";
run;

/* 2(b) Full factorial split-plot with all interactions */
proc mixed data=cigarett;
  class WP A B C;
  model time = A B C A*B A*C B*C A*B*C;
  random WP(A);
  title "2(b): Full Split-Plot Model";
run;

/* 2(c) Tukey CIs for Brand main effect */
proc mixed data=cigarett;
  class WP A B C;
  model time = A B C A*B A*C B*C A*B*C;
  random WP(A);
  lsmeans B / cl adjust=Tukey;
  title "2(c): Tukey CIs for Brand";
run;
