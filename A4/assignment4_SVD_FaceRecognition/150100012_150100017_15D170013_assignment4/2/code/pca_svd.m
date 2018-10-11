function norm_eig_vecs_C =  pca_svd(train_x, num_persons, num_train_per_person, im_h, im_w)

	% Calculating the singular value decomposition of a matrix using the svds() function which gives the singular values in the sorted order 
	% and the left singular vectors in the corresponding order
	[lsv, sm, rsv] = svds(train_x, num_persons * num_train_per_person);

	% Eigen vectors of Covariance matrix is same as the left singular vectors of the 'X' matrix which is 'train_x' here
	eig_vecs_C = lsv;

	% We calculate the norm of each eigen vector and later divide each eigen vector by its norm to normalise the eigen vectors
	diag_norm = diag(sqrt(eig_vecs_C' * eig_vecs_C));
	divide_mat_norms = repmat(diag_norm', [im_h*im_w, 1]);
	norm_eig_vecs_C = eig_vecs_C ./ divide_mat_norms;
end