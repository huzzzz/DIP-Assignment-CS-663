function [modified_pic] = myLinearContrastStretching(original_pic)

	% Linear contrast stretching %

	% Extracting the dimensions of the image %
	[h, w, num_chan] = size(original_pic);

	% Initialising the image to be returned %
	modified_pic = zeros([h, w, num_chan]);

	% Performing linear contrast stretching for all channels one by one %
	for i=1:num_chan
		% Extracting the current channel image pixel values and finding their minimum and maximum values %
		chan = original_pic(:,:,i);
		max_val = max(chan(:));
		min_val = min(chan(:));
		
		% Performing linear contrast stretching on the values of the current channel by subtracting all the values from the minimum value and dividing by range %
		modified_pic(:,:,i) = double(chan-min_val)./double(max_val-min_val);
	end 
end