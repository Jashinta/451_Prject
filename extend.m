%% Fun With Filters!!!
function extend (fileName)
close all;
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


%% Compute squares, magnitude
x2  = extended(1,:).^2;
y2  = extended(2,:).^2;
z2  = extended(3,:).^2;
mag = sqrt(x2+y2+z2);


%% Populate struct array
pStruct(1).name = 'original';
pStruct(1).x 	= extended(1,:);
pStruct(1).y 	= extended(2,:);
pStruct(1).z 	= extended(3,:);
pStruct(1).mag	= mag;


%% Step counting
threshold = 15;
timeMin = 600;
timeMax = 10000;

[c1, steps] = stepCount(pStruct(1).mag, threshold, timeMin, timeMax);

hold on;
plot(steps.*35, '--r');
plot(pStruct(1).mag);
axis([1.5E5 7E5 0 35]);
title('Step locations overlaid on accData');
xlabel('Time (0.1ms)');
ylabel('Magnitude');
legend('Step Locations', 'Extended accData');

figure;
hold on;
plot(pStruct(1).mag, 'g');
axis([400000 500000 0 35]);

title('Extended accData');
xlabel('Time (0.1ms), samples 4000 - 5000 of 15804');
ylabel('Magnitude');

disp(c1);

plotStruct(pStruct,1);

end
