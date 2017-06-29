function [irideTagliata, centro2] = tagliaIride(Img, centro, raggio, eyeboxes)



centro2(1)= centro(1) + eyeboxes(1);
centro2(2) = centro(2) + eyeboxes(2);
out2 = Img(1:size(Img,1), 1:size(Img,2));

[xx,yy]=ndgrid(1:size(Img,1), 1:size(Img,2));

CroppingMask= uint8(( (xx-centro2(2)).^2+(yy-centro2(1)).^2<=raggio^2 ));
irideTagliata=out2.*CroppingMask;

% x= size(irideTagliata,1);
% y = size(irideTagliata,2);
% for i=1:x
%     for j = 1:y
%         if irideTagliata(i,j)==0
%             irideTagliata(i,j)=255;
%         end
%     end
% end

% imshow(CroppingMask);
% figure(2);imshow(irideTagliata);



end

