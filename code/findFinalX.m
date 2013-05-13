function out=findFinalV(tracks)
    allV=[];
    allTheta=[];
    for i = 1:max(tracks(:,3))
        tempCent=tracks((tracks(:,3)==i),1:2);
        vx=findOneFinalX(tempCent,0);
        allVx=[allV;vx];
    end
    
out=allVx; 
end

function vx = findOneFinalX(position, plotflag)
    n = nnz(position) / 2;
    
    vx = position(n,1) - position(1,1);


    if plotflag==1
        figure
        subplot(1,3,1)
        plot(tempCent(:,1),tempCent(:,2))
        title('Trajectory')
        subplot(1,3,2)
        plot(v)
        title('V')
        subplot(1,3,3)
        plot(theta)
        title('Theta')
    end
end
