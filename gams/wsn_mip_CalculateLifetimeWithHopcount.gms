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
scalar bmin3 betamin /0/;
scalar it iteration;
it=0;
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
eq8         ..  sum(i2, sum(j2, sum(k, f(i2,j2,k)))) =e=  bmin3 * t2 ;
eq9         ..  sum(i2, sum(j2, sum(k, f(i2,j2,k)))) =e=  bmin2 * t2.l ;
eq10        ..  bmin2 =e= bmin;
eq11        ..  t2 =e= t;


$include %outfile%\OutOfRangeDistances.txt


Model modelFindMinHopCount /eq1, eq2, eq3, eq4, eq10/;
Model modelMaxLifetimeEnforced /eq4, eq2, eq5, eq6, eq7, eq11/ ;
Model modelMinHopCountEnforced /eq4, eq2, eq5, eq6, eq7, eq8, eq11/ ;


Solve modelFindMinHopCount using mip minimizing bmin;

File minHopCountResults /%outfile%\ResultsMinHopCount.txt/;
if(bmin2.l >0,
    put minHopCountResults;
    put bmin2.l
);

putclose;

File resultsLifeHop /%outfile%\ResultsLifetimeWithHopCount.txt/;
resultsLifeHop.pc = 5;
while (it < 8,
    bmin3=bmin2.l*(1+0.05*it);
    Solve modelMinHopCountEnforced using mip maximizing t;
    display f.l;
       
    put resultsLifeHop;
    put t.l, it /;  
    it=it+1;
);
putclose;

Solve modelMaxLifetimeEnforced using mip maximizing t;

File maxLifetimeResults /%outfile%\ResultsMaxLifetime.txt/;
put maxLifetimeResults;
put t.l
putclose;
