%% MyMainScript

tic;

% Prepare data for the algorithm
% Defining database directory, number of persons, number of training and test images per person, and the dimensions of the image
database_dir = '../../../../att_faces/';
num_persons = 32;
num_train_per_person = 6;
num_test_per_person = 4;
im_h = 112;
im_w = 92;

% Number of persons which are not part of our training database and hence should not be detected ideally
num_persons_test = 8;


% Initialising the training and test set, the test set will contain both people in training database and people not in training database
train_x = zeros(num_persons * num_train_per_person, im_h*im_w);
test_x = zeros(num_persons * num_test_per_person, im_h*im_w);

train_index = 1;
test_index = 1;

% Listing the folders of the persons in the relevant directory
folders = dir(database_dir);

non_dir = 0;
for i=1:length(folders)
	if folders(i).isdir == 0
		non_dir = non_dir + 1;
	end
end

% Iterating through the folders of each person
for person = 1 : num_persons
    
    % Extracting the current person directory from the "folders" which is a list of folders and files in that directory
    % An offset of 2 is required to skip the '.' and '..' directories which are always listed as the first two directories of the dir command
    % An offset of non_dir is required to skip the non directories which are there in the database folder
    curr_person_dir = folders(person+2+non_dir).name;

    % Listing the files in the current person directory
    files = dir(strcat(database_dir, '/',curr_person_dir));

    % Iterating through all the files(images) in the current person's directory
    for sample = 1 : num_train_per_person + num_test_per_person      
        % Extracting the current file name which is to be added to the relevant test/train matrix. The offset of 2 has the same explanation as before;
        file_name = files(sample+2).name;
        % Extracting the image with the current filename
        temp_im = imread(strcat(database_dir, '/',curr_person_dir,'/', file_name));
        % Resizing the image matrix to a vector
        resized_temp_im = temp_im(:);

        % If the index of the current sample lies within num_train_per_person(which is the number of training samples per person) 
        % then add it to the train matrix
        if (sample <= num_train_per_person)
            train_x(train_index, :) = resized_temp_im';
            train_index = train_index + 1;
        % else add it to the test matrix
        else
            test_x(test_index, :) = resized_temp_im';
            test_index = test_index + 1;
        end
    end 
end

% Iterating through the persons not included in the train database
for person = 1 : num_persons_test
     % Extracting the current person directory from the "folders" which is a list of folders and files in that directory
    % An offset of 2 is required to skip the '.' and '..' directories which are always listed as the first two directories of the dir command
    % An offset of 32 is required to skip the first 32 persons which are there in the database  
    % An offset of non_dir is required to skip the non directories which are there in the database folder
    curr_person_dir = folders(person+2+32+non_dir).name;

    % Listing the files in the current person directory
    files = dir(strcat(database_dir, '/',curr_person_dir));

    % Iterating through all the files(images) in the current person's directory
    for sample = 1 : num_train_per_person + num_test_per_person      
        % Extracting the current file name which is to be added to the relevant test/train matrix. The offset of 2 has the same explanation as before
        file_name = files(sample+2).name;
        % Extracting the image with the current filename
        temp_im = imread(strcat(database_dir, '/',curr_person_dir,'/', file_name));
        % Resizing the image matrix to a vector
        resized_temp_im = temp_im(:);

        % If the index of the current sample does NOT lie within num_train_per_person(which is the number of training samples per person) 
        % then add it to the test matrix
        if (sample > num_train_per_person)
        	test_x(test_index, :) = resized_temp_im';
            test_index = test_index + 1;
        end
    end 
end

% Taking the transpose to have the image vectors as columns instead of rows
test_x = test_x';
train_x = train_x';

% Calculating the mean vector of the image vectors
mean_vec  = mean(train_x');
mean_vec  = mean_vec';

% Subtracting the mean vector from each of the image vectors in both the train and test dataset
train_x = train_x - mean_vec;
test_x = test_x - mean_vec;

% Calculating and extracting normalised eigen vectors using eigs()
tic;
norm_eig_vecs_C =  pca_eig(train_x, num_persons, num_train_per_person, im_h, im_w);
toc;

% Using the top 100 eigenvectors for the reconstruction of the images
k_test = 100;

% Taking the eigen vectors from the starting index upto index k. We simply extract from the normalised sorted eigen vector matrix passed as argument.
norm_eig_vecs_C_k = norm_eig_vecs_C(:, 1:k_test);

% Calculating the eigen vector coefficients using the extracted eigen vectors only for both the train and test datsets
eigen_coeffs_train = norm_eig_vecs_C_k' * train_x;
eigen_coeffs_test = norm_eig_vecs_C_k' * test_x;

% Initialising the no. of false negatives, false positives and the threshold for determining whether to consider the person as belonging to the train database
false_neg = 0;
false_pos = 0;
threshold = 0.65e7;
%  0.7 : 22, 8; 0.65 : 25, 6

% Iterating through all the test case images
for i = 1:(num_persons + num_persons_test)*num_test_per_person
    % Extracting the current test image's eigen vector coefficients from the matrix calculated before
	curr_test_coeffs = eigen_coeffs_test(:, i);

    % Calculating the squared difference between each eigen coefficient vector of the training dataset and the current test image's coefficients
	coeff_diffs = eigen_coeffs_train - curr_test_coeffs;
    % We extract the diagonal elements as those contain the required squared differences of the current test image with each data point
	squared_diffs = diag(coeff_diffs' * coeff_diffs);	

    % Extracting the train example with which we get the minimum squared difference, that is our predicted person, 
    % which we don't care about as here we only care about whether the person belongs to the database or not
	[min_diff , pred_person] = min(squared_diffs);	

    % Actual person can be calculated using the index of the current test image and the number of test images per person
	act_person = ceil(double(i) / num_test_per_person);

    % If the minimum difference is lesser than the threshold, then it means that our person is predicted to belong to the database
	if (min_diff < threshold)
        % If the person is predicted to belong to the database and the actual person is not a part of the database, then it is a false positive
		if (act_person > num_persons)
			false_pos = false_pos + 1;
		end		
	else
        % If the person is predicted to NOT belong to the database and the actual person is indeed a part of the database, then it is a false negative
		if (act_person <= num_persons)
			false_neg = false_neg + 1;
		end
	end

end

% Displaying the no. of false negatives, no. of false positives and their rates as well
disp('False Negatives : ');
disp(false_neg);

disp('False Positives : ');
disp(false_pos);

disp('False Negatives Rate : ');
disp(false_neg / (num_test_per_person*(num_persons+num_persons_test)));

disp('False Positives Rate : ');
disp(false_pos / (num_test_per_person*(num_persons+num_persons_test)));
toc;
