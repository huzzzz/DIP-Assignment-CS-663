function [modified_pic] = myHE(original_pic)
	% Histogram Equalization %
	[h, w, num_chan] = size(original_pic);
	% Initialising the new image as a blank image %
	modified_pic = zeros([h, w, num_chan]);
	% Doing the operation independently for every channel %
	for i=1:num_chan
		chan = original_pic(:,:,i);
		% Making the histogram with 256 being the no of bins %
		counts = imhist(chan,256);
		% Making the cumulative distribution function from the probability distribution function %
		pic_cdf = cumsum(counts/sum(counts));
		% Applying the cumulative distribution function of original image on the original image intensities to get the mapping %
		modified_pic(:,:,i) = pic_cdf(chan+1);
	end
end