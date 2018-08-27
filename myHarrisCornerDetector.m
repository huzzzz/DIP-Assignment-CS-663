function [modified_pic, Cornerness, Eigen_1, Eigen_2, I_x, I_y] = myHarrisCornerDetector(original_pic,patch_gaussian_sigma,k)
	% Harris Corner Detection %
	
	% Defining the masks %
	sobel_mask = fspecial('sobel');
	prewitt_mask = fspecial('prewitt');
	
	custom_mask_x = [0,0,0;-1,0,1;0,0,0];
	custom_mask_y = custom_mask_x';

	gradient_mask_x = sobel_mask';
	gradient_mask_y = sobel_mask;

	I_x = imfilter(original_pic,gradient_mask_x);
	I_y = imfilter(original_pic,gradient_mask_y);
	
	I_x2 = I_x.*I_x;
	I_y2 = I_y.*I_y;
	I_xy = I_y.*I_x;

	patch_size = double(int16(int16(2*patch_gaussian_sigma)/2)*2 + 3);
	patch_gaussian_filter = fspecial('gaussian',patch_size,patch_gaussian_sigma);
	
	A_11 = imfilter(I_x2,patch_gaussian_filter);
	A_22 = imfilter(I_y2,patch_gaussian_filter);
	A_12 = imfilter(I_xy,patch_gaussian_filter);

	Trace = A_11 + A_22;
	Determinant = A_11.*A_22 - A_12.*A_12;

	Eigen_1 = (Trace + sqrt(Trace.^2 - 4*Determinant))/2;
	Eigen_2 = (Trace - sqrt(Trace.^2 - 4*Determinant))/2;

	Cornerness = Determinant - k*(Trace.^2);

	% Extra Part, not asked in the assignment, for visualization purposes %
	modified_pic = max(0,Cornerness);
	non_max_supp = ordfilt2(modified_pic,9,ones(3,3));
	
	mask = (non_max_supp == modified_pic);
	modified_pic = mask .* modified_pic	;
	threshold = 0.0001;
	modified_pic = modified_pic>threshold;

end