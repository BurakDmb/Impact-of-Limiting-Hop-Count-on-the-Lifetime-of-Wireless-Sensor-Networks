function [EtxOpt,error] = findOptimalEnergyLevel(Etx, RMax, R)
%FÝNDOPTÝMALENERGYLEVEL Finds the optimal energy level inside the radius R
    lmax=length(RMax);
    for l=1:lmax
        if R < RMax(l)
            EtxOpt=Etx(l);
            error=0;
            return;
        end
    end
    error=1;
    EtxOpt=-1;
end

