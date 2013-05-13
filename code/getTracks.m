function [allTracks] = getTracks(folder, nFrames)

trackParam=struct('mem',0,'dim',2,'good',15,'quiet',0);

for i = 0:nFrames
    n_name = ['samp_' num2str((i*15)) '.mat'];
    cents=kiacentroids(n_name,4,40,200,0.75,0.5,0,...
                   folder);
    tracks=track(cents,15,trackParam);
    allTracks(i+1,1:length(tracks),:) = tracks(:,1:4);
    tracks = [];
end
end