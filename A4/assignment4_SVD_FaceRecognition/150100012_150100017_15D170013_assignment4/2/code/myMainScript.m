%% My Main Script

%% 25 Eigen faces
% Prepare data for the algorithm
% Defining database directory, number of persons, number of training and test images per person, and the dimensions of the image
database_dir = '../../../../CroppedYale/';
num_persons = 38;
num_train_per_person = 40;
num_test_per_person = 20;
im_h = 192;
im_w = 168;

tic;
% Extracting the train and test matrices using the above information
[train_x, test_x] = prepare_data(database_dir, num_persons, num_train_per_person, num_test_per_person, im_h, im_w);
toc;

% Calculating the mean vector of the image vectors
mean_vec  = mean(train_x');
mean_vec  = mean_vec';

% Subtracting the mean vector from each of the image vectors in both the train and test dataset
train_x = train_x - mean_vec;
test_x = test_x - mean_vec;

tic;
% Calculating and extracting normalised eigen vectors using svds()
norm_eig_vecs_C =  pca_svd(train_x, num_persons, num_train_per_person, im_h, im_w);
toc;

% The different values of 'k' for which our algorithm is to be run
k_values = [2, 10, 20, 50, 75, 100, 125, 150, 175, num_persons * num_train_per_person];

% Initiailising the recognition rates list for the different k values
recog_rates = zeros(1, length(k_values));

% Plotting the top 25 eigen faces
norm_eig_vecs_C_25 = norm_eig_vecs_C(:, 1:25);

% Initialising the figure and setting the colormap
fig = figure;
colormap(gray);

% Plotting each eigen face one by one as a subplot
for i = 1:25
	% Extracting the ith eigenvector, then reshaping it into the dimensions of a face image, then contrast stretching it for consistency
	curr_im = norm_eig_vecs_C_25(:, i);
	curr_im = reshape(curr_im, im_h, im_w);
	curr_im = myLinearContrastStretching(curr_im);

	% Displaying the ith eigen face as a subplot
	subplot(5,5,i), imagesc(curr_im), title(strcat('Face ', int2str(i))), colorbar, daspect([1 1 1]), axis tight;
end

% Saving the figure in the given relative address and then closing it
saveas(fig, '../plots/25 Eigen Faces.jpg');
close(fig);

%% Face Reconstruction
% Taking one of the test images for reconstruction, here it is the first one
curr_test_image = test_x(:, 1);

% Initialising the figure and setting the colormap
fig = figure;
colormap(gray);

% Plotting the original test image first, and then the reconstructions using different values of k
curr_test_image_op = curr_test_image + mean_vec;
curr_test_image_op = reshape(curr_test_image_op, im_h, im_w);
subplot(3,4,1), imagesc(curr_test_image_op),  title('Orig Im'), colorbar, daspect([1 1 1]), axis tight;

% Initialising the index
ind = 2;

% Reconstructing for each value of k
for k = k_values
	
	% Taking the first k eigen vectors. We simply extract from the normalised sorted eigen vector matrix passed as argument.	
	norm_eig_vecs_C_k = norm_eig_vecs_C(:, 1:k);
	% Calculating the eigen vector coefficients using the extracted eigen vectors only, for both the train and test datsets
	eigen_coeffs_test = norm_eig_vecs_C_k' * curr_test_image;

	% curr_im holds the reconstructed face for the current value of k

	% Reconstructing the face by first summing the eigen vectors weighted by their coefficients and then adding the mean vector
	curr_im = norm_eig_vecs_C_k * eigen_coeffs_test + mean_vec;
	% Then reshape the image into the 2D matrix of appropriate original size and then linearly contrast stretch it for consistency
	curr_im = reshape(curr_im, im_h, im_w);
	curr_im = myLinearContrastStretching(curr_im);

	% Displaying the reconstructed face as a subplot
	subplot(3,4,ind), imagesc(curr_im), title(strcat('k = ', int2str(k))), colorbar, daspect([1 1 1]), axis tight;
	% Incrementing ind
	ind = ind + 1;	
end

% Saving the figure in the given relative address and then closing it
saveas(fig, '../plots/Reconstructed Faces using k Value.jpg');
close(fig);
