function [modified_pic] = myUnsharpMasking(original_pic,filter_size,filter_sigma,scale_factor)
	% Unsharp Masking %
	[h, w, num_chan] = size(original_pic);
	
	gauss_filter = fspecial('gaussian',filter_size,filter_sigma);
	unsharp_pic = imfilter(original_pic,gauss_filter);
	unsharp_mask_pic = original_pic - unsharp_pic;
	modified_pic = original_pic + scale_factor*unsharp_mask_pic;

end