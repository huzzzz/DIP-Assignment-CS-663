function[modified_pic] = myShrinkImageByFactorD(original_pic,D)
	% Shrink function %
	[h,w,num_chan] = size(original_pic);
	for i=1:num_chan
		% Sampling from every Dth pixel from the original image %
		modified_pic(:,:,i) = original_pic(1:D:end,1:D:end,i);
	end
end