function modified_pic = myPCADenoising1(noisy_pic, gaussian_sigma, patch_size, nbr_size, num_nbr)
	% PCA Denoising %

	modified_pic = zeros(size(noisy_pic));

	[h,w] = size(noisy_pic);
	N = (h-patch_size+1)*(w-patch_size+1);
	P = zeros([patch_size*patch_size,N]);
	count = 1;

	
	for j = 1:w-patch_size+1
		for i = 1:h-patch_size+1
			temp = noisy_pic(i:i+patch_size-1,j:j+patch_size-1);
			P(:,count) = temp(:);
			count = count + 1;
		end
	end
	
	P_final = zeros(size(P));
	for a=1:N
		curr_patch = P(:,a);
		
		[x_patch,y_patch] = ind2sub([h-patch_size+1,w-patch_size+1],a);
		nbr_len = floor(nbr_size/2);
		xl = max(1,x_patch-nbr_len);
		xu = min(h-patch_size+1,x_patch+nbr_len);

		yl = max(1,y_patch-nbr_len);
		yu = min(w-patch_size+1,y_patch+nbr_len);
		count = 1;

		window_indices = zeros([(xu-xl+1)*(yu-yl+1),1]);
		for x = xl:xu
			for y = yl:yu
				curr_ind = sub2ind([h-patch_size+1,w-patch_size+1],x,y);
				window_indices(count)  = curr_ind;
				count = count + 1;
			end
		end
		curr_neighborhood = P(:,window_indices);
		nearest_indices = knnsearch(curr_neighborhood',curr_patch','K',num_nbr);
		Q = curr_neighborhood(:,nearest_indices);

		[eig_vecs, eig_vals] = eigs(Q*Q',patch_size^2);
		alpha_curr = eig_vecs' * curr_patch;
		alpha_mat = eig_vecs' * Q;
		alpha_sq = alpha_mat.*alpha_mat;
		alpha_bar_sq = max(0, mean(alpha_sq,2) - gaussian_sigma^2);

		alpha_curr = alpha_curr ./ (1 + gaussian_sigma*gaussian_sigma./alpha_bar_sq);

		P_final(:,a) = eig_vecs*alpha_curr;
	end

	count_mat = zeros(size(noisy_pic));
	
	count = 1;
	for j = 1:w-patch_size+1
		for i = 1:h-patch_size+1
			temp = P_final(:,count);
			modified_pic(i:i+patch_size-1,j:j+patch_size-1) = modified_pic(i:i+patch_size-1,j:j+patch_size-1) + reshape(temp,patch_size,patch_size);
			count = count + 1;
			count_mat(i:i+patch_size-1,j:j+patch_size-1) = count_mat(i:i+patch_size-1,j:j+patch_size-1) + 1;
		end
	end
	modified_pic = modified_pic./count_mat;
end