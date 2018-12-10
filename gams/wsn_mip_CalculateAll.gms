Sets
$include %outfile%\Nodes.txt
       i(V)     bigI         / #V /
       i2(i)    smallI       / #W /
       
       j2(V)    bigJ         / #V /
       j(j2)     smallJ       / #W /

       k(W)     smallK       / #W /;
Parameter EtxOpt(i,j2) 'Optimal energy values for node-i to node-j';
$include %outfile%\EtxOptTable.txt

Scalar Lp           data packet size in bits                    /1024/;
Scalar InitEnergy   initial energy                              /25000/;
Scalar Erx          Energy dissipation for reception of data;
Erx=922;
Scalar bminValue   beta min value;
Scalar tmax    tmax value;

Variable t      time;
Variable bmin   minimum total hop count;
Positive Variable f(V,V,W) the ammount of data generated at node-k flows from node-i to node-s;
Variable e(i2);
Integer Variable bmin2 bmin in integer form;
Integer Variable t2 t in integer form;
option IntVarUp=0;

Equations
     eq1(i,k)       equation number 1(3)
     eq2(k)         equation number 2(4 and 8)
     eq3            equation number 3(5)
     eq4(i2,j2,k)    equation number 4(6 and 12)
     eq5(i,k)       equation number 5(7)
     eq6(i2)        equation number 6(9)
     eq7(i2)        equation number 7(10)
     eq8            equation number 8(11-bmin)
     eq9            equation number 9(11-bmax)
     eq10           free the objective variable bmin
     eq11           free the objective variable t;

*model-1 equations
eq1(i,k)    ..  sum(j2 $ (not sameas(i, j2)) , f(i,j2,k)  ) - sum(j $ (not sameas(i, j)), f(j,i,k)  )  =e= 0 - 1 $ (sameas(i, "node-0")) + 1 $ (sameas(i, k)) ;     
eq2(k)      ..  sum(j, f(j,k,k))  =e=  0 ;
eq3         ..  sum(i2, sum(j2, sum(k, f(i2,j2,k)))) =e=  bmin2 ;
eq4(i2,j2,k)  ..  f(i2,j2,k) =g= 0;

*model-2 equations
eq5(i,k)    ..  sum(j2 $ (not sameas(i, j2)), f(i,j2,k) ) - sum(j $ (not sameas(i, j)), f(j,i,k)  )  =e= 0 - t2 $ (sameas(i, "node-0")) + t2 $ (sameas(i, k)) ;
eq6(i2)     ..  Lp*sum(k, sum(j2, EtxOpt(i2,j2)*f(i2,j2,k)) + Erx *sum(j, f(j,i2,k))) =l= e(i2)*(10**9);
eq7(i2)     ..  e(i2) =e= InitEnergy;
eq8         ..  sum(i2, sum(j2, sum(k, f(i2,j2,k)))) =e=  bmin2.l * t2 ;
eq9         ..  sum(i2, sum(j2, sum(k, f(i2,j2,k)))) =e=  bmin2 * t2.l ;
eq10        ..  bmin2 =e= bmin;
eq11        ..  t2 =e= t;


$include %outfile%\OutOfRangeDistances.txt


Model modelFindMinHopCount /eq1, eq2, eq3, eq4, eq10/;
Model modelMaxLifetimeEnforced /eq4, eq2, eq5, eq6, eq7, eq11/ ;
Model modelMinHopCountEnforced /eq4, eq2, eq5, eq6, eq7, eq8, eq11/ ;
Model modelHopCountWithMaxLifetime /eq4, eq2, eq5, eq6, eq7, eq9, eq10, eq11/ ;

Solve modelFindMinHopCount using mip minimizing bmin;

File minHopCountResults /%outfile%\ResultsMinHopCount.txt/;
put minHopCountResults;
put bmin2.l
putclose;

File minHopCountResults2 /%outfile%\ResultsMinHopCount2.txt/;
minHopCountResults2.pc = 5;
put minHopCountResults2;
loop(k,
    loop((i2,j2),
        put $(f.l(i2,j2,k)<>0) k.tl, i2.tl, j2.tl, f.l(i2,j2,k) /
    );

);
putclose;

Solve modelMinHopCountEnforced using mip maximizing t;
display f.l;

File resultsMinHop /%outfile%\ResultsMinHopCountEnforced.txt/;
resultsMinHop.pc = 5;
put resultsMinHop;
*put "k","i","j","f"/;
loop(k,
    loop((i2,j2),
        put $(f.l(i2,j2,k)<>0) k.tl, i2.tl, j2.tl, f.l(i2,j2,k) /
    );

);
display bmin2.l;
display t.l
  
putclose;

File LifetimeResults /%outfile%\ResultsLifetime.txt/;
put LifetimeResults;
put t.l
putclose;


Solve modelMaxLifetimeEnforced using mip maximizing t;

File maxLifetimeResults /%outfile%\ResultsMaxLifetime.txt/;
put maxLifetimeResults;
put t.l
putclose;

t.fx=t.l;

Solve modelHopCountWithMaxLifetime using mip minimizing bmin;
File resultsHopWithMaxLifetime /%outfile%\ResultsHopWithMaxLifetime.txt/;
resultsHopWithMaxLifetime.pc = 5;
put resultsHopWithMaxLifetime;
*put "k","i","j","f"/;
loop(k,
    loop((i2,j2),
        put $(f.l(i2,j2,k)<>0.00) k.tl, i2.tl, j2.tl, f.l(i2,j2,k) /
    );

);
  
putclose;

File hopCountMaxLifetimeResults /%outfile%\ResultsHopCountWithMaxLifetime.txt/;
put hopCountMaxLifetimeResults;
put bmin.l
putclose;