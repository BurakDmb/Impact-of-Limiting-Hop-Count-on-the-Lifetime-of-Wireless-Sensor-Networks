function [nodes] = generateNetwork(N, Rnet, RMax, Etx, filename)
%GENERATENETWORK Creates a random network using the input args and returns the simulated data
if exist(filename,'dir')
    rmdir (filename,'s')
end
mkdir(filename)
%% Function definition
rn=@(rn0) Rnet*sqrt(rn0); %rn calculation function
calculateDistance=@(theta1,theta2,r1,r2)...
    sqrt(r1^2+r2^2-(2*r1*r2*cos(theta1-theta2)));

%% Node creation
rng shuffle
nodes=rand(N,2);
nodes(:,1)=nodes(:,1)*(2*pi);
nodes(:,2)=rn(nodes(:,2));

%% Nodes.txt creation
fileID=fopen(strcat(filename,'\Nodes.txt'),'w');
fprintf(fileID,' V        allnodes     / ');
for i=1:N
    fprintf(fileID,'node-%d, ',i);
end
fprintf(fileID,'node-0');
fprintf(fileID,'/\n');

fprintf(fileID,' W(V)     exceptBase   / ');
for i=1:N-1
    fprintf(fileID,'node-%d, ',i);
end
fprintf(fileID,'node-%d',N);
fprintf(fileID,'/\n');

fclose(fileID);
%% Distance matrix creation
distance=zeros(N);
for i=1:N
   for j=1:N
       distance(i,j)=calculateDistance(nodes(i,1), nodes(j,1), nodes(i,2), nodes(j,2));
   end
end

%% ExtOptTable.txt creation
optimalEnergy=zeros(N);
fileID=fopen(strcat(filename,'\EtxOptTable.txt'),'w');
for i=1:N
    %fprintf(fileID,'EtxOpt(\"node-0\",\"node-%d\") = inf;\n',i);
   for j=i:N
       [optimalEnergy(i,j),err]=findOptimalEnergyLevel(Etx,RMax,distance(i,j));
       if err==0
           fprintf(fileID,'EtxOpt(\"node-%d\",\"node-%d\") = %f;\n',i,j,optimalEnergy(i,j));
       end
   end
   [eLevel, err]=findOptimalEnergyLevel(Etx,RMax,nodes(i,2));
   if err==0
       fprintf(fileID,'EtxOpt(\"node-%d\",\"node-0\") = %f;\n',i,eLevel);
   end
end
fclose(fileID);

%% OutOfRangeDistances.txt creation
fileID=fopen(strcat(filename,'\OutOfRangeDistances.txt'),'w');
%eq9(i2,j2,k) ..  f(i2,j2,k)$(sameas(i2,"node-1") and sameas(j2,"node-0")) =e= 0;
%fprintf(fileID,'eq9(i2,j2,k) ..  f(i2,j2,k)$(\n');
for i=1:N
    if nodes(i,2)>RMax(length(RMax))
           fprintf(fileID,'f.fx(\"node-%d\",\"node-0\",k) = 0;\n',i);
    end
    for j=1:N
        if distance(i,j) > RMax(length(RMax))
           fprintf(fileID,'f.fx(\"node-%d\","node-%d\",k) = 0;\n',i,j);
        end
    end
end
fclose(fileID);

end

