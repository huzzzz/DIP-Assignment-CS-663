function norm_eig_vecs_C =  pca_eig(train_x, num_persons, num_train_per_person, im_h, im_w)

	% Calculating the 'L' matrix as defined in class for quicker computation
	L = train_x' * train_x;
	
	% Calculating the diagonal matrix containing the eigen values and the matrix of eigen vectors using eigs(matrix, X) function, 
	% which returns the top X eigen values in sorted order and the corresponding matrix of eigen vectors in corresponding order as well, just what is required.
	% Here we calculate the entire eigen vector matrix, and extract all the possible eigen vectors. We will later extract 'k' columns from it as required
	[eig_vecs_L, eig_vals_L] = eigs(L, num_persons * num_train_per_person);

	% Now we calculate the eigen vector matrix for Covariance matrix using the eigen vector matrix of the 'L' matrix
	eig_vecs_C = train_x * eig_vecs_L;

	% We calculate the norm of each eigen vector and later divide each eigen vector by its norm to normalise the eigen vectors
	diag_norm = diag(sqrt(eig_vecs_C' * eig_vecs_C));
	divide_mat_norms = repmat(diag_norm', [im_h*im_w, 1]);
	norm_eig_vecs_C = eig_vecs_C ./ divide_mat_norms;
end