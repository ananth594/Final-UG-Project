clc; clear;
% Initialise Arduino COM port and SERVO variables
a = arduino('com3','Uno');
wrist = servo(a,'D10');
elbow = servo(a,'D9');
shoulder_Vert = servo(a,'D6');
shoulder_Hori = servo(a,'D5');
claw = servo(a,'D11');
%Initial position
writePosition(claw,0.2);
writePosition(wrist,0.6);
writePosition(elbow,0.4)
writePosition(shoulder_Vert,0.25)
writePosition(shoulder_Hori, 0.6)
 
%Threshold for each colour channel
redThresh = 0.24;
greenThresh = 0.05;
blueThresh = 0.15;
 
vidDevice = imaq.VideoDevice('winvideo', 1, 'YUY2_640x480','ROI', [1 1 500 300], ...
    'ReturnedColorSpace', 'rgb'); %initialise video device
 
vidInfo = imaqhwinfo(vidDevice);
 
 
hblob = vision.BlobAnalysis(    'AreaOutputPort',        false, ...
    'CentroidOutputPort',    true, ...
    'BoundingBoxOutputPort', true', ...
    'MinimumBlobArea',       5000, ...
    'MaximumBlobArea',       10000, ...
    'MaximumCount',            1); %initialise blob analysis for counting the detected colours
 
 
hshapeinsBox = vision.ShapeInserter('BorderColorSource', 'Input port', ...
    'Fill', true, ...
    'FillColorSource', 'Input port', ...
    'Opacity', 0.4); % To insert the mask
 
htextinsRed = vision.TextInserter('Text', 'Red   : %2d', ...
    'Location',  [5 2], ...
    'Color', [1 0 0], ...
    'Font', 'Courier New', ...
    'FontSize', 14);  
 
htextinsGreen = vision.TextInserter('Text', 'Green : %2d', ...
    'Location',  [5 18], ...
    'Color', [0 1 0], ...
    'Font', 'Courier New', ...
    'FontSize', 14);
 
htextinsBlue = vision.TextInserter('Text', 'Blue  : %2d', ...
    'Location',  [5 34], ...
    'Color', [0 0 1], ...
    'Font', 'Courier New', ...
    'FontSize', 14);
 
htextinsCent = vision.TextInserter('Text', '+      X:%4d, Y:%4d', ...
    'LocationSource', 'Input port', ...
    'Color', [1 1 0], ...
    'Font', 'Courier New', ...
    'FontSize', 14);
% Insert the box with each colour showing the number of counts available
 
hVideoIn = vision.VideoPlayer('Name', 'Final Video', ...
    'Position', [100 100  vidInfo.MaxWidth+20 vidInfo.MaxHeight+30]);
nFrame = 0;
 
 
while(nFrame < 5000)
    rgbFrame = step(vidDevice);
    rgbFrame = flipdim(rgbFrame,2);
    
    diffFrameRed = imsubtract(rgbFrame(:,:,1), rgb2gray(rgbFrame)); % Extract the red channel
    diffFrameRed = medfilt2(diffFrameRed, [3 3]); % Filter the image
    binFrameRed = im2bw(diffFrameRed, redThresh); % Get the area where mask will be put
    
    diffFrameGreen = imsubtract(rgbFrame(:,:,2), rgb2gray(rgbFrame)); % Extract the green channel
    diffFrameGreen = medfilt2(diffFrameGreen, [3 3]);% Filter the image
    binFrameGreen = im2bw(diffFrameGreen, greenThresh);% Get the area where mask will be put
    
    diffFrameBlue = imsubtract(rgbFrame(:,:,3), rgb2gray(rgbFrame));% Extract the blue channel
    diffFrameBlue = medfilt2(diffFrameBlue, [3 3]);% Filter the image
    binFrameBlue = im2bw(diffFrameBlue, blueThresh);% Get the area where mask will be put
    
    [centroidRed, bboxRed] = step(hblob, binFrameRed);
    centroidRed = uint16(centroidRed);
    
    [centroidGreen, bboxGreen] = step(hblob, binFrameGreen);
    centroidGreen = uint16(centroidGreen);
    
    [centroidBlue, bboxBlue] = step(hblob, binFrameBlue);
    centroidBlue = uint16(centroidBlue);
    % initialise variable to put the centroid values 
    rgbFrame(1:50,1:90,:) = 0;
    vidIn = step(hshapeinsBox, rgbFrame, bboxRed, single([1 0 0]));
    vidIn = step(hshapeinsBox, vidIn, bboxGreen, single([0 1 0]));
    vidIn = step(hshapeinsBox, vidIn, bboxBlue, single([0 0 1]));
    
    for object = 1:1:length(bboxRed(:,1));
        centXRed = centroidRed(object,1); centYRed = centroidRed(object,2);
        vidIn = step(htextinsCent, vidIn, [centXRed centYRed], [centXRed-6 centYRed-9]);
    end
    
    for object = 1:1:length(bboxGreen(:,1));
        centXGreen = centroidGreen(object,1);
        centYGreen = centroidGreen(object,2);
        vidIn = step(htextinsCent, vidIn, [centXGreen centYGreen], [centXGreen-6 centYGreen-9]);
    end
    
    
    for object = 1:1:length(bboxBlue(:,1));
        centXBlue = centroidBlue(object,1); centYBlue = centroidBlue(object,2);
        vidIn = step(htextinsCent, vidIn, [centXBlue centYBlue], [centXBlue-6 centYBlue-9]);
    end
    
    
    vidIn = step(htextinsRed, vidIn, uint8(length(bboxRed(:,1))));
    vidIn = step(htextinsGreen, vidIn, uint8(length(bboxGreen(:,1))));
    vidIn = step(htextinsBlue, vidIn, uint8(length(bboxBlue(:,1))));
    
    step(hVideoIn, vidIn);
    nFrame = nFrame+1;
    
    br= length(bboxRed(:,1)) % Get the count for red colour
    bg= length(bboxGreen(:,1)) % Get the count for red colour
    bb= length(bboxBlue(:,1)) % Get the count for red colour
 
    if (bb>0)
% perform the gesture to hold the object
      fprintf('Holding the Object.....')                
        writePosition(claw,0.2);
        pause(1)        
        writePosition(wrist,0.6)
        pause(1)        
        writePosition(elbow,0.4)
        pause(1)        
        writePosition(shoulder_Vert,0.25)
        pause(1)        
        writePosition(shoulder_Hori, 0.6)
        pause(1)        
        writePosition(claw,0.6)
        pause(1)        
        writePosition(shoulder_Vert,0.35)
        pause(1)
        writePosition(elbow,0.2)
        writePosition(wrist,0.25)
        pause(1)
        
    end
    
    if (bg > 0)
        
        fprintf('Lifting the Object.....')
        % perform the gesture to lift the object
        for i=1:2
            pause(1)
            
            writePosition(wrist,0.65)
            writePosition(elbow,0.6)
            writePosition(shoulder_Vert,0.3)
            pause(1)
            writePosition(claw,0.2)
            pause(1)
            writePosition(claw,0.6)
            pause(1)
            writePosition(wrist,0.2)
            writePosition(elbow,0.2)
            pause(2)
            writePosition(wrist,0.65)
            writePosition(elbow,0.6)
            pause(2)
            writePosition(claw,0.2)
            pause(1)
        end
end
    
if(br>0)
    fprintf('Moving the Object.....')
        
        % perform the gesture to move the object
        writePosition(wrist,0.6)
        pause(1)
        writePosition(elbow,0.4)
        pause(1)
        writePosition(shoulder_Vert,0.25)
        pause(1)
        writePosition(shoulder_Hori, 0.6)
        pause(1)
        writePosition(claw,0.2)
        pause(1)
        writePosition(claw,0.6)
        pause(1)
        writePosition(shoulder_Hori,0.2)
        pause(1)
        writePosition(claw,0.2)
        pause(1)
        writePosition(shoulder_Hori, 0.6)
        pause(1)
   end
    
end
 
release(hVideoIn);
release(vidDevice);
clear all;
clc;
