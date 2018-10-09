%% MyMainScript

disp('Starting experiment using the att_faces database using eig function');

tic;

database_dir = '../../../../att_faces/';

num_persons = 32;
num_train_per_person = 6;
num_test_per_person = 4;
im_h = 112;
im_w = 92;

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

k_values = [1, 2, 3, 5, 10, 15, 20, 30, 50, 75, 100, 150, 170];
num_k_vals = size(k_values);
recog_rates = zeros(1, num_k_vals(2));

ind = 1;
for k = k_values
	norm_eig_vecs_C_k = norm_eig_vecs_C(:, 1:k);

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

% recog_rates

fig = figure;
plot(k_values, recog_rates);
saveas(fig, "Eig Based Recognition Rates vs k values.jpg");
close(fig);

toc;

disp("Testing the svd implementation on the att_faces");

tic;

database_dir = '../../../../att_faces/';

num_persons = 32;
num_train_per_person = 6;
num_test_per_person = 4;
im_h = 112;
im_w = 92;

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

test_x = test_x';
train_x = train_x';

mean_vec  = mean(train_x');
mean_vec  = mean_vec';

train_x = train_x - mean_vec;
test_x = test_x - mean_vec;

[lsv, sm, rsv] = svds(train_x, num_persons * num_train_per_person);

eig_vecs_C = lsv;

diag_norm = diag(sqrt(eig_vecs_C' * eig_vecs_C));
divide_mat_norms = repmat(diag_norm', [im_h*im_w, 1]);

norm_eig_vecs_C = eig_vecs_C ./ divide_mat_norms;

k_values = [1, 2, 3, 5, 10, 15, 20, 30, 50, 75, 100, 150, 170];
num_k_vals = size(k_values);
recog_rates = zeros(1, num_k_vals(2));

ind = 1;
for k = k_values
	norm_eig_vecs_C_k = norm_eig_vecs_C(:, 1:k);

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

% recog_rates

fig = figure;
plot(k_values, recog_rates);
saveas(fig, "SVD Based Recognition Rates vs k values.jpg");
close(fig);

toc;

disp("Testing the svd implementation on the Yale Dataset");

tic;

database_dir = '../../../../CroppedYale/';

num_persons = 38;
num_train_per_person = 40;
num_test_per_person = 20;
im_h = 192;
im_w = 168;

train_x = zeros(num_persons * num_train_per_person, im_h*im_w);
test_x = zeros(num_persons * num_test_per_person, im_h*im_w);

train_index = 1;
test_index = 1;

folders = dir(database_dir);

for person = 1 : num_persons
	curr_person_dir = folders(person+2).name;
	% disp(curr_person_dir);
    files = dir(strcat(database_dir, '/',curr_person_dir));

    for sample = 1 : num_train_per_person + num_test_per_person        
        file_name = files(sample+2).name;
        temp_im = imread(strcat(database_dir, '/',curr_person_dir,'/', file_name));
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

test_x = test_x';
train_x = train_x';

mean_vec  = mean(train_x');
mean_vec  = mean_vec';

train_x = train_x - mean_vec;
test_x = test_x - mean_vec;

[lsv, sm, rsv] = svds(train_x, num_persons * num_train_per_person);

eig_vecs_C = lsv;

diag_norm = diag(sqrt(eig_vecs_C' * eig_vecs_C));
divide_mat_norms = repmat(diag_norm', [im_h*im_w, 1]);

norm_eig_vecs_C = eig_vecs_C ./ divide_mat_norms;

k_values = [1, 2, 3, 5, 10, 15, 20, 30, 50, 75, 100, 150, 170];
num_k_vals = size(k_values);
recog_rates = zeros(1, num_k_vals(2));

ind = 1;
for k = k_values
	norm_eig_vecs_C_k = norm_eig_vecs_C(:, 1:k);

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


fig = figure;
plot(k_values, recog_rates);
saveas(fig, "Part a. Yale DataSet : SVD Based Recognition Rates vs k values.jpg");
close(fig);

disp("Recog_rates for all the eigen vectors starting from 4");

k_values = k_values(4:num_k_vals(2));
recog_rates = zeros(1, num_k_vals(2) - 3);

ind = 1;
for k = k_values
	norm_eig_vecs_C_k = norm_eig_vecs_C(:, 4:k);

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

fig = figure;
plot(k_values, recog_rates);
saveas(fig, "Part b. : Yale DataSet : SVD Based Recognition Rates vs k values.jpg");
close(fig);

toc;
