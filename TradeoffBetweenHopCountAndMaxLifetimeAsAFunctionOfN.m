close all;


%% Constant definition
N=30;
N_Increase=5;
N_Count=5;
Rnet=100;
Rnet_Increase=100;
Rnet_Count=2;
Average_Count=40;
%% Rmax deðerlerinin okunmasý

fileID = fopen('Constant_RmaxValues.txt','r');
RMax = textscan(fileID,'%f','Delimiter',',');
RMax = RMax{1};
fclose(fileID);

%% Etx deðerlerinin okunmasý

fileID = fopen('Constant_EtxValues.txt','r');
Etx = textscan(fileID,'%f','Delimiter',',');
Etx = Etx{1};
fclose(fileID);

%% Parallel generation for efficiency
legendString=strings(N_Count,1);
for r=1:Rnet_Count
    numberOfNodes=zeros(N_Count,1);
    maxLifeTimePercent=zeros(N_Count,1);
    minHopCounts=zeros(N_Count,1);
    hopCountPercent=zeros(N_Count,1);
    rnet=Rnet+Rnet_Increase*(r-1);
    for i=1:N_Count
        numberOfNodes(i)=N+N_Increase*(i-1);
        for j=1:Average_Count
            filename1=strcat('..\results\',num2str(r),'\',num2str(i),'\',num2str(j));
            filename2=strcat('results\',num2str(r),'\',num2str(i),'\',num2str(j));

            nodes=simulateNetwork(numberOfNodes(i), rnet, RMax, Etx, filename1,filename2, 0);
            if j==Average_Count/2
                waitToComplete(filename2,0);
            end
        end
        
        waitToComplete(filename2,0);
    end
    
end

%% Validating the results
for r=1:Rnet_Count
    numberOfNodes=zeros(N_Count,1);
    maxLifeTimePercent=zeros(N_Count,1);
    minHopCounts=zeros(N_Count,1);
    hopCountPercent=zeros(N_Count,1);
    rnet=Rnet+Rnet_Increase*(r-1);
    for i=1:N_Count
        numberOfNodes(i)=N+N_Increase*(i-1);
        for j=1:Average_Count
            filename1=strcat('..\results\',num2str(r),'\',num2str(i),'\',num2str(j));
            filename2=strcat('results\',num2str(r),'\',num2str(i),'\',num2str(j));
            validateNetwork(numberOfNodes(i), rnet, RMax, Etx, filename1,filename2);
            %validate_only(numberOfNodes(i), rnet, RMax, Etx, filename1,filename2);
        end
    end
    
    
end

%% Calculate and plot the values

calculateAverageResults(N, N_Increase, N_Count, Rnet, Rnet_Increase, Rnet_Count, Average_Count, 0);
