function [modified_pic] = myBilinearInterpolation(original_pic,m,n)
	% Bilinear Interpolation %
	[h,w,num_chan] = size(original_pic);
	for i=1:num_chan
		h_new = m*(h-1)+1;
		w_new = n*(w-1)+1;
		modified_pic(:,:,i) = zeros(h_new,w_new);
		for x = 1:h_new
			for y = 1:w_new
				x_rem = mod(x-1,m);
				y_rem = mod(y-1,n);
				if(x == h_new && y==w_new)
					tl = [floor((x-1)/m)+1,floor((y-1)/n)+1];
					modified_pic(x,y,i) = original_pic(tl(1),tl(2),i);
				elseif(x == h_new)
					tl = [floor((x-1)/m)+1,floor((y-1)/n)+1];
					tr = [tl(1),tl(2)+1];
					modified_pic(x,y,i) = original_pic(tl(1),tl(2),i)*((n-y_rem)/n) + original_pic(tr(1),tr(2),i)*(y_rem/n);
				elseif(y==w_new)
					tl = [floor((x-1)/m)+1,floor((y-1)/n)+1];
					bl = [tl(1)+1,tl(2)];
					modified_pic(x,y,i) = original_pic(tl(1),tl(2),i)*((m-x_rem)/m) + original_pic(bl(1),bl(2),i)*(x_rem/m);
				else
					tl = [floor((x-1)/m)+1,floor((y-1)/n)+1];
					tr = [tl(1),tl(2)+1];
					bl = [tl(1)+1,tl(2)];
					br = [tl(1)+1,tl(2)+1];
					modified_pic(x,y,i) = original_pic(tl(1),tl(2),i)*((m-x_rem)*(n-y_rem)/(m*n)) + original_pic(tr(1),tr(2),i)*((m-x_rem)*y_rem/(m*n)) + original_pic(bl(1),bl(2),i)*(x_rem*(n-y_rem)/(m*n))+ original_pic(br(1),br(2),i)*(x_rem*y_rem/(m*n));
				end
			end
		end
	end
	modified_pic = double(modified_pic)./255.0;
end
