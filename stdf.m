%% Short-Time-Digital filter
function out_vec = stdf ( Hd, vec, N )
	out_vec = zeros(size(vec));

	n = 0:N-1;

	w = 0.5*(1 - cos( 2*pi*n/(N-1)));
	for index = 0:length(vec)/N-1
		window = vec(index*N+1:(index+1)*N);

    	out_vec	(index*N+1:(index+1)*N) = filter(Hd, window.*w);
    end
end