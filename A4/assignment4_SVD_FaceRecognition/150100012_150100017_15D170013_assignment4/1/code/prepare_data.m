function [train_x, test_x] = prepare_data(database_dir, num_persons, num_train_per_person, num_test_per_person, im_h, im_w)
	
	% Initialising the train and test data matrices 
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
		curr_person_dir = folders(person+2+non_dir).name;

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

	% Taking the transpose to have the image vectors as columns instead of rows
	test_x = test_x';
	train_x = train_x';

end