function graphBacteria(id,nFrames)  

switch id
    
    case 0 %show a few random tracks
        n_name = ['N2_1.mat'];
        cents=kiacentroids(n_name, 4, 30, 200, 0.8,0.65,0,...
                           'C:/Users/Kiarash/Dropbox/aerotaxis/data/5_2/');
        trackParam=struct('mem',0,'dim',2,'good',5,'quiet',0);
        tracks=track(cents,15,trackParam);   
        tempCent=tracks((tracks(:,4)==15 | tracks(:,4)==20 | tracks(:,4)==55 | tracks(:,4)==120),1:3);
        playtrack(n_name,tempCent);        
        
    case 1   
        nCount=[];
        oCount=[];
        for i = 1:nFrames
            n_name = ['N2_' num2str(i) '.mat'];
            cents=kiacentroids(n_name, 4, 30, 200, 0.8,0.65,0,...
                               'C:/Users/Kiarash/Dropbox/aerotaxis/data/5_2/');
            trackParam=struct('mem',0,'dim',2,'good',5,'quiet',0);
            tracks=track(cents,15,trackParam);
            nCount=[nCount max(tracks(:,4))];

            n_name = ['O2_' num2str(i) '.mat'];
            cents=kiacentroids(n_name, 4, 30, 200, 0.8,0.65,0,...
                               'C:/Users/Kiarash/Dropbox/aerotaxis/data/5_2/');
            trackParam=struct('mem',0,'dim',2,'good',5,'quiet',0);
            tracks=track(cents,15,trackParam);
            oCount=[oCount max(tracks(:,4))];
        end    
        plot(nCount,'-ro')
        xlabel('Minute');
        ylabel('Number of Tracks of Bacteria Over');
        title(['Change of Number of Tracks of Bacteria Over Time']);
        hold on
        plot(oCount,'-xb')
        hold off
        hleg1=legend('N_2','O_2');
        set(hleg1,'Location','NorthWest')
    
    case 2
        nAvg=[];
        oAvg=[];
        for i = 1:nFrames
            n_name = ['N2_' num2str(i) '.mat'];
            cents=kiacentroids(n_name, 4, 30, 200, 0.8,0.65,0,...
                               'C:/Users/Kiarash/Dropbox/aerotaxis/data/5_2/');
            trackParam=struct('mem',0,'dim',2,'good',5,'quiet',0);
            tracks=track(cents,15,trackParam);
            V=findV(tracks(:,[1,2,4]));
            nAvg=[nAvg;mean(V(:,1))];

            n_name = ['O2_' num2str(i) '.mat'];
            cents=kiacentroids(n_name, 4, 30, 200, 0.8,0.65,0,...
                               'C:/Users/Kiarash/Dropbox/aerotaxis/data/5_2/');
            trackParam=struct('mem',0,'dim',2,'good',5,'quiet',0);
            tracks=track(cents,15,trackParam);
            V=findV(tracks(:,[1,2,4]));
            oAvg=[oAvg;mean(V(:,1))];            
        end    
        plot(nAvg,'-ro')
        xlabel('Minute');
        ylabel('Average Speed');
        title(['Change of Avg. Speed Over Time']);
        hold on
        plot(oAvg,'-xb')
        hold off
        hleg1=legend('N_2','O_2');
        set(hleg1,'Location','NorthWest')        
    case 3
        for i = 1:nFrames
            n_name = ['N2_' num2str(i) '.mat'];
            cents=kiacentroids(n_name, 4, 30, 200, 0.8,0.65,0,...
                               'C:/Users/Kiarash/Dropbox/aerotaxis/data/5_2/');
            trackParam=struct('mem',0,'dim',2,'good',5,'quiet',0);
            tracks=track(cents,15,trackParam);
            V=findV(tracks(:,[1,2,4]));
            subplot(4,5,i);
            hist(V(:,1)>0.2,80)
            xlabel('x axis is Speed');
            ylabel('Number of Bacteria')
            title(['Histogram of N2 -' 'minute ' num2str(i)]);
            axis([0,15,0,800]);
        end

    case 4
        for i = 1:nFrames
            n_name = ['N2_' num2str(i) '.mat'];
            cents=kiacentroids(n_name, 4, 30, 200, 0.8,0.65,0,...
                               'C:/Users/Kiarash/Dropbox/aerotaxis/data/5_2/');
            trackParam=struct('mem',0,'dim',2,'good',5,'quiet',0);
            tracks=track(cents,15,trackParam);
            V=findV(tracks(:,[1,2,4]));
            degrees=V(:,2)+pi;
            avg=[mean(V(:,1)),mean(degrees)];  
            [x, y] = pol2cart(avg(:,2),avg(:,1));
            subplot(4,5,i);
            v = 0:.01:1*pi;
            h = compass(v, 1 * ones(size(v)));
            set(h, 'Visible', 'off')
            hold on
            compass(x, y)
            title(['Change of Average Direction near N2 -' 'minute ' num2str(i)]);
        end
        
    case 5
        for i = 1:nFrames
            n_name = ['N2_' num2str(i) '.mat'];
            cents=kiacentroids(n_name, 4, 30, 200, 0.8,0.65,0,...
                               'C:/Users/Kiarash/Dropbox/aerotaxis/data/5_2/');
            trackParam=struct('mem',0,'dim',2,'good',5,'quiet',0);
            tracks=track(cents,15,trackParam);
            V=findV(tracks(:,[1,2,4]));
            subplot(4,5,i);
            degrees=V(:,2)*180/pi+180;
            hist(degrees,90)
            xlabel('x axis is 0 - 360 degrees');
            ylabel('Number of Bacteria')
            title(['Histogram of Directions on the N2 side -' 'minute ' num2str(i)]);
            axis([0,360,0,120]);
        end        
          
    otherwise
        fprintf('id=0 for show a few random tracks')
        fprintf('id=1 for count N2 vs O2 \n')
        fprintf('id=2 for Average Speed N2 vs O2 \n')   
        fprintf('id=3 for histogram of Speed of N2 \n')        
        fprintf('id=4 for Direction near N2 \n') 
        fprintf('id=5 for Histogram of Directions on N2 side \n')       
        
end    

end