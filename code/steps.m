%steps

cents=kiacentroids('O2_10.mat', 4, 30, 200, 0.8,0.65,0);
trackParam=struct('mem',5,'dim',2,'good',5,'quiet',0);
tra=track(cents,15,trackParam);

tempCent=tra((tra(:,4)==30 | tra(:,4)==10 | tra(:,4)==60 | tra(:,4)==100),1:3);
playtrack('O2_10.mat',tempCent);

tempCent=tra((tra(:,4)==30),1:3);
findV

