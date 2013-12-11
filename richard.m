close all;
load data.mat;

time   = accData(1, :);
xvalue = accData(2, :);
yvalue = accData(3, :);
zvalue = accData(4, :);

r_time   = time(1):10000:time(end);
r_xvalue = interp1(time, xvalue, r_time);
r_yvalue = interp1(time, yvalue, r_time);
r_zvalue = interp1(time, zvalue, r_time);

mag = sqrt( r_xvalue.^2 + r_yvalue.^2 + r_zvalue.^2 );
normalized_mag = mag - mean(mag);
n   = length(normalized_mag);
% figure;
% plot(1:n, normalized_mag,'b');
% axis([4000 5000 -10 15]);
% title('Gravity Normalized Magnitude of X,Y,&Z Axis');
% ylabel('Magnitude');
% xlabel('Samples 4000-5000 of 15804');

short_m     = 10;
short_power = zeros(n);
for t = short_m+1:length(normalized_mag)
    short_freq = fftshift(fft(normalized_mag(t-short_m:t)))/sqrt(short_m);
    short_power(t) = (sum(abs(short_freq) .^ 2))/short_m;
end



long_m = 200;
long_power = zeros(n);
for t = long_m+1:length(normalized_mag)
    long_freq  = fftshift(fft(normalized_mag(t-long_m:t)))/sqrt(long_m);
    long_power(t) = (sum(abs(long_freq) .^ 2))/long_m;
end

% figure;
% hold on;
% plot(1:n, long_power*2,'r');
% plot(1:n, short_power,'g');
% axis([4000 5000 -5 300]);
% title('Scaled (*2.0) Long Power Window (Red) & Short Power Window (Green)');
% ylabel('Power');
% xlabel('Samples 4000-5000 of 15804');
% hold off;

% 
threshold = 2.0;
%step_count = numel(find(diff(short_power( long_m+1:end) > long_power(long_m+1:end).*threshold) == 1))

steps_array = zeros(length(long_power));
steps_array = find(diff(short_power( long_m+1:end) > long_power(long_m+1:end).*threshold) == 1);

full_array = zeros(length(long_power));
for t = 1:length(steps_array)
   full_array(steps_array(t)+long_m+1) = 200; 
end

hold on;
plot(1:n, long_power*2,'r');
plot(1:n, short_power,'g');
plot(full_array);
axis([4000 5000 -5 300]);
title('Steps Counter (Blue) Overlayed On Short (Green) & Long (Red) Power');
ylabel('Power/ Steps');
xlabel('Samples 4000-5000 of 15804');

%stem(steps_array);
% 
% figure;
% hold on;
% plot(1:n, long_power*2.2,'r');
% plot(1:n, short_power,'g');
% stem(step_index + long_m, zeros(length(step_index)) + 10, 'b');
% hold off;