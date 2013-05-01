close all

d    = 1.0e-6;             % radius of our beads in meters (Fall 2010)
eta  = 1.0e-3;              % viscosity of water in SI units 
                            % (Pascal-seconds) at 293 K
kB   = 1.38e-23;            % Boltzmann constant
T    = 293;                 % Our room temperature in degrees Kelvin
D    = kB * T / (3 * pi * eta * d); % Our theoretical diffusion constant 
                                    % for water
dimensions = 2;             % two dimensional simulation
fps = 10;                   % camera recording frames per second
tau = 1/fps;                % time interval in seconds
delfactor = sqrt(D * 2 * 1 * tau); % factor for dx or dy (each 1D)

maxpixdisp = 10*7400/40;
param.mem = 0;
param.dim = 2;
param.good = 100;
param.quiet = 0;

MaxTauAnalyze = 10;       % in seconds
NumExtendCertainty = 900;  % in frames, max additional subsets attempted 
RealTimePlotFlag = 1;

matfilename = 'TestFoo1.mat';
centroids = mycentroids(matfilename, 0.19, 1, 10, 1500, 1, 1, ...
    RealTimePlotFlag);
% centroids = load('../Data/Centroids_cells120930_sfn1.txt');
centroids(:,1:2) = centroids(:,1:2)*7400/40; %centroid positions in nm
partracks = track(centroids, maxpixdisp, param);

particles = [];
numpts = [];
numframes = size(partracks,1);
numparticles = floor(min([max(partracks(:,4)) 3]));
if numparticles < 2
    display(' ');
    display('Only one particle detected. Ending program.');
    display(' ');
    return
end
tracks = zeros(numframes,3,numparticles);
for i = 1:numparticles;
   particles(i).track = partracks((partracks(:,4)==i),1:3); %#ok<*SAGROW>
   particles(i).track(:,1) = particles(i).track(:,1)-particles(i).track(1,1);
   particles(i).track(:,2) = particles(i).track(:,2)-particles(i).track(1,2);
   numpts = min([numpts length(particles(i).track(:,3))]);
end

if numparticles >= 3
    diffparticle12 = (particles(1).track(1:numpts,1:2)-particles(2).track(1:numpts,1:2))/sqrt(2);
    diffparticle23 = (particles(2).track(1:numpts,1:2)-particles(3).track(1:numpts,1:2))/sqrt(2);
    diffparticle31 = (particles(3).track(1:numpts,1:2)-particles(1).track(1:numpts,1:2))/sqrt(2);

    figure(1)
    plot(particles(1).track(:,1), particles(1).track(:,2),...
         particles(2).track(:,1), particles(2).track(:,2),...
         particles(3).track(:,1), particles(3).track(:,2));
    figure(2)
    plot(diffparticle12(1:numpts,1), diffparticle12(1:numpts,2),...
         diffparticle23(1:numpts,1), diffparticle23(1:numpts,2),...
         diffparticle31(1:numpts,1), diffparticle31(1:numpts,2));
else
    diffparticle12 = (particles(1).track(1:numpts,1:2)-particles(2).track(1:numpts,1:2))/sqrt(2);

    figure(1)
    plot(particles(1).track(:,1), particles(1).track(:,2),...
         particles(2).track(:,1), particles(2).track(:,2));
    figure(2)
    plot(diffparticle12(1:numpts,1), diffparticle12(1:numpts,2));
end

numtau = floor(numpts)-1;
NewLineCount = 0;
MSD = zeros(numtau,numparticles);
diffMSD = zeros(numtau,size(combntns(1:numparticles,2),1));
for j = 1:numtau
    MSD1 = 0;
    MSD2 = 0;
    MSD3 = 0;
    MSD12 = 0;
    MSD23 = 0;
    MSD13 = 0;
    count = 0;
    numshift = min(min(j-1, NumExtendCertainty), numtau - j);
    if numparticles >= 3
        for i = 1:numshift+1
            MSD1 =      mean(diff(particles(1).track(1:j:numpts,1)).^2 + diff(particles(1).track(1:j:numpts,2)).^2);
            MSD2 =      mean(diff(particles(2).track(1:j:numpts,1)).^2 + diff(particles(2).track(1:j:numpts,2)).^2);
            MSD3 =      mean(diff(particles(3).track(1:j:numpts,1)).^2 + diff(particles(3).track(1:j:numpts,2)).^2);

            MSD12 =      mean(diff(diffparticle12(1:j:numpts,1)).^2 + diff(diffparticle12(1:j:numpts,2)).^2);
            MSD23 =      mean(diff(diffparticle23(1:j:numpts,1)).^2 + diff(diffparticle23(1:j:numpts,2)).^2);
            MSD31 =      mean(diff(diffparticle31(1:j:numpts,1)).^2 + diff(diffparticle31(1:j:numpts,2)).^2);
            count = count + 1;
        end
        MSD(j,:) = [MSD1 MSD2 MSD3]/count;
        diffMSD(j,:) = [MSD12 MSD23 MSD31]/count;
    else
        for i = 1:numshift+1
            MSD1 = MSD1 + mean(diff(particles(1).track(i:j:numpts,1)).^2 + diff(particles(1).track(i:j:numpts,2)).^2);
            MSD2 = MSD2 + mean(diff(particles(2).track(i:j:numpts,1)).^2 + diff(particles(2).track(i:j:numpts,2)).^2);

            MSD12 = MSD12 + mean(diff(diffparticle12(i:j:numpts,1)).^2 + diff(diffparticle12(i:j:numpts,2)).^2);
            count = count + 1;
        end
        MSD(j,:) = [MSD1 MSD2]/count;
        diffMSD(j,:) = [MSD12]/count; %#ok<NBRAK>
    end
    if mod(j,100)==0
        fprintf('%4.0f,',numshift)
        NewLineCount = NewLineCount + 1;
    end
    if mod(NewLineCount,10)==0 & NewLineCount>5
        fprintf('\n')
        NewLineCount = 0;
    end
end

filtorder = 21;
trim = floor(filtorder/3);
trim = 0;
filtMSD = medfilt1(MSD,1);
filtdiffMSD = medfilt1(diffMSD,1);
tauIndex = (1:numtau-trim)';
tauVec = tauIndex/fps;

D_stat = diffMSD(1,:)/(1e18*2*dimensions*tau) %#ok<*NOPTS>
Eta_stat = kB * T ./ (3 * pi * D_stat * d)*1e3 %#ok<*NASGU>

MSDSampleLength = 1;
difftau = tauVec(2:MSDSampleLength+1,:) - tauVec(1,:);
difftau = repmat(difftau(1:MSDSampleLength),...
    1,size(diffMSD(2:MSDSampleLength+1,:),2));
diffdiffMSD = diffMSD(2:MSDSampleLength+1,:) ...
    - repmat(diffMSD(1,:),size(diffMSD(2:MSDSampleLength+1,:),1),1);
D_stat = mean(mean(diffdiffMSD./(1e18 * 2 * dimensions * difftau)))
Eta_stat = kB * T ./ (3 * pi * D_stat * d)*1e3

DataChoose = tauVec<MaxTauAnalyze+eps;
MSDAnalyze = filtdiffMSD(DataChoose);
tauVecAnalyze = tauVec(DataChoose);

% Calculate an MSD fit and compare to 'best' MSD (and diffusion const)
n = 1;
PolyMSDFit = polyfit(log10(tauVecAnalyze), log10(MSDAnalyze), n);
tauVecFit = logspace(log10(min(tauVecAnalyze)),log10(max(tauVecAnalyze)), 100);
MSDFit = polyval(PolyMSDFit, log10(tauVecFit));

figure(3)
loglog(tauVec, filtMSD(tauIndex,:), tauVec, filtdiffMSD(tauIndex,:), ...
       tauVecFit, 10.^(MSDFit), 'xr')
xlabel('Tau (s)')
ylabel('MSD (nm^2)')

% Calculate and show the storage and loss parameters
GprimeResults = CalculateGdata([tauVecAnalyze, MSDAnalyze], ...
                                    1, T, d/2);

figure(4)
OmegaVector = 2*pi./tauVecAnalyze(2:end);
loglog(OmegaVector, abs(GprimeResults(:,1))*1e18, '-b', ...
       OmegaVector, abs(GprimeResults(:,2))*1e18, '-r', ...
       OmegaVector, abs(GprimeResults(:,3))*1e18, 'xb', ...
       OmegaVector, abs(GprimeResults(:,4))*1e18, 'or')
title(' Storage Modulus G prime & Loss Modulus G double prime ');
xlabel('Frequency (rad/s)'); ylabel('Pa');
legend('|Gp poly|','|Gpp poly|','|Gp data|','|Gpp data|','Location','NorthWest')

% centroidoverlayMovie = playcentroids(matfilename, centroids*40/7400);

