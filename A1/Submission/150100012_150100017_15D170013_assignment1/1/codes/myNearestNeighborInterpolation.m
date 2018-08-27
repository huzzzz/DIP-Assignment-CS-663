function[modified_pic] = myNearestNeighborInterpolation(original_pic,m,n)
	% Nearest Neighbor Interpolation %
	[h,w, num_chan] = size(original_pic);
	for i=1:num_chan
		% Setting the new image dimensions %
		x_new = m*(h-1)+1;
		y_new = n*(w-1)+1;
		% Initialising the image as a blank image %
		modified_pic(:,:,i) = zeros(x_new,y_new);
		for x = 1:x_new
			for y = 1:y_new
				x_rem = mod(x-1,m);
				y_rem = mod(y-1,n);
				tl = [floor((x-1)/m)+1,floor((y-1)/n)+1];
				x_taken = 0;
				y_taken = 0;
				% Finding the nearest pixels in the original image %
				if(x_rem <= floor((m-1)/2))
					x_taken = tl(1);
				else
					x_taken = tl(1)+1;
				end
				if(y_rem <= floor((n-1)/2))
					y_taken = tl(2);
				else
					y_taken = tl(2)+1;
				end
				% Setting the values of the new pixel according to the nearest pixel in the original image %
				modified_pic(x,y,i) = original_pic(x_taken,y_taken,i);
			end
		end
	end
	% Getting the pixel intensity values in 0 to 1 %
	modified_pic = double(modified_pic)./255.0;
end