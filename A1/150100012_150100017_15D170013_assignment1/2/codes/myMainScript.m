%% MyMainScript

tic;
%% Your code here
barbara_pic = imread('../data/barbara.png');
tem_pic = imread('../data/TEM.png');
canyon_pic = imread('../data/canyon.png');
retina_pic = imread('../data/retina.png');
retina_ref_pic = imread('../data/retinaRef.png');
church_pic = imread('../data/church.png');

my_num_of_colors = 256;
col_scale =  [0:1/(my_num_of_colors-1):1]';
my_color_scale = [col_scale,col_scale,col_scale];
colormap (my_color_scale);

% original_pic = retina_pic;
% ref_pic = retina_ref_pic;

original_pic = barbara_pic;

kernel_size = 100;
threshold = 200;

modified_pic = myLinearContrastStretching(original_pic);
% modified_pic = myHM(original_pic,ref_pic);
% modified_pic = myHE(original_pic);
% modified_pic = myAHE(original_pic,kernel_size);
% modified_pic = myCLAHE(original_pic,kernel_size,threshold);

subplot(1,2,1), imagesc(original_pic);
colorbar;
subplot(1,2,2), imagesc(modified_pic);
colorbar;

% subplot(1,3,1), imagesc(original_pic);
% colorbar;
% subplot(1,3,2), imagesc(modified_pic);
% colorbar;
% subplot(1,3,3), imagesc(ref_pic);
% colorbar;

impixelinfo()   
toc;