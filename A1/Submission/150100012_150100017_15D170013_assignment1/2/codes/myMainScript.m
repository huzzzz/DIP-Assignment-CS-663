%% MyMainScript
%% Your code here

% Setting the color scale %
my_num_of_colors = 256;
col_scale =  [0:1/(my_num_of_colors-1):1]';
my_color_scale = [col_scale,col_scale,col_scale];

% Set to_save to 1 if you want to save the generated images %
to_save = 0;

% Loading the images %
barbara_pic = imread('../data/barbara.png');
tem_pic = imread('../data/TEM.png');
canyon_pic = imread('../data/canyon.png');
retina_pic = imread('../data/retina.png');
retina_ref_pic = imread('../data/retinaRef.png');
retina_mask_pic = imread('../data/retinaMask.png');
retina_ref_mask_pic = imread('../data/retinaRefMask.png');
church_pic = imread('../data/church.png');

% Linear Contrast Stretching %
tic;
original_pic = barbara_pic;
modified_pic = myLinearContrastStretching(original_pic);
savefig(my_color_scale,original_pic,modified_pic,'Linear Contrast Stretched','Part2_a_1.png',0,to_save);

original_pic = tem_pic;
modified_pic = myLinearContrastStretching(original_pic);
savefig(my_color_scale,original_pic,modified_pic,'Linear Contrast Stretched','Part2_a_2.png',0,to_save);

original_pic = canyon_pic;
modified_pic = myLinearContrastStretching(original_pic);
savefig(my_color_scale,original_pic,modified_pic,'Linear Contrast Stretched','Part2_a_3.png',1,to_save);

original_pic = church_pic;
modified_pic = myLinearContrastStretching(original_pic);
savefig(my_color_scale,original_pic,modified_pic,'Linear Contrast Stretched','Part2_a_4.png',1,to_save);
toc;

% Histogram Equalization %
tic;
original_pic = barbara_pic;
modified_pic = myHE(original_pic);
savefig(my_color_scale,original_pic,modified_pic,'Histogram Equalized','Part2_b_1.png',0,to_save);

original_pic = tem_pic;
modified_pic = myHE(original_pic);
savefig(my_color_scale,original_pic,modified_pic,'Histogram Equalized','Part2_b_2.png',0,to_save);

original_pic = canyon_pic;
modified_pic = myHE(original_pic);
savefig(my_color_scale,original_pic,modified_pic,'Histogram Equalized','Part2_b_3.png',1,to_save);

original_pic = church_pic;
modified_pic = myHE(original_pic);
savefig(my_color_scale,original_pic,modified_pic,'Histogram Equalized','Part2_b_4.png',1,to_save);

original_pic = retina_pic;
original_mask_pic = retina_mask_pic;
[h,w,num_chan] = size(original_pic);
for i = 1:num_chan
	original_pic(:,:,i) = original_pic(:,:,i) .* uint8(original_mask_pic);
end
modified_pic = myHE(original_pic);
savefig(my_color_scale,original_pic,modified_pic,'Histogram Equalized','Part2_c_HE.png',1,to_save);
toc;

% Histogram Matching %
tic;
original_pic = retina_pic;
ref_pic = retina_ref_pic;
original_mask_pic = retina_mask_pic;
ref_mask_pic = retina_ref_mask_pic;
[h,w,num_chan] = size(original_pic);
for i = 1:num_chan
	original_pic(:,:,i) = original_pic(:,:,i) .* uint8(original_mask_pic);
	ref_pic(:,:,i) = ref_pic(:,:,i) .* uint8(ref_mask_pic);
end

modified_pic = myHM(original_pic, ref_pic, original_mask_pic, ref_mask_pic);
if to_save==1
    fig = figure('units','normalized','outerposition',[0 0 1 1]); colormap(my_color_scale);
else
    fig = figure; colormap(my_color_scale);
end
colormap jet;
subplot(1,3,1), imagesc(original_pic),title('Original Image'), colorbar, daspect([1 1 1]), axis tight;
subplot(1,3,2), imagesc(modified_pic),title('Histogram Matched Image'), colorbar, daspect([1 1 1]), axis tight;
subplot(1,3,3), imagesc(ref_pic),title('Reference Image'), colorbar, daspect([1 1 1]), axis tight;
impixelinfo();

if to_save == 1
	saveas(fig,'Part2_c.png'),close(fig);
end
toc;

% Adaptive Histogram Equalization %
kernel_sizes = [10, 200, 400];
for kernel_size = kernel_sizes
	tic;
	original_pic = barbara_pic;
	modified_pic = myAHE(original_pic,kernel_size);
	savefig(my_color_scale,original_pic,modified_pic,strcat('Adaptive Histogram Equalized with kernel size - ',int2str(kernel_size)),strcat('Part2_d_1_k_',int2str(kernel_size),'.png'),0,to_save);

	original_pic = tem_pic;
	modified_pic = myAHE(original_pic,kernel_size);
	savefig(my_color_scale,original_pic,modified_pic,strcat('Adaptive Histogram Equalized with kernel size - ',int2str(kernel_size)),strcat('Part2_d_2_k_',int2str(kernel_size),'.png'),0,to_save);

	original_pic = canyon_pic;
	modified_pic = myAHE(original_pic,kernel_size);
	savefig(my_color_scale,original_pic,modified_pic,strcat('Adaptive Histogram Equalized with kernel size - ',int2str(kernel_size)),strcat('Part2_d_3_k_',int2str(kernel_size),'.png'),1,to_save);
	toc;	
end

% Contrast Limited Adaptive Histogram Equalization %

kernel_size = 200;
thresholds = [0.005,0.0025];
for threshold = thresholds
	tic;
	original_pic = barbara_pic;
	modified_pic = myCLAHE(original_pic,kernel_size,threshold);
	savefig(my_color_scale,original_pic,modified_pic,strcat('CLAHE with kernel size - ',num2str(kernel_size),', threshold -',num2str(threshold)),strcat('Part2_e_1_k_',num2str(kernel_size),'_t_',num2str(threshold),'.png'),0,to_save);

	original_pic = tem_pic;
	modified_pic = myCLAHE(original_pic,kernel_size,threshold);
	savefig(my_color_scale,original_pic,modified_pic,strcat('CLAHE with kernel size - ',num2str(kernel_size),', threshold -',num2str(threshold)),strcat('Part2_e_2_k_',num2str(kernel_size),'_t_',num2str(threshold),'.png'),0,to_save);

	original_pic = canyon_pic;
	modified_pic = myCLAHE(original_pic,kernel_size,threshold);
	savefig(my_color_scale,original_pic,modified_pic,strcat('CLAHE with kernel size - ',num2str(kernel_size),', threshold -',num2str(threshold)),strcat('Part2_e_3_k_',num2str(kernel_size),'_t_',num2str(threshold),'.png'),1,to_save);
	toc;
end

% End of part 2 %

% Helper function to display and save processed images %
function savefig(my_color_scale,original_pic,modified_pic,title_name,file_name,is_color,to_save)
	if to_save==1
		fig = figure('units','normalized','outerposition',[0 0 1 1]); colormap(my_color_scale);
	else
		fig = figure; colormap(my_color_scale);
	end

	if is_color == 1
		colormap jet;
	end
	
	subplot(1,2,1), imagesc(original_pic), title('Original Image'), colorbar, daspect([1 1 1]), axis tight;
	subplot(1,2,2), imagesc(modified_pic), title(title_name), colorbar, daspect([1 1 1]), axis tight;
	impixelinfo();

	if to_save == 1
		saveas(fig,file_name),close(fig);
	end
end
