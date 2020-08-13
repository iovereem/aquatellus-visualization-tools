% September 2015, om iets te debuggen met Arnaud Temme
% User defined input parameters for DEM file generation for AqaTellUs

numrow=120; %number of columns in the DEM
numcol=180; %number of rows in the DEM

topo_apex_h=8; %height at the top-end of the grid (in m)
topgrad=0.05; %the topographical gradient of te floodplain (in cm/km)
coastlinecol=floor(topo_apex_h/topgrad);

noise_mu_fluv=0.1; % mean noise added to the smooth topography (in m)
noise_sig_fluv=0.2; % standard deviation of noise added to the smooth topography (in m)
noise_mu_mar=0.02;
noise_sig_mar=0.05;

%declare the 2Dgrid
[X,Y]=meshgrid(1:numrow,1:numcol);

%fill in the grid with values
Z=topo_apex_h-topgrad*Y;

%add 2 noise fields to DEM
%onshore topographhical noise
Nfluv=random('norm',noise_mu_fluv,noise_sig_fluv,coastlinecol,numrow);
%offshore tpographical noise, is more diffused by waves and tides and thus uses lower value
Nmar=random('norm',noise_mu_mar,noise_sig_mar, numcol-coastlinecol, numrow)

Ndem=[Nfluv; Nmar];
ZN=Ndem+Z;

figure(1)
surf(X,Y,ZN)
title('Initial DEM for floodplain modeling');

%write DEM into txt file that Aquatellus can read
dlmwrite('noisyflatgrid2.txt',ZN);