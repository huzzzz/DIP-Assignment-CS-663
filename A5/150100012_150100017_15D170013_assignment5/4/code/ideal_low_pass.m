function filtered_fft = ideal_low_pass(original_fft, cutoff_frequency)

	[U,V] = size(original_fft);
	centre_u = U/2;
	centre_v = V/2;

	filtered_fft = zeros([U,V]);
	for u = 1:U
		for v = 1:V
			if( (u-centre_u)^2 + (v-centre_v)^2 <= cutoff_frequency^2 )
				filtered_fft(u,v) = original_fft(u,v);
			end
		end
	end 
end