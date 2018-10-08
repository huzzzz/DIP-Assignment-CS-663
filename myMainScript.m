%% MyMainScript

% Setting the color scale %
my_num_of_colors = 256;
col_scale =  [0:1/(my_num_of_colors-1):1]';
my_color_scale = [col_scale,col_scale,col_scale];

% Set to_save to 1, if you want to save the generated pictures %
to_save = 0;

% Loading the pictures %
baboon_pic = imread('../data/baboonColor.png');

tic;

original_pic = baboon_pic;
original_pic = myLinearContrastStretching(original_pic);

% Defining noise filter and its parameters %
filter_sigma = 1;
filter_size = 3;
smooth_gauss = fspecial('gaussian',filter_size,filter_sigma);
[h,w,num_chan] = size(original_pic);

% Filtering the image with the formed Gaussian filter %
for i=1:num_chan
	original_pic(:,:,i) = imfilter(original_pic(:,:,i),smooth_gauss);
end

% Subsampling the image %
D=2;
intermediate_pic = zeros([h/D, w/D, num_chan]);
for i=1:num_chan
	intermediate_pic(:,:,i) = original_pic(1:D:end,1:D:end,i);
end

original_pic = intermediate_pic;

% Parameters for the mean shift segmentation %
h_color = 0.1;
h_spatial = 16;
num_iter = 20;

modified_pic = myMeanShiftSegmentation(original_pic,h_color,h_spatial,num_iter);
savefig(my_color_scale,original_pic,modified_pic,'Segmented Image','Part2_a_segments.png',1,to_save);

toc;

% Linear Contrast Stretching helper function %
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

% Helper function to display and save processed images %
function savefig(my_color_scale,original_pic,modified_pic,title_name,file_name,is_color,to_save)
	if to_save==1
		fig = figure('units','normalized','outerposition',[0 0 1 1]); colormap(my_color_scale);
	else
		fig = figure; colormap(my_color_scale);
	end

	if is_color == 1
		colormap jet;
	else
		colormap(gray);
	end
	
	subplot(1,2,1), imagesc(original_pic), title('Original Image'), colorbar, daspect([1 1 1]), axis tight;
	subplot(1,2,2), imagesc(modified_pic), title(title_name), colorbar, daspect([1 1 1]), axis tight;
	impixelinfo();
    
	if to_save == 1
		saveas(fig,file_name),close(fig);
	end
end

% Helper function to display and save 3 processed images %
function savefig3(my_color_scale,original_pic,mid_pic,modified_pic,mid_name,title_name,file_name,is_color,to_save)
	if to_save==1
		fig = figure('units','normalized','outerposition',[0 0 1 1]); colormap(my_color_scale);
	else
		fig = figure; colormap(my_color_scale);
	end

	if is_color == 1
		colormap jet;
	else
		colormap(gray);
	end
	
	subplot(1,3,1), imagesc(original_pic), title('Original Image'), colorbar, daspect([1 1 1]), axis tight;
	subplot(1,3,2), imagesc(mid_pic), title(mid_name), colorbar, daspect([1 1 1]), axis tight;
	subplot(1,3,3), imagesc(modified_pic), title(title_name), colorbar, daspect([1 1 1]), axis tight;
	impixelinfo();
    
	if to_save == 1
		saveas(fig,file_name),close(fig);
	end
end