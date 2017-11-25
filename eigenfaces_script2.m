#pkg load statistics
#pkg load image


%read in all the images - 40 individuals x 10 different images
root_dir = 'C:\Users\andreas\Desktop\stuff\data science\blog\faces\att_faces\orl_faces\';
cd(root_dir)

n_individuals = 40;

n_images = 10;

total_images = n_individuals * n_images;

im_size = [101, 83];

c=0;

disp("Loading images...")
fflush(stdout);

if ~exist("ifiles","var")
  
  ifiles = double(zeros(400,prod(im_size)));

  for d=1:n_individuals
    
    for f=1:n_images
    
    ifile = ['s',num2str(d),'/',num2str(f),'.pgm'];
    c = c + 1;
    ifiles(c,:) = double(reshape(imresize(imread(ifile),0.9),1,[]));
    
    end
    
  end
end

%mean centralise
ifiles = ifiles - mean(ifiles,2);

%singular value decomposition
printf("Performing SVD...");
fflush(stdout);

[U S V] = svd(ifiles);
E=(S'*S);


%find the top PCs which account for 90% of the variance
topPCs=find(cumsum(diag(E)) / sum(diag(E)) > 0.90);
topPCs = topPCs(1);
numPCs=length(find(diag(E) > 0));

%reconstruct images with eigenvectors starting from 1st PC to the value in numPCs and
%compute reconstruction error as we add more PCs
rec_error = zeros(numPCs,1);
reconst = zeros(numPCs,prod([im_size]));

sample = ceil(rand * total_images);
im = ifiles(sample,:)';

printf("\nReconstructing image for sample %d [number of PCs = %d]",sample,numPCs)
fflush(stdout);

for n=1:numPCs
  
  A=V(:,1:n) * V(:,1:n)';

  reconst(n,:) = (A * im);

  rec_error(n) = mean((im -reconst(n,:)').^2);

end
 

%let's do the same thing but this time add some Gaussian blurring to the images
f = fspecial("gaussian",5,1.5);
rec_error_blur = zeros(numPCs,1);
reconst_blur = zeros(numPCs,prod([im_size]));

%apply filter

im_blurred = double(reshape(imfilter(reshape(im,[im_size]),f),[],1));
im_blurred = im_blurred - mean(im_blurred);

printf("\nReconstructing image for blurred sample %d [number of PCs = %d]",sample,numPCs)
fflush(stdout);
  
for n=1:numPCs
  
  A=V(:,1:n) * V(:,1:n)';

  reconst_blur(n,:) = (A * im_blurred);

  rec_error_blur(n) = mean((im -reconst_blur(n,:)').^2);

end

rec_error_noise = zeros(numPCs,1);
reconst_noise = zeros(numPCs,prod([im_size]));

noise=normrnd(mean(im),std(im),prod([im_size]),1);
im_noise = im+noise;
im_noise = im_noise - mean(im_noise);

printf("\nReconstructing image for noise sample %d [number of PCs = %d]",sample,numPCs)
fflush(stdout);
  
for n=1:numPCs
  
  A=V(:,1:n) * V(:,1:n)';

  reconst_noise(n,:) = (A * im_noise);

  rec_error_noise(n) = mean((im -reconst_noise(n,:)').^2);

end

%plot results 

figure; plot(rec_error,'-r');
axis ([0 numPCs min(rec_error) max(rec_error)])
figure; plot(rec_error,'-r');
hold on;plot(rec_error_blur,'-g');
hold on;plot(rec_error_noise,'-k');
axis ([0 numPCs min(rec_error) max(rec_error_noise)])



  
  
  