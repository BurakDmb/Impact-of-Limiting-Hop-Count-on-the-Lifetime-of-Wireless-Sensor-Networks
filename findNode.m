function [node] = findNode(nodes,nodeIndex)
%FÝNDNODE Summary of this function goes here
%   Detailed explanation goes here
node=zeros(2,1);
if nodeIndex==0
   node(1)=0;
   node(2)=0;
else
    node=nodes(nodeIndex,:);
end
end

