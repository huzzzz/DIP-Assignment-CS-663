%% MyMainScript

% Setting the color scale %
my_num_of_colors = 256;
col_scale =  [0:1/(my_num_of_colors-1):1]';
my_color_scale = [col_scale,col_scale,col_scale];

% Set to_save to 1, if you want to save the generated pictures %
to_save = 1;
% Loading the pictures %
barbara_data = load('../data/barbara.mat');
honey_pic = double(imread('../data/honeyCombReal.png'));
grass_pic = double(imread('../data/grass.png'));

barbara_pic = barbara_data.imageOrig;
% honey_pic = honey_data.imgCorrupt;
% grass_pic = grass_data.imgCorrupt;


%% Intial Tuning %%
tic;
% %% Your code here
% %% Displaying the patch based filtering gaussian mask applied to the patches:
% patch_size = 9;
% patch_gaussian_sigma = 2;
% patch_gaussian_filter = fspecial('gaussian',patch_size,patch_gaussian_sigma);
% savefig3(my_color_scale,patch_gaussian_filter,patch_gaussian_filter,patch_gaussian_filter,'Gaussian Noise','Gaussian Noise',strcat(strcat('Part3_a_mask',num2str(12)),'.png'),0,to_save);

% imshow(patch_gaussian_filter);

%% Grass Pic
% RMSD best
%    25.3322

% RMSD 0.9
%    25.4009

% RMSD 1.1
%    25.3635
%%
intensity_scale = 0.016
original_pic = grass_pic;
seed = 5;
intensity_limit = [min(min(original_pic)),max(max(original_pic))];
intensity_range = intensity_limit(2) - intensity_limit(1);
noise_sigma = 0.05*intensity_range;
rng(seed);
gaussian_noise = randn(size(original_pic))*noise_sigma;
original_pic_corrupt = original_pic + gaussian_noise;
h_sigma = intensity_range*intensity_scale;
modified_pic = myPatchBasedFiltering(original_pic_corrupt, h_sigma);
savefig3(my_color_scale,original_pic,original_pic_corrupt,modified_pic,'Corrupted Image','Patch Filtered Image',strcat(strcat('Part3_a_2_',num2str(intensity_scale)),'.png'),0,to_save);

disp('RMSD best')
disp(calculate_rmsd(modified_pic,original_pic))
h_sigma = intensity_range*intensity_scale*0.9;
modified_pic = myPatchBasedFiltering(original_pic_corrupt, h_sigma);
disp('RMSD 0.9')
disp(calculate_rmsd(modified_pic,original_pic))
h_sigma = intensity_range*intensity_scale*1.1;
modified_pic = myPatchBasedFiltering(original_pic_corrupt, h_sigma);
disp('RMSD 1.1')
disp(calculate_rmsd(modified_pic,original_pic))

%% Barbara Pic
% RMSD best
%    25.3322

% RMSD 0.9
%    25.4009

% RMSD 1.1
%    25.3635
%%
intensity_scale = 0.015
original_pic = barbara_pic;
seed = 5;
intensity_limit = [min(min(original_pic)),max(max(original_pic))];
intensity_range = intensity_limit(2) - intensity_limit(1);
noise_sigma = 0.05*intensity_range;
rng(seed);
gaussian_noise = randn(size(original_pic))*noise_sigma;
original_pic_corrupt = original_pic + gaussian_noise;
h_sigma = intensity_range*intensity_scale;
modified_pic = myPatchBasedFiltering(original_pic_corrupt, h_sigma);
savefig3(my_color_scale,original_pic,original_pic_corrupt,modified_pic,'Corrupted Image','Patch Filtered Image',strcat(strcat('Part3_a_1_',num2str(intensity_scale)),'.png'),0,to_save);

disp('RMSD best')
disp(calculate_rmsd(modified_pic,original_pic))
h_sigma = intensity_range*intensity_scale*0.9;
modified_pic = myPatchBasedFiltering(original_pic_corrupt, h_sigma);
disp('RMSD 0.9')
disp(calculate_rmsd(modified_pic,original_pic))
h_sigma = intensity_range*intensity_scale*1.1;
modified_pic = myPatchBasedFiltering(original_pic_corrupt, h_sigma);
disp('RMSD 1.1')
disp(calculate_rmsd(modified_pic,original_pic))


%% Honey Pic
% RMSD best
%    25.3322

% RMSD 0.9
%    25.4009

% RMSD 1.1
%    25.3635
%%

intensity_scale = 0.018
original_pic = honey_pic;
seed = 5;
intensity_limit = [min(min(original_pic)),max(max(original_pic))];
intensity_range = intensity_limit(2) - intensity_limit(1);
noise_sigma = 0.05*intensity_range;
rng(seed);
gaussian_noise = randn(size(original_pic))*noise_sigma;
original_pic_corrupt = original_pic + gaussian_noise;
h_sigma = intensity_range*intensity_scale;
modified_pic = myPatchBasedFiltering(original_pic_corrupt, h_sigma);
savefig3(my_color_scale,original_pic,original_pic_corrupt,modified_pic,'Corrupted Image','Patch Filtered Image',strcat(strcat('Part3_a_3_',num2str(intensity_scale)),'.png'),0,to_save);

disp('RMSD best')
disp(calculate_rmsd(modified_pic,original_pic))
h_sigma = intensity_range*intensity_scale*0.9;
modified_pic = myPatchBasedFiltering(original_pic_corrupt, h_sigma);
disp('RMSD 0.9')
disp(calculate_rmsd(modified_pic,original_pic))
h_sigma = intensity_range*intensity_scale*1.1;
modified_pic = myPatchBasedFiltering(original_pic_corrupt, h_sigma);
disp('RMSD 1.1')
disp(calculate_rmsd(modified_pic,original_pic))
% end
toc;

% RMSE Calculation Helper Function %
function [rmsd] = calculate_rmsd(pic1, pic2)
	rmsd = sqrt(sum(sum((pic1 - pic2).^2))/numel(pic1));
end

% Helper function to display and save processed images %
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

% % for intensity_scale = [0.005,0.01,0.02,0.05,0.1]

% 	original_pic = grass_pic;
% 	seed = 5;
% 	intensity_limit = [min(min(original_pic)),max(max(original_pic))];
% 	intensity_range = intensity_limit(2) - intensity_limit(1);
% 	noise_sigma = 0.01*intensity_range;
% 	rng(seed);
% 	gaussian_noise = randn(size(original_pic))*noise_sigma;
% 	original_pic_corrupt = original_pic + gaussian_noise;
% 	h_sigma = intensity_range*intensity_scale;
% 	modified_pic = myPatchBasedFiltering(original_pic_corrupt, h_sigma);
% 	savefig3(my_color_scale,original_pic,original_pic_corrupt,modified_pic,'Corrupted Image','Patch Filtered Image',strcat(strcat('Part3_a_2_',num2str(intensity_scale)),'.png'),0,to_save);

% 	original_pic = barbara_pic;
% 	seed = 5;
% 	intensity_limit = [min(min(original_pic)),max(max(original_pic))];
% 	intensity_range = intensity_limit(2) - intensity_limit(1);
% 	noise_sigma = 0.01*intensity_range;
% 	rng(seed);
% 	gaussian_noise = randn(size(original_pic))*noise_sigma;
% 	original_pic_corrupt = original_pic + gaussian_noise;
% 	h_sigma = intensity_range*intensity_scale;
% 	modified_pic = myPatchBasedFiltering(original_pic_corrupt, h_sigma);
% 	savefig3(my_color_scale,original_pic,original_pic_corrupt,modified_pic,'Corrupted Image','Patch Filtered Image',strcat(strcat('Part3_a_1_',num2str(intensity_scale)),'.png'),0,to_save);

% 	original_pic = honey_pic;
% 	seed = 5;
% 	intensity_limit = [min(min(original_pic)),max(max(original_pic))];
% 	intensity_range = intensity_limit(2) - intensity_limit(1);
% 	noise_sigma = 0.01*intensity_range;
% 	rng(seed);
% 	gaussian_noise = randn(size(original_pic))*noise_sigma;
% 	original_pic_corrupt = original_pic + gaussian_noise;
% 	h_sigma = intensity_range*intensity_scale;
% 	modified_pic = myPatchBasedFiltering(original_pic_corrupt, h_sigma);
% 	savefig3(my_color_scale,original_pic,original_pic_corrupt,modified_pic,'Corrupted Image','Patch Filtered Image',strcat(strcat('Part3_a_3_',num2str(intensity_scale)),'.png'),0,to_save);

% 	disp('Done')
% 	disp(intensity_scale)
% % end
% toc;
% disp('RMSD best')
% disp(calculate_rmsd(modified_pic,original_pic))
% spatial_sigma =1.4*0.9;
% intensity_sigma = intensity_range*0.1;
% modified_pic = myBilateralFiltering(original_pic_corrupt, spatial_sigma, intensity_sigma);
% disp('RMSD 0.9 spatial')
% disp(calculate_rmsd(modified_pic,original_pic))
% spatial_sigma =1.4*1.1;
% intensity_sigma = intensity_range*0.1;
% modified_pic = myBilateralFiltering(original_pic_corrupt, spatial_sigma, intensity_sigma);
% disp('RMSD 1.1 spatial')
% disp(calculate_rmsd(modified_pic,original_pic))
% spatial_sigma =1.4;
% intensity_sigma = intensity_range*0.1*0.9;
% modified_pic = myBilateralFiltering(original_pic_corrupt, spatial_sigma, intensity_sigma);
% disp('RMSD 0.9 intensity')
% disp(calculate_rmsd(modified_pic,original_pic))
% spatial_sigma =1.4;
% intensity_sigma = intensity_range*0.1*1.1;
% modified_pic = myBilateralFiltering(original_pic_corrupt, spatial_sigma, intensity_sigma);
% disp('RMSD 1.1 intensity')
% disp(calculate_rmsd(modified_pic,original_pic))

% f = waitbar(0, 'Starting Tuning');
% progress = 0.05;

% waitbar(progress,f,'Starting Grass');

% original_pic = grass_pic;
% seed = 5;
% intensity_limit = [min(min(original_pic)),max(max(original_pic))];
% intensity_range = intensity_limit(2) - intensity_limit(1);

% noise_sigma = 0.05*intensity_range;

% rng(seed);
% gaussian_noise = randn(size(original_pic))*noise_sigma;
% original_pic_corrupt = original_pic + gaussian_noise;

% best_intensity_scale = 0;
% best_rmsd = 1.e100;

% %% Your code here
% for intensity_scale = 0.011:0.001:0.019
% 	h_sigma = intensity_range*intensity_scale;
% 	modified_pic = myPatchBasedFiltering(original_pic_corrupt, h_sigma);
% 	rmsd_value = calculate_rmsd(original_pic,modified_pic);
% 	if rmsd_value < best_rmsd
% 		best_intensity_scale = intensity_scale;
% 		best_rmsd = rmsd_value;
% 	end
% 	progress = progress + 0.28/(5);
% 	waitbar(progress,f,'Tuning...');
% end

% % waitbar(progress,f,'Done');
% disp("best_rmsd")
% disp(best_rmsd)
% disp("best_intensity_scale")
% disp(best_intensity_scale);

% h_sigma = intensity_range*best_intensity_scale;
% modified_pic = myPatchBasedFiltering(original_pic_corrupt, h_sigma);
% rmsd_value = calculate_rmsd(original_pic,modified_pic);
% savefig3(my_color_scale,original_pic,original_pic_corrupt,modified_pic,'Corrupted Image','Patch Filtered Image',strcat(strcat('Part3_a_2_',num2str(intensity_scale)),'.png'),0,to_save);


% %%--------------------------------Barbara Tuning-----------------------------------------
% waitbar(progress,f,'Starting Barbara');

% original_pic = barbara_pic;
% seed = 5;
% intensity_limit = [min(min(original_pic)),max(max(original_pic))];
% intensity_range = intensity_limit(2) - intensity_limit(1);
% noise_sigma = 0.05*intensity_range;
% rng(seed);
% gaussian_noise = randn(size(original_pic))*noise_sigma;
% original_pic_corrupt = original_pic + gaussian_noise;

% best_intensity_scale = 0;
% best_rmsd = 1.e100;

% for intensity_scale = 0.008:0.01:0.018	
% 	h_sigma = intensity_range*intensity_scale;
% 	modified_pic = myPatchBasedFiltering(original_pic_corrupt, h_sigma);
% 	rmsd_value = calculate_rmsd(original_pic,modified_pic);
% 	if rmsd_value < best_rmsd
% 		best_intensity_scale = intensity_scale;
% 		best_rmsd = rmsd_value;
% 	end
% 	progress = progress + 0.33/3;
% 	waitbar(progress,f,'Tuning...');
% end

% % waitbar(progress,f,'Done');

% disp("best_rmsd")
% disp(best_rmsd)
% disp("best_intensity_scale")
% disp(best_intensity_scale);

% h_sigma = intensity_range*best_intensity_scale;
% modified_pic = myPatchBasedFiltering(original_pic_corrupt, h_sigma);
% rmsd_value = calculate_rmsd(original_pic,modified_pic);
% savefig3(my_color_scale,original_pic,original_pic_corrupt,modified_pic,'Corrupted Image','Patch Filtered Image',strcat(strcat('Part3_a_1_',num2str(intensity_scale)),'.png'),0,to_save);

%%--------------------------------Honey Tuning-----------------------------------------

% waitbar(progress,f,'Starting Honey');

% original_pic = honey_pic;
% seed = 5;
% intensity_limit = [min(min(original_pic)),max(max(original_pic))];
% intensity_range = intensity_limit(2) - intensity_limit(1);
% noise_sigma = 0.05*intensity_range;
% rng(seed);
% gaussian_noise = randn(size(original_pic))*noise_sigma;
% original_pic_corrupt = original_pic + gaussian_noise;
% savefig3(my_color_scale,original_pic,original_pic_corrupt,original_pic,'Corrupted Image','Patch Filtered Image',strcat(strcat('Part3_a_2_',num2str(intensity_scale)),'.png'),0,to_save);

% best_intensity_scale = 0;
% best_rmsd = 1.e100;

% for intensity_scale = 0.018:0.001:0.020	
% 	h_sigma = intensity_range*intensity_scale;
% 	modified_pic = myPatchBasedFiltering(original_pic_corrupt, h_sigma);
% 	rmsd_value = calculate_rmsd(original_pic,modified_pic);
% 	if rmsd_value < best_rmsd
% 		best_intensity_scale = intensity_scale;
% 		best_rmsd = rmsd_value;
% 	end
% 	progress = progress + 0.33;
% 	waitbar(progress,f,'Tuning...');
% end

% disp("best_rmsd")
% disp(best_rmsd)
% disp("best_intensity_scale")
% disp(best_intensity_scale);

% h_sigma = intensity_range*best_intensity_scale;
% modified_pic = myPatchBasedFiltering(original_pic_corrupt, h_sigma);
% rmsd_value = calculate_rmsd(original_pic,modified_pic);
% savefig3(my_color_scale,original_pic,original_pic_corrupt,modified_pic,'Corrupted Image','Patch Filtered Image',strcat(strcat('Part3_a_2_',num2str(intensity_scale)),'.png'),0,to_save);

% waitbar(progress,f,'Done');
% close(f)
