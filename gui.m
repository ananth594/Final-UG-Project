%MATLAB code for GUI for ROBOTIC ARM
 
function varargout = jinju(varargin)
 
% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
    'gui_Singleton',  gui_Singleton, ...
    'gui_OpeningFcn', @jinju_OpeningFcn, ...
    'gui_OutputFcn',  @jinju_OutputFcn, ...
    'gui_LayoutFcn',  [] , ...
    'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end
 
if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
 
 
 
function jinju_OpeningFcn(hObject, eventdata, handles, varargin)
 
handles.output = hObject;
 
% Update handles structure
guidata(hObject, handles);
 
% UIWAIT makes jinju wait for user response (see UIRESUME)
 
% initialise arduino com port in MATLAB with SERVO variables
clear a;
global a
a = arduino('com3','Uno');
wrist = servo(a,'D10');
elbow = servo(a,'D9');
shoulder_Vert =servo(a,'D6');
shoulder_Hori =servo(a,'D5');
claw = servo(a,'D11');
 
% --- Outputs from this function are returned to the command line.
function varargout = jinju_OutputFcn(hObject, eventdata, handles)
 
varargout{1} = handles.output;
 
 
% --- Executes on slider movement.
function slider1_Callback(hObject, eventdata, handles)
% reinitialise arduino com port with servo variables
 
global a
shoulder_Hori = servo(a,'D5');
guidata(hObject,handles);
handles.a = get(handles.slider1,'Value')
b=handles.a
for i = 1:60
    writePosition(shoulder_Hori,b);%change the shoulder horizontal position
end
 
 
% --- Executes during object creation, after setting all properties.
function slider1_CreateFcn(hObject, eventdata, handles)
 
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end
 
 
% --- Executes on slider movement.
function slider2_Callback(hObject, eventdata, handles)
% reinitialise arduino com port with servo variables
 
global a
shoulder_Vert =servo(a,'D6');
 
guidata(hObject,handles);
 
handles.a = get(handles.slider2,'Value')
 
b = handles.a
b = b/180
for i = 1:60
    writePosition(shoulder_Vert,b);%change the shoulder vertical position
end
 
% --- Executes during object creation, after setting all properties.
function slider2_CreateFcn(hObject, eventdata, handles)
 
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end
 
 
% --- Executes on slider movement.
function slider3_Callback(hObject, eventdata, handles)
global a
elbow =servo(a,'D9');
guidata(hObject,handles);
 
handles.a = get(handles.slider3,'Value')
 
b=handles.a
 
 
for i = 1:60
    writePosition(elbow,b);%change the elbow position
end
% --- Executes during object creation, after setting all properties.
function slider3_CreateFcn(hObject, eventdata, handles)
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end
 
 
% --- Executes on slider movement.
function slider4_Callback(hObject, eventdata, handles)
% reinitialise arduino com port with servo variables
 
global a
wrist =servo(a,'D10');
guidata(hObject,handles);
 
handles.a = get(handles.slider4,'Value')
 
b=handles.a
 
for i = 1:60
    writePosition(wrist,b);%change the wrist position
end
 
% --- Executes during object creation, after setting all properties.
function slider4_CreateFcn(hObject, eventdata, handles)
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end
 
 
% --- Executes on slider movement.
function slider5_Callback(hObject, eventdata, handles)
% reinitialise arduino com port with servo variables
global a
claw =servo(a,'D11');
guidata(hObject,handles);
 
handles.a = get(handles.slider5,'Value')
 
b=handles.a
 
for i = 1:60
    writePosition(claw,b);%change the gripper position
end
 
% --- Executes during object creation, after setting all properties.
function slider5_CreateFcn(hObject, eventdata, handles)
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end
 
 
% --- Executes on button press in Green button.
function pushbutton1_Callback(hObject, eventdata, handles)
% reinitialise arduino com port with servo variables
 
global a
wrist = servo(a,'D10');
elbow = servo(a,'D9');
shoulder_Vert =servo(a,'D6');
shoulder_Hori =servo(a,'D5');
claw = servo(a,'D11');
 
%Predefined motion to pick and drop the object
 
writePosition(wrist,0.5)
writePosition(elbow,0.5)
writePosition(shoulder_Vert,0.5)
writePosition(claw,0.5)
writePosition(shoulder_Hori,0.5)
 
 
for i=1:2
    
    writePosition(shoulder_Hori,0.5)
    writePosition(wrist,0.7)
    writePosition(elbow,0.6)
    writePosition(shoulder_Vert,0.3)
    writePosition(claw,0.2)
    pause(1)
    writePosition(claw,0.6)
    pause(1)
    writePosition(wrist,0.3)
    writePosition(elbow,0.2)
    pause(2)
    writePosition(wrist,0.7)
    writePosition(elbow,0.6)
    pause(2)
    writePosition(claw,0.2)
    pause(1)
    
end
 
% --- Executes on button press in Red button.
function pushbutton2_Callback(hObject, eventdata, handles)
% reinitialise arduino com port with servo variables
 
global a
wrist = servo(a,'D10');
elbow = servo(a,'D9');
shoulder_Vert =servo(a,'D6');
shoulder_Hori =servo(a,'D5');
claw = servo(a,'D11');
 
%Predefined motion to move the object
 
for i=1:1
    writePosition(claw,0.2)
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
    writePosition(shoulder_Hori,0.2)
    pause(1)
  writePosition(claw,0.2)
    pause(1)
    writePosition(shoulder_Hori,0.6)
    pause(1)
    
end
 

% --- Executes on button press in Blue t=button.
function pushbutton3_Callback(hObject, eventdata, handles)
 
% reinitialise arduino com port with servo variables
global a
wrist = servo(a,'D10');
elbow = servo(a,'D9');
shoulder_Vert =servo(a,'D6');
shoulder_Hori =servo(a,'D5');
claw = servo(a,'D11');
%Predefined motion to hold the object
writePosition(claw,0.2)
pause(1)
 
writePosition(wrist,0.6)
pause(1)
 
writePosition(elbow,0.4)
pause(1)
 
writePosition(shoulder_Vert,0.25)
pause(1)
 
for i = 1:3
    
    writePosition(shoulder_Hori, 0.6)
    writePosition(claw,0.6)
    pause(2)
    writePosition(shoulder_Vert,0.35)
    writePosition(elbow,0.2)
    writePosition(wrist,0.25)
    pause(1)
end

