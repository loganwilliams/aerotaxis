function plotTracks(tracks)
    figure(1)
    hold on
    for i = 1:length(tracks)
        tempCent=tracks((tracks(:,3)==i),1:2);
        plot(tempCent(:,1), tempCent(:,2))
        plot(tempCent(end,1), tempCent(end,2), 'o', 'MarkerSize', 5);
        axis([0 640 0 480])
    end   
end
