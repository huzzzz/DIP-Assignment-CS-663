function recog_rates = recog_eval(eig_start, k_values, norm_eig_vecs_C, train_x, test_x, num_persons, num_train_per_person, num_test_per_person)
	
	% Initiailising the recognition rates list for the different k values
	recog_rates = zeros(1, length(k_values));

	ind = 1;
	% Iterating through all the different k values
	for k = k_values
		% Taking the eigen vectors from the eigen start index upto index k. We simply extract from the normalised sorted eigen vector matrix passed as argument.
		norm_eig_vecs_C_k = norm_eig_vecs_C(:, eig_start:k);

		% Calculating the eigen vector coefficients using the extracted eigen vectors only, for both the train and test datsets
		eigen_coeffs_train = norm_eig_vecs_C_k' * train_x;
		eigen_coeffs_test = norm_eig_vecs_C_k' * test_x;

		% Initialising the no. of correctly recognised images
		recognition_correct = 0;

		% Iterating through all the test case images
		for i = 1:num_persons*num_test_per_person
			% Extracting the current test image's eigen vector coefficients from the matrix calculated before
			curr_test_coeffs = eigen_coeffs_test(:, i);

			% Calculating the squared difference between each eigen coefficient vector of the training dataset and the current test image's coefficients
			coeff_diffs = eigen_coeffs_train - curr_test_coeffs;
			% We extract the diagonal elements as those contain the required squared differences of the current test image with each data point
			squared_diffs = diag(coeff_diffs' * coeff_diffs);

			% Extracting the train example with which we get the minimum squared difference, that is our predicted person
			[min_diff , pred_person] = min(squared_diffs);
			pred_person = ceil(double(pred_person) / num_train_per_person);
			
			% Actual person can be calculated using the index of the current test image and the number of test images per person
			act_person = ceil(double(i) / num_test_per_person);

			% If the predicted person is the actual person, we increase the count of the correctly recognised images by 1
			if (pred_person == act_person)
				recognition_correct = recognition_correct + 1;
			end	
		end
		
		% Calculating the recognition rate using the simple formula, (recognition rate = no of correct cases / total cases)
		recog_rates(ind) = double(recognition_correct) / (num_persons*num_test_per_person);
		% Incrementing the index for the recognition rates list so that the rate for the next k value is stored in the next index
		ind = ind + 1;
	end
end