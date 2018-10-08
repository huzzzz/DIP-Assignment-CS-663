function [U,S,V] = MySVD(A)

	% eigs gives eigenvalues in sorted order

	% get left singular vectors of A. 
	% AA' = (USV') (VS'U') = US(VV')S'U' = USS'U' = USSU'. Hence U is eigenvector matrix of AA'
	[U,~] = eigs( A * A' );

	% get right singular vectors of A
	% A'A = (VS'U') (USV') = VS'(U'U)SV' = VS'SV' = VS'SV'. Hence V is eigenvector matrix of A'A
	[V,~] = eigs( A' * A );

	% Since U and V are orthornormal, U' * (U*S*V') * V = S 
	S = U' * A * V;

	% But we need only non-negative values on diagonal for S
	% So we adjust S and U to maintain consistency. Negating does not affect the orthonormality of U
    [m,n] = size(S);
    for d=1:min(m,n)
    	if(S(d,d)<0)
    		U(:,d) = -U(:,d);
    		S(d,d) = -S(d,d);
    	end
    end
	
end
