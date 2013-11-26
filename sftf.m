%% Short-Time-Digital filter
function out_vec = stdf ( Hd, vec, N )
	out_vec = zeros(size(vec));
	for index = 0:length(pStruct.x)
    	out_vec	(index*N+1:(index+1)*N,:) = filter(Hd, vec(index*N+1:(index+1)*N,:));
    end
end