function [modified_pic] = myCLAHE(original_pic,kernel_size,threshold)
	% Contrast Limited Adaptive Histogram Equalization %
	[h, w, num_chan] = size(original_pic);
	modified_pic = zeros([h, w, num_chan]);
	kernel = [kernel_size,kernel_size];
	for i=1:num_chan
		chan = original_pic(:,:,i);
		for j=1:h
			ver_chan = chan(int16(max(1,j-kernel_size/2)):int16(min(j+kernel_size/2,h)),:);
			for k=1:w
				grid_wind = ver_chan(:,int16(max(1,k-kernel_size/2)):int16(min(k+kernel_size/2,w)));
				counts = imhist(grid_wind,256);

				extra_area = sum(max(0,counts-threshold));
				counts = min(counts,threshold);
				counts = counts + double(extra_area)/255.0;
				
				pic_cdf = cumsum(counts/sum(counts));
				modified_pic(j,k,i) = pic_cdf(original_pic(j,k,i)+1);
			end
		end
		disp('Done')
	end
end