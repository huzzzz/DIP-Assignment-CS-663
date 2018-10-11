%% MyMainScript

%% Face recognition for ORL Dataset

disp('Starting experiment using the att_faces');

% Prepare data for the algorithm
% Defining database directory, number of persons, number of training and test images per person, and the dimensions of the image
database_dir = '../../../../att_faces/';
num_persons = 32;
num_train_per_person = 6;
num_test_per_person = 4;
im_h = 112;
im_w = 92;

% Extracting the train and test matrices using the above information
[train_x, test_x] = prepare_data(database_dir, num_persons, num_train_per_person, num_test_per_person, im_h, im_w);

% Calculating the mean vector of the image vectors
mean_vec  = mean(train_x');
mean_vec  = mean_vec';

% Subtracting the mean vector from each of the image vectors in both the train and test dataset
train_x = train_x - mean_vec;
test_x = test_x - mean_vec;

% The different values of 'k' for which our algorithm is to be run
k_values = [1, 2, 3, 5, 10, 15, 20, 30, 50, 75, 100, 150, 170];

% Implement PCA by first calculating and extracting normalised eigen vectors using eigs() and then calculating the recognition rates
disp('PCA using eigs function');
tic;
norm_eig_vecs_C =  pca_eig(train_x, num_persons, num_train_per_person, im_h, im_w);
recog_rates_eig = recog_eval(1, k_values, norm_eig_vecs_C, train_x, test_x, num_persons, num_train_per_person, num_test_per_person);
toc;

% Implement PCA by first calculating and extracting normalised eigen vectors using svds() and then calculating the recognition rates
tic;
disp('PCA using svd function');
norm_eig_vecs_C =  pca_svd(train_x, num_persons, num_train_per_person, im_h, im_w);
recog_rates_svd = recog_eval(1, k_values, norm_eig_vecs_C, train_x, test_x, num_persons, num_train_per_person, num_test_per_person);
toc;

% Plot the recognition rates obtained from the above methods
fig = figure;
plot(k_values, recog_rates_eig);
saveas(fig, '../plots/Eig Based Recognition Rates vs k values.jpg');
close(fig);

fig = figure;
plot(k_values, recog_rates_svd);
saveas(fig, '../plots/SVD Based Recognition Rates vs k values.jpg');
close(fig);

%% Face recognition on Yale Dataset

% Prepare the necessary data for the algorithm just like the ORL case
database_dir = '../../../../CroppedYale/';
num_persons = 38;
num_train_per_person = 40;
num_test_per_person = 20;
im_h = 192;
im_w = 168;

% The different values of 'k' for which our algorithm is to be run
k_values = [1, 2, 3, 5, 10, 15, 20, 30, 50, 60, 65, 75, 100, 200, 300, 500, 1000];

% Extracting the train and test matrices using the above information
tic;
disp('Preparing data from Yale dataset');
[train_x, test_x] = prepare_data(database_dir, num_persons, num_train_per_person, num_test_per_person, im_h, im_w);
toc;

% Calculating the mean vector of the image vectors
mean_vec  = mean(train_x');
mean_vec  = mean_vec';

% Subtracting the mean vector from each of the image vectors in both the train and test dataset
train_x = train_x - mean_vec;
test_x = test_x - mean_vec;

% Implement PCA by first calculating and extracting normalised eigen vectors using svds() and then calculating the recognition rates
tic;
disp('PCA using svd on Yale dataset');
norm_eig_vecs_C =  pca_svd(train_x, num_persons, num_train_per_person, im_h, im_w);
toc;

% Calculating the recognition rates using all eigen values, starting eigen value index is 1 as we need to take all eigen values
tic;
disp('Obtain recognition rates including the top 3 eigenvalues');
recog_rates_a = recog_eval(1, k_values, norm_eig_vecs_C, train_x, test_x, num_persons, num_train_per_person, num_test_per_person);
toc;

% Calculating the recognition rates using all but the top 3 eigen values, this thing is implemented using the first parameter which is the starting eigen value index, in this case it is 4
tic;
disp('Obtain recognition rates excluding the top 3 eigenvalues');
recog_rates_b = recog_eval(4, k_values(4:length(k_values)), norm_eig_vecs_C, train_x, test_x, num_persons, num_train_per_person, num_test_per_person);
toc;

% Plot the recognition rates obtained from the above methods
fig = figure;
plot(k_values, recog_rates_a);
saveas(fig, '../plots/Part a) Yale DataSet SVD Based Recognition Rates vs k values.jpg');
close(fig);

fig = figure;
plot(k_values(4:length(k_values)), recog_rates_b);
saveas(fig, '../plots/Part b) Yale DataSet SVD Based Recognition Rates vs k values.jpg');
close(fig);
