function [modified_pic] = myHE(original_pic)
	% Histogram Equalization %
	[h, w, num_chan] = size(original_pic);
	modified_pic = zeros([h, w, num_chan]);
	for i=1:num_chan
		chan = original_pic(:,:,i);
		counts = imhist(chan,256);
		pic_cdf = cumsum(counts/sum(counts));
		modified_pic(:,:,i) = pic_cdf(chan+1);
	end
end