function [centroIride,raggioIride]=trovaIride(I,rmin,rmax, soglia);

%Usiamo la trasformata di Hough per trovare possibili cerchi all'interno di
%ogni immagine filtrata.
%Creiamo una matrice a tre dimensioni per tenere traccia dei  centri e dei 
%raggi (nella prima "dimensione" c'è la coordinata x dei centri, nella
%seconda "dimensione" c'è la coordinata y dei centri e nell'ultima
%"dimensione" c'è il raggio associato ad ogni centro).
%In particolare, le colonne rappresentano il numero di filtri applicati
%all'immagine, nel nostro caso 6 anche se sarebbe possibile tranquillamente
%generalizzare e permettere all'utente stesso di scegliere quanti e quali
%filtri usare/non usare. Le righe rappresentano, invece, il numero di
%centri presi in considerazione per ogni filtro, nel nostro caso abbiamo
%posto come limite 5, ma anche qui sarebbe possibile permettere all'utente
%di personalizzare questa scelta. Se ci fossero più di cinque cerchi in
%un'immagine filtrata, la politica è quella di accettare solo i cinque più
%grandi (si tratta di una probabilità trascurabile stando alle prove
%fatte - DA IMPLEMENTARE).

centerMatrix(:,:,1) = NaN(5,6);
centerMatrix(:,:,2) = NaN(5,6);
centerMatrix(:,:,3) = NaN(5,6);

%La matrice seguente viene utilizzata per tenere traccia dei cerchi simili
%associati ad un singolo cerchio. In particolare, anche in questo caso è
%stata utilizzata una matrice a tre dimensioni in cui: nella prima
%"dimensione" abbiamo memorizzato i "coefficienti di similarità" di un
%centro con tutti gli altri, nella seconda dimensione ci sono gli indici di
%riga dei centri a cui i coefficienti fanno riferimento e nella seconda
%dimensione l'indice di colonna dei centri a cui i coefficienti fanno
%riferimento (NB. indici di riga e indici di colonna sono da utilizzare per 
% prendere il cerchio di riferimento nella matrice centerMatrix). 

similarityMatrix = zeros(30,6,3);

%Qui troviamo i sei filtri valutati con la funzione imfindcircles, in
%particolare da notare il parametro 'twostage' che sta ad indicare
%l'utilizzo della trasformata di Hough. 

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
[centers5, radii5] = imfindcircles(Icomplement,[rmin rmax], 'Sensitivity',0.91, 'Method', 'twostage');
viscircles(centers5, radii5, 'EdgeColor', 'b');
if isempty(centers5)
    centers5=NaN(1,2);
    radii5=NaN;
end
centerMatrix(1:size(centers5,1),5,1) = centers5(:,1);
centerMatrix(1:size(centers5,1),5,2) = centers5(:,2);
centerMatrix(1:size(radii5),5,3) = radii5;

Iycbcr=rgb2ycbcr(Iadjust);
[centers6, radii6] = imfindcircles(Iycbcr,[rmin rmax], 'Sensitivity',0.93, 'Method', 'twostage');
viscircles(centers6, radii6, 'EdgeColor', 'b');
if isempty(centers6)
    centers6=NaN(1,2);
    radii6=NaN;
end
centerMatrix(1:size(centers6,1),6,1) = centers6(:,1);
centerMatrix(1:size(centers6,1),6,2) = centers6(:,2);
centerMatrix(1:size(radii6),6,3) = radii6;

%All'interno di questi cicli vengono calcolati i coefficienti di similarità
%tra i vari centri. In particolare, viene fissato un centro e poi viene
%confrontato con gli altri venticinque (per ogni colonna/filtro viene
%considerato solo quello "più simile" ovvero quello con un coefficiente più
%piccolo. Questo coefficiente viene poi memorizzato nella matrice
%similarityMatrix. 

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

%Vienne effettuata la ricerca della riga con somma minore, in quanto in
%quel caso significa che il centro a cui "appartiene" il vettore, è quello
%che ha più cerchi simili ed è quello che interessa a noi per scegliere poi
%i parametri con cui estrarre l'iride. 

minIniziale = sum(similarityMatrix(1,:,1));
rigaP = 1;
for s=1:30;
   if sum(similarityMatrix(s,:,1))<minIniziale
       minIniziale = sum(similarityMatrix(s,:,1));
       rigaP=s;
   end
end

%METODO BASATO SUL VALORE DI ENTROPIA/raggio%
%Vengono considerati tutti i cerchi associati al vettore trovato in
%precedenza e, in particolare, si effettua un ciclo per andare a trovare
%quello che possiede il rapporto ENTROPIA/raggio più piccolo. Il cerchio
%che valore più piccolo è il candidato per essere l'iride all'interno
%dell'immagine di partenza. 

vettoreOrdinato = sort(similarityMatrix(rigaP, :, 1));
 
% [xx,yy]=ndgrid(1:size(I,1), 1:size(I,2));
%  centro(1) = centerMatrix(similarityMatrix(rigaP,1,2),similarityMatrix(rigaP,1,3),1);
%  centro(2) = centerMatrix(similarityMatrix(rigaP,1,2),similarityMatrix(rigaP,1,3),2);
%  raggio = centerMatrix(similarityMatrix(rigaP,1,2),similarityMatrix(rigaP,1,3),3);
%  CroppingMask= uint8(( (xx-centro(1)).^2+(yy-centro(2)).^2<=raggio^2 ));
%  CroppingMask= Igray.*CroppingMask;
%  minEntRag = wentropy(CroppingMask, 'shannon')/raggio;

minEntRag = 100;
 centro(1,2) = NaN;
 centro(1,1) = NaN;
 raggio = NaN;
 
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
 
 
 
 %METODO CON VALORE MEDIANO%
 %vettoreOrdinato = sort(similarityMatrix(rigaP,:,1);
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

%viscircles(centro, raggio, 'Edgecolor', 'b');
if not(isempty(centers4)) & isnan(centro) & isnan(raggio)
centro = centers4;
raggio = radii4;
end

centroIride = centro;
raggioIride = raggio; 
end