%% Helper function to calculate root mean square
function rmse_error = rmse(A,B)
	[h,w] = size(A);
	rmse_error = sqrt(sum(sum((A - B) .* (A - B))) / sum(sum(B.*B))); 
end
