%% Short-Time-Digital filter
function stdf ( Hd, pStruct, N )
	for x = 0:length(pStruct.x)
    	filtered(x*N+1:(x+1)*N,:) = filter(Hd, y(x*N+1:(x+1)*N,:));
    end
end