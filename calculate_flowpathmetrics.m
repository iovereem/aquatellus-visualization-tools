% this is a simple routine to calculate flowpath re-occupancy rates generated by AquaTellUs
% written by Irina Overeem, march 2014

numcol=120;
numrow=180;
flowpathgrid=zeros(numrow,numcol);

%read in the flowpath stack from the files
findex = dir('flowpath*.dat');

numfiles = length(findex)-1;
% topodata = cell(1, numfiles);

%read in the flowpath stack from the files
flowpathdata = cell(1, numfiles);

for l = 1:numfiles
  fpfilename = sprintf('flowpath%d.dat', l);
  flowpathdata{l} = importdata(fpfilename);
end



%visualize the elevation grid and movie it through the simulation


figure(1)
set(0,'DefaultAxesColorOrder',[1 0 0;0 1 0;0 0 1],'DefaultAxesLineStyleOrder','-|--|:')
for m=1:1:numfiles
t=flowpathdata{1,m};
tt=t+1;
plot(tt(:,2),tt(:,1),'k.');
hold on
title('Flowpath Changes due to Channel Switches');
K(m) = getframe;
end

for m=1:1:numfiles
t=flowpathdata{1,m};
tt=t+1; % index difference between matlab and c
IND(m)=sub2ind(size(flowpathgrid),tt(:,1),tt(:,2));
end

