function modified_pic = myPCADenoising1(noisy_pic, gaussian_sigma, patch_size)
	% PCA Denoising %

	modified_pic = zeros(size(noisy_pic));

	[h,w] = size(noisy_pic);
	N = (h-patch_size+1)*(w-patch_size+1);
	P = zeros([patch_size*patch_size,N]);
	count = 1;

	for i = 1:h-patch_size+1
		for j = 1:w-patch_size+1
			temp = noisy_pic(i:i+patch_size-1,j:j+patch_size-1);
			P(:,count) = temp(:);
			count = count + 1;
		end
	end

	[eig_vecs, eig_vals] = eigs(P*P',patch_size^2);
	alpha_mat = eig_vecs' * P;
	alpha_sq = alpha_mat.*alpha_mat;
	alpha_bar_sq = max(0, (sum(alpha_sq,2)/N) - gaussian_sigma^2);

	alpha_denoised = zeros(size(alpha_mat));
	
	for i=1:patch_size^2
		for j=1:N
			alpha_denoised(i,j) = (alpha_bar_sq(i)*alpha_mat(i,j))/(alpha_bar_sq(i) + gaussian_sigma^2);
		end
	end

	P_final = eig_vecs*alpha_denoised;
	count_mat = zeros(size(noisy_pic));
	
	count = 1;
	for i = 1:h-patch_size+1
		for j = 1:w-patch_size+1
			temp = P_final(:,count);
			modified_pic(i:i+patch_size-1,j:j+patch_size-1) = modified_pic(i:i+patch_size-1,j:j+patch_size-1) + reshape(temp,patch_size,patch_size);
			count = count + 1;
			count_mat(i:i+patch_size-1,j:j+patch_size-1) = count_mat(i:i+patch_size-1,j:j+patch_size-1) + 1;
		end
	end

	modified_pic = modified_pic./count_mat;

end