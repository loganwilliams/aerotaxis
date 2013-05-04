function out = kiacentroids(filename, DilationRadius, AreaMin,...
    AreaMax, EccentricityMax,optionalThreshold, optionalPlotflag, optionalFolder)

if nargin>8
    error('myfuns:somefun2:TooManyInputs');
end
switch nargin
    case {5,6}
        optionalFolder='C:/Users/Kiarash/Dropbox/aerotaxis/data/5_2/';
        optionalPlotflag=1;
    case 7
        optionalFolder='C:/Users/Kiarash/Dropbox/aerotaxis/data/5_2/';        
end



fLoad=load([optionalFolder filename]);
[~,filePref,e]=fileparts(filename);
MicroSphereFrames = fLoad.(filePref)*16; % gain up from 12 to 16 bit

if nargin==5
    optionalThreshold=graythresh(MicroSphereFrames(:,:,1,10));    
    fprintf('otsu threshold is : %d \n',optionalThreshold);
end



MicroSphereCentroids = [];
NewLineCount = 0;
numFrames = size(MicroSphereFrames, 4);

for i = 1:numFrames

    frame = MicroSphereFrames(:,:,1,i);
    BW = im2bw(frame, optionalThreshold);
    SE = strel('disk', DilationRadius,4);
    BWdilated = imdilate(BW,SE);
    BWdilated = imclearborder(BWdilated);
    [L, num] = bwlabel(BWdilated);
    
    STATS = regionprops(L, frame, 'WeightedCentroid','Area','Eccentricity');

    FrameCentroids = cat(1,STATS(:).WeightedCentroid);
    FrameArea = cat(1,STATS(:).Area);
    FrameEccentricity = cat(1,STATS(:).Eccentricity);  
    
    AreaSwitch = ~((FrameArea < AreaMin) | (FrameArea > AreaMax));    
    
    %SaturatedSwitch = ~(FrameMaxIntensity > floor(IntensityMax*2^16));
    EccentricSwitch = ~(FrameEccentricity > EccentricityMax);
    
    FrameCentroidOnOffSwitch = AreaSwitch .* EccentricSwitch;
    
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

    if optionalPlotflag
        figure(4)
        imshow(frame)
        hold on
        plot(MicroSphereCentroids((MicroSphereCentroids(:,3)==i),1),...
            MicroSphereCentroids((MicroSphereCentroids(:,3)==i),2),'O',...
                'LineWidth',1,...
                'MarkerFaceColor','none',...
                'MarkerEdgeColor','g',...
                'MarkerSize',20)
        %for j = 1:size(FrameBoundingBox,1)
        %    rectangle('Position',FrameBoundingBox(j,:),...
        %        'EdgeColor','y')
        %end
        hold off
        pause(0.2)
    end
    
    if mod(i,50)==0
        NewLineCount = NewLineCount + 1;
    end
    if mod(NewLineCount,10)==0 && NewLineCount>5
        NewLineCount = 0;
    end
end

out = MicroSphereCentroids;

