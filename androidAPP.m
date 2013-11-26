%%This Script will extract data from the textFile generated by the android
 %application for collecting sensor data. Please do not modify this
 %interface. The data from the different sensors will be stored in
 %individual matrices. For example, the accelorometer data will be stored
 %in the matrix accData of the form of 4*n matrix where the first row of
 %each column represents the timeStamp, second row indicates the value in
 %the x direction, 3rd row indicates the value in the y direction and the
 %last row indicates the value in the z direction. 
%==============================================================================
 
%%
function androidAPP(fileName)
display('writing file.....');
fileId= fopen(fileName);

dataCell= textscan(fileId, '%s %d %s %f %f %f');

data= struct('type', [], 'time', [], 'xVal', [], 'yVal', [], 'zVal',[]);

gyroData=[];
accData=[];
magData=[];

for i=1:length(dataCell{6})
    data(i).type= dataCell{1}(i);
    data(i).time= dataCell{2}(i);
    data(i).xVal= dataCell{4}(i);
    data(i).yVal= dataCell{5}(i);
    data(i).zVal= dataCell{6}(i);
    
    switch(data(i).type{1})
        case 'ACC'
            accData= [accData [data(i).time; data(i).xVal; data(i).yVal; data(i).zVal]];
        case 'GYR'
            gyroData= [gyroData [data(i).time; data(i).xVal; data(i).yVal; data(i).zVal]];
        case 'MAG'
             magData= [magData [data(i).time; data(i).xVal; data(i).yVal; data(i).zVal]];
    end
end

clear dataCell fileName fileId list parsedStrCell;

save('data.mat','data','accData', 'magData', 'gyroData');