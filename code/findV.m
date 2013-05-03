function [v, theta] = findV(tempCent, plotflag)

v=sqrt(diff(tempCent(:,1)).^2 + diff(tempCent(:,2)).^2);
theta=atan(diff(tempCent(:,1))./diff(tempCent(:,2)));

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
