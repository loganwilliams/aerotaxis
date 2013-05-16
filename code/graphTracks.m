function [out] = graphTracks(e,switchPoint)

sumX = [];
avgV = [];
avgTheta = [];
allAvg = [];
allNl = [];
allNr = [];
allNd = [];
allNu = [];

for i = 1:size(e,1)
    i;
    tracks = [];
    tracks(:,:) = e(i,:,:);
    %plotTracks(tracks(:,[1,2,4]))
    ntracks = nnz(tracks)/4;
    allX = findX(tracks(:,[1,2,4]));
    sumX = [sumX sum(allX)];
    
    allV = findV(tracks(:,[1,2,4]));
    
    v = allV(:,1);
    theta = allV(:,2);
    avgV = [avgV sum(v)/ntracks];
    
     %hist(v,100)
     %axis([0 10 0 150])

% 
%     hist(theta,100)
%     axis([-pi pi 0 50])
    

    c = toComplex(allV);
    avgTheta = [avgTheta angle(sum(c))];
    
%     bigC = [];
%     j = 1;
    
%     for i = 1:length(c)
%         if abs(c(i)) > 20
%             bigC(j) = c(i);
%             j = j + 1;
%         end
%     end
% 
    nl = 0;
    nr = 0;
    nu = 0;
    nd = 0;
    for i = 1:length(c)
        if (abs(c(i)) > 1)
            if ((angle(c(i)) > ((2/3)*pi)) || (angle(c(i)) < (-(2/3) * pi)))
                nl = nl + 1;
            elseif ((angle(c(i)) > (-(2/3)*pi)) && (angle(c(i)) < (-(1/3)*pi)))
                nd = nd + 1;
            elseif ((angle(c(i)) > (-(1/3)*pi)) && (angle(c(i)) < ((1/3) * pi)))
                nr = nr + 1;
            elseif ((angle(c(i)) > ((1/3)*pi)) && (angle(c(i)) < ((2/3) * pi)))
                nu = nu + 1;
            end
        end
    end
%     
    
%     i
%     figure(1)
%      scatterplot(c)
%      title([num2str(i*15) ' seconds']);
%      axis([-30*pi 30*pi -30*pi 30*pi])
%      pause
%      close
    
    
    
    avg = 0;
    n = 0;
%     
%     for i = 1:length(c)
%         if ((abs(c(i))) > 2)
%             avg = avg + c(i);
%             n = n + 1;
%         end
%     end
%     
    %allAvg = [allAvg sum(bigC)/length(bigC)];
    allNl = [allNl nl];
    allNr = [allNr nr];
    allNu = [allNu nu];
    allNd = [allNd nd];
end


for i = 1:length(allNl)
    t = allNl(i) + allNr(i) + allNd(i) + allNu(i);
    pL(i) = allNl(i) / t;
    pR(i) = allNr(i) / t;
    pD(i) = allNd(i) / t;
    pU(i) = allNu(i) / t;
end

figure(1)
%plot(1:length(allNl), allNl, 1:length(allNl), allNr, 1:length(allNl), allNu, 1:length(allNl), allNd);
plot((15:15:(length(allNl)*15)), pL, (15:15:(length(allNl)*15)), pR, (15:15:(length(allNl)*15)), pU, (15:15:(length(allNl)*15)), pD);
vline(switchPoint*15, 'k', 'Replacing N2 with O2');

figure(2)
plot(pL - pR);

out = pL - pR;

vline(switchPoint, 'k', 'Replacing N2 with O2');

end