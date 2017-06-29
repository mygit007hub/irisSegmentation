
fileFolder = pwd; %restituisce vettore degli elementi presenti nella cartella
numFrames = size(fileFolder);%restituisce numero elementi del vettore
for i=1:numFrames
	nomeFile = fileFolder(i).name %restituisce il nome dell'i-esimo elemento
end