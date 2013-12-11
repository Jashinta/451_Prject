%% Short-Time-Digital filter
function outStruct = deBias ( inStruct, N )

	outStruct.name = strcat( inStruct.name, ' debiased' );
	outStruct.x    = zeros( 1, length(inStruct.x) );
	outStruct.y    = zeros( 1, length(inStruct.y) );
	outStruct.z    = zeros( 1, length(inStruct.z) );
	outStruct.mag  = zeros( 1, length(inStruct.mag) );
	n = 0; 

	for index = 1:length(outStruct.x)

		averagex 	 	= mean( outStruct.x  (1, (index - n): index) );
		averagey 	 	= mean( outStruct.y  (1, index -  n: index) );
		averagez 	 	= mean( outStruct.z  (1, index -  n: index) );
		averagem 	 	= mean( outStruct.mag(1, index -  n: index) );


		outStruct.x(1,index)	= inStruct.x  (1, index - n) - averagex;
		outStruct.y(1,index)	= inStruct.y  (1, index - n) - averagey;
		outStruct.z(1,index)	= inStruct.z  (1, index - n) - averagez;
		outStruct.mag(1,index)	= inStruct.mag(1, index - n) - averagem;

		if( n < N )
			n = n + 1;
		end

    end
    
end


% %% Short-Time-Digital filter
% function outStruct = deBias ( inStruct, N )

% 	outStruct.name = strcat( inStruct.name, ' debiased' );
% 	outStruct.x    = zeros( 1, length(inStruct.x) + N );
% 	outStruct.y    = zeros( 1, length(inStruct.y) + N );
% 	outStruct.z    = zeros( 1, length(inStruct.z) + N );
% 	outStruct.mag  = zeros( 1, length(inStruct.mag) + N );


% 	for index = (N+1):length(outStruct.x)-1

% 		averagex 	 	= mean( outStruct.x  (1, (index - N): index) );
% 		averagey 	 	= mean( outStruct.y  (1, index - N: index) );
% 		averagez 	 	= mean( outStruct.z  (1, index - N: index) );
% 		averagem 	 	= mean( outStruct.mag(1, index - N: index) );


% 		outStruct.x(1,index)	= inStruct.x  (1, index - N) - averagex;
% 		outStruct.y(1,index)	= inStruct.y  (1, index - N) - averagey;
% 		outStruct.z(1,index)	= inStruct.z  (1, index - N) - averagez;
% 		outStruct.mag(1,index)	= inStruct.mag(1, index - N) - averagem;

%     end
    
% end
