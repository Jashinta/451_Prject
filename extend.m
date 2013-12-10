%% Fun With Filters!!!
function extend (filename)

% So far, I have had little trouble with MATLAB and the sensor app interface,
% and I have been able to make some good progress on filtering and viewing
% data. Thus far I have not really implemented any step counting algorithms.
% Although I have implemented a Short-Time-Digital-Filter (stdf.m) that
% uses a FIR filter designed by the FDATool and applies a general Hanning
% Window. You can see from both the sample and frequency domain plots 
% that the stdf works pretty well.


if (nargin == 0)
	filename = 'data/walking_from_cc_11_11.txt';
end

close all;

%% parse and resample sensor data
androidAPP(filename);
load data.mat;
n = 1:accData(1, end); 
extended = zeros(3,length(n)/14);
count = 0;
for i = 1:length(accData)/14
    while (accData(1,i) > count)
        count = count + 1;
        extended(1,count) =  accData(2,i);
        extended(2,count) =  accData(3,i);
        extended(3,count) =  accData(4,i);  
    end
end

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

pStruct(2).name = 'STDF 140HZ filter, N = 500';
pStruct(2).x	= stdf  ( d140, pStruct( 1 ).x,   500);
pStruct(2).y	= stdf  ( d140, pStruct( 1 ).y,   500);
pStruct(2).z	= stdf  ( d140, pStruct( 1 ).z,   500);
pStruct(2).mag	= stdf  ( d140, pStruct( 1 ).mag, 500);

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
