% Initialise Arduino COM port and SERVO variables
a = arduino('com3','Uno');

shoulder_Hori = servo(a,'D5');
shoulder_Vert = servo(a,'D6');
elbow = servo(a,'D9');
wrist = servo(a,'D10');
claw = servo(a,'D11');

r = audiorecorder(22050, 16, 1);
fprintf('say a word immediately after hitting enter: ');% Record voice to match
input('');

recordblocking(r,4);
y=getaudiodata(r);

filename = 'govindha.wav';
audiowrite(filename,y,22050);

sound(y,22050)% Play the file that was recorded
pause(3)

speech=audioread(filename);
x=speech;
x=x';
x=x(1,:);
x=x';

y1=audioread('picktheobject.wav');
y1=y1';
y1=y1(1,:);
y1=y1';

z1=xcorr(x,y1);
m1=max(abs(z1));%Find the cross-correlation between 'picktheobject.wav' and newly recorded audio 

y2=audioread('dropitdown.wav');
y2=y2';
y2=y2(1,:);
y2=y2';
z2=xcorr(x,y2);
m2=max(abs(z2));%Find the cross-correlation between 'dropitdown.wav' and newly recorded audio

y3=audioread('holdup.wav');
y3=y3';
y3=y3(1,:);
y3=y3';
z3=xcorr(x,y3);
m3=max(abs(z3));%Find the cross-correlation between 'holdup.wav' and newly recorded audio

m4 = 70;
a=[m1 m2 m3 m4]
m=max(a)

if m<=m1
    soundsc(audioread('picktheobject.wav'),22050)
     
        fprintf('Picking the object.....')% Perform the gesture for picking the object
        
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
        
elseif m<=m2
    soundsc(audioread('dropitdown.wav'),22050)% Perform the gesture for dropping the object
      fprintf('Moving and dropping the object.....')
      
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
      
elseif m<=m3
    soundsc(audioread('holdup.wav'),22050)% Perform the gesture for holding the object
        
        fprintf('holding the object')
        
    
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
        pause(1)
    
        writePosition(wrist,0.25)
        pause(1)
elseif m<=m4
  fprintf('Invalid')% Print invalid if none of the audio files match
end
