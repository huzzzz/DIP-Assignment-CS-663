function [modified_pic] = myBilateralFiltering(original_pic_old,spatial_sigma,intensity_sigma)
	% Bilateral Filtering %
	filter_size = double(idivide(int16(spatial_sigma*3),2,'floor')*2 +1);
	modified_pic = zeros(size(original_pic_old));
	[h_old, w_old, num_chan] = size(original_pic_old);
	original_pic = zeros(h_old+filter_size-1,w_old+filter_size-1);
	[h, w, num_chan] = size(original_pic);
	
	original_pic(int16((filter_size-1)/2)+1:h-int16((filter_size-1)/2),int16((filter_size-1)/2)+1:w-int16((filter_size-1)/2)) = original_pic_old;
	spatial_filter = fspecial('gaussian',filter_size,spatial_sigma);
	for i=1:h_old
		for j=1:w_old
			curr_intensity = original_pic_old(i,j);
			sub_area = original_pic(i:i+filter_size-1,j:j+filter_size-1);
			intensity_filter = gaussmf(sub_area,[intensity_sigma curr_intensity]);
			net_filter = spatial_filter.*intensity_filter;
			norm_const = sum(sum(net_filter));
			modified_pic(i,j) = sum(sum(net_filter.*sub_area))/norm_const;
		end
	end
end