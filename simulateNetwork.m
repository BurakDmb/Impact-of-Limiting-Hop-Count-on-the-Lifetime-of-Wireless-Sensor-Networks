function [nodes] = simulateNetwork(N, Rnet, RMax, Etx, filename, filename2,mode)
%SÝMULATENETWORK Simulates the network for previously generated network, returns the optimation results data

    nodes=generateNetwork(N,Rnet,RMax,Etx, filename2);

      
    if mode==0
       %% Running the gams script
        cd 'gams/';
        system(strcat("gamsScript ",filename," &"));
        cd '../';   
    else
        %% Running the gams script
        cd 'gams/';
        system(strcat("gamsScript2 ",filename," &"));
        cd '../';  
    end
    
end

