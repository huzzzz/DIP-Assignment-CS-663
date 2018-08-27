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


%% Grass %%
% 0.1800 - factor

% 42.8400 - intenstity sigma

% 0.9000 - spatial sigma


%% Barbara %%
% 0.1000

% 10

% 1.4000


%% Honey %%
%  0.1600

% 40.6400

%  1.1000


tic;
%% Your code here

original_pic = barbara_pic;
seed = 5;
intensity_limit = [min(min(original_pic)),max(max(original_pic))];
intensity_range = intensity_limit(2) - intensity_limit(1);
noise_sigma = 0.05*intensity_range;
rng(seed);
gaussian_noise = randn(size(original_pic))*noise_sigma;
original_pic_corrupt = original_pic + gaussian_noise;
spatial_sigma =1.4;
intensity_sigma = intensity_range*0.1;
modified_pic = myBilateralFiltering(original_pic_corrupt, spatial_sigma, intensity_sigma);
savefig3(my_color_scale,original_pic,original_pic_corrupt,modified_pic,'Corrupted Image','Bilaterally Filtered Image','Part2_a_1.png',0,to_save);
savefig(my_color_scale,original_pic,gaussian_noise,'Gaussian Noise Mask','Part2_a_1_mask.png',0,to_save);
disp('RMSD best')
disp(calculate_rmsd(modified_pic,original_pic))
spatial_sigma =1.4*0.9;
intensity_sigma = intensity_range*0.1;
modified_pic = myBilateralFiltering(original_pic_corrupt, spatial_sigma, intensity_sigma);
disp('RMSD 0.9 spatial')
disp(calculate_rmsd(modified_pic,original_pic))
spatial_sigma =1.4*1.1;
intensity_sigma = intensity_range*0.1;
modified_pic = myBilateralFiltering(original_pic_corrupt, spatial_sigma, intensity_sigma);
disp('RMSD 1.1 spatial')
disp(calculate_rmsd(modified_pic,original_pic))
spatial_sigma =1.4;
intensity_sigma = intensity_range*0.1*0.9;
modified_pic = myBilateralFiltering(original_pic_corrupt, spatial_sigma, intensity_sigma);
disp('RMSD 0.9 intensity')
disp(calculate_rmsd(modified_pic,original_pic))
spatial_sigma =1.4;
intensity_sigma = intensity_range*0.1*1.1;
modified_pic = myBilateralFiltering(original_pic_corrupt, spatial_sigma, intensity_sigma);
disp('RMSD 1.1 intensity')
disp(calculate_rmsd(modified_pic,original_pic))

original_pic = grass_pic;
seed = 5;
intensity_limit = [min(min(original_pic)),max(max(original_pic))];
intensity_range = intensity_limit(2) - intensity_limit(1);
noise_sigma = 0.05*intensity_range;
rng(seed);
gaussian_noise = randn(size(original_pic))*noise_sigma;
original_pic_corrupt = original_pic + gaussian_noise;
spatial_sigma =0.9;
intensity_sigma = intensity_range*0.18;
modified_pic = myBilateralFiltering(original_pic_corrupt, spatial_sigma, intensity_sigma);
savefig3(my_color_scale,original_pic,original_pic_corrupt,modified_pic,'Corrupted Image','Bilaterally Filtered Image','Part2_a_2.png',0,to_save);
savefig(my_color_scale,original_pic,gaussian_noise,'Gaussian Noise Mask','Part2_a_2_mask.png',0,to_save);
disp('RMSD best')
disp(calculate_rmsd(modified_pic,original_pic))
spatial_sigma =0.9*0.9;
intensity_sigma = intensity_range*0.18;
modified_pic = myBilateralFiltering(original_pic_corrupt, spatial_sigma, intensity_sigma);
disp('RMSD 0.9 spatial')
disp(calculate_rmsd(modified_pic,original_pic))
spatial_sigma =0.9*1.1;
intensity_sigma = intensity_range*0.18;
modified_pic = myBilateralFiltering(original_pic_corrupt, spatial_sigma, intensity_sigma);
disp('RMSD 1.1 spatial')
disp(calculate_rmsd(modified_pic,original_pic))
spatial_sigma =0.9;
intensity_sigma = intensity_range*0.18*0.9;
modified_pic = myBilateralFiltering(original_pic_corrupt, spatial_sigma, intensity_sigma);
disp('RMSD 0.9 intensity')
disp(calculate_rmsd(modified_pic,original_pic))
spatial_sigma =0.9;
intensity_sigma = intensity_range*0.18*1.1;
modified_pic = myBilateralFiltering(original_pic_corrupt, spatial_sigma, intensity_sigma);
disp('RMSD 1.1 intensity')
disp(calculate_rmsd(modified_pic,original_pic))


original_pic = honey_pic;
seed = 5;
intensity_limit = [min(min(original_pic)),max(max(original_pic))];
intensity_range = intensity_limit(2) - intensity_limit(1);
noise_sigma = 0.05*intensity_range;
rng(seed);
gaussian_noise = randn(size(original_pic))*noise_sigma;
original_pic_corrupt = original_pic + gaussian_noise;
spatial_sigma =1.1;
intensity_sigma = intensity_range*0.16;
modified_pic = myBilateralFiltering(original_pic_corrupt, spatial_sigma, intensity_sigma);
savefig3(my_color_scale,original_pic,original_pic_corrupt,modified_pic,'Corrupted Image','Bilaterally Filtered Image','Part2_a_3.png',0,to_save);
savefig(my_color_scale,original_pic,gaussian_noise,'Gaussian Noise Mask','Part2_a_3_mask.png',0,to_save);
disp('RMSD best')
disp(calculate_rmsd(modified_pic,original_pic))
spatial_sigma =1.1*0.9;
intensity_sigma = intensity_range*0.16;
modified_pic = myBilateralFiltering(original_pic_corrupt, spatial_sigma, intensity_sigma);
disp('RMSD 0.9 spatial')
disp(calculate_rmsd(modified_pic,original_pic))
spatial_sigma =1.1*1.1;
intensity_sigma = intensity_range*0.16;
modified_pic = myBilateralFiltering(original_pic_corrupt, spatial_sigma, intensity_sigma);
disp('RMSD 1.1 spatial')
disp(calculate_rmsd(modified_pic,original_pic))
spatial_sigma =1.1;
intensity_sigma = intensity_range*0.16*0.9;
modified_pic = myBilateralFiltering(original_pic_corrupt, spatial_sigma, intensity_sigma);
disp('RMSD 0.9 intensity')
disp(calculate_rmsd(modified_pic,original_pic))
spatial_sigma =1.1;
intensity_sigma = intensity_range*0.16*1.1;
modified_pic = myBilateralFiltering(original_pic_corrupt, spatial_sigma, intensity_sigma);
disp('RMSD 1.1 intensity')
disp(calculate_rmsd(modified_pic,original_pic))


toc;

%% Barbara Pic %%
% RMSD best
%     3.2992

% RMSD 0.9 spatial
%     3.3031

% RMSD 1.1 spatial
%     3.3005

% RMSD 0.9 intensity
%     3.3269

% RMSD 1.1 intensity
%     3.3086


%% Grass Pic %%
% RMSD best
%     7.3624

% RMSD 0.9 spatial
%     7.3798

% RMSD 1.1 spatial
%     7.3770

% RMSD 0.9 intensity
%     7.3746

% RMSD 1.1 intensity
%     7.3849


%% Honey Pic %%
% RMSD best
%     7.3495

% RMSD 0.9 spatial
%     7.3716

% RMSD 1.1 spatial
%     7.5309

% RMSD 0.9 intensity
%     7.3782

% RMSD 1.1 intensity
%     7.3695



%% Tuning Code %%
% original_pic = grass_pic;

% seed = 5;
% intensity_limit = [min(min(original_pic)),max(max(original_pic))];
% intensity_range = intensity_limit(2) - intensity_limit(1);

% noise_sigma = 0.05*intensity_range;
% rng(seed);
% gaussian_noise = randn(size(original_pic))*noise_sigma;
% original_pic_corrupt = original_pic + gaussian_noise;
% % spatial_sigma =3;
% best_spatial = 0;
% best_factor = 0;
% best_rmsd = 1.e100;

% f = waitbar(0, 'Starting Tuning');
% progress = 0.05;

% waitbar(progress,f,'Starting Grass');
% for spatial_sigma=0.8:0.05:1.1
% 	for intensity_sigma_factor=0.04:0.02:0.2
% 		intensity_sigma = intensity_range*intensity_sigma_factor;
% 		modified_pic = myBilateralFiltering(original_pic_corrupt, spatial_sigma, intensity_sigma);
% 		rmsd_value = calculate_rmsd(original_pic,modified_pic);
% 		if rmsd_value < best_rmsd
% 			best_factor = intensity_sigma_factor;
% 			best_intensity = intensity_sigma;
% 			best_spatial = spatial_sigma;
% 			best_rmsd = rmsd_value;
% 		end
% 		progress = progress + 0.95/(81*3);
% 		waitbar(progress,f,'Computing...');
% 	end
% end

% waitbar(progress,f,'Done');
% disp(best_factor);
% disp(best_intensity);
% disp(best_spatial);

% seed = 5;
% intensity_limit = [min(min(original_pic)),max(max(original_pic))];
% intensity_range = intensity_limit(2) - intensity_limit(1);

% spatial_sigma =best_spatial;
% intensity_sigma = intensity_range*best_factor;
% modified_pic = myBilateralFiltering(original_pic_corrupt, spatial_sigma, intensity_sigma);
% savefig3(my_color_scale,original_pic,original_pic_corrupt,modified_pic,'Corrupted Image','Bilaterally Filtered Image','Part2_a_2.png',0,to_save);


% original_pic = barbara_pic;

% seed = 5;
% intensity_limit = [min(min(original_pic)),max(max(original_pic))];
% intensity_range = intensity_limit(2) - intensity_limit(1);

% noise_sigma = 0.05*intensity_range;
% rng(seed);
% gaussian_noise = randn(size(original_pic))*noise_sigma;
% original_pic_corrupt = original_pic + gaussian_noise;
% % spatial_sigma =3;
% best_spatial = 0;
% best_factor = 0;
% best_rmsd = 1.e100;

% waitbar(progress,f,'Starting Barbara');
% for spatial_sigma=1:0.1:2
% 	for intensity_sigma_factor=0.04:0.02:0.2
% 		intensity_sigma = intensity_range*intensity_sigma_factor;
% 		modified_pic = myBilateralFiltering(original_pic_corrupt, spatial_sigma, intensity_sigma);
% 		rmsd_value = calculate_rmsd(original_pic,modified_pic);
% 		if rmsd_value < best_rmsd
% 			best_factor = intensity_sigma_factor;
% 			best_intensity = intensity_sigma;
% 			best_spatial = spatial_sigma;
% 			best_rmsd = rmsd_value;
% 		end
% 		progress = progress + 0.95/(81*3);
% 		waitbar(progress,f,'Computing...');
% 	end
% end

% disp(best_factor);
% disp(best_intensity);
% disp(best_spatial);

% seed = 5;
% intensity_limit = [min(min(original_pic)),max(max(original_pic))];
% intensity_range = intensity_limit(2) - intensity_limit(1);

% spatial_sigma =best_spatial;
% intensity_sigma = intensity_range*best_factor;
% modified_pic = myBilateralFiltering(original_pic_corrupt, spatial_sigma, intensity_sigma);
% savefig3(my_color_scale,original_pic,original_pic_corrupt,modified_pic,'Corrupted Image','Bilaterally Filtered Image','Part2_a_2.png',0,to_save);


% original_pic = honey_pic;
% seed = 5;
% intensity_limit = [min(min(original_pic)),max(max(original_pic))];
% intensity_range = intensity_limit(2) - intensity_limit(1);

% noise_sigma = 0.05*intensity_range;
% rng(seed);
% gaussian_noise = randn(size(original_pic))*noise_sigma;
% original_pic_corrupt = original_pic + gaussian_noise;
% best_spatial = 0;
% best_factor = 0;
% best_rmsd = 1.e100;

% waitbar(progress,f,'Starting honey');
% for spatial_sigma=0.8:0.05:1.1
% 	for intensity_sigma_factor=0.04:0.02:0.2
% 		intensity_sigma = intensity_range*intensity_sigma_factor;
% 		modified_pic = myBilateralFiltering(original_pic_corrupt, spatial_sigma, intensity_sigma);
% 		rmsd_value = calculate_rmsd(original_pic,modified_pic);
% 		if rmsd_value < best_rmsd
% 			best_factor = intensity_sigma_factor;
% 			best_intensity = intensity_sigma;
% 			best_spatial = spatial_sigma;
% 			best_rmsd = rmsd_value;
% 		end
% 		progress = progress + 0.95/(81*3);
% 		waitbar(progress,f,'Computing...');
% 	end
% end

% waitbar(progress,f,'Done');
% disp(best_factor);
% disp(best_intensity);
% disp(best_spatial);

% seed = 5;
% intensity_limit = [min(min(original_pic)),max(max(original_pic))];
% intensity_range = intensity_limit(2) - intensity_limit(1);

% spatial_sigma =best_spatial;
% intensity_sigma = intensity_range*best_factor;
% modified_pic = myBilateralFiltering(original_pic_corrupt, spatial_sigma, intensity_sigma);
% savefig3(my_color_scale,original_pic,original_pic_corrupt,modified_pic,'Corrupted Image','Bilaterally Filtered Image','Part2_a_2.png',0,to_save);

%% End of tuning code %%

% RMSE Calculation Helper Function %
function [rmsd] = calculate_rmsd(pic1, pic2)
	rmsd = sqrt(sum(sum((pic1 - pic2).^2))/numel(pic1));
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

% Helper function to display and save 2 processed images %
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
