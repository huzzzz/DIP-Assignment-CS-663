function [modified_pic] = myHM(original_pic,ref_pic, original_mask_pic, ref_mask_pic)
	% Histogram Matching %
	[h, w, num_chan] = size(original_pic);
	% Initialising the new image as a blank image %
	modified_pic = zeros([h, w, num_chan]);

	for i=1:num_chan
		chan = original_pic(:,:,i);
		chan_ref = ref_pic(:,:,i);
		% Counting the number of background pixels %
		ori_num_zero = sum(original_mask_pic(:) == 0);
		ref_num_zero = sum(ref_mask_pic(:) == 0);
		% Adjusting the histogram counts to ignore the background pixels %
		counts = imhist(chan,256);
		counts(1) = counts(1) - ori_num_zero;
		counts_ref = imhist(chan_ref,256);
		counts_ref(1) = counts_ref(1) - ref_num_zero;
	
		% Making the cumulative distribution function from the probability distribution function %	
		pic_cdf = cumsum(counts/sum(counts));
		ref_cdf = cumsum(counts_ref/sum(counts_ref));

		% Applying the cumulative distribution function of original image on the original image intensities to get the mapping %
		prob = pic_cdf(chan+1);
		% abc is a placeholder, ind_mat contains the intensity of the reference image whose cdf value is the nearest to the cdf value of the intensity in the original image %
		[abc,ind_mat] = arrayfun(@(x) min(abs(ref_cdf-x)),prob);
		% Rescaling the intensities to lie between 0 and 1  %
		modified_pic(:,:,i) = double(ind_mat)/255.0;
		% Applying the final mask to the new image %
		modified_pic(:,:,i) = modified_pic(:,:,i) .* double(original_mask_pic);
	end
	% Uncomment the following lines if you want to display and compare the new histograms after modification %

	% for i=1:num_chan
	% 	chan = original_pic(:,:,i);
	% 	chan_mod = modified_pic(:,:,i);
	% 	chan_ref = ref_pic(:,:,i);

	% 	counts = imhist(chan,256);
	% 	counts_mod = imhist(chan_mod,256);
	% 	counts_ref = imhist(chan_ref,256);
	% 	stem([counts,counts_mod,counts_ref])
	% 	legend('counts','counts_mod','counts_ref')
	% 	waitforbuttonpress
	% end
end