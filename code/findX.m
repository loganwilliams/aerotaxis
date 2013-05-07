function allX=findX(tracks)
    allX=[];
    for i = 1:max(tracks(:,3))
        tempCent=tracks((tracks(:,3)==i),1:2);
        x=findOneX(tempCent,0);
        allX=[allX;x];
    end   
end

function vx = findOneX(position, plotflag)

    vx = diff(position(:,1));
    %vy = diff(position(:,2));
    %v  = sqrt( vx.^2 + vy.^2 );
    %theta = atan2( vy , vx );

    if plotflag==1
        figure
        subplot(1,3,1)
        plot(tempCent(:,1),tempCent(:,2))
        title('Trajectory')
        subplot(1,3,2)
        plot(vx)
        title('vx')
    end
end
