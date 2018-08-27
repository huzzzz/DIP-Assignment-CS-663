function [modified_pic] = myAHE(original_pic,kernel_size)
	% Adaptive Histogram Equalization %
	[h, w, num_chan] = size(original_pic);
	% Initialising the new image as a blank image %
	modified_pic = zeros([h, w, num_chan]);
	% Setting the kernel size according to the arguments %
	kernel = [kernel_size,kernel_size];
	% Doing the operation independently for every channel %
	for i=1:num_chan
		chan = original_pic(:,:,i);
		for j=1:h
			% Taking care to crop the windows according to image boundary limits %
			ver_chan = chan(int16(max(1,j-kernel_size/2)):int16(min(j+kernel_size/2,h)),:);
			for k=1:w
				% Taking care to crop the windows according to image boundary limits %
				grid_wind = ver_chan(:,int16(max(1,k-kernel_size/2)):int16(min(k+kernel_size/2,w)));
				% Making the histogram with 256 being the no of bins %
				counts = imhist(grid_wind,256);
				% Making the cumulative distribution function from the probability distribution function %
				pic_cdf = cumsum(counts/sum(counts));
				% Applying the cumulative distribution function of original image on the original image intensities to get the mapping %
				modified_pic(j,k,i) = pic_cdf(original_pic(j,k,i)+1);
			end
		end
	end
end