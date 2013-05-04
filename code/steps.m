%steps


%DRAFT


avg_N2=[];
b=1;

for count = 1:b
    n_name = ['N2_' num2str(count) '.mat'];
    cents=kiacentroids(n_name, 4, 30, 200, 0.8,0.65,0,'C:/Users/Kiarash/Dropbox/aerotaxis/data/5_2/');
    trackParam=struct('mem',0,'dim',2,'good',5,'quiet',0);
    tracks=track(cents,15,trackParam);
    V=findV(tracks(:,[1,2,4]));
    avg=[mean(V(:,1)),mean(V(:,2))] ;  
    [x, y] = pol2cart(avg(:,2),avg(:,1));
    v = 0:.01:1*pi;
    h = compass(v, 5 * ones(size(v)));
    set(h, 'Visible', 'off')
    hold on
    compass(x, y)
end