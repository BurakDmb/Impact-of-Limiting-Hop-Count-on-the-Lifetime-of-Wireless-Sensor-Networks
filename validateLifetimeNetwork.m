function [] = validateLifetimeNetwork(N, Rnet, RMax, Etx, filename, filename2)
%VALIDATELIFETIMENETWORK Summary of this function goes here
%   Detailed explanation goes here
while true
    

%% Running the gams script
    printCounter=15;
    secondsWaited=0;
    maxSecondsToWait=120;
    if exist(strcat(filename2,'\ResultsMinHopCount.txt'),'file')
        return;
    else
        display(strcat('Validate2-not found-generating:  ', filename2));
    end
    generateNetwork(N,Rnet,RMax,Etx, filename2);
    cd 'gams/';
    system(strcat("gamsScript2 ",filename," &"));
    cd '../';
    while secondsWaited<maxSecondsToWait
        if exist(strcat(filename2,'\ResultsMinHopCount.txt'),'file') 
            return;
        end
        if exist(strcat(filename2,'\ResultsMaxLifetime.txt'),'file')
            break;
        end
        if secondsWaited>=printCounter 
           printCounter=printCounter+15;
           display(strcat('Validate2-waiting:  ', filename2,', for: ',num2str(secondsWaited),' seconds'));
        end
        pause(1);
        secondsWaited=secondsWaited+1;
    end
    
    
end

end

