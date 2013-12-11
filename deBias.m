%% Causal moving average is used to debias data
function outStruct = deBias ( inStruct, N )

	outStruct.name = strcat( inStruct.name, ' debiased' );
	outStruct.x    = zeros( 1, length(inStruct.x));
	outStruct.y    = zeros( 1, length(inStruct.y));
	outStruct.z    = zeros( 1, length(inStruct.z));
	outStruct.mag  = zeros( 1, length(inStruct.mag));
	n = N; 
    %plot(inStruct.x - mean(inStruct.x));
	for index = 1:N:length(outStruct.x)-N

		outStruct.x  (1,index:index+N)	= inStruct.x  (1,index:index+N) - mean( inStruct.x(1,index:index+N) );
		outStruct.y  (1,index:index+N)	= inStruct.y  (1,index:index+N) - mean( inStruct.x(1,index:index+N) );
		outStruct.z  (1,index:index+N)	= inStruct.z  (1,index:index+N) - mean( inStruct.x(1,index:index+N) );
		outStruct.mag(1,index:index+N)	= inStruct.mag(1,index:index+N) - mean( inStruct.x(1,index:index+N) );
    end
    
end
