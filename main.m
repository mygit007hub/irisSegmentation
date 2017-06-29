

for i=1:37; %ciclo di lettura ed elaborazione di tutte le immagini
 s1 = '1 (';
 s3 = ').jpg';
 s2 = int2str(i);
 superstring = [s1 s2 s3];
 

im= imread(superstring);


X=size(im,2);
Y=size(im,1);


 try
    if((X<=257 && X>=0) && (Y<=342 && Y>=0))
        %trova la zona perioculare in un'immagine
          [periocularZone,eyeboxes] = trovaZonaPerioculare(im, 100, 70);
          [centro, raggio] = trovaIride(periocularZone, 15, 55, 5);
    elseif ((X<=960 && X>=258) && (Y<=960 && Y>=343))
        %trova la zona perioculare in un'immagine
          [periocularZone,eyeboxes] = trovaZonaPerioculare(im, 600, 300);
          [centro, raggio] = trovaIride(periocularZone, 85, 125, 30);
    elseif((X<=960 && X>=258) && (Y<=1280 && Y>=961))
        %trova la zona perioculare in un'immagine
          [periocularZone,eyeboxes] = trovaZonaPerioculare(im, 450, 250);
          [centro, raggio] = trovaIride(periocularZone, 45, 125, 20);
    elseif ((X<=1536 && X>=961) && (Y<=2048 && Y>=1281))
        %trova la zona perioculare in un'immagine
          [periocularZone, eyeboxes] = trovaZonaPerioculare(im, 650, 300);
          [centro, raggio] = trovaIride(periocularZone, 65, 145, 20);
    elseif ((X<=2448 && X>=1537) && (Y<=2448 && Y>=2049))
        %trova la zona perioculare in un'immagine
          [periocularZone, eyeboxes] = trovaZonaPerioculare(im, 1600, 1000);
          [centro, raggio] = trovaIride(periocularZone, 155, 255, 65);
    elseif ((X<=2448 && X>=1537) && (Y<=3264 && Y>=2449))
        %trova la zona perioculare in un'immagine
          [periocularZone, eyeboxes] = trovaZonaPerioculare(im, 1400, 800);
          [centro, raggio] = trovaIride(periocularZone, 105, 355, 40);
    end 

%     [periocularZone, eyeboxes] = trovaZonaPerioculare(im, 650, 300);
% 
%     [centro, raggio] = trovaIride(periocularZone, 60, 140, 30);

    [irideTagliata, centroTotal] = tagliaIride(im, centro, raggio, eyeboxes); 
    [centroP, raggioP] = trovaPupillaDaIride(irideTagliata,raggio, centro, eyeboxes);
    writeMask(irideTagliata, s1, s2, s3, centroTotal, centroP, raggio, raggioP);
catch
     disp('errore rilevato, continuo..');
%     
% 
 end
  clear;  
end


