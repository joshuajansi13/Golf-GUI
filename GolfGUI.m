function varargout = GolfGUI(varargin)
% GOLFGUI MATLAB code for GolfGUI.fig
%      GOLFGUI, by itself, creates a new GOLFGUI or raises the existing
%      singleton*.
%
%      H = GOLFGUI returns the handle to a new GOLFGUI or the handle to
%      the existing singleton*.
%
%      GOLFGUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in GOLFGUI.M with the given input arguments.
%
%      GOLFGUI('Property','Value',...) creates a new GOLFGUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before GolfGUI_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to GolfGUI_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help GolfGUI

% Last Modified by GUIDE v2.5 12-Dec-2018 09:52:50

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @GolfGUI_OpeningFcn, ...
                   'gui_OutputFcn',  @GolfGUI_OutputFcn, ...
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
% End initialization code - DO NOT EDIT


% --- Executes just before GolfGUI is made visible.
function GolfGUI_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to GolfGUI (see VARARGIN)

% Choose default command line output for GolfGUI
handles.output = hObject;

%Initizalize values
handles.club = "D";
handles.windspeed.Value = 0;
handles.winddir.Value = 0;
handles.swingpower.Value = 0;
handles.swingangle.Value = 0;


axis(handles.axes2,[-150,150,0,300])
grid(handles.axes2,'on')
axis(handles.axes3,[0,300,0,70])
grid(handles.axes3,'on')
axis(handles.axes4,[-150,150,0,300,0,70])
grid(handles.axes4,'on')


% create an axes that spans the whole gui
ah = axes('unit', 'normalized', 'position', [0 0 1 1]); 
% import the background image and show it on the axes
bg = imread('golf1.jpg'); imagesc(bg);
% prevent plotting over the background and turn the axis off
set(ah,'handlevisibility','off','visible','off')
% making sure the background is behind all the other uicontrols
uistack(ah, 'bottom');

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes GolfGUI wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = GolfGUI_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;



% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
club = handles.club;
switch club
    case 'D'
      v0=167;
      theta0=11;
      omega0 = 2700;
    case '2W'
      v0 = 163;
      theta0 = 10;
      omega0 = 3100;
    case '3W'
      v0=158;
      theta0=9;
      omega0 = 3600;
    case '4W'
      v0=155;
      theta0=9;
      omega0 = 3900;
    case '5W'
      v0=152;
      theta0=9;
      omega0=4300;
    case '6W'
      v0=149;
      theta0=10;
      omega0=4400;
    case '7W'
      v0=146;
      theta0=10;
      omega0=4500;
    case '3I'
      v0=142;
      theta0=10;
      omega0=4600;
    case '4I'
      v0=137;
      theta0=11;
      omega0=4800;
    case '5I'
      v0=132;
      theta0=12;
      omega0=5400;
    case '6I'
      v0=127;
      theta0=14;
      omega0=6200;
    case '7I'
      v0=120;
      theta0=16;
      omega0=7100;
    case '8I'
      v0=115;
      theta0=18;
      omega0=8000;
    case '9I'
      v0=109;
      theta0=20;
      omega0=8600;
    case 'PW'
      v0=102;
      theta0=24;
      omega0=9300;
    otherwise
      v0=0;
      theta0 = 0;
      omega0 = 0;
end
fraction = handles.slider3.Value;
v=v0*fraction*.44704; % convert to m/s from mph
omega = omega0*fraction*.10472; % convert from rpm to rad/s
theta = theta0 * (pi/180);
Spin(1)=0; %No rotation about x axis
Spin(2)=0; %No hook or slice spin
Spin(3)=omega; %All spin about horizontal axis
Vel(1) = v*cos(theta); %X coordinate
Vel(2) = v*sin(theta); %Y coordinate
Vel(3) = 0; % No pull or push velocity

windspeed = handles.slider1.Value;
winddirection = handles.slider2.Value;
swingangle = handles.slider4.Value + 90;

initx = 0;
inity = 0;
initz = 0;

xwind = windspeed*cosd(winddirection - swingangle);
ywind = 0;
zwind = windspeed*sind(winddirection - swingangle);


xswing = Vel(1);
yswing = Vel(2);
zswing = Vel(3);

xspin = Spin(1);
yspin = Spin(2);
zspin = Spin(3);

%Initial conditions
initcond = [initx;inity;initz;xswing;yswing;zswing;xwind;ywind;zwind;xspin;yspin;zspin];

tspan = 0:.01:10;

%Plotting functions
[TOUT,YOUT] = ode45(@golfeom,tspan,initcond);


PositiveIndices = find(YOUT(:,2) >= 0);
YOUT = YOUT(PositiveIndices,:);

xswingframe = YOUT(:,1);
yswingframe = YOUT(:,2);
zswingframe = YOUT(:,3);

%Rotation matrix
A = [cosd(swingangle) -sind(swingangle);
    sind(swingangle) cosd(swingangle)];
swingframe_vectors = [xswingframe'; zswingframe'];

worldframe = A*swingframe_vectors;

xworldframe = worldframe(1,:);
zworldframe = worldframe(2,:);

line = rand(1,3);

x = handles.distancetohole;
z = handles.zdistancetohole;

plot(handles.axes3,x,0,'o','MarkerSize',7,'Color','b')
% axis(handles.axes3,[0,300,0,70])
grid(handles.axes3,'on')
ax2 = handles.axes2;
ax3 = handles.axes3;
ax4 = handles.axes4;
hold(ax2,'on')
hold(ax3,'on')
hold(ax4,'on')


%Top view
plot(handles.axes2,zworldframe,xworldframe,'color',line)
% axis(handles.axes2,[-150,150,0,300])
grid(handles.axes2,'on')
hold on
%Side view
plot(handles.axes3,xworldframe,yswingframe,'color',line)
% axis(handles.axes3,[0,300,0,70])
grid(handles.axes3,'on')
hold on
%3D view
plot3(handles.axes4,zworldframe,xworldframe,yswingframe,'color',line)
% axis(handles.axes4,[-150,150,0,300,0,70])
grid(handles.axes4,'on')
hold on


xworldframe(end)
yswingframe(end)
zworldframe(end)


if xworldframe(end) < x + 4 && xworldframe(end) > x - 4 && zworldframe(end) < z + 4 && zworldframe(end) > z - 4
    plot(handles.axes2,z,x,'o','MarkerSize',7,'Color','g')
%     axis(handles.axes2,[-150,150,0,300])
    grid(handles.axes2,'on')
    hold on
    plot(handles.axes3,x,0,'o','MarkerSize',7,'Color','g')
%     axis(handles.axes3,[0,300,0,70])
    grid(handles.axes3,'on')
    ax3 = handles.axes3;
    hold(ax3,'on')
    plot3(handles.axes4,z,x,0,'o','MarkerSize',7,'Color','g')
%     axis(handles.axes4,[-150,150,0,300,0,70])
    grid(handles.axes4,'on')
    hold on
    
    msgbox('Hole in 1! Congratulations!')
end
    
guidata(hObject, handles);

% --- Executes on slider movement.
function slider1_Callback(hObject, eventdata, handles)
% hObject    handle to slider1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
val = round(hObject.Value);
handles.slider1.Value = val;

speed = handles.slider1.Value;
set(handles.text7,'String',speed);

%Hole
cla(handles.axes2);
x = handles.distancetohole;
z = handles.zdistancetohole;

%Top view
plot(handles.axes2,z,x,'o','MarkerSize',7,'Color','b')
axis(handles.axes2,[-150,150,0,300])
grid(handles.axes2,'on')
ax2 = handles.axes2;
hold(ax2,'on')


%Quiver for windspeed and angle
handles.winddir = get(handles.slider2,'Value');
handles.windspeed = get(handles.slider1,'Value');
axes(handles.axes2);
drawArrow = @(x,y,props) quiver( x(1),y(1),x(2)-x(1),y(2)-y(1),0, props{:} );
wind_angle = (handles.winddir - 90) * -1; % degrees

pointx = (handles.windspeed)*cos(wind_angle*pi/180)+100;
pointy = (handles.windspeed)*sin(wind_angle*pi/180)+250;
x1 = [100 pointx];
y1 = [250 pointy];
drawArrow(x1,y1,{'MaxHeadSize',2,'Color','g','LineWidth',2});
axis(handles.axes2,[-150,150,0,300])
grid(handles.axes2,'on')


%Quiver for swing power and angle
handles.swingangle = get(handles.slider4,'Value');
handles.swingpower = get(handles.slider3,'Value');
axes(handles.axes2);
drawArrow = @(x,y,props) quiver( x(1),y(1),x(2)-x(1),y(2)-y(1),0, props{:} );
swing_angle = (handles.swingangle * -1) - 360; % degrees

pointx = (handles.swingpower*100)*cos(swing_angle*pi/180)+0;
pointy = (handles.swingpower*100)*sin(swing_angle*pi/180)+0;
x1 = [0 pointx];
y1 = [0 pointy];
drawArrow(x1,y1,{'MaxHeadSize',2,'Color','r','LineWidth',2});
axis(handles.axes2,[-150,150,0,300])
grid(handles.axes2,'on')


guidata(hObject, handles);
% --- Executes during object creation, after setting all properties.
function slider1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end

guidata(hObject, handles);



% --- Executes on slider movement.
function slider2_Callback(hObject, eventdata, handles)
% hObject    handle to slider2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
val = round(hObject.Value);
handles.slider2.Value = val;


direction = handles.slider2.Value;
set(handles.text19,'String',direction);


%Hole
cla(handles.axes2);
x = handles.distancetohole;
z = handles.zdistancetohole;

%Top view
plot(handles.axes2,z,x,'o','MarkerSize',7,'Color','b')
axis(handles.axes2,[-150,150,0,300])
grid(handles.axes2,'on')
ax2 = handles.axes2;
hold(ax2,'on')


%Quiver for windspeed and angle
handles.winddir = get(handles.slider2,'Value');
handles.windspeed = get(handles.slider1,'Value');
axes(handles.axes2);
drawArrow = @(x,y,props) quiver( x(1),y(1),x(2)-x(1),y(2)-y(1),0, props{:} );
wind_angle = (handles.winddir - 90) * -1; % degrees

pointx = (handles.windspeed)*cos(wind_angle*pi/180)+100;
pointy = (handles.windspeed)*sin(wind_angle*pi/180)+250;
x1 = [100 pointx];
y1 = [250 pointy];
drawArrow(x1,y1,{'MaxHeadSize',2,'Color','g','LineWidth',2});
axis(handles.axes2,[-150,150,0,300])
grid(handles.axes2,'on')

%Quiver for swing power and angle
handles.swingangle = get(handles.slider4,'Value');
handles.swingpower = get(handles.slider3,'Value');
axes(handles.axes2);
drawArrow = @(x,y,props) quiver( x(1),y(1),x(2)-x(1),y(2)-y(1),0, props{:} );
swing_angle = (handles.swingangle * -1) - 360; % degrees

pointx = (handles.swingpower*100)*cos(swing_angle*pi/180)+0;
pointy = (handles.swingpower*100)*sin(swing_angle*pi/180)+0;
x1 = [0 pointx];
y1 = [0 pointy];
drawArrow(x1,y1,{'MaxHeadSize',2,'Color','r','LineWidth',2});
axis(handles.axes2,[-150,150,0,300])
grid(handles.axes2,'on')


guidata(hObject, handles);



% --- Executes during object creation, after setting all properties.
function slider2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on button press in pushbutton2.
function pushbutton2_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
cla(handles.axes2);
cla(handles.axes3);
cla(handles.axes4);

handles.distancetohole = randi([100,200],1);
handles.zdistancetohole = randi([-150,100],1);

x = handles.distancetohole;
z = handles.zdistancetohole;


plot(handles.axes2,z,x,'o','MarkerSize',7,'Color','b')
axis(handles.axes2,[-150,150,0,300])
grid(handles.axes2,'on')
hold on
plot(handles.axes3,x,0,'o','MarkerSize',7,'Color','b')
axis(handles.axes3,[0,300,0,70])
grid(handles.axes3,'on')
hold on
plot3(handles.axes4,z,x,0,'o','MarkerSize',7,'Color','b')
axis(handles.axes4,[-150,150,0,300,0,70])
grid(handles.axes4,'on')
hold on


r = num2str(sqrt(x^2 + z^2));
set(handles.text11,'String',r);


guidata(hObject, handles);



% --- Executes on slider movement.
function slider3_Callback(hObject, eventdata, handles)
% hObject    handle to slider3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
swing = round(handles.slider3.Value * 100);
set(handles.text15,'String',swing);


%Hole
cla(handles.axes2);
x = handles.distancetohole;
z = handles.zdistancetohole;

%Top view
plot(handles.axes2,z,x,'o','MarkerSize',7,'Color','b')
axis(handles.axes2,[-150,150,0,300])
grid(handles.axes2,'on')
ax2 = handles.axes2;
hold(ax2,'on')

%Quiver for windspeed and angle
handles.winddir = get(handles.slider2,'Value');
handles.windspeed = get(handles.slider1,'Value');
axes(handles.axes2);
drawArrow = @(x,y,props) quiver( x(1),y(1),x(2)-x(1),y(2)-y(1),0, props{:} );
wind_angle = (handles.winddir - 90) * -1; % degrees

pointx = (handles.windspeed)*cos(wind_angle*pi/180)+100;
pointy = (handles.windspeed)*sin(wind_angle*pi/180)+250;
x1 = [100 pointx];
y1 = [250 pointy];
drawArrow(x1,y1,{'MaxHeadSize',2,'Color','g','LineWidth',2});
axis(handles.axes2,[-150,150,0,300])
grid(handles.axes2,'on')

%Quiver for swing power and angle
handles.swingangle = get(handles.slider4,'Value');
handles.swingpower = get(handles.slider3,'Value');
axes(handles.axes2);
drawArrow = @(x,y,props) quiver( x(1),y(1),x(2)-x(1),y(2)-y(1),0, props{:} );
swing_angle = (handles.swingangle * -1) - 360; % degrees

pointx = (handles.swingpower*100)*cosd(swing_angle)+0;
pointy = (handles.swingpower*100)*sind(swing_angle)+0;
x1 = [0 pointx];
y1 = [0 pointy];
drawArrow(x1,y1,{'MaxHeadSize',2,'Color','r','LineWidth',2});
axis(handles.axes2,[-150,150,0,300])
grid(handles.axes2,'on')


guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function slider3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on slider movement.
function slider4_Callback(hObject, eventdata, handles)
% hObject    handle to slider4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
val = round(hObject.Value);
handles.slider4.Value = val;

angle = (handles.slider4.Value + 90);
set(handles.text17,'String',angle);


%Hole
cla(handles.axes2);
x = handles.distancetohole;
z = handles.zdistancetohole;

%Top view
plot(handles.axes2,z,x,'o','MarkerSize',7,'Color','b')
axis(handles.axes2,[-150,150,0,300])
grid(handles.axes2,'on')
ax2 = handles.axes2;
hold(ax2,'on')


%Quiver for windspeed and angle
handles.winddir = get(handles.slider2,'Value');
handles.windspeed = get(handles.slider1,'Value');
axes(handles.axes2);
drawArrow = @(x,y,props) quiver( x(1),y(1),x(2)-x(1),y(2)-y(1),0, props{:} );
wind_angle = (handles.winddir - 90) * -1; % degrees

pointx = (handles.windspeed)*cosd(wind_angle)+100;
pointy = (handles.windspeed)*sind(wind_angle)+250;
x1 = [100 pointx];
y1 = [250 pointy];
drawArrow(x1,y1,{'MaxHeadSize',2,'Color','g','LineWidth',2});
axis(handles.axes2,[-150,150,0,300])
grid(handles.axes2,'on')

%Quiver for swing power and angle
handles.swingangle = get(handles.slider4,'Value');
handles.swingpower = get(handles.slider3,'Value');
axes(handles.axes2);
drawArrow = @(x,y,props) quiver( x(1),y(1),x(2)-x(1),y(2)-y(1),0, props{:} );
swing_angle = (handles.swingangle * -1) - 360; % degrees

pointx = (handles.swingpower*100)*cos(swing_angle*pi/180)+0;
pointy = (handles.swingpower*100)*sin(swing_angle*pi/180)+0;
x1 = [0 pointx];
y1 = [0 pointy];
drawArrow(x1,y1,{'MaxHeadSize',2,'Color','r','LineWidth',2});
axis(handles.axes2,[-150,150,0,300])
grid(handles.axes2,'on')


guidata(hObject, handles);



% --- Executes during object creation, after setting all properties.
function slider4_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on button press in pushbutton4.
function pushbutton4_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
cla(handles.axes2);
cla(handles.axes3);
cla(handles.axes4);

x = 150;
z = 0;
handles.distancetohole = x;
handles.zdistancetohole = z;


plot(handles.axes2,z,x,'o','MarkerSize',7,'Color','b')
axis(handles.axes2,[-150,150,0,300])
grid(handles.axes2,'on')
hold on
plot(handles.axes3,x,0,'o','MarkerSize',7,'Color','b')
axis(handles.axes3,[0,300,0,70])
grid(handles.axes3,'on')
hold on
plot3(handles.axes4,z,x,0,'o','MarkerSize',7,'Color','b')
axis(handles.axes4,[-150,150,0,300,0,70])
grid(handles.axes4,'on')
hold on


r = num2str(sqrt(x^2 + z^2));
set(handles.text11,'String',r);


guidata(hObject, handles);



% --- Executes on button press in pushbutton5.
function pushbutton5_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
cla(handles.axes2);
cla(handles.axes3);
cla(handles.axes4);

x = 300;
z = 0;
handles.distancetohole = x;
handles.zdistancetohole = z;


plot(handles.axes2,z,x,'o','MarkerSize',7,'Color','b')
axis(handles.axes2,[-150,150,0,300])
grid(handles.axes2,'on')
hold on
plot(handles.axes3,x,0,'o','MarkerSize',7,'Color','b')
axis(handles.axes3,[0,300,0,70])
grid(handles.axes3,'on')
hold on
plot3(handles.axes4,z,x,0,'o','MarkerSize',7,'Color','b')
axis(handles.axes4,[-150,150,0,300,0,70])
grid(handles.axes4,'on')
hold on


r = num2str(sqrt(x^2 + z^2));
set(handles.text11,'String',r);


guidata(hObject, handles);


% --- Executes on button press in radiobutton1.
function radiobutton1_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radiobutton1
driver = get(hObject,'Value');
if driver == 1
    handles.club = "D";
end

guidata(hObject,handles);


% --- Executes on button press in radiobutton2.
function radiobutton2_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radiobutton2
wood2 = get(hObject,'Value');
if wood2 == 1
    handles.club = "2W";
end

guidata(hObject,handles);


% --- Executes on button press in radiobutton3.
function radiobutton3_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radiobutton3
wood3 = get(hObject,'Value');
if wood3 == 1
    handles.club = "3W";
end

guidata(hObject,handles);

% --- Executes on button press in radiobutton4.
function radiobutton4_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radiobutton4
wood4 = get(hObject,'Value');
if wood4 == 1
    handles.club = "4W";
end

guidata(hObject,handles);


% --- Executes on button press in radiobutton5.
function radiobutton5_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radiobutton5
wood5 = get(hObject,'Value');
if wood5 == 1
    handles.club = "5W";
end

guidata(hObject,handles);


% --- Executes on button press in radiobutton6.
function radiobutton6_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radiobutton6
wood6 = get(hObject,'Value');
if wood6 == 1
    handles.club = "6W";
end

guidata(hObject,handles);


% --- Executes on button press in radiobutton7.
function radiobutton7_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radiobutton7
wood7 = get(hObject,'Value');
if wood7 == 1
    handles.club = "7W";
end

guidata(hObject,handles);

% --- Executes on button press in radiobutton8.
function radiobutton8_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radiobutton8
iron3 = get(hObject,'Value');
if iron3 == 1
    handles.club = "3I";
end

guidata(hObject,handles);


% --- Executes on button press in radiobutton9.
function radiobutton9_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton9 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radiobutton9
iron4 = get(hObject,'Value');
if iron4 == 1
    handles.club = "4I";
end


guidata(hObject,handles);

% --- Executes on button press in radiobutton10.
function radiobutton10_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton10 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radiobutton10
iron5 = get(hObject,'Value');
if iron5 == 1
    handles.club = "5I";
end


guidata(hObject,handles);

% --- Executes on button press in radiobutton11.
function radiobutton11_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton11 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radiobutton11
iron6 = get(hObject,'Value');
if iron6 == 1
    handles.club = "6I";
end

guidata(hObject,handles);

% --- Executes on button press in radiobutton12.
function radiobutton12_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton12 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radiobutton12
iron7 = get(hObject,'Value');
if iron7 == 1
    handles.club = "7I";
end

guidata(hObject,handles);

% --- Executes on button press in radiobutton13.
function radiobutton13_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton13 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radiobutton13
% --- Executes on button press in radiobutton12.
iron8 = get(hObject,'Value');
if iron8 == 1
    handles.club = "8I";
end

guidata(hObject,handles);


% --- Executes on button press in radiobutton14.
function radiobutton14_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton14 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radiobutton14
iron9 = get(hObject,'Value');
if iron9 == 1
    handles.club = "9I";
end


guidata(hObject,handles);


% --- Executes on button press in radiobutton15.
function radiobutton15_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton15 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radiobutton15
wedge = get(hObject,'Value');
if wedge == 1
    handles.club = "PW";
end


guidata(hObject,handles);


function xdot = golfeom(t,x)

g = 9.81;
Cd = 0.3;
rho = 1.225; %kg/m^3
m = 0.0459; %kg
r = 0.02135; %m
A = pi*r^2; %m^2

xpos = x(1);
ypos = x(2);
zpos = x(3);
velx = x(4);
vely = x(5);
velz = x(6);
windx = x(7);
windy = x(8);
windz = x(9);
spinx = x(10);
spiny = x(11);
spinz = x(12);

vrx = velx - windx;
vry = vely - windy;
vrz = velz - windz;


xdot(1) = vrx + windx;
xdot(2) = vry + windy;
xdot(3) = vrz + windz;
xdot(4) = -(Cd*rho*A*vrx*abs(vrx))/(2*m) + (r*rho*A*(spiny*vrz-spinz*vry))/(2*m);
xdot(5) = -g - (Cd*rho*A*vry*abs(vry))/(2*m) + (r*rho*A*(spinz*vrx-spinx*vrz))/(2*m);
xdot(6) = -(Cd*rho*A*vrz*abs(vrz))/(2*m) + (r*rho*A*(spinx*vry-spiny*vrx))/(2*m);
xdot(7) = 0;
xdot(8) = 0;
xdot(9) = 0;
xdot(10) = 0;
xdot(11) = 0;
xdot(12) = 0;

xdot = xdot';
