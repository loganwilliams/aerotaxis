function out = playcentroids(filename, FrameCentroids, folder)

load([folder filename]);
OverlayHandle = figure(4);
figure(OverlayHandle);
%figure('Visible', 'on');
MicroSphereFrames = eval(filename(1:end-4))*16; % gain up from 12 to 16 bit
F = getframe(OverlayHandle);
FrameSize = size(F.cdata(:,:,1));
FrameCount = size(MicroSphereFrames, 4);
MicroSphereMarkup = zeros([FrameSize FrameCount]); 

for i = 1:FrameCount
    figure(4)
    frame = MicroSphereFrames(:,:,1,i);
    imshow(frame)
    hold on
    plot(FrameCentroids((FrameCentroids(:,3)==i),1), ...
         FrameCentroids((FrameCentroids(:,3)==i),2), 'O', ...
            'LineWidth',1,...
            'MarkerEdgeColor','g',...
            'MarkerFaceColor','none',...
            'MarkerSize',20)
    hold off
    pause(0.4)
end

