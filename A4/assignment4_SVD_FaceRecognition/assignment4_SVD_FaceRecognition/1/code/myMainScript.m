%% MyMainScript

tic;
%% Your code here>

database_dir = '../../../../att_faces/';

num_persons = 32;
num_train_per_person = 6;
num_test_per_person = 4;
im_h = 112;
im_w = 92;

train_x = zeros(num_persons * num_train_per_person, im_h*im_w);
test_x = zeros(num_persons * num_test_per_person, im_h*im_w);

% size(train_x)
% size(test_x)
% size(test_x(1,  : ))

train_index = 1;
test_index = 1;

for person = 1 : num_persons
	curr_person_dir = strcat(database_dir, 's', int2str(person));
    for sample = 1 : 10        
        file_name = strcat(curr_person_dir,'/', int2str(sample), '.pgm');
        temp_im = imread(file_name);
        resized_temp_im = temp_im(:);

        if (sample <= num_train_per_person)
        	% size(resized_temp_im)
        	% size(train_x(train_index, :))
            train_x(train_index, :) = resized_temp_im';
            train_index = train_index + 1;
        else
        	test_x(test_index, :) = resized_temp_im';
            test_index = test_index + 1;
        end
    end 
end

% size(test_x)
% size(train_x)
test_x = test_x';
train_x = train_x';

mean_vec  = mean(train_x');
mean_vec  = mean_vec';
% size(mean_vec)

train_x = train_x - mean_vec;
test_x = test_x - mean_vec;

% size(train_x)

L = train_x' * train_x;
% size(L)

[eig_vecs_L, eig_vals_L] = eigs(L, num_persons * num_train_per_person);
% size(eig_vecs_L)

eig_vecs_C = train_x * eig_vecs_L;
% size(eig_vecs_C)

diag_norm = diag(sqrt(eig_vecs_C' * eig_vecs_C));
divide_mat_norms = repmat(diag_norm', [im_h*im_w, 1]);

norm_eig_vecs_C = eig_vecs_C ./ divide_mat_norms;
% size(norm_eig_vecs_C)

k_values = [1, 2, 3, 5, 10, 15, 20, 30, 50, 75, 100, 150, 170];
num_k_vals = size(k_values);
recog_rates = zeros(1, num_k_vals(2));

ind = 1;
for k = k_values
	norm_eig_vecs_C_k = norm_eig_vecs_C(:, 1:k);
	% size(norm_eig_vecs_C_k)

	eigen_coeffs_train = norm_eig_vecs_C_k' * train_x;
	% size(eigen_coeffs_train)

	% size(mean_vec)
	eigen_coeffs_test = norm_eig_vecs_C_k' * test_x;
	% size(eigen_coeffs_test)

	recognition_correct = 0;

	for i = 1:num_persons*num_test_per_person
		curr_test_coeffs = eigen_coeffs_test(:, i);
		% size(curr_test_coeffs)

		coeff_diffs = eigen_coeffs_train - curr_test_coeffs;
		squared_diffs = diag(coeff_diffs' * coeff_diffs);	
		% size(squared_diffs)

		[min_diff , pred_person] = min(squared_diffs);
		pred_person = ceil(double(pred_person) / num_train_per_person);
		
		act_person = ceil(double(i) / num_test_per_person);
		
		% disp(act_person);
		% disp(pred_person);

		if (pred_person == act_person)
			recognition_correct = recognition_correct + 1;
		end	
	end
	
	recog_rates(ind) = double(recognition_correct) / (num_persons*num_test_per_person);
	ind = ind + 1;

end

% recog_rates

plot(k_values, recog_rates);

toc;