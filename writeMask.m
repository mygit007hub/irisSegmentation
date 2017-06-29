function [] = writeMask(Img, s1, s2, s3, ci, cp, ri, rp)


%AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
% cp= ci;
% rp = ri-40;
%AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA


[xx,yy]=ndgrid(1:size(Img,1), 1:size(Img,2));
white = Img;
white( (xx-ci(2)).^2 + (yy-ci(1)).^2<=ri^2 ) = 255;
white( (xx-cp(2)).^2 + (yy-cp(1)).^2<=rp^2 ) = 0;



superstring2 = [s1 s2 '-mask' s3];
imwrite(white, superstring2, 'jpg');
end

