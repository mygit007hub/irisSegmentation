function [periocularZone, eyeboxes] = trovaZonaPerioculare(Img, X, Y)

    pericularDetector = vision.CascadeObjectDetector('LeftEye');
    
    %aggiungere eventualmente if per differenza delle dimensioni
    pericularDetector.MinSize = [Y,X];
    eyeboxes = step(pericularDetector, Img);
    pericularCrop = insertObjectAnnotation(Img, 'rectangle', eyeboxes, 'Eye');
   
    periocularZone=Img(eyeboxes(2):eyeboxes(2)+eyeboxes(4),eyeboxes(1):eyeboxes(1)+eyeboxes(3),:);
end

