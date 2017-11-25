
figure;

for n=1:9

subplot(3,3,n)
i=((n-1) * floor(numPCs/9)) + 1
imagesc(reshape(reconst(i,:),101,83))
axis off
colormap("gray")

title(["rank-",num2str(i),", error = ", num2str(rec_error(i))])

end

figure;

for n=1:9

subplot(3,3,n)
i=((n-1) * floor(numPCs/9)) + 1
imagesc(reshape(reconst_blur(i,:),101,83))
axis off
colormap("gray")
title(["rank-",num2str(i),", error = ", num2str(rec_error_blur(i))])
end

figure;

for n=1:9

subplot(3,3,n)
i=((n-1) * floor(numPCs/9)) + 1
imagesc(reshape(reconst_noise(i,:),101,83))
axis off
colormap("gray")
title(["rank-",num2str(i),", error = ", num2str(rec_error_noise(i))])

end