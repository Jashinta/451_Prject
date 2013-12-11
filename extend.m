%% Fun With Filters!!!
function extend (fileName)
close all;
% So far, I have had little trouble with MATLAB and the sensor app interface,
% and I have been able to make some good progress on filtering and viewing
% data. Thus far I have not really implemented any step counting algorithms.
% Although I have implemented a Short-Time-Digital-Filter (stdf.m) that
% uses a FIR filter designed by the FDATool and applies a general Hanning
% Window. You can see from both the sample and frequency domain plots 
% that the stdf works pretty well.

%% Read in data
if (nargin == 0)
	fileName = 'data/walking_from_cc_11_11.txt';
end

fileId= fopen(fileName);
rawData= fscanf(fileId, '%*s %d %*s %f %f %f');
rawData = reshape( rawData, 4, length(rawData)/4 );

%% Normalize time stamps to every 100us and drop doubles

rawData(1,:) = round( rawData(1,:) / 100 );
[~,ia,~] = unique(rawData(1,:));
accData = rawData(:,ia);

%% parse and resample sensor data
n = 1:accData(1, end); 

extended = zeros(3,length(n));
count = 1;
for i = 1:length(accData)
    while (accData(1,i) >= count)
        extended(1,count) =  accData(2,i);
        extended(2,count) =  accData(3,i);
        extended(3,count) =  accData(4,i);
        count = count + 1;
    end
end

zeroFill = zeros(3, length(n));
zeroFill(:,accData(1,:) + 1) = accData(2:4, :); 
xz2  = zeroFill(1,:).^2;
yz2  = zeroFill(2,:).^2;
zz2  = zeroFill(3,:).^2;
magz = sqrt(xz2+yz2+zz2);


%% Compute squares, magnitude, un bias 
x2  = extended(1,:).^2;
y2  = extended(2,:).^2;
z2  = extended(3,:).^2;
mag = sqrt(x2+y2+z2);



%% Build filters

% Equiripple Lowpass filter designed using the FIRPM function.
% All frequency values are in Hz.
% Fs = 1000;  % Sampling Frequency

% Fpass = 1;               % Passband Frequency
% Fstop = 140;             % Stopband Frequency
% Dpass = 0.057501127785;  % Passband Ripple
% Dstop = 0.0001;          % Stopband Attenuation
% dens  = 20;              % Density Factor
d140 = drop140();


%% Populate struct array
pStruct(1).name = 'original';
pStruct(1).x 	= extended(1,:);
pStruct(1).y 	= extended(2,:);
pStruct(1).z 	= extended(3,:);
pStruct(1).mag	= mag;

% pStruct(2).name = 'zeroFill';
% pStruct(2).x 	= zeroFill(1,:);
% pStruct(2).y 	= zeroFill(2,:);
% pStruct(2).z 	= zeroFill(3,:);
% pStruct(2).mag	= magz;

% pStruct(3).name = 'STDF 140HZ filter, N = 500';
% pStruct(3).x	= stdf  ( d140, pStruct( 1 ).x,   1000);
% pStruct(3).y	= stdf  ( d140, pStruct( 1 ).y,   1000);
% pStruct(3).z	= stdf  ( d140, pStruct( 1 ).z,   1000);
% pStruct(3).mag	= stdf  ( d140, pStruct( 1 ).mag, 1000);

% pStruct(4).name = 'STDF 140HZ filter, N = 500, zeroFill';
% pStruct(4).x	= stdf  ( d140, pStruct( 2 ).x,   1000);
% pStruct(4).y	= stdf  ( d140, pStruct( 2 ).y,   1000);
% pStruct(4).z	= stdf  ( d140, pStruct( 2 ).z,   1000);
% pStruct(4).mag	= stdf  ( d140, pStruct( 2 ).mag, 1000);


%% Incramental de biasing

pStruct(2) = deBias( pStruct(1), 10000 );



%% Frequency of Unbiased Original Magnitude signal

window_width = 50;

figure;
norm_mag = mag - mean(mag);
Mag = fftshift(fft(norm_mag));
midpt = ceil(length(Mag)/2);
viewing_window = midpt-window_width:midpt+window_width;
stem(abs(Mag(viewing_window)));
%axis([4950 5050 0 11000]);
title('Unbiased Original Freq Breakdown (5000 is center)');


%% Frequency of Unbiased LowPass Filtered (140 Hz Knee) Magnitude signal
figure;
filt_norm_mag = pStruct(2).mag - mean(pStruct(2).mag);
filt_Mag = fftshift(fft(filt_norm_mag));
stem(abs(filt_Mag(viewing_window)));
%axis([4950 5050 0 18000]);
title('Unbiased Filtered Freq Breakdown (5000 is center)')

%% Plot
plotStruct(pStruct,2);

end
