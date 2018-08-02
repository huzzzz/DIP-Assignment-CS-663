%% Report for Part 2 of Assignment 1

my_num_of_colors = 256;
col_scale =  [0:1/(my_num_of_colors-1):1]';
my_color_scale = [col_scale,col_scale,col_scale];

to_save = 1;
barbara_pic = imread('../data/barbara.png');
tem_pic = imread('../data/TEM.png');
canyon_pic = imread('../data/canyon.png');
retina_pic = imread('../data/retina.png');
retina_ref_pic = imread('../data/retinaRef.png');
church_pic = imread('../data/church.png');

%% Linear Contrast Stretching
% Formula applied for Linear Contrast Stretching:
% 
tic;
original_pic = barbara_pic;
savefig(my_color_scale,original_pic,'barbara.png','',0,0);snapnow;
modified_pic = myLinearContrastStretching(original_pic);
savefig(my_color_scale,modified_pic,'Linear Contrast Stretched','Part2_a_1.png',0,to_save);snapnow;

original_pic = tem_pic;
savefig(my_color_scale,original_pic,'tem.png','',0,0);snapnow;
modified_pic = myLinearContrastStretching(original_pic);
savefig(my_color_scale,modified_pic,'Linear Contrast Stretched','Part2_a_2.png',0,to_save);snapnow;

original_pic = canyon_pic;
savefig(my_color_scale,original_pic,'canyon.png','',1,0);snapnow;
modified_pic = myLinearContrastStretching(original_pic);
savefig(my_color_scale,modified_pic,'Linear Contrast Stretched','Part2_a_3.png',1,to_save);snapnow;

original_pic = church_pic;
savefig(my_color_scale,original_pic,'church.png','',1,0);snapnow;
modified_pic = myLinearContrastStretching(original_pic);
savefig(my_color_scale,modified_pic,'Linear Contrast Stretched','Part2_a_5.png',1,to_save);snapnow;
%Contrast stretching on Image(5): 
toc;

%% Histogram Equalization 
tic;
original_pic = barbara_pic;
savefig(my_color_scale,original_pic,'barbara.png','',0,0);snapnow;
modified_pic = myHE(original_pic);
savefig(my_color_scale,modified_pic,'Histogram Equalized','Part2_b_1.png',0,to_save);snapnow;

original_pic = tem_pic;
savefig(my_color_scale,original_pic,'tem.png','',0,0);snapnow;
modified_pic = myHE(original_pic);
savefig(my_color_scale,modified_pic,'Histogram Equalized','Part2_b_2.png',0,to_save);snapnow;

original_pic = canyon_pic;
savefig(my_color_scale,original_pic,'canyon.png','',1,0);snapnow;
modified_pic = myHE(original_pic);
savefig(my_color_scale,modified_pic,'Histogram Equalized','Part2_b_3.png',1,to_save);snapnow;

original_pic = church_pic;
savefig(my_color_scale,original_pic,'church.png','',1,0);snapnow;
modified_pic = myHE(original_pic);
savefig(my_color_scale,modified_pic,'Histogram Equalized','Part2_b_5.png',1,to_save);snapnow;
%HE or Contrast Stretching for image(5):
toc;

%% Histogram Matching
tic;
original_pic = retina_pic;
ref_pic = retina_ref_pic;
modified_pic = myHM(original_pic, ref_pic);

fig = figure;
colormap(my_color_scale), colormap jet;
savefig(my_color_scale,original_pic,'retina.png', '', 1, 0);snapnow;
savefig(my_color_scale,modified_pic,'Histogram Matched Image', 'Part2_c.png', 1, to_save);snapnow;
savefig(my_color_scale,ref_pic,'retinaRef.png', '', 1, 0);snapnow;
%Observations: 

toc;

%% Adaptive Histogram Equalization
kernel_sizes = [10, 50, 250];
for kernel_size = kernel_sizes
	tic;
	original_pic = barbara_pic;
	savefig(my_color_scale,original_pic,'barbara.png','',0,0);snapnow;
	modified_pic = myAHE(original_pic,kernel_size);
	savefig(my_color_scale,modified_pic,strcat('Adaptive Histogram Equalized with kernel size = ',int2str(kernel_size)),strcat('Part2_d_1_k_',int2str(kernel_size),'.png'),0,to_save);snapnow;

	original_pic = tem_pic;
	savefig(my_color_scale,original_pic,'tem.png','',0,0);snapnow;
	modified_pic = myAHE(original_pic,kernel_size);
	savefig(my_color_scale,modified_pic,strcat('Adaptive Histogram Equalized with kernel size = ',int2str(kernel_size)),strcat('Part2_d_2_k_',int2str(kernel_size),'.png'),0,to_save);snapnow;

	original_pic = canyon_pic;
	savefig(my_color_scale,original_pic,'canyon.png','',1,0);snapnow;
	modified_pic = myAHE(original_pic,kernel_size);
	savefig(my_color_scale,modified_pic,strcat('Adaptive Histogram Equalized with kernel size = ',int2str(kernel_size)),strcat('Part2_d_3_k_',int2str(kernel_size),'.png'),1,to_save);snapnow;
	toc;
	%Observations:	
end

%% Contrast Limited Adaptive Histogram Equalization

kernel_size = 100;
thresholds = [0.02,0.01];
for threshold = thresholds
	tic;
	original_pic = barbara_pic;
	savefig(my_color_scale,original_pic,'barbara.png','',0,0);snapnow;
	modified_pic = myCLAHE(original_pic,kernel_size,threshold);
	savefig(my_color_scale,modified_pic,strcat('CLAHE with kernel size = ',num2str(kernel_size),', threshold =',num2str(threshold)),strcat('Part2_e_1_k_',num2str(kernel_size),'_t_',num2str(threshold),'.png'),0,to_save);snapnow;

	original_pic = tem_pic;
	savefig(my_color_scale,original_pic,'tem.png','',0,0);snapnow;
	modified_pic = myCLAHE(original_pic,kernel_size,threshold);
	savefig(my_color_scale,modified_pic,strcat('CLAHE with kernel size = ',num2str(kernel_size),', threshold =',num2str(threshold)),strcat('Part2_e_2_k_',num2str(kernel_size),'_t_',num2str(threshold),'.png'),0,to_save);snapnow;

	original_pic = canyon_pic;
	savefig(my_color_scale,original_pic,'canyon.png','',1,0);snapnow;
	modified_pic = myCLAHE(original_pic,kernel_size,threshold);
	savefig(my_color_scale,modified_pic,strcat('CLAHE with kernel size = ',num2str(kernel_size),', threshold =',num2str(threshold)),strcat('Part2_e_3_k_',num2str(kernel_size),'_t_',num2str(threshold),'.png'),1,to_save);snapnow;
	toc;
end

%%
% Helper function to display and save processed images
function savefig(my_color_scale,pic,title_name,file_name,is_color,to_save)
	
	fig = figure; 
	colormap(my_color_scale);

	if is_color == 1
		colormap jet;
	end
	
	imagesc(pic), title(title_name), colorbar, daspect([1 1 1]), axis tight;
	if to_save == 1
		saveas(fig,file_name),close(fig);
	end
end
