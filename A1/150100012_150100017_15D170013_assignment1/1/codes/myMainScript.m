%% MyMainScript

my_num_of_colors = 256;
col_scale =  [0:1/(my_num_of_colors-1):1]';
my_color_scale = [col_scale,col_scale,col_scale];

% 0 for just displaying images and 1 for saving the images in the same folder

to_save = 0;
conc_pic = imread('../data/circles_concentric.png');
barbara_pic = imread('../data/barbaraSmall.png');

% Image Shrinking %
tic;
original_pic = conc_pic;

D = 2;
modified_pic = myShrinkImageByFactorD(original_pic,D);
savefig(my_color_scale,original_pic,modified_pic,'Shrunk Image by factor 2','Part1_a_1.png',0,to_save);

D = 3;
modified_pic = myShrinkImageByFactorD(original_pic,D);
savefig(my_color_scale,original_pic,modified_pic,'Shrunk Image by factor 3','Part1_a_2.png',0,to_save);
toc;

% Image enlargement using Bilinear Interpolation %
tic;
original_pic = barbara_pic;
m = 3; n = 2;
modified_pic = myBilinearInterpolation(original_pic,m,n);
savefig(my_color_scale,original_pic,modified_pic,'Bilinear Interpolation','Part1_b.png',0,to_save);
toc;

% Image enlargement using Nearest Neighbor Interpolation %
tic;
original_pic = barbara_pic;
m = 3; n = 2;
modified_pic = myNearestNeighborInterpolation(original_pic,m,n);
savefig(my_color_scale,original_pic,modified_pic,'Nearest Neighbor Interpolation','Part1_c.png',0,to_save);
toc;

% End of part 1 %

% Helper function to display and save processed images %
function savefig(my_color_scale,original_pic,modified_pic,title_name,file_name,is_color,to_save)
	
	fig = figure;
	colormap(my_color_scale), daspect([1 1 1]), axis tight;
	
	if is_color == 1
		colormap jet;
	end
	
	subplot(1,2,1), imagesc(original_pic), title('Original Image'), colorbar;
	subplot(1,2,2), imagesc(modified_pic), title(title_name), colorbar;
	impixelinfo();

	if to_save == 1
		saveas(fig,file_name),close(fig);
	end
end