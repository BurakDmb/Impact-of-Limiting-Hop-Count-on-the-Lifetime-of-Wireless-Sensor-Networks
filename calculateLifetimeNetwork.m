function [lifeTime, maxLifeTime] = calculateLifetimeNetwork(filename)
%CALCULATENETWORK Summary of this function goes here
%   Detailed explanation goes here



%% Reading from ResultsMaxLifetimeEnforced.txt and processing the results with matlab.
if ~exist(strcat(filename,'\ResultsLifetimeWithHopCount.txt'),'file') 
    display(strcat('Not exist: ',filename))
end
fileID = fopen(strcat(filename,'\ResultsLifetimeWithHopCount.txt'),'r');
A = textscan(fileID,'%f %f','Delimiter',',');
lifeTime=zeros(size(A,2),2);
for i=1:size(A{2},1)
    lifeTime(i,1)=A{1}(i);
    lifeTime(i,2)=A{2}(i);
end
fclose(fileID);

%% Reading the max lifetime of the network
fileID=fopen(strcat(filename,'\ResultsMaxLifetime.txt'),'r');
maxLifeTime=fscanf(fileID,'%f');
fclose(fileID);


end

