function [modified_pic] = myMeanShiftSegmentation(original_pic,h_color,h_spatial,num_iter)
	% Mean Shift Segmentation %

	lr = 1;
	[h,w,num_chan] = size(original_pic);	
	[X,Y] = meshgrid(1:h,1:w);

	hyper_dim_pic = original_pic;
	hyper_dim_pic(:,:,num_chan+1) = X;
	hyper_dim_pic(:,:,num_chan+2) = Y;

	hyper_dim_pic = reshape(hyper_dim_pic, h*w, num_chan+2);

	for i=1:num_iter
		tic;
		i
		% No. of neighbours %
		k = 1000;

		nn_pixels_ind = knnsearch(hyper_dim_pic,hyper_dim_pic,'K',k);

		for j=1:h*w
			grad = calc_grad(hyper_dim_pic(j,:),hyper_dim_pic(nn_pixels_ind(j,:),:),h_color,h_spatial);
			hyper_dim_pic(j,:) = hyper_dim_pic(j,:) + lr*grad;
		end
		toc;
	end
	
	temp_pic = hyper_dim_pic(:,1:num_chan);
	% c = size(unique(temp_pic))
	% d = size(unique(original_pic))
	c = size(unique(uint8(temp_pic*256),'rows'))
	d = size(unique(uint8(original_pic*256),'rows'))
	modified_pic = reshape(temp_pic,h,w,num_chan);

end

function grad = calc_grad(curr, nbrs, h_color, h_spatial)
	spatial_diff = nbrs(:,end-1:end)-curr(end-1:end);
	spatial_diff_sq = sum(spatial_diff.^2,2);
	weight_space = gaussmf(spatial_diff_sq,[h_spatial 0]);

	color_diff = nbrs(:,1:end-2)-curr(1:end-2);
	color_diff_sq = sum(color_diff.^2,2);
	weight_color = gaussmf(color_diff_sq,[h_color 0]);

	weight = weight_color .* weight_space;

	grad = sum(nbrs.*repmat(weight,1,size(nbrs,2)))/sum(weight) - curr;

end