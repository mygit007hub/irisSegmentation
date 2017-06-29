function [c2, r2] = trovaPupillaDaIride(irideTagliata, raggioI, centroI, eyeboxes)
%TROVAPUPILLADAIRIDE Summary of this function goes here
%   Detailed explanation goes here

% irideTagliata= imadjust(irideTagliata);
% irideTagliata= histeq(irideTagliata);
irideTagliata = (double(irideTagliata) >= 30) ;
% imshow(irideTagliata);

rmin= int8(raggioI*0.2);
rmax= int8(raggioI*0.4);
[c, r] = imfindcircles(irideTagliata,[rmin rmax], 'ObjectPolarity', 'dark', 'Sensitivity',0.93, 'Method', 'twostage');
viscircles(c, r, 'EdgeColor', 'b');


if isempty(r)
    disp('sto in isempty');
    r2 = int8(raggioI*0.3);
    c2(1)= centroI(1)+eyeboxes(1);
    c2(2)=centroI(2)+eyeboxes(2);
else
    disp('sono nel not');
    rprova=0;
    for i=1:size(r)
        if r(i)>= rprova
            rprova=r(i);
            cont=i;
        end
    end
    r2= r(cont);
    c2(1)=c(cont,1);
    c2(2)=c(cont,2);
end

end

