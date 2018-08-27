function [modified_pic] = myLinearContrastStretching(original_pic)
	% Linear contrast stretching %
	[h, w, num_chan] = size(original_pic);
	modified_pic = zeros([h, w, num_chan]);
	% Running over all channels %
	for i=1:num_chan
		chan = original_pic(:,:,i);
		% Finding the max and min values %
		max_val = max(chan(:));
		min_val = min(chan(:));
		% Linearly stretching the values according to the formula in report %
		modified_pic(:,:,i) = double(chan-min_val)./double(max_val-min_val);
	end 
end