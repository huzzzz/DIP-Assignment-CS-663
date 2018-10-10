function recog_rates = recog_eval(eig_start, k_values, norm_eig_vecs_C, train_x, test_x, num_persons, num_train_per_person, num_test_per_person)

	recog_rates = zeros(1, length(k_values));

	ind = 1;
	for k = k_values
		norm_eig_vecs_C_k = norm_eig_vecs_C(:, eig_start:k);

		eigen_coeffs_train = norm_eig_vecs_C_k' * train_x;

		eigen_coeffs_test = norm_eig_vecs_C_k' * test_x;

		recognition_correct = 0;

		for i = 1:num_persons*num_test_per_person
			curr_test_coeffs = eigen_coeffs_test(:, i);

			coeff_diffs = eigen_coeffs_train - curr_test_coeffs;
			squared_diffs = diag(coeff_diffs' * coeff_diffs);	

			[min_diff , pred_person] = min(squared_diffs);
			pred_person = ceil(double(pred_person) / num_train_per_person);
			
			act_person = ceil(double(i) / num_test_per_person);

			if (pred_person == act_person)
				recognition_correct = recognition_correct + 1;
			end	
		end
		
		recog_rates(ind) = double(recognition_correct) / (num_persons*num_test_per_person);
		ind = ind + 1;

	end

end

% k_values = [1, 2, 3, 5, 10, 15, 20, 30, 50, 75, 100, 150, 170];
% num_k_vals = size(k_values);
% recog_rates = zeros(1, num_k_vals(2));

% ind = 1;
% for k = k_values
% 	norm_eig_vecs_C_k = norm_eig_vecs_C(:, 1:k);

% 	eigen_coeffs_train = norm_eig_vecs_C_k' * train_x;

% 	eigen_coeffs_test = norm_eig_vecs_C_k' * test_x;

% 	recognition_correct = 0;

% 	for i = 1:num_persons*num_test_per_person
% 		curr_test_coeffs = eigen_coeffs_test(:, i);

% 		coeff_diffs = eigen_coeffs_train - curr_test_coeffs;
% 		squared_diffs = diag(coeff_diffs' * coeff_diffs);	

% 		[min_diff , pred_person] = min(squared_diffs);
% 		pred_person = ceil(double(pred_person) / num_train_per_person);
		
% 		act_person = ceil(double(i) / num_test_per_person);

% 		if (pred_person == act_person)
% 			recognition_correct = recognition_correct + 1;
% 		end	
% 	end
	
% 	recog_rates(ind) = double(recognition_correct) / (num_persons*num_test_per_person);
% 	ind = ind + 1;

% end

% k_values = k_values(4:num_k_vals(2));
% recog_rates = zeros(1, num_k_vals(2) - 3);

% ind = 1;
% for k = k_values
% 	norm_eig_vecs_C_k = norm_eig_vecs_C(:, 4:k);

% 	eigen_coeffs_train = norm_eig_vecs_C_k' * train_x;

% 	eigen_coeffs_test = norm_eig_vecs_C_k' * test_x;

% 	recognition_correct = 0;

% 	for i = 1:num_persons*num_test_per_person
% 		curr_test_coeffs = eigen_coeffs_test(:, i);

% 		coeff_diffs = eigen_coeffs_train - curr_test_coeffs;
% 		squared_diffs = diag(coeff_diffs' * coeff_diffs);	

% 		[min_diff , pred_person] = min(squared_diffs);
% 		pred_person = ceil(double(pred_person) / num_train_per_person);
		
% 		act_person = ceil(double(i) / num_test_per_person);

% 		if (pred_person == act_person)
% 			recognition_correct = recognition_correct + 1;
% 		end	
% 	end
	
% 	recog_rates(ind) = double(recognition_correct) / (num_persons*num_test_per_person);
% 	ind = ind + 1;

% end
