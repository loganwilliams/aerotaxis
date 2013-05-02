function out = mycentroids(filename, Threshold, DilationRadius, AreaMin,...
    AreaMax, IntensityMax, EccentricityMax, plotflag)

load(['C:/Users/student/Documents/GitHub/aerotaxis/data/cereus_bright/' filename]);
MicroSphereFrames = eval(filename(1:end-4))*16; % gain up from 12 to 16 bit
MicroSphereCentroids = [];
% CentroidOnOffSwitch = [];
NewLineCount = 0;
numFrames = size(MicroSphereFrames, 4);

%fprintf('number of frames: %d',numFrames);

for i = 1:numFrames
%     [BinnedIntensity IntensityBins] = imhist(MicroSphereFrames(:,:,1,i),2^16);
%     [maxfoo ModeIntensity] = max);
%     BackgroundLevel = ceil(
    frame = MicroSphereFrames(:,:,1,i);
    BW = im2bw(frame, Threshold);
    SE = strel('disk', DilationRadius);
    BWdilated = imdilate(BW,SE);
    BWdilated = imclearborder(BWdilated);
    [L, num] = bwlabel(BWdilated);
    
    STATS = regionprops(L, frame, 'WeightedCentroid','Area', ...
        'BoundingBox','MaxIntensity','Eccentricity');

    FrameCentroids = cat(1,STATS(:).WeightedCentroid);
    FrameArea = cat(1,STATS(:).Area);
    FrameBoundingBox = cat(1,STATS(:).BoundingBox);
    FrameMaxIntensity = cat(1,STATS(:).MaxIntensity);
    FrameEccentricity = cat(1,STATS(:).Eccentricity);    
    %fprintf('frame max intensity:%d   , %d \n', FrameMaxIntensity,FrameEccentricity);
    
    AreaSwitch = ~((FrameArea < AreaMin) | (FrameArea > AreaMax));
    SaturatedSwitch = ~(FrameMaxIntensity > floor(IntensityMax*2^16));
    EccentricSwitch = ~(FrameEccentricity > EccentricityMax);
    
    FrameCentroidOnOffSwitch = AreaSwitch ...
        .* SaturatedSwitch .* EccentricSwitch;
    
    ProcessedFrameCentroids = [FrameCentroids, ...
        ones(size(FrameCentroids,1),1)*i] ...
                .*[FrameCentroidOnOffSwitch, FrameCentroidOnOffSwitch, ...
                   FrameCentroidOnOffSwitch];
    
    ProcessedFrameCentroids(ProcessedFrameCentroids==0) = [];
    if size(ProcessedFrameCentroids, 1) == 1
        ProcessedFrameCentroids = reshape(ProcessedFrameCentroids, round(...
            length(ProcessedFrameCentroids)/3), 3);
    end
    
    MicroSphereCentroids = [MicroSphereCentroids; ...
                ProcessedFrameCentroids];

    if plotflag
        figure(4)
        imshow(frame)
        hold on
        plot(MicroSphereCentroids((MicroSphereCentroids(:,3)==i),1),...
            MicroSphereCentroids((MicroSphereCentroids(:,3)==i),2),'x',...
                'LineWidth',1,...
                'MarkerEdgeColor','r',...
                'MarkerFaceColor','g',...
                'MarkerSize',5)
        for j = 1:size(FrameBoundingBox,1)
            rectangle('Position',FrameBoundingBox(j,:),...
                'EdgeColor','y')
        end
        hold off
        pause(0.2)
    end
    if mod(i,50)==0
        NewLineCount = NewLineCount + 1;
    end
    if mod(NewLineCount,10)==0 & NewLineCount>5
        NewLineCount = 0;
    end
end
out = MicroSphereCentroids;
