%%My Main Script

%Prepare data for the algorithm
database_dir = '../../../../CroppedYale/';
num_persons = 38;
num_train_per_person = 40;
num_test_per_person = 20;
im_h = 192;
im_w = 168;

tic;
[train_x, test_x] = prepare_data_yale(database_dir, num_persons, num_train_per_person, num_test_per_person, im_h, im_w);
toc;

mean_vec  = mean(train_x');
mean_vec  = mean_vec';

train_x = train_x - mean_vec;
test_x = test_x - mean_vec;

tic;
norm_eig_vecs_C =  pca_svd(train_x, num_persons, num_train_per_person, im_h, im_w);
toc;

k_values = [1, 2, 3, 5, 10, 15, 20, 30, 50, 75, 100, 150, 170, num_persons * num_train_per_person];
recog_rates = zeros(1, length(k_values));

%  Plot of the best 25 eigen faces
norm_eig_vecs_C_25 = norm_eig_vecs_C(:, 1:25);

fig = figure;
colormap(gray);

for i = 1:25
	curr_im = norm_eig_vecs_C_25(:, i);
	curr_im = reshape(curr_im, im_h, im_w);
	curr_im = myLinearContrastStretching(curr_im);
	subplot(5,5,i), imagesc(curr_im), title(strcat('Face ', int2str(i))), colorbar, daspect([1 1 1]), axis tight;
end

saveas(fig, '../plots/25 Eigen Faces.jpg');
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

saveas(fig, '../plots/Reconstructed Faces using k Value.jpg');
close(fig);
