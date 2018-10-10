function norm_eig_vecs_C =  pca_eig(train_x, num_persons, num_train_per_person, im_h, im_w)

	L = train_x' * train_x;

	[eig_vecs_L, eig_vals_L] = eigs(L, num_persons * num_train_per_person);

	eig_vecs_C = train_x * eig_vecs_L;

	diag_norm = diag(sqrt(eig_vecs_C' * eig_vecs_C));
	divide_mat_norms = repmat(diag_norm', [im_h*im_w, 1]);

	norm_eig_vecs_C = eig_vecs_C ./ divide_mat_norms;
end