function [train_x, test_x] = prepare_data_yale(database_dir, num_persons, num_train_per_person, num_test_per_person, im_h, im_w)

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

end