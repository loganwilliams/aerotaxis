function out=findV(tracks)
    allV=[];
    allTheta=[];
    for i = 1:max(tracks(:,4))
        tempCent=tracks((tracks(:,4)==i),1:2);
        [v,theta]=findOneV(tempCent,0);
        allV=[allV;v];
        allTheta=[allTheta;theta];
    end
    
out=[allV,allTheta];   
end

function [v, theta] = findOneV(position, plotflag)
    position;
    vx = diff(position(:,1));
    vy = diff(position(:,2));
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
