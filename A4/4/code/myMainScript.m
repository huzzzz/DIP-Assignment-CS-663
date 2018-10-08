A = [1,2; 3,4];

[U,S,V] = MySVD(A);
[Um, Sm, Vm] = svd(A);

disp(U*S*V')
disp(Um*Sm*Vm')