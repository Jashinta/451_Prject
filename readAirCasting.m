function readAirCasting(filename)
% this function will convert the csv file into a data.mat file which can be
% further used for processing. 
% data.mat file will contain GPS_Latitude, GPS_Longitude and Soundlevel
% variables.
display('writing file.....');
 D = csvread(filename, 3,1);
 GPS_Latitude  = D(:,1);
 GPS_Longitude = D(:,2);
 SoundLevel    = D(:,3);
 save('data.mat','GPS_Latitude', 'GPS_Longitude', 'SoundLevel');
end