function varargout = LoginGui(varargin)
% LOGINGUI MATLAB code for LoginGui.fig
%      LOGINGUI, by itself, creates a new LOGINGUI or raises the existing
%      singleton*.
%
%      H = LOGINGUI returns the handle to a new LOGINGUI or the handle to
%      the existing singleton*.
%
%      LOGINGUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in LOGINGUI.M with the given input arguments.
%
%      LOGINGUI('Property','Value',...) creates a new LOGINGUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before LoginGui_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to LoginGui_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help LoginGui

% Last Modified by GUIDE v2.5 01-Sep-2015 15:51:47

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @LoginGui_OpeningFcn, ...
                   'gui_OutputFcn',  @LoginGui_OutputFcn, ...
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


% --- Executes just before LoginGui is made visible.
function LoginGui_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to LoginGui (see VARARGIN)

% Choose default command line output for LoginGui
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes LoginGui wait for user response (see UIRESUME)
% uiwait(handles.figure1);

setappdata(0,'hLogGui',gcf);

% --- Outputs from this function are returned to the command line.
function varargout = LoginGui_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;

%% setup figure
base_color = (rand(1,3)+rand(1,3))./2;
position = get(0,'screensize');
pos=get(handles.figure1,'Position');
height = pos(4);
width = pos(3);

movegui(handles.figure1,'center');
set(handles.figure1,'Color',base_color);
set(handles.user_tag,'backgroundColor',base_color);
set(handles.pass_tag,'backgroundColor',base_color);

function username_Callback(hObject, eventdata, handles)
% hObject    handle to username (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of username as text
%        str2double(get(hObject,'String')) returns contents of username as a double



% --- Executes during object creation, after setting all properties.
function username_CreateFcn(hObject, eventdata, handles)
% hObject    handle to username (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function password_Callback(hObject, eventdata, handles)
% hObject    handle to password (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of password as text
%        str2double(get(hObject,'String')) returns contents of password as a double


% --- Executes during object creation, after setting all properties.
function password_CreateFcn(hObject, eventdata, handles)
% hObject    handle to password (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on key press with focus on password and none of its controls.
function password_KeyPressFcn(hObject, eventdata, handles)
% hObject    handle to password (see GCBO)
% eventdata  structure with the following fields (see MATLAB.UI.CONTROL.UICONTROL)
%	Key: name of the key that was pressed, in lower case
%	Character: character interpretation of the key(s) that was pressed
%	Modifier: name(s) of the modifier key(s) (i.e., control, shift) pressed
% handles    structure with handles and user data (see GUIDATA)
    password = get(handles.password,'Userdata');
    key = get(handles.figure1,'currentkey');
        switch key
            case 'backspace'
                password = password(1:end-1); 
                SizePass = size(password); 
                if SizePass(2) > 0
                    asterisk(1,1:SizePass(2)) = '•';
                    set(handles.password,'String',asterisk); 
                else
                    set(handles.password,'String','');
                end
                set(handles.password,'Userdata',password) %
            case 'escape'
            case 'insert'
            case 'delete'
            case 'home'
            case 'pageup'
            case 'pagedown'
            case 'end'
            case 'rightarrow'
            case 'downarrow'
            case 'leftarrow'
            case 'uparrow'
            case 'shift'
            case 'return'
            case 'alt'
            case 'control'
            case 'windows'
            otherwise
                password = [password get(handles.figure1,'currentcharacter')];
                SizePass = size(password); 
                if SizePass(2) > 0
                    asterisk(1:SizePass(2)) = '•'; 
                    set(handles.password,'string',asterisk) 
                else
                    set(handles.password,'String','');
                end
                set(handles.password,'Userdata',password) ;
        end


% --- Executes on button press in login_btn.
function login_btn_Callback(hObject, eventdata, handles)
% hObject    handle to login_btn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

        ID = get(handles.username,'string')
        PW = get(handles.password,'UserData')
        if strcmp(ID,'afiq') && strcmp(PW,'1234')
            a = msgbox('Login Sucessful');
            hLogGui = getappdata(0,'hLogGui');
            setappdata(hLogGui,'userName',ID);
            run('C:/users/user/Dropbox/Matlab/workspace/DBS/GUI/DBS.m');
            close(handles.figure1);
            delete(a);
        else
            errordlg('Invalid ID or Password');
        end
