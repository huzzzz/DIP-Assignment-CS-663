%% MyMainScript

%% Setting the color scale
my_num_of_colors = 256;
col_scale =  [0:1/(my_num_of_colors-1):1]';
my_color_scale = [col_scale,col_scale,col_scale];
to_save = 1;

tic;

%% Loading image
original_pic = load('../data/image_low_frequency_noise.mat');
original_pic = original_pic.Z;

%% Display Log magnitude of Fourier Transform
fft_pic = fftshift(fft2(original_pic));
log_fft_pic = log(abs(fft_pic)+1);
imshow(log_fft_pic,[-2 18]);
title('Log magnitude of Fourier Transform');
colormap(jet); colorbar; impixelinfo();
snapnow;

%% Applying Ideal Notch Filter to the Fourier transform
% Peaks found at (119,124) and (139,134) in the log magnitude of Fourier transform.
for i = -3:3
	for j = -3:3
		fft_pic(119+i, 124+j) = 0;
		fft_pic(139+i, 134+j) = 0;
	end
end

%% Displaying Log magnitude of Fourier Transform after applying Notch Filter
log_fft_pic = log(abs(fft_pic)+1);
imshow(log_fft_pic,[-2 18]);
title('FFT After applying Notch Filter');
colormap(jet); colorbar; impixelinfo();
snapnow;

%% Displaying restored image
modified_pic = ifft2(ifftshift(fft_pic));
savefig(my_color_scale,original_pic,modified_pic,'Notch Filtered Image','../images/notch_filtered_image.png',0,to_save);

toc;


%% Helper function to display and save processed images
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
