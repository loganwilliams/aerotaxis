vid = videoinput('gige', 1, 'Mono12');
src = getselectedsource(vid);
vid.FramesPerTrigger = 30;
triggerconfig(vid, 'manual');
src.AcquisitionFrameRateAbs = 15;
src.ExposureAuto = 'Off';
src.ExposureTimeAbs = 650;
vid.LoggingMode = 'memory';
imaqmem(4000000000);
vid.TriggerRepeat = Inf;
starttime = clock;
start(vid)
current_trig = 0;

while (etime(clock, starttime) < 30)
    if etime(clock, starttime) > current_trig
        trigger(vid);
        current_trig = current_trig + 15;
    end
end
    
data = getdata(vid);

stop(vid);
save('data.mat', 'data');