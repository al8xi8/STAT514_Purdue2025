
/* Homework 4
   Student: Alexandra Chang
   Course: STAT 514 - Summer 2025
   Instructor: Dr. Chenzhong Wu
*/

/* Problem 1: Water Heating Experiment */
data waterheating;
input trtmt C D E block time order;
lines;
111 1 1 1 1 261.0 1
111 1 1 1 2 279.0 12
111 1 1 1 3 296.7 6
111 1 1 1 4 282.8 5
112 1 1 2 1 259.4 12
112 1 1 2 2 249.4 5
112 1 1 2 3 280.7 10
112 1 1 2 4 259.9 4
121 1 2 1 1 300.0 3
121 1 2 1 2 331.8 10
121 1 2 1 3 308.3 12
121 1 2 1 4 314.2 11
122 1 2 2 1 286.6 10
122 1 2 2 2 281.3 1
122 1 2 2 3 287.7 4
122 1 2 2 4 276.3 7
211 2 1 1 1 255.7 2
211 2 1 1 2 304.4 7
211 2 1 1 3 286.8 1
211 2 1 1 4 276.4 12
212 2 1 2 1 245.6 7
212 2 1 2 2 254.7 9
212 2 1 2 3 249.1 2
212 2 1 2 4 263.6 10
221 2 2 1 1 266.1 4
221 2 2 1 2 291.5 11
221 2 2 1 3 285.7 8
221 2 2 1 4 294.5 2
222 2 2 2 1 256.4 6
222 2 2 2 2 262.2 8
222 2 2 2 3 259.2 3
222 2 2 2 4 264.0 8
311 3 1 1 1 162.2 8
311 3 1 1 2 168.1 4
311 3 1 1 3 147.8 7
311 3 1 1 4 132.2 1
312 3 1 2 1 137.0 9
312 3 1 2 2 168.1 3
312 3 1 2 3 151.9 9
312 3 1 2 4 169.9 9
321 3 2 1 1 109.6 5
321 3 2 1 2 109.3 2
321 3 2 1 3 109.3 5
321 3 2 1 4 294.5 3
322 3 2 2 1 108.2 11
322 3 2 2 2 135.3 6
322 3 2 2 3 111.2 11
322 3 2 2 4 110.0 6
;
run;

proc glm data=waterheating;
class C D E Block;
model time=Block C|D|E;
lsmeans C /cl pdiff adjust=Tukey;
run;

data q;
input b @@;
alpha=0.05;
MSE=1200.336;
n=12*b;
df=n-12-b+1;
prob=1-alpha;
qT=probmc("range",.,prob,df,3);
msd=(qT/sqrt(2))*sqrt(MSE*2/(2*2*b));
lines;
7 8 9 10
;
proc print;
run;

/* Problem 3: Incomplete Block Designs - Tukey */
data size;
r=15;
alpha=0.05;
mse=30;
v=7;
k=5;
b=v*r/k;
df=v*r-b-v+1;
lambda=r*(k-1)/(v-1);
q=probmc('range',.,1-alpha,df,v);
width_Tukey=2*(q/sqrt(2))*sqrt(2*mse*k/(lambda*v));
run;

proc print;
var r lambda width_Tukey;
run;

/* Problem 3: Incomplete Block Designs - Dunnett */
data size;
r=15;
alpha=0.05;
mse=30;
v=7;
k=5;
b=v*r/k;
df=v*r-b-v+1;
lambda=r*(k-1)/(v-1);
width_Dunnett=2*probmc('dunnett2', ., 1-alpha, df, v-1)*sqrt(2*mse*k/(lambda*v));
run;

proc print;
var r lambda width_Dunnett;
run;

/* Problem 4: Rust Experiment */
data rust;
input temp @@;
do block=1 to 10;
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

proc print; run;

proc glm data=rust;
class temp block;
model pct=temp block;
lsmeans temp /cl pdiff adjust=tukey;
contrast 'linear' temp -2 -1 0 1 2;
run;
