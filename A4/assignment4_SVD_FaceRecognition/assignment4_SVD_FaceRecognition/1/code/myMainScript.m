%% MyMainScript


disp('Starting experiment using the att_faces');

%Prepare data for the algorithm
database_dir = '../../../../att_faces/';
num_persons = 32;
num_train_per_person = 6;
num_test_per_person = 4;
im_h = 112;
im_w = 92;

[train_x, test_x] = prepare_data(database_dir, num_persons, num_train_per_person, num_test_per_person, im_h, im_w);

mean_vec  = mean(train_x');
mean_vec  = mean_vec';

train_x = train_x - mean_vec;
test_x = test_x - mean_vec;

k_values = [1, 2, 3, 5, 10, 15, 20, 30, 50, 75, 100, 150, 170];

% Implement PCA using eig and recognise
tic;
norm_eig_vecs_C =  pca_eig(train_x, num_persons, num_train_per_person, im_h, im_w);
recog_rates_eig = recog_eval(1, k_values, norm_eig_vecs_C, train_x, test_x, num_persons, num_train_per_person, num_test_per_person);
toc;

%Implement PCA using SVD and recognise 
tic;
norm_eig_vecs_C =  pca_svd(train_x, num_persons, num_train_per_person, im_h, im_w);
recog_rates_svd = recog_eval(1, k_values, norm_eig_vecs_C, train_x, test_x, num_persons, num_train_per_person, num_test_per_person);
toc;

%Plot Recognisation rates obtained
fig = figure;
plot(k_values, recog_rates_eig);
saveas(fig, '../plots/Eig Based Recognition Rates vs k values.jpg');
close(fig);

fig = figure;
plot(k_values, recog_rates_svd);
saveas(fig, '../plots/SVD Based Recognition Rates vs k values.jpg');
close(fig);

%% Yale Dataset
disp('Testing the svd implementation on the Yale Dataset');

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

tic;
recog_rates_a = recog_eval(1, k_values, norm_eig_vecs_C, train_x, test_x, num_persons, num_train_per_person, num_test_per_person);
toc;

tic;
recog_rates_b = recog_eval(4, k_values(4:length(k_values)), norm_eig_vecs_C, train_x, test_x, num_persons, num_train_per_person, num_test_per_person);
toc;

fig = figure;
plot(k_values, recog_rates_a);
saveas(fig, '../plots/Part a. Yale DataSet : SVD Based Recognition Rates vs k values.jpg');
close(fig);

fig = figure;
plot(k_values, recog_rates);
saveas(fig, '../plots/Part b. : Yale DataSet : SVD Based Recognition Rates vs k values.jpg');
close(fig);
