function extend (filename)

if (nargin == 0)
	filename = 'data/walking_from_cc_11_11.txt';
end

close all;

%% parse and resample sensor data
androidAPP(filename);
load data.mat;
n = 1:accData(1, end); 
extended = zeros(3,length(n));
count = 0;
for i = 1:length(accData)
    while (accData(1,i) > count)
        count = count + 1;
        extended(1,count) =  accData(2,i);
        extended(2,count) =  accData(3,i);
        extended(3,count) =  accData(4,i);  
    end
end

%% Compute squares, magnitude, un bias 
x2 = extended(1,1:10000).^2;
y2 = extended(2,1:10000).^2;
z2 = extended(3,1:10000).^2;

mag = sqrt(x2+y2+z2);
norm_mag = mag - mean(mag);

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


% IIR maximally flat Lowpass filter designed using the MAXFLAT function.
% All frequency values are in Hz.
% Fs = 1000;  % Sampling Frequency

% Nb = 8;   % Numerator Order
% Na = 8;   % Denominator Order
% Fc = 20;  % Cutoff Frequency
d20  = drop20();


% IIR maximally flat Lowpass filter designed using the MAXFLAT function.
% All frequency values are in Hz.
Fs = 1000;  % Sampling Frequency

Nb = 8;  % Numerator Order
Na = 8;  % Denominator Order
Fc = 3;  % Cutoff Frequency
d3 = drop3();


%% Populate struct array

pStruct(1).x 	= extended(1,1:10000);
pStruct(1).y 	= extended(2,1:10000);
pStruct(1).z 	= extended(3,1:10000);
pStruct(1).mag	= norm_mag;


pStruct(2).name = 'STDF 140HZ filter, N = 500';
pStruct(2).x	= stdf  ( d140, pStruct( 1 ).x,   500);
pStruct(2).y	= stdf  ( d140, pStruct( 1 ).y,   500);
pStruct(2).z	= stdf  ( d140, pStruct( 1 ).z,   500);
pStruct(2).mag	= stdf  ( d140, pStruct( 1 ).mag, 500);

pStruct(3).name = 'STDF 20HZ filter, N = 2000';
pStruct(3).x	= stdf  ( d3  , pStruct( 1 ).x,   2000);
pStruct(3).y	= stdf  ( d3  , pStruct( 1 ).y,   2000);
pStruct(3).z	= stdf  ( d3  , pStruct( 1 ).z,   2000);
pStruct(3).mag	= stdf  ( d3  , pStruct( 1 ).mag, 2000);


Mag = fftshift(fft(pStruct(2).mag));
stem(abs(Mag));

%% Plot
plotStruct(pStruct,3);


% Mag = fftshift(fft(filtered));

% spectrogram(filtered, 8);

		
% 
% midpt = ceil(length(Mag)/2);
% window_width = 1000;
% viewing_window = midpt-window_width:midpt+window_width;
% 
% plotStruct(pStruct,depth);
% 
% 
% stem(abs(Mag(viewing_window)));
% 

end
% title ('frequency breakdown');