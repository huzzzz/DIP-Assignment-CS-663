function [modified_pic] = myLinearContrastStretching(original_pic)
	% Linear contrast stretching %
	size_pic = size(size(original_pic));
	if(size_pic(2) == 3)
		rchan = original_pic(:,:,1);
		gchan = original_pic(:,:,2);
		bchan = original_pic(:,:,3);

		max_val = max(rchan(:));
		min_val = min(rchan(:));
		mod_r = arrayfun(@(x) (double(x-min_val)/double(max_val-min_val)), rchan);

		max_val = max(gchan(:));
		min_val = min(gchan(:));
		mod_g = arrayfun(@(x) (double(x-min_val)/double(max_val-min_val)), gchan);

		max_val = max(bchan(:));
		min_val = min(bchan(:));
		mod_b = arrayfun(@(x) (double(x-min_val)/double(max_val-min_val)), bchan);

		modified_pic = cat(3,mod_r,mod_g,mod_b);
	else
		max_val = max(original_pic(:));
		min_val = min(original_pic(:));
		modified_pic = arrayfun(@(x) (double(x-min_val)/double(max_val-min_val)), original_pic);	
	end
end