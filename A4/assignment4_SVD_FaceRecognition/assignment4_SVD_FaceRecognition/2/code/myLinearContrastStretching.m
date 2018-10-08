function [modified_pic] = myLinearContrastStretching(original_pic)
	% Linear contrast stretching %
	[h, w, num_chan] = size(original_pic);
	modified_pic = zeros([h, w, num_chan]);
	for i=1:num_chan
		chan = original_pic(:,:,i);
		max_val = max(chan(:));
		min_val = min(chan(:));
		modified_pic(:,:,i) = double(chan-min_val)./double(max_val-min_val);
	end 
end