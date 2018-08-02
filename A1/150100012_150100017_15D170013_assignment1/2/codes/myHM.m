function [modified_pic] = myHM(original_pic,ref_pic)
	% Histogram Matching %
	[h, w, num_chan] = size(original_pic);
	modified_pic = zeros([h, w, num_chan]);

	for i=1:num_chan
		chan = original_pic(:,:,i);
		chan_ref = ref_pic(:,:,i);

		counts = imhist(chan,256);
		counts_ref = imhist(chan_ref,256);
		
		pic_cdf = cumsum(counts/sum(counts));
		ref_cdf = cumsum(counts_ref/sum(counts_ref));

		prob = pic_cdf(chan+1);
		[abc,ind_mat] = arrayfun(@(x) min(abs(ref_cdf-x)),prob);
		modified_pic(:,:,i) = double(ind_mat)/255.0;
	end
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