function [] = waitToComplete(filename2, mode)
%WAITTOCOMPLETE Summary of this function goes here
%   Detailed explanation goes here

while true
    if mode==0
        printCounter=60;
        secondsWaited=0;
        maxSecondsToWait=120;

        if exist(strcat(filename2,'\ResultsHopCountWithMaxLifetime.txt'),'file') && exist(strcat(filename2,'\ResultsMinHopCount.txt'),'file')
            return;
        end
        while secondsWaited<maxSecondsToWait
            if exist(strcat(filename2,'\ResultsHopCountWithMaxLifetime.txt'),'file') && exist(strcat(filename2,'\ResultsMinHopCount.txt'),'file')

                return;
            end
            if secondsWaited>=printCounter 
               printCounter=printCounter+60;
               display(strcat('Waited: ', filename2,', for: ',num2str(secondsWaited),' seconds'));
            end
            pause(1);
            secondsWaited=secondsWaited+1;
        end
    else
        printCounter=60;
        secondsWaited=0;
        maxSecondsToWait=120;

        if exist(strcat(filename2,'\ResultsMaxLifetime.txt'),'file') 
            return;
        end
        while secondsWaited<maxSecondsToWait
            if exist(strcat(filename2,'\ResultsMaxLifetime.txt'),'file') 

                return;
            end
            if secondsWaited>=printCounter 
               printCounter=printCounter+60;
               display(strcat('Waited: ', filename2,', for: ',num2str(secondsWaited),' seconds'));
            end
            pause(1);
            secondsWaited=secondsWaited+1;
        end
        
    end

    
end

end

