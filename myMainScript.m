%% MyMainScript

% Setting the color scale %
my_num_of_colors = 256;
col_scale =  [0:1/(my_num_of_colors-1):1]';
my_color_scale = [col_scale,col_scale,col_scale];

% Set to_save to 1, if you want to save the generated pictures %
to_save = 0;

% Loading the pictures %
boat_data = load('../data/boat.mat');
boat_pic = boat_data.imageOrig;

tic;
%% Your code here

% k = 0.1 %

patch_gaussian_sigma = 0.8;
k = 0.2;

original_pic = boat_pic;
original_pic_old = myLinearContrastStretching(original_pic);


filter_sigma = 0.8;
filter_size = double(int16(int16(2*filter_sigma)/2)*2 + 3);
smooth_gauss = fspecial('gaussian',filter_size,filter_sigma);
original_pic = imfilter(original_pic_old,smooth_gauss);

[modified_pic, Cornerness, Eigen_1, Eigen_2, I_x, I_y] = myHarrisCornerDetector(original_pic,patch_gaussian_sigma,k);

% savefig3(my_color_scale,original_pic,Eigen_1,Eigen_2,'Eigen 1','Eigen 2','Part1_a_eigen.png',0,to_save);
% savefig3(my_color_scale,original_pic,I_x,I_y,'Gradient X','Gradient Y','Part1_a_gradient.png',0,to_save);
% savefig(my_color_scale,original_pic,Cornerness,'Cornerness','Part1_a_corner.png',0,to_save);

% savefig(my_color_scale,original_pic,I_x,'X Gradient','Part1_a_x.png',0,to_save);
% savefig(my_color_scale,original_pic,I_y,'Y gradient','Part1_a_y.png',0,to_save);
% savefig(my_color_scale,original_pic,Eigen_1,'Eigen 1','Part1_a_e1.png',0,to_save);
% savefig(my_color_scale,original_pic,Eigen_2,'Eigen 2','Part1_a_e2.png',0,to_save);


[h,w,num_chan] = size(original_pic);
new_img = zeros([h,w,3]);
for i=1:3
	new_img(:,:,i) = original_pic_old;
end
corner_points = zeros([h,w,3]);
corner_points(:,:,1) = modified_pic;

imagesc(new_img+corner_points);
% fig = figure('units','normalized','outerposition',[0 0 1 1]); colormap(my_color_scale);
% [row, col] = find(modified_pic);

% imagesc(new_img), daspect([1 1 1]), axis tight;
% hold on;
% plot(row, col, 'r*');

% savefig(my_color_scale,original_pic_old,modified_pic,'Corner points','Part1_a_final.png',0,to_save);

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
