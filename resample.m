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
normalized_mag = mag;
n   = length(normalized_mag);

short_m     = 10;
short_power = zeros(n);
for t = short_m+1:length(normalized_mag)
    short_freq = fftshift(fft(normalized_mag(t-short_m:t)))/sqrt(short_m);
%     for i = 1:15
%         short_freq(i) = 0`
%     end
%     for i = 35:50
%         short_freq(i) = 0;
%     end
    % insert filter
    short_power(t) = (sum(abs(short_freq) .^ 2))/short_m;
end

long_m = 200;
long_power = zeros(n);
for t = long_m+1:length(normalized_mag)
    long_freq  = fftshift(fft(normalized_mag(t-long_m:t)))/sqrt(long_m);
%     for i = 1:98
%         long_freq(i) = 0;
%     end
%     for i = 102:200
%         long_freq(i) = 0;
%     end
    long_power(t) = (sum(abs(long_freq) .^ 2))/long_m;
end

threshold = 2.0;
step_count(i) = numel(find(diff(short_power(long_m+1:end) > long_power(long_m+1:end).*threshold) == 1));

plot(threshold, (step_count - 140).^2);

%figure;
%hold on;
%plot(1:n, long_power*2.2,'r');
%plot(1:n, short_power,'g');
%stem(step_index + long_m, zeros(length(step_index)) + 10, 'b');
%hold off;