function varargout = viewSignal(varargin)
% VIEWSIGNAL MATLAB code for viewSignal.fig
%      VIEWSIGNAL, by itself, creates a new VIEWSIGNAL or raises the existing
%      singleton*.
%
%      H = VIEWSIGNAL returns the handle to a new VIEWSIGNAL or the handle to
%      the existing singleton*.
%
%      VIEWSIGNAL('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in VIEWSIGNAL.M with the given input arguments.
%
%      VIEWSIGNAL('Property','Value',...) creates a new VIEWSIGNAL or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before viewSignal_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to viewSignal_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help viewSignal

% Last Modified by GUIDE v2.5 30-Sep-2015 22:41:04

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @viewSignal_OpeningFcn, ...
                   'gui_OutputFcn',  @viewSignal_OutputFcn, ...
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


% --- Executes just before viewSignal is made visible.
function viewSignal_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to viewSignal (see VARARGIN)

% Choose default command line output for viewSignal
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes viewSignal wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = viewSignal_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;
movegui(handles.figure1,'center');

h=waitbar(0.1,strcat('Getting Input',{' '},'10%'));
set(h,'WindowStyle','modal');

hMainGui = getappdata(0,'hMainGui');
fs = getappdata(hMainGui,'getFs');

plottitle = getappdata(hMainGui,'getPlotTitle');

waitbar(0.2,h,strcat('Plotting Every Signal',{' '},'20%'));
%% normal signal
normal = getappdata(hMainGui,'normalSig');
handles.normal_play = audioplayer(normal,fs);
axes(handles.normal_sig);
N = length(normal); % signal length
n = 0:N-1;
ts = n*(1/fs); % time for signal
plot(ts,normal,'Color','red');
ylim([-1 1]);
xlabel(strcat('Sample Number (fs = ', num2str(fs), ')'));
ylabel('amplitude');
title(strcat('Input Signal'));
set(gca,'FontSize',8,'fontWeight','bold');
set(findall(gcf,'type','text'),'FontSize',8,'fontWeight','bold');

%%
waitbar(0.4,h,strcat('Plotting Every Signal',{' '},'40%'));

%% silence signal
silence = getappdata(hMainGui,'silenceSig');
handles.silence_play = audioplayer(silence,fs);
axes(handles.silence_sig);
N = length(silence); % signal length
n = 0:N-1;
ts = n*(1/fs); % time for signal
plot(ts,silence);
ylim([-1 1]);
xlabel(strcat('Sample Number (fs = ', num2str(fs), ')'));
ylabel('amplitude');
title(strcat('Input Signal for',{' '},plottitle,{' '},'After Silence Removal'));
set(gca,'FontSize',8,'fontWeight','bold');
set(findall(gcf,'type','text'),'FontSize',8,'fontWeight','bold');

pcnt = getappdata(hMainGui,'sil_edit');
set(handles.sil_edit,'String',pcnt);

%%
waitbar(0.5,h,strcat('Plotting Every Signal',{' '},'50%'));

%% noise signal
noise = getappdata(hMainGui,'noiseSig');
handles.noise_play = audioplayer(noise,fs);
axes(handles.noise_sig);
plot(noise);
ylim([-1 1]);
xlabel(strcat('Sample Number (fs = ', num2str(fs), ')'));
ylabel('amplitude');
title(strcat('Input Signal for',{' '},plottitle,{' '},'After Noise Removal'));
set(gca,'FontSize',8,'fontWeight','bold');
set(findall(gcf,'type','text'),'FontSize',8,'fontWeight','bold');

pcnt = getappdata(hMainGui,'noi_edit');
set(handles.noi_edit,'String',pcnt);

%%
waitbar(0.8,h,strcat('Plotting Every Signal',{' '},'80%'));

%% output signal
output = getappdata(hMainGui,'currentSig');
handles.output_play = audioplayer(output,fs);
axes(handles.output_sig);
N = length(output); % signal length
n = 0:N-1;
ts = n*(1/fs); % time for signal
plot(ts,output,'Color',[251 111 66] ./ 255);
ylim([-1 1]);
xlabel(strcat('Sample Number (fs = ', num2str(fs), ')'));
ylabel('amplitude');
title(strcat('Output Signal for',{' '},plottitle));
set(gca,'FontSize',8,'fontWeight','bold');
set(findall(gcf,'type','text'),'FontSize',8,'fontWeight','bold');
%%
waitbar(0.9,h,strcat('Elotting Every Signal',{' '},'90%'));

guidata(hObject,handles);
delete(h);


% --- Executes on button press in play_n.
function play_n_Callback(hObject, eventdata, handles)
% hObject    handle to play_n (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of play_n

isPushed = get(hObject,'Value');
if isPushed
    set(hObject,'String','Pause');
    resume(handles.normal_play);
else
    set(hObject,'String','Play');
    pause(handles.normal_play);
end

% --- Executes on button press in stop_n.
function stop_n_Callback(hObject, eventdata, handles)
% hObject    handle to stop_n (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

stop(handles.normal_play);
set(handles.play_n,'Value',0);
set(handles.play_n,'String','Play');

% --- Executes on button press in play_out.
function play_out_Callback(hObject, eventdata, handles)
% hObject    handle to play_out (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of play_out

isPushed = get(hObject,'Value');
if isPushed
    set(hObject,'String','Pause');
    resume(handles.output_play);
else
    set(hObject,'String','Play');
    pause(handles.output_play);
end

% --- Executes on button press in stop_out.
function stop_out_Callback(hObject, eventdata, handles)
% hObject    handle to stop_out (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

stop(handles.output_play);

set(handles.play_out,'Value',0);
set(handles.play_out,'String','Play');

% --- Executes on button press in play_s.
function play_s_Callback(hObject, eventdata, handles)
% hObject    handle to play_s (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of play_s

isPushed = get(hObject,'Value');
if isPushed
    set(hObject,'String','Pause');
    resume(handles.silence_play);
else
    set(hObject,'String','Play');
    pause(handles.silence_play);
end

% --- Executes on button press in stop_s.
function stop_s_Callback(hObject, eventdata, handles)
% hObject    handle to stop_s (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

stop(handles.silence_play);
set(handles.play_s,'Value',0);
set(handles.play_s,'String','Play');

% --- Executes on button press in play_no.
function play_no_Callback(hObject, eventdata, handles)
% hObject    handle to play_no (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of play_no

isPushed = get(hObject,'Value');
if isPushed
    set(hObject,'String','Pause');
    resume(handles.noise_play);
else
    set(hObject,'String','Play');
    pause(handles.noise_play);
end

% --- Executes on button press in stop_no.
function stop_no_Callback(hObject, eventdata, handles)
% hObject    handle to stop_no (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

stop(handles.noise_play);
set(handles.play_no,'Value',0);
set(handles.play_no,'String','Play');


% --- Executes on button press in back_btn.
function back_btn_Callback(hObject, eventdata, handles)
% hObject    handle to back_btn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

close(handles.figure1);



function sil_edit_Callback(hObject, eventdata, handles)
% hObject    handle to sil_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of sil_edit as text
%        str2double(get(hObject,'String')) returns contents of sil_edit as a double


% --- Executes during object creation, after setting all properties.
function sil_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to sil_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function noi_edit_Callback(hObject, eventdata, handles)
% hObject    handle to noi_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of noi_edit as text
%        str2double(get(hObject,'String')) returns contents of noi_edit as a double


% --- Executes during object creation, after setting all properties.
function noi_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to noi_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
