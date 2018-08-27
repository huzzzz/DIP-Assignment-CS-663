function [modified_pic] = myPatchBasedFiltering(original_pic_old,h_sigma)
	% Patch Based Filtering %
	f = waitbar(0, 'Starting Patch Based Filtering');
	
	window_size = 25;
	patch_size = 9;
	patch_gaussian_sigma = 2;

	modified_pic = zeros(size(original_pic_old));
	[h_old, w_old, num_chan] = size(original_pic_old);
	original_pic = zeros(h_old+window_size+patch_size-2,w_old+window_size+patch_size-2);
	[h, w, num_chan] = size(original_pic);
	padding_size = int16((window_size+patch_size)/2); 
	original_pic(padding_size:h-padding_size+1,padding_size:w-padding_size+1) = original_pic_old;	
	patch_gaussian_filter = fspecial('gaussian',patch_size,patch_gaussian_sigma);
	% imshow(patch_gaussian_filter);

	progress = 0.02;	
	for i=1:h_old
		for j=1:w_old
			curr_intensity = original_pic_old(i,j);
			patch_pad = (patch_size-1)/2;
			displace_less = padding_size-patch_pad;
			displace_more = padding_size+patch_pad;
			curr_patch = original_pic(i+displace_less:i+displace_more,j+displace_less:j+displace_more);
			filter_weights = zeros(window_size);
			h_wind = 1;
			w_wind = 1;
			for k=i+patch_pad:i+patch_pad+window_size-1
				for l=j+patch_pad:j+patch_pad+window_size-1
					temp_patch = original_pic(k-patch_pad:k+patch_pad,l-patch_pad:l+patch_pad);
					filter_weights(h_wind,w_wind) = patch_weights(temp_patch,curr_patch,patch_gaussian_filter,h_sigma);
					w_wind = w_wind + 1;
				end
				w_wind = 1;
				h_wind = h_wind + 1;
			end
			sub_area = original_pic(i+patch_pad:i+patch_pad+window_size-1,j+patch_pad:j+patch_pad+window_size-1);
			norm_const = sum(sum(filter_weights));
			modified_pic(i,j) = sum(sum(filter_weights.*sub_area))/norm_const;


			progress = progress + (0.97/double(h_old*w_old));
			waitbar(progress,f,'Computing...');
		end
	end
	waitbar(1,f,'Done');
	close(f);
end

function [patch_weight] = patch_weights(patch1, patch2, patch_gaussian_filter, h_sigma)
	patch1 = patch1.*patch_gaussian_filter;
	patch2 = patch2.*patch_gaussian_filter;
	patch_weight = exp(-sum(sum((patch1-patch2).^2))/(h_sigma^2));
end