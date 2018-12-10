function [] = validate_only(N, Rnet, RMax, Etx, filename, filename2)
%VALIDATENETWORK Validates the network for the given filename, and if the file not exists, regenerates it


    
    if exist(strcat(filename2,'\ResultsHopWithMaxLifetime.txt'),'file') && exist(strcat(filename2,'\ResultsMinHopCountEnforced.txt'),'file')
    
        return;
    else
        
    display(strcat('Not exist: ',filename2))
    end
    
    


end


