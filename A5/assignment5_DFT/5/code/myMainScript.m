%% MyMainScript

%% Setting the color scale
my_num_of_colors = 256;
col_scale =  [0:1/(my_num_of_colors-1):1]';
my_color_scale = [col_scale,col_scale,col_scale];
to_save = 1;

%% Parameters
gaussian_sigma = 20;
patch_size = 7;
neighborhood_size = 31;
num_neighbors = 200;

%% Load image and compute fft
original_pic = double(imread('../data/barbara256.png'));
noisy_pic = original_pic + gaussian_sigma*randn(size(original_pic));

%% PCA Denoising method 1
tic;
modified_pic = myPCADenoising1(noisy_pic,gaussian_sigma,patch_size);
disp(rmse(modified_pic,original_pic));
savefig3(my_color_scale,original_pic,noisy_pic,modified_pic,'Noisy','Method 1 Denoised','../images/PCADenoised1.png',0,to_save)
toc;

%% PCA Denoising method 2
tic;
modified_pic = myPCADenoising2(noisy_pic,gaussian_sigma,patch_size,neighborhood_size,num_neighbors);
disp(rmse(modified_pic,original_pic));
savefig3(my_color_scale,original_pic,noisy_pic,modified_pic,'Noisy','Method 2 Denoised','../images/PCADenoised2.png',0,to_save)
toc;

%% Bilateral Filtering
tic;
intensity_limit = [min(min(noisy_pic)),max(max(noisy_pic))];
intensity_range = intensity_limit(2) - intensity_limit(1);
spatial_sigma =1.4;
intensity_sigma = intensity_range*0.1;
modified_pic = myBilateralFiltering(noisy_pic, spatial_sigma, intensity_sigma);
savefig3(my_color_scale,original_pic,noisy_pic,modified_pic,'Noisy','Bilateral Denoised','../images/Bilateral.png',0,to_save)
toc;

%% Poisson Noise
tic;
poisson_noise_pic = poissrnd(original_pic);
root_noise_pic = sqrt(poisson_noise_pic);
modified_pic = myPCADenoising2(root_noise_pic,0.5,patch_size,neighborhood_size,num_neighbors);
modified_pic = modified_pic.^2;
disp(rmse(modified_pic,original_pic));
savefig3(my_color_scale,original_pic,root_noise_pic,modified_pic,'Poisson Noisy','Denoised','../images/Poisson.png',0,to_save)
toc;

%% Poisson Noise by 20
tic;
poisson_noise_pic = poissrnd(original_pic/20);
root_noise_pic = sqrt(poisson_noise_pic);
modified_pic = myPCADenoising2(root_noise_pic,0.5,patch_size,neighborhood_size,num_neighbors);
modified_pic = 20 * modified_pic.^2;
disp(rmse(modified_pic,original_pic));
savefig3(my_color_scale,original_pic,root_noise_pic,modified_pic,'Poisson Noisy By 20','Denoised','../images/PoissonBy20.png',0,to_save)
toc;

%% Helper function to display and save 3 processed images
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
    snapnow;
	if to_save == 1
		saveas(fig,file_name),close(fig);
	end
end