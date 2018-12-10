function [] = calculateAverageResults(N, N_Increase, N_Count, Rnet, Rnet_Increase, Rnet_Count, Average_Count, mode)
%CALCULATEAVERAGERESULTS Summary of this function goes here
%   Detailed explanation goes here

close all;

if mode==0
    
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




    legendString=strings(Rnet_Count,1);
    for r=1:Rnet_Count
        numberOfNodes=zeros(N_Count,1);
        maxLifeTimePercent=zeros(N_Count,1);
        minHopCounts=zeros(N_Count,1);
        hopCountPercent=zeros(N_Count,1);
        rnet=Rnet+Rnet_Increase*(r-1);
        for i=1:N_Count
            numberOfNodes(i)=N+N_Increase*(i-1);

            minHopCounts(i)=0;
            maxLifeTimePercent(i)=0;
            hopCountPercent(i)=0;
            for j=1:Average_Count

                filename1=strcat('..\results\',num2str(r),'\',num2str(i),'\',num2str(j));
                filename2=strcat('results\',num2str(r),'\',num2str(i),'\',num2str(j));

                [minHopCountsTmp, pathsWithMinHop, lifeTimeWithMinHop,...
                    hopCountWithMaxLifeTime, pathsWithMaxLifeTime, maxLifeTime]=...
                    calculateNetwork(filename2);

                hopCountPercentTmp=(hopCountWithMaxLifeTime/minHopCountsTmp)*100-100;
                maxLifeTimePercentTmp=100*((maxLifeTime-lifeTimeWithMinHop)/(maxLifeTime));


                minHopCounts(i)=minHopCounts(i)+minHopCountsTmp;
                maxLifeTimePercent(i)=maxLifeTimePercent(i)+maxLifeTimePercentTmp;
                hopCountPercent(i)=hopCountPercent(i)+hopCountPercentTmp;
            end
            minHopCounts(i)=minHopCounts(i)/Average_Count;
            maxLifeTimePercent(i)=maxLifeTimePercent(i)/Average_Count;
            hopCountPercent(i)=hopCountPercent(i)/Average_Count;

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
else


    for r=1:Rnet_Count
        rnet=Rnet+Rnet_Increase*(r-1);
        figure('Name','Network lifetime-Hop count.');
        legendString=strings(N_Count,1);
        numberOfNodes=zeros(N_Count,1);
        for i=1:N_Count
            numberOfNodes(i)=N+N_Increase*(i-1);
            lifeTimeDecreaseTmp=zeros(8,1);
            for j=1:Average_Count
                
                    filename1=strcat('..\results2\',num2str(r),'\',num2str(i),'\',num2str(j));
                    filename2=strcat('results2\',num2str(r),'\',num2str(i),'\',num2str(j));
                    [lifeTime, maxLifeTime]=...
                        calculateLifetimeNetwork(filename2);
                     lifeTimeDecreaseTmp=lifeTimeDecreaseTmp+100*((maxLifeTime-lifeTime(:,1))/(maxLifeTime));
            end
            lifeTimeDecrease=lifeTimeDecreaseTmp/Average_Count;
            hopCountIncrease=[0;5; 10; 15; 20; 25; 30; 35];
            
            
            plot(hopCountIncrease,lifeTimeDecrease,'-o');
            hold on;
            legendString(i)=strcat(num2str(numberOfNodes(i)),' nodes');
        end
        legend(legendString);
        
        xlabel('Hop Count Increase(%)');
        ylabel('Lifetime Decrease(%)');

        xlim([-3 38]);
        title(strcat('Network lifetime-Hop count R=',num2str(rnet)));
    end
    
    
end


end

