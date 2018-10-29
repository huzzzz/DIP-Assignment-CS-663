function filtered_fft = gaussian_low_pass(original_fft, gaussian_sigma)

	[U,V] = size(original_fft);
	centre_u = U/2;
	centre_v = V/2;

	filtered_fft = zeros([U,V]);
	for u = 1:U
		for v = 1:V
			filtered_fft(u,v) = original_fft(u,v)*exp( -( ((u-centre_u)^2 + (v-centre_v)^2) / (2*gaussian_sigma^2) ) );
		end
	end 
end