vid = videoinput('gige', 1, 'Mono12'); % find video input
src = getselectedsource(vid);
vid.FramesPerTrigger = 30; % 30 frames per trigger
triggerconfig(vid, 'manual'); % manual trigger
src.AcquisitionFrameRateAbs = 15; % 15 fps (actually 14.999...)
src.ExposureAuto = 'Off'; % manual exposure
src.ExposureTimeAbs = 650;
vid.LoggingMode = 'memory'; % log to memory
imaqmem(4000000000); % 4GB max
vid.TriggerRepeat = Inf; % allow infinite triggers

start(vid);
starttime = clock;
current_trig = 0;

max_time = 20 * 60; % minutes to capture
trigger_interval = 15; % trigger interval (in s)

while (etime(clock, starttime) < max_time)
    if etime(clock, starttime) > current_trig
        trigger(vid);
        current_trig = current_trig + trigger_interval;
        disp(sprintf('Time elapsed: %f seconds\n', etime(clock, starttime)));
    end
end
    
data = getdata(vid);

stop(vid);
save('data.mat', 'data');