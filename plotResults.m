%% Constant definition
N=25;
N_Increase=3;
N_Count=2;
Rnet=100;
Rnet_Increase=20;
Rnet_Count=3;
%% Figure-1 Minimum Hop Count.
f1=figure('Name','Minimum Hop Count.');
ylim([0 100]);
xlim([N-1 N+N_Increase*(N_Count-1)+1]);
title('Minimum Hop Count');



%% Figure-2 Decrease in network lifetime when the minimum hop count is enforced.
f2=figure('Name','Decrease in network lifetime when the minimum hop count is enforced.');
ylim([0 100]);
xlim([N-1 N+N_Increase*(N_Count-1)+1]);
title('Decrease in network lifetime when the minimum hop count is enforced');


%% Figure-3 Hop Count increase to achieve the maximum lifetime.
f3=figure('Name','Hop Count increase to achieve the maximum lifetime.');

title('Hop Count increase to achieve the maximum lifetime');




legendString=strings(N_Count,1);
for r=1:Rnet_Count
    numberOfNodes=zeros(N_Count,1);
    maxLifeTimePercent=zeros(N_Count,1);
    minHopCounts=zeros(N_Count,1);
    hopCountPercent=zeros(N_Count,1);
    rnet=Rnet+Rnet_Increase*(r-1);
    for i=1:N_Count
        numberOfNodes(i)=N+N_Increase*(i-1);
        
        
        filename1=strcat('..\results\',num2str(r),'\',num2str(i));
        filename2=strcat('results\',num2str(r),'\',num2str(i));
        
        
        [minHopCounts(i), pathsWithMinHop, lifeTimeWithMinHop,...
            hopCountWithMaxLifeTime, pathsWithMaxLifeTime, maxLifeTime]=...
            calculateNetwork(filename2);
        hopCountPercent(i)=(hopCountWithMaxLifeTime/minHopCounts(i))*100-100;
        maxLifeTimePercent(i)=100*((maxLifeTime-lifeTimeWithMinHop)/(maxLifeTime));
       
    end
    figure(f1);
    plot(numberOfNodes,minHopCounts,'-o');
    hold on;
    
    figure(f2);
    plot(numberOfNodes,maxLifeTimePercent,'-o');
    hold on;
    
    figure(f3);
    plot(numberOfNodes,hopCountPercent,'-o');
    hold on;
    
    legendString(r)=strcat('Rnet=',num2str(rnet));
end





figure(f1);
grid;
legend(legendString);
xlabel('Number of Nodes');
ylabel('Minimum Hop Count');

figure(f2);
grid;
legend(legendString);
ylim([0 100]);
xlim([N-1 N+N_Increase*(N_Count-1)+1]);
xlabel('Number of Nodes');
ylabel('Lifetime Decrease(%)');

figure(f3);
grid;
legend(legendString);
ylim([0 100]);
xlim([N-1 N+N_Increase*(N_Count-1)+1]);
xlabel('Number of Nodes');
ylabel('Hop Count increase(%)');