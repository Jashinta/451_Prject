%%This Script will extract data from the USB log txt file
 %Running this script will create a strcut called Data
 %with the following components: 
 %sNo (serial number), Value (actual reading of the sensor), time_stamp
 %(time stamp associated with the sampe), minAlarmVavlue (Min Permissible temp)
 %maxAlarmValue(Max permissible temperature)
 %Please DO NOT modify the file output by the sensor's interface.
%==============================================================================
 
%%
function TemperatureSensor(fileName)

%list= dir('*.txt');
%i= 1:length(list);

%filePos= (list(i).name(end-6:end-4)=='USB');
%fileName= list(find(filePos,1)).name;

fileId= fopen(fileName);

[~]= textscan(fileId, '%*[^\n]', 1);

dataCell= textscan(fileId, '%d %s %s');

data= struct('sNo', [], 'value', [], 'time_stamp', [], 'minAlarmValue', [], 'maxAlarmValue',[]);

for i=1:length(dataCell{1})
    data(i).sNo= dataCell{1}(i);
    parsedStrCell= regexp(dataCell{3}(i),',','split');
    data(i).time_stamp= parsedStrCell{1}(1);
    data(i).value= str2double(parsedStrCell{1}(2));
    x(i)=data(i).value;
    data(i).minAlarmValue= str2double(parsedStrCell{1}(3));
    data(i).maxAlarmValue= str2double(parsedStrCell{1}(4));
end

clear dataCell fileName fileId list parsedStrCell;

save('data.mat','data','x');