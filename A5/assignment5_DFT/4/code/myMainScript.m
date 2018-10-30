%% MyMainScript

%% Setting the color scale
my_num_of_colors = 256;
col_scale =  [0:1/(my_num_of_colors-1):1]';
my_color_scale = [col_scale,col_scale,col_scale];
to_save = 1;

tic;

%% Load image and compute fft
original_pic = imread('../data/barbara256.png');
fft_pic = fftshift(fft2(original_pic));
log_fft_pic = log(abs(fft_pic)+1);

%% Ideal low pass filter
mid_fft_pic = ideal_low_pass(fft_pic, 40);
modified_fft_pic = ideal_low_pass(fft_pic, 80);

log_mid_fft_pic = log(abs(mid_fft_pic)+1);
log_modified_fft_pic = log(abs(modified_fft_pic)+1);

mid_pic = abs(ifft2(ifftshift(mid_fft_pic)));
modified_pic = abs(ifft2(ifftshift(modified_fft_pic)));

savefig3(my_color_scale,log_fft_pic,log_mid_fft_pic,log_modified_fft_pic,'Cutoff Frequency = 40','Cutoff Frequency = 80','../images/ideal_low_pass_fft.png',1,to_save)
savefig3(my_color_scale,original_pic,mid_pic,modified_pic,'Cutoff Frequency = 40','Cutoff Frequency = 80','../images/ideal_low_pass.png',0,to_save)

%% Gaussian low pass filter
mid_fft_pic = gaussian_low_pass(fft_pic, 40);
modified_fft_pic = gaussian_low_pass(fft_pic, 80);

log_mid_fft_pic = log(abs(mid_fft_pic)+1);
log_modified_fft_pic = log(abs(modified_fft_pic)+1);

mid_pic = abs(ifft2(ifftshift(mid_fft_pic)));
modified_pic = abs(ifft2(ifftshift(modified_fft_pic)));

savefig3(my_color_scale,log_fft_pic,log_mid_fft_pic,log_modified_fft_pic,'Sigma = 40','Sigma = 80','../images/gaussian_low_pass_fft.png',1,to_save)
savefig3(my_color_scale,original_pic,mid_pic,modified_pic,'Sigma = 40','Sigma = 80','../images/gaussian_low_pass.png',0,to_save)

toc;

%% Comments on the output
% 1. Ideal Low Pass Filter: As the cutoff frequency increases, we get less blurred image as more information is retained (Higher frequencies retained)

% 2. Gaussian Low Pass Filter: Similarly as sigma increases, we get less blurred image as high frequencies are comparatively less attenuated

% 3. Comparing across the filters, we see clearly ringing artifacts when ideal low pass filter is applied for cutoff frequency = 40    

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