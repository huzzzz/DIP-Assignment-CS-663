function [train_x, test_x] = prepare_data(database_dir, num_persons, num_train_per_person, num_test_per_person, im_h, im_w)

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

end