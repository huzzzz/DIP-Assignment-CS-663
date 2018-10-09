disp('Starting experiment using the att_faces database using eig function');

tic;

database_dir = '../../../../att_faces/';

num_persons = 32;
num_train_per_person = 6;
num_test_per_person = 4;
im_h = 112;
im_w = 92;

num_persons_test = 8;

train_x = zeros(num_persons * num_train_per_person, im_h*im_w);
test_x = zeros(num_persons * num_test_per_person, im_h*im_w);

train_index = 1;
test_index = 1;

for person = 1 : num_persons
	curr_person_dir = strcat(database_dir, 's', int2str(person));
    for sample = 1 : 10        
        file_name = strcat(curr_person_dir,'/', int2str(sample), '.pgm');
        temp_im = imread(file_name);
        resized_temp_im = temp_im(:);

        if (sample <= num_train_per_person)
            train_x(train_index, :) = resized_temp_im';
            train_index = train_index + 1;
        else
        	test_x(test_index, :) = resized_temp_im';
            test_index = test_index + 1;
        end
    end 
end

for person = 1 : num_persons_test
	curr_person_dir = strcat(database_dir, 's', int2str(32+person));
    for sample = 1 : 10        
        file_name = strcat(curr_person_dir,'/', int2str(sample), '.pgm');
        temp_im = imread(file_name);
        resized_temp_im = temp_im(:);
        if (sample > num_train_per_person)
        	test_x(test_index, :) = resized_temp_im';
            test_index = test_index + 1;
        end
    end 
end

test_x = test_x';
train_x = train_x';

mean_vec  = mean(train_x');
mean_vec  = mean_vec';

train_x = train_x - mean_vec;
test_x = test_x - mean_vec;

L = train_x' * train_x;

[eig_vecs_L, eig_vals_L] = eigs(L, num_persons * num_train_per_person);

eig_vecs_C = train_x * eig_vecs_L;

diag_norm = diag(sqrt(eig_vecs_C' * eig_vecs_C));
divide_mat_norms = repmat(diag_norm', [im_h*im_w, 1]);

norm_eig_vecs_C = eig_vecs_C ./ divide_mat_norms;

k_test = 100;

norm_eig_vecs_C_k = norm_eig_vecs_C(:, 1:k_test);

eigen_coeffs_train = norm_eig_vecs_C_k' * train_x;

eigen_coeffs_test = norm_eig_vecs_C_k' * test_x;

false_neg = 0;
false_pos = 0;
threshold = 0.65e7;
%  0.7 : 22, 8; 0.65 : 25, 6

for i = 1:(num_persons + num_persons_test)*num_test_per_person
	curr_test_coeffs = eigen_coeffs_test(:, i);

	coeff_diffs = eigen_coeffs_train - curr_test_coeffs;
	squared_diffs = diag(coeff_diffs' * coeff_diffs);	

	[min_diff , pred_person] = min(squared_diffs);	
	act_person = ceil(double(i) / num_test_per_person);
	% disp(min_diff);
	if (min_diff < threshold)
		if (act_person > 32)
			false_pos = false_pos + 1;
		end		
	else
		if (act_person <= 32)
			false_neg = false_neg + 1;
		end
	end

end

disp('False Negatives : ');
disp(false_neg);

disp('False Positives : ');
disp(false_pos);
% recog_rates

toc;
