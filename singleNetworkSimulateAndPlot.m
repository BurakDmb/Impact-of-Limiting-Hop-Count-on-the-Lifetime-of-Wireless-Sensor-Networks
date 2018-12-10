

%% Constant definition
N=30;
Rnet=100;
filename='..\results\singleNetwork';
filename2='results\singleNetwork';

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

nodes = simulateNetwork(N, Rnet, RMax, Etx, filename, filename2, 0);
waitToComplete(filename2,0);
[minimumHopCount, pathsWithMinHop, ...
    lifeTimeWithMinHop, hopCountWithMaxLifeTime,...
    pathsWithMaxLifeTime, maxLifeTime] = calculateNetwork(filename2);




%% Figure-1 Minimim hop count enforced.
figure('Name','Minimim hop count enforced');
title('Minimim hop count enforced');
col=hsv(N);
for n=1:N
    clearvars realPathsIndex;
    realPathsIndex=find(pathsWithMinHop(:,1)==n & pathsWithMinHop(:,4));
    for k=1:size(realPathsIndex,1)
        plotdata=zeros(2,2);
        plotdata(1,:)= findNode(nodes,pathsWithMinHop(realPathsIndex(k),2));
        plotdata(2,:)= findNode(nodes,pathsWithMinHop(realPathsIndex(k),3));
        polarplot(plotdata(:,1), plotdata(:,2),...
            's-', 'Linewidth', 0.5,...
            'MarkerSize', 15, 'color',col(n,:),...
            'MarkerFaceColor', col(n,:),'MarkerIndices',1);
        hold on;
    end
end

for k=1:size(nodes,1)
    text(nodes(k,1), nodes(k,2),num2str(k));
end

%% Figure-2 Maximum lifetime enforced.
figure('Name','Maximum lifetime enforced');
title('Maximum lifetime enforced');
col=hsv(N);
for n=1:N
    clearvars realPathsIndex;
    realPathsIndex=find(pathsWithMaxLifeTime(:,1)==n & pathsWithMaxLifeTime(:,4));
    for k=1:size(realPathsIndex,1)
        plotdata=zeros(2,2);
        plotdata(1,:)= findNode(nodes,pathsWithMaxLifeTime(realPathsIndex(k),2));
        plotdata(2,:)= findNode(nodes,pathsWithMaxLifeTime(realPathsIndex(k),3));
        polarplot(plotdata(:,1), plotdata(:,2),...
            's-', 'Linewidth', 0.5,...
            'MarkerSize', 15, 'color',col(n,:),...
            'MarkerFaceColor', col(n,:),'MarkerIndices',1);
        hold on;
    end
end

for k=1:size(nodes,1)
    text(nodes(k,1), nodes(k,2),num2str(k));
end
