function [] = validateNetwork(N, Rnet, RMax, Etx, filename, filename2)
%VALIDATENETWORK Validates the network for the given filename, and if the file not exists, regenerates it

while true
    

%% Running the gams script
    printCounter=15;
    secondsWaited=0;
    maxSecondsToWait=120;
    if exist(strcat(filename2,'\ResultsHopWithMaxLifetime.txt'),'file') && exist(strcat(filename2,'\ResultsMinHopCountEnforced.txt'),'file')
        return;
    else
        display(strcat('Validate-not found-generating:  ', filename2));
    end
    generateNetwork(N,Rnet,RMax,Etx, filename2);
    cd 'gams/';
    system(strcat("gamsScript ",filename," &"));
    cd '../';
    while secondsWaited<maxSecondsToWait
        if exist(strcat(filename2,'\ResultsHopWithMaxLifetime.txt'),'file') && exist(strcat(filename2,'\ResultsMinHopCountEnforced.txt'),'file')
            return;
        end
        if exist(strcat(filename2,'\ResultsHopCountWithMaxLifetime.txt'),'file')
            break;
        end
        if secondsWaited>=printCounter 
           printCounter=printCounter+15;
           display(strcat('Validate-waiting:  ', filename2,', for: ',num2str(secondsWaited),' seconds'));
        end
        pause(1);
        secondsWaited=secondsWaited+1;
    end
    
    
end

end


