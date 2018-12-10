function [minimumHopCount, pathsWithMinHop, ...
    lifeTimeWithMinHop, hopCountWithMaxLifeTime,...
    pathsWithMaxLifeTime, maxLifeTime] = calculateNetwork(filename)
%CALCULATENETWORK Summary of this function goes here
%   Detailed explanation goes here



%% Reading from ResultsMaxLifetimeEnforced.txt and processing the results with matlab.
if ~exist(strcat(filename,'\ResultsHopWithMaxLifetime.txt'),'file') 
    display(strcat('Not exist: ',filename))
end
fileID = fopen(strcat(filename,'\ResultsHopWithMaxLifetime.txt'),'r');
A = textscan(fileID,'%q %q %q %f','Delimiter',',');
pathsWithMaxLifeTime=zeros(size(A,2),4);
for i=1:size(A{4},1)
    pathsWithMaxLifeTime(i,1)=str2double(strrep(A{1}{i},'node-',''));
    pathsWithMaxLifeTime(i,2)=str2double(strrep(A{2}{i},'node-',''));
    pathsWithMaxLifeTime(i,3)=str2double(strrep(A{3}{i},'node-',''));
    pathsWithMaxLifeTime(i,4)=A{4}(i);
end
fclose(fileID);
%% Reading from ResultsMinHopCountEnforced.txt and processing the results with matlab.
fileID = fopen(strcat(filename,'\ResultsMinHopCountEnforced.txt'),'r');
A= textscan(fileID, '%q %q %q %f','Delimiter', ',');
pathsWithMinHop=zeros(size(A,2),4);
for i=1:size(A{4},1)
    pathsWithMinHop(i,1)=str2double(strrep(A{1}{i},'node-',''));
    pathsWithMinHop(i,2)=str2double(strrep(A{2}{i},'node-',''));
    pathsWithMinHop(i,3)=str2double(strrep(A{3}{i},'node-',''));
    pathsWithMinHop(i,4)=A{4}(i);
end
fclose(fileID);

%% Returning the minimum hop count
fileID=fopen(strcat(filename,'\ResultsMinHopCount.txt'),'r');
minimumHopCount=fscanf(fileID,'%f');
fclose(fileID);

%% Returning the hopCountWithMaxLifeTime
fileID=fopen(strcat(filename,'\ResultsHopCountWithMaxLifetime.txt'),'r');
hopCountWithMaxLifeTime=fscanf(fileID,'%f');
fclose(fileID);

%% Reading the lifetime of network with MinHop enforced
fileID= fopen(strcat(filename,'\ResultsLifetime.txt'),'r');
lifeTimeWithMinHop=fscanf(fileID,'%f');
fclose(fileID);

%% Reading the max lifetime of the network
fileID=fopen(strcat(filename,'\ResultsMaxLifetime.txt'),'r');
maxLifeTime=fscanf(fileID,'%f');
fclose(fileID);


end

