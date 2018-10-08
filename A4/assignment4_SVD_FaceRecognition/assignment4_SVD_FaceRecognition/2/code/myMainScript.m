
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

[lsv, sm, rsv] = svds(train_x, num_persons * num_train_per_person);

eig_vecs_C = lsv;

diag_norm = diag(sqrt(eig_vecs_C' * eig_vecs_C));
divide_mat_norms = repmat(diag_norm', [im_h*im_w, 1]);

norm_eig_vecs_C = eig_vecs_C ./ divide_mat_norms;

k_values = [1, 2, 3, 5, 10, 15, 20, 30, 50, 75, 100, 150, 170, num_persons * num_train_per_person];
num_k_vals = size(k_values);
recog_rates = zeros(1, num_k_vals(2));

%  Plot of the best 25 eigen faces
norm_eig_vecs_C_25 = norm_eig_vecs_C(:, 1:25);
size(norm_eig_vecs_C_25);

fig = figure;
colormap(gray);

for i = 1:25
	curr_im = norm_eig_vecs_C_25(:, i);
	curr_im = reshape(curr_im, im_h, im_w);
	curr_im = myLinearContrastStretching(curr_im);
	subplot(5,5,i), imagesc(curr_im), title(strcat('num ', int2str(i))), colorbar, daspect([1 1 1]), axis tight;
end

saveas(fig, "25 Eigen Faces.jpg");
close(fig);

curr_test_image = test_x(:, 1);

fig = figure;
colormap(gray);

curr_test_image_op = curr_test_image + mean_vec;
curr_test_image_op = reshape(curr_test_image_op, im_h, im_w);

subplot(3,5,1), imagesc(curr_test_image_op),  title('Orig Im'), colorbar, daspect([1 1 1]), axis tight;

ind = 2;
for k = k_values
	norm_eig_vecs_C_k = norm_eig_vecs_C(:, 1:k);

	eigen_coeffs_test = norm_eig_vecs_C_k' * curr_test_image;

	curr_im = norm_eig_vecs_C_k * eigen_coeffs_test + mean_vec;
	curr_im = reshape(curr_im, im_h, im_w);
	curr_im = myLinearContrastStretching(curr_im);

	subplot(3,5,ind), imagesc(curr_im), title(strcat('k = ', int2str(k))), colorbar, daspect([1 1 1]), axis tight;
	ind = ind + 1;	
end

saveas(fig, "Reconstructed Faces using k Value.jpg");
close(fig);

toc;