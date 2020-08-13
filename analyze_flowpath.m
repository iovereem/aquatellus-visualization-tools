clear all
close all
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                                                   %
%               USER-DEFINED PARAMETERS             %
%                                                   %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
chunk_size=10; %# of pixels considered a significant channel segment

rows=180+1; %total grid size
cols=120+1;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                                                   %
%    READ IN DATA AND CONVERT TO LINEAR INDEXING    %
%                                                   %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
findex = dir('~/Users/overeem/AQUATELLUS2.0/aquatellusv9/src/output/flowpath*.dat');

numfiles = length(findex)-1;
topodata = cell(1, numfiles);

%read in the flowpath stack from the files
flowpathdata = cell(1, numfiles);

total=[];
for l = 1:numfiles
    fpfilename = sprintf('flowpath%d.dat', l);
    subs=importdata(['~/Users/overeem/AQUATELLUS2.0/aquatellusv9/src/output',fpfilename]);
    coords = sub2ind([rows cols],subs(:,1)+1,subs(:,2)+1)'; %building a giant string of flow paths
    total=[total coords-1]; %same string, just re-indexed to fortran again
end

copy=total;

chunk_index=1;
while length(copy)>=1;
    i=1;
    is_unique=0;
    while is_unique==0;
        pattern=copy(1:i);
        frequency=strfind(copy,pattern);
        if length(frequency)<=1;
            if i==1;
                copy(1)=[];
                chunk_store{chunk_index}=copy(1);
                freq_store{chunk_index}=1;
            else
                pattern2=copy(1:i-1); %back up one number in the pattern
                frequency2=strfind(copy,pattern2);
                chunk_store{chunk_index}=pattern2;
                freq_store{chunk_index}=length(frequency2);
                for j=1:length(frequency2);
                    frequency3=strfind(copy,pattern2);
                    copy(frequency3(1):frequency3(1)+i-1)=[]; %remove instances of that chunk from the pattern;
                end
            end
            chunk_index=chunk_index+1;
            is_unique=1;
        end
        i=i+1;
    end
end

for i=1:length(total)-chunk_size+1;
test=total(i:i+chunk_size-1);
freq_store(i,1:chunk_size)=test;
freq=strfind(total,test);
freq_store(i,chunk_size+1)=numel(freq);
end

