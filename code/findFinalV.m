function out=findFinalV(tracks)
    allV=[];
    allTheta=[];
    for i = 1:max(tracks(:,3))
        tempCent=tracks((tracks(:,3)==i),1:2);
        [v,theta]=findOneFinalV(tempCent,0);
        allV=[allV;v];
        allTheta=[allTheta;theta];
    end
    
out=[allV,allTheta];   
end

function [v, theta] = findOneFinalV(position, plotflag)
    n = nnz(position) / 2;
    
    vx = position(n,1) - position(1,1);
    vy = position(n,2) - position(1,2);
    v  = sqrt( vx.^2 + vy.^2 );
    theta = atan2( vy , vx );

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
