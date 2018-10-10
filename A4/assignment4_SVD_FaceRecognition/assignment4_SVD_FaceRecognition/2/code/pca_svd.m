function norm_eig_vecs_C =  pca_svd(train_x, num_persons, num_train_per_person, im_h, im_w)

	[lsv, sm, rsv] = svds(train_x, num_persons * num_train_per_person);

	eig_vecs_C = lsv;

	diag_norm = diag(sqrt(eig_vecs_C' * eig_vecs_C));
	divide_mat_norms = repmat(diag_norm', [im_h*im_w, 1]);

	norm_eig_vecs_C = eig_vecs_C ./ divide_mat_norms;
end