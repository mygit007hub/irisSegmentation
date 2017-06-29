%considerare i rapporti tra entropia e raggi e prendere il rapporto più
%piccolo 
figure;
I = imread('1 (17).jpg');

soglia= 30;
rmin= 65;
rmax= 140;

centerMatrix(:,:,1) = NaN(5,6);
centerMatrix(:,:,2) = NaN(5,6);
centerMatrix(:,:,3) = NaN(5,6);

similarityMatrix = zeros(30,6,3);

subplot(2,3,1);
imshow(I);
[centers1, radii1] = imfindcircles(I,[rmin rmax], 'ObjectPolarity', 'dark', 'Sensitivity',0.93, 'Method', 'twostage');
viscircles(centers1, radii1,'EdgeColor','b');
if isempty(centers1)
    centers1=NaN(1,2);
    radii1=NaN;
end
centerMatrix(1:size(centers1,1),1,1) = centers1(:,1);
centerMatrix(1:size(centers1,1),1,2) = centers1(:,2);
centerMatrix(1:size(radii1),1,3) = radii1;

Iadjust = imadjust(I,[.2 .3 0; .6 .7 1],[]);
subplot(2,3,2);
imshow(Iadjust);
[centers2, radii2] = imfindcircles(Iadjust,[rmin rmax], 'ObjectPolarity', 'dark', 'Sensitivity',0.93, 'Method', 'twostage');
viscircles(centers2, radii2,'EdgeColor','b');
if isempty(centers2)
    centers2=NaN(1,2);
    radii2=NaN;
end
centerMatrix(1:size(centers2,1),2,1) = centers2(:,1);
centerMatrix(1:size(centers2,1),2,2) = centers2(:,2);
centerMatrix(1:size(radii2),2,3) = radii2;


Igray = rgb2gray(Iadjust);
subplot(2,3,3);
imshow(Igray);
[centers3, radii3] = imfindcircles(Igray,[rmin rmax], 'ObjectPolarity', 'dark', 'Sensitivity',0.93, 'Method', 'twostage');
viscircles(centers3, radii3, 'EdgeColor', 'b');
if isempty(centers3)
    centers3=NaN(1,2);
    radii3=NaN;
end
centerMatrix(1:size(centers3,1),3,1) = centers3(:,1);
centerMatrix(1:size(centers3,1),3,2) = centers3(:,2);
centerMatrix(1:size(radii3),3,3) = radii3;

Ibw = im2bw(Iadjust,0.2);
subplot(2,3,4);
imshow(Ibw);
[centers4, radii4] = imfindcircles(Ibw,[rmin rmax], 'ObjectPolarity', 'dark', 'Sensitivity',0.93, 'Method', 'twostage');
viscircles(centers4, radii4, 'EdgeColor', 'b');
if isempty(centers4)
    centers4=NaN(1,2);
    radii4=NaN;
end
centerMatrix(1:size(centers4,1),4,1) = centers4(:,1);
centerMatrix(1:size(centers4,1),4,2) = centers4(:,2);
centerMatrix(1:size(radii4),4,3) = radii4;

Icomplement=imcomplement(Iadjust);
subplot(2,3,5);
imshow(Icomplement);
[centers5, radii5] = imfindcircles(Icomplement,[rmin rmax], 'Sensitivity',0.93, 'Method', 'twostage');
viscircles(centers5, radii5, 'EdgeColor', 'b');
if isempty(centers5)
    centers5=NaN(1,2);
    radii5=NaN;
end
centerMatrix(1:size(centers5,1),5,1) = centers5(:,1);
centerMatrix(1:size(centers5,1),5,2) = centers5(:,2);
centerMatrix(1:size(radii5),5,3) = radii5;

Iycbcr=rgb2ycbcr(Iadjust);
subplot(2,3,6);
imshow(Iycbcr);
[centers6, radii6] = imfindcircles(Iycbcr,[rmin rmax], 'Sensitivity',0.93, 'Method', 'twostage');
viscircles(centers6, radii6, 'EdgeColor', 'b');
if isempty(centers6)
    centers6=NaN(1,2);
    radii6=NaN;
end
centerMatrix(1:size(centers6,1),6,1) = centers6(:,1);
centerMatrix(1:size(centers6,1),6,2) = centers6(:,2);
centerMatrix(1:size(radii6),6,3) = radii6;

%cerchiamo i centri simili all'interno della matrice generata coi centri
%presi da tutte e sei le immagini 
for j=1:6
   for i=1:5
       k=mod(j+1,6);
       if (j+1)==6
           k=6;
       end
       min = soglia;
       minR = 0;
       minC = 0;
       for z=1:25
           
           riga = mod(z,5);
            if(riga==0)
                riga=5;
            end
        
           confronto = abs(centerMatrix(i,j,1)-centerMatrix(riga,k,1));
           confronto = confronto + abs(centerMatrix(i,j,2)-centerMatrix(riga,k,2));
           confronto = confronto + abs(centerMatrix(i,j,3)-centerMatrix(riga,k,3));
           
           if confronto < min
               min = confronto;
               minR = riga;
               minC = k;
           end
           
        if mod(z,5)==0
            similarityMatrix(i+(j-1)*5,k,1)=min;
            similarityMatrix(i+(j-1)*5,k,2)=minR;
            similarityMatrix(i+(j-1)*5,k,3)=minC;
            k=1+mod(k,6);
            min = soglia;
        end       
        
       end
   end
end

figure;
imshow(I);
minIniziale = sum(similarityMatrix(1,:,1));
rigaP = 1;
for s=1:30;
   if sum(similarityMatrix(s,:,1))<minIniziale
       minIniziale = sum(similarityMatrix(s,:,1));
       rigaP=s;
   end
end
minIniziale
rigaP



% [xx,yy]=ndgrid(1:size(I,1), 1:size(I,2));
%  centro(1) = centerMatrix(similarityMatrix(rigaP,1,2),similarityMatrix(rigaP,1,3),1);
%  centro(2) = centerMatrix(similarityMatrix(rigaP,1,2),similarityMatrix(rigaP,1,3),2);
%  raggio = centerMatrix(similarityMatrix(rigaP,1,2),similarityMatrix(rigaP,1,3),3);
%  CroppingMask= uint8(( (xx-centro(1)).^2+(yy-centro(2)).^2<=raggio^2 ));
%  CroppingMask= Igray.*CroppingMask;
%  minEntRag = wentropy(CroppingMask, 'shannon')/raggio;

minEntRag = 0;
 
 for t=1:6
 [xx,yy]=ndgrid(1:size(I,1), 1:size(I,2));
 indiR = similarityMatrix(rigaP,t,2) ;
 indiC = similarityMatrix(rigaP,t,3) ;
 if indiR~=0 && indiC~=0
 centroTmp(1,1) = centerMatrix(indiR,indiC,1);
 centroTmp(1,2) = centerMatrix(indiR,indiC,2);
 raggioTmp = centerMatrix(similarityMatrix(rigaP,t,2),similarityMatrix(rigaP,t,3),3);
 CroppingMask= uint8(( (xx-centroTmp(1)).^2+(yy-centroTmp(2)).^2<=raggioTmp^2 ));
 CroppingMask= Igray.*CroppingMask; 
     if (wentropy(CroppingMask, 'shannon')/raggioTmp) < minEntRag 
         minEntRag = wentropy(CroppingMask, 'shannon')/raggioTmp;
         centro(1,1) = centroTmp(1);
         centro(1,2) = centroTmp(2);
         raggio = raggioTmp; 
     end
 end
 end
 
 
 
% valoreMediano = vettoreOrdinato(3);
% for t=1:6
%     if similarityMatrix(rigaP,t,1)==valoreMediano;
%         coordinataR = similarityMatrix(rigaP,t,2);
%         coordinataC = similarityMatrix(rigaP,t,3);
%     end
% end
% center = [centerMatrix(coordinataR, coordinataC, 1) centerMatrix(coordinataR, coordinataC, 2)];
% radii = centerMatrix(coordinataR, coordinataC, 3);
%viscircles(center, radii, 'EdgeColor', 'b');
if not(isempty(centers4))
centro = centers4;
raggio = radii4;
end
viscircles(centro, raggio, 'Edgecolor', 'b');