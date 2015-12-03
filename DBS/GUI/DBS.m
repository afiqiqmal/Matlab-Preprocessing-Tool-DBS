function varargout = DBS(varargin)
% DBS MATLAB code for DBS.fig
%      DBS, by itself, creates a new DBS or raises the existing
%      singleton*.
%
%      H = DBS returns the handle to a new DBS or the handle to
%      the existing singleton*.
%
%      DBS('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in DBS.M with the given input arguments.
%
%      DBS('Property','Value',...) creates a new DBS or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before DBS_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to DBS_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help DBS

% Last Modified by GUIDE v2.5 13-Oct-2015 17:32:33

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @DBS_OpeningFcn, ...
                   'gui_OutputFcn',  @DBS_OutputFcn, ...
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


% --- Executes just before DBS is made visible.
function DBS_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to DBS (see VARARGIN)

% Choose default command line output for DBS
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes DBS wait for user response (see UIRESUME)
% uiwait(handles.figure1);

setappdata(0,'hMainGui',gcf);


% --- Outputs from this function are returned to the command line.
function varargout = DBS_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;
movegui(handles.figure1,'center');
list = get(handles.files_list,'String');
if isempty(list)
   set(handles.files_list,'Enable','off');
   set(handles.view_other_sig,'Enable','off');
   set(handles.ste_btn,'Enable','off');
   set(handles.zcrste_btn,'Enable','off');
   set(handles.hcode_btn,'Enable','off');
   set(handles.specsub_filter,'Enable','off');
   set(handles.reco_filter_btn,'Enable','off');
   set(handles.final_plot,'Enable','off');
   set(handles.play_2nd_sig,'Enable','off');
end

% hLogGui = getappdata(0,'hLogGui');
% username = getappdata(hLogGui,'userName');
% set(handles.welcome_text,'string',strcat('Welcome,',username));

function title_Callback(hObject, eventdata, handles)
% hObject    handle to title (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of title as text
%        str2double(get(hObject,'String')) returns contents of title as a double


% --- Executes during object creation, after setting all properties.
function title_CreateFcn(hObject, eventdata, handles)
% hObject    handle to title (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes on selection change in files_list.
function files_list_Callback(hObject, eventdata, handles)
% hObject    handle to files_list (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Hints: contents = cellstr(get(hObject,'String')) returns files_list contents as cell array
%contents{get(hObject,'Value')} returns selected item from files_list
set(handles.ste_text,'String','');
set(handles.hcode_text,'String','');
set(handles.zcrste_text,'String','');
set(handles.specsub_text,'String','');

hMainGui = getappdata(0,'hMainGui');
setappdata(hMainGui,'getPlotTitle','');
setappdata(hMainGui,'normalSig','');
setappdata(hMainGui,'outputSig','');
setappdata(hMainGui,'noiseSig','');
setappdata(hMainGui,'noiwin','');
setappdata(hMainGui,'silenceSig','');
setappdata(hMainGui,'axes2play','');
setappdata(hMainGui,'getFs','');
    
fin = findall(0,'type','axes');
for i=1:length(fin)
    cla(fin(i));
end

set(handles.play_btn,'Value',0);
set(handles.play_btn,'String','Play');

%% making loading
h=waitbar(0.3,strcat('Get Audio Ready',{' '},'30%'));
set(h,'Name','Please Wait');
set(h,'WindowStyle','modal');
waitObj = findobj(h,'Type','Patch');
set(waitObj, 'FaceColor',[0 0 1]);

%% get input
index_selected = get(hObject,'Value');
list = get(hObject,'String');
if isempty(list)
   set(handles.files_list,'Enable','off');
end
handles.item_selected = list{index_selected};
[get_audio,fs] = audioread(strcat(handles.folder_name,...
                '\',handles.item_selected));
[m,n] = size(get_audio);
if n>1
   get_audio = (get_audio(:,1)+get_audio(:,2))/2;
end
handles.audio = get_audio;
handles.player = audioplayer(get_audio,fs);

waitbar(0.4,h,strcat('Plotting Signal',{' '},'40%'));

%% ploting audio signal at first plot axes
N = length(get_audio); % signal length
n = 0:N-1;
ts = n*(1/fs); % time for signal
axes(handles.wave_form);
plot(ts,get_audio,'Color',[251 111 66] ./ 255);
ylim([-1 1]);
xlabel(strcat('Sample Number (fs = ', num2str(fs), ')'));
ylabel('amplitude');
title(strcat('Input Signal for',{' '},handles.item_selected));
set(gca,'FontSize',8,'fontWeight','bold');
set(findall(gcf,'type','text'),'FontSize',8,'fontWeight','bold');

waitbar(0.99,h,strcat('Almost There',{' '},'99%'));

%% Storing to appdata
hMainGui = getappdata(0,'hMainGui');
setappdata(hMainGui,'normalSig',get_audio);
setappdata(hMainGui,'currentSig',get_audio);
setappdata(hMainGui,'getFs',fs);
setappdata(hMainGui,'getPlotTitle',handles.item_selected);


%% global variable pass
msgbox({'1. Please choose your removal technique at right sidebar' '    OR'...
            '2. Click Recommended Run button below right sidebar*' ' '...
            '#####################################'...
            '*NOTE: Recommended Run will auto choose techniques based on percentages and produce output'...
            '######################################'},...
            'NOTE','help','modal');
        
guidata(hObject,handles);
set(handles.view_other_sig,'Enable','on');
set(handles.ste_btn,'Enable','on');
set(handles.zcrste_btn,'Enable','on');
set(handles.hcode_btn,'Enable','on');
set(handles.specsub_filter,'Enable','on');
set(handles.reco_filter_btn,'Enable','on');
set(handles.final_plot,'Enable','on');
set(handles.play_2nd_sig,'Enable','on');
delete(h);

% --- Executes during object creation, after setting all properties.
function files_list_CreateFcn(hObject, eventdata, handles)
% hObject    handle to files_list (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function welcome_text_Callback(hObject, eventdata, handles)
% hObject    handle to welcome_text (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of welcome_text as text
%        str2double(get(hObject,'String')) returns contents of welcome_text as a double


% --- Executes during object creation, after setting all properties.
function welcome_text_CreateFcn(hObject, eventdata, handles)
% hObject    handle to welcome_text (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --------------------------------------------------------------------
function open_Callback(hObject, eventdata, handles)
% hObject    handle to open (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function view_Callback(hObject, eventdata, handles)
% hObject    handle to view (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function help_Callback(hObject, eventdata, handles)
% hObject    handle to help (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function open_dir_Callback(hObject, eventdata, handles)
% hObject    handle to open_dir (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% default folder
folder_name = uigetdir('C:\Users\user\Dropbox\Matlab','');
set(handles.files_list,'Value',1); % set default value 
set(handles.files_list,'String',[]); % clearing first

handles.folder_name = folder_name;
% get all content of the folder
allFiles = dir( folder_name ); 
% get all name of all content
allNames = {allFiles(~[allFiles.isdir]).name};
set(handles.files_list,'String',allNames);
set(handles.files_list,'Enable','on');
guidata(hObject,handles);
% --------------------------------------------------------------------
function open_files_Callback(hObject, eventdata, handles)
% hObject    handle to open_files (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

[filename,path] = uigetfile({'*.wav' 'Wav files';'*.mp3' 'Mp3 Files'},...
                    'Select a file',...
                    'C:\Users\user\Dropbox\Matlab','MultiSelect', 'on');

set(handles.files_list,'Value',1);
set(handles.files_list,'String',[]); % clearing first

% convert to string array
filename = cellstr(filename);

handles.folder_name = path;
set(handles.files_list,'String',filename);
set(handles.files_list,'Enable','on');
guidata(hObject,handles);


% --- Executes on button press in play_btn.
function play_btn_Callback(hObject, eventdata, handles)
% hObject    handle to play_btn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Hint: get(hObject,'Value') returns toggle state of play_btn

isPushed = get(hObject,'Value');
if isPushed
   set(hObject,'String','Pause');
   resume(handles.player);
else
   set(hObject,'String','Play');
   pause(handles.player);
end

% --- Executes on button press in stop_btn.
function stop_btn_Callback(hObject, eventdata, handles)
% hObject    handle to stop_btn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
stop(handles.player);
set(handles.play_btn,'Value',0);
set(handles.play_btn,'String','Play');

% --- Executes on button press in clear_list.
function clear_list_Callback(hObject, eventdata, handles)
% hObject    handle to clear_list (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
list = get(handles.files_list,'String');
if isempty(list)
   set(handles.files_list,'Enable','off');
else
    set(handles.files_list,'Enable','off');
    set(handles.files_list,'String',[]);
    fin = findall(0,'type','axes');
    for i=1:length(fin)
        cla(fin(i));
    end
    set(handles.axes2_pcnt,'String','');
    set(handles.axes2_pcnt_n,'String','');
    set(handles.hcode_text,'String','');
    set(handles.zcrste_text,'String','');
    set(handles.ste_text,'String','');
    set(handles.specsub_text,'String','');
    
    % disable all button
    set(handles.files_list,'Enable','off');
    set(handles.view_other_sig,'Enable','off');
    set(handles.ste_btn,'Enable','off');
    set(handles.zcrste_btn,'Enable','off');
    set(handles.hcode_btn,'Enable','off');
    set(handles.specsub_filter,'Enable','off');
    set(handles.reco_filter_btn,'Enable','off');
    set(handles.final_plot,'Enable','off');
    set(handles.play_2nd_sig,'Enable','off');
    
    
    hMainGui = getappdata(0,'hMainGui');
    setappdata(hMainGui,'getPlotTitle','');
    setappdata(hMainGui,'normalSig','');
    setappdata(hMainGui,'currentSig','');
    setappdata(hMainGui,'outputSig','');
    setappdata(hMainGui,'noiseSig','');
    setappdata(hMainGui,'noiwin','');
    setappdata(hMainGui,'silenceSig','');
    setappdata(hMainGui,'axes2play','');
    setappdata(hMainGui,'getFs','');
    
    clear all;
end

% --- Executes on button press in logout_btn.
function logout_btn_Callback(hObject, eventdata, handles)
% hObject    handle to logout_btn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in view_other_sig.
function view_other_sig_Callback(hObject, eventdata, handles)
% hObject    handle to view_other_sig (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

viewSignal;

% --- Executes on button press in play_2nd_sig.
function play_2nd_sig_Callback(hObject, eventdata, handles)
% hObject    handle to play_2nd_sig (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of play_2nd_sig
hMainGui = getappdata(0,'hMainGui');
audio = getappdata(hMainGui,'axes2play');
fs = getappdata(hMainGui,'getFs');

isPushed = get(hObject,'Value');
if isPushed
    set(hObject,'String','Stop');
    sound(audio,fs);
else
    set(hObject,'String','Play');
    clear sound;
end

% --- Executes on button press in recorder_bttn.
function recorder_bttn_Callback(hObject, eventdata, handles)
% hObject    handle to recorder_bttn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of recorder_bttn
isPushed = get(hObject,'Value');
if isPushed
    set(hObject,'String','Stop Record');
    %create modal dialog
    prompt = {'Enter duration size: *empty to record until stop',...
              'Enter Sampling Rate:*leave empty to default fs',...
              'Enter FFT N-point block size:*leave empty to default FFT'};
    dlg_title = 'Recorder Setting Input';
    num_lines = 1;
    defaultans = {'10s','16000','16000'};
    options.WindowStyle = 'modal';
    answer = inputdlg(prompt,dlg_title,num_lines,defaultans,options);
    
    if ~isempty(answer)
        durat = answer{1};
        if(isnumeric(str2num(durat(1:end-1))) & isnumeric(str2num(answer{1})) &  isnumeric(str2num(answer{3})))
            % start recorder
            [recorder,fs] = audio_recorder(answer{2},answer{1},answer{3});
            % stop recorder when done
            stop(recorder);
            % extract data from audio
            input = getaudiodata(recorder);
            %save files
            [nfname,npath]=uiputfile('.wav','Save sound','new_sound.wav');
            if isequal(nfname,0) || isequal(npath,0)
               return
            else
               nwavfile=fullfile(npath, nfname);
               %loading
               h=waitbar(0.3,strcat('Saving..',{' '},'30%'));
               set(h,'Name','Please Wait');
               set(h,'WindowStyle','modal');
               waitObj = findobj(h,'Type','Patch');
               set(waitObj, 'FaceColor',[0 0 1]);

               %writing files
               audiowrite(nwavfile,input,fs,'BitsPerSample',recorder.BitsPerSample,...
                   'Comment','This is new recorded audio file.');

               %removing waitbar
               waitbar(0.99,h,strcat('Almost There',{' '},'99%'));
               delete(h);
            end

            %add to listbox
            set(handles.files_list,'Value',1);
            set(handles.files_list,'String',[]); % clearing first
            nfname = cellstr(nfname);
            handles.folder_name = npath;
            set(handles.files_list,'String',nfname);
            set(handles.files_list,'Enable','on');
        end
                
        
        %reset button
        set(hObject,'String','Start Record');
        set(hObject,'Value',0);
    else
        set(hObject,'String','Start Record');
        set(hObject,'Value',0);
    end
    
end
guidata(hObject,handles);


function axes2_pcnt_CreateFcn(hObject, eventdata, handles)
% hObject    handle to axes2_pcnt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes during object creation, after setting all properties.
function axes2_pcnt_n_CreateFcn(hObject, eventdata, handles)
% hObject    handle to axes2_pcnt_n (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes on button press in zcrste_btn.
function zcrste_btn_Callback(hObject, eventdata, handles)
% hObject    handle to zcrste_btn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
hMainGui = getappdata(0,'hMainGui');
audio = getappdata(hMainGui,'currentSig');
fs = getappdata(hMainGui,'getFs');


Title = 'Windowing';
%%%% SETTING DIALOG OPTIONS
Options.WindowStyle = 'modal';
Options.Resize = 'off';
Options.Interpreter = 'tex';
Options.CancelButton = 'on';
Options.ApplyButton = 'off';
Options.ButtonNames = {'Apply','Cancel'}; %<- default names, included here just for illustration
Option.Dim = 4; % Horizontal dimension in fields

Prompt = {};
Formats = {};
DefAns = {};

Prompt = {'Choose Windowing type?','Windowing',[]};
Formats.type = 'list';
Formats.format = 'text';
Formats.style = 'radiobutton';
Formats.items = {'hamming' 'hanning';'blackman' 'rectangle'};
DefAns.Windowing = '';

[Answer,Cancelled] = inputsdlg(Prompt,Title,Formats,DefAns,Options);

    if Cancelled ~= 1
        wind = Answer.Windowing;
        h=waitbar(0.1,strcat('ZCR STE Implementation with',{' '},wind,{' '},'10%'));
        set(h,'Name','Please Wait');
        set(h,'WindowStyle','modal');
        waitObj = findobj(h,'Type','Patch');
        set(waitObj, 'FaceColor',[0 0 1]);

        set(handles.current_sil,'String',strcat('Current: Short Term Zero Crossing with',{' '},wind,{' '},'windowing'));
        no_silence_sig = zcrste_removal(fs,audio,wind);

        waitbar(0.4,h,strcat('ZCR STE Truncating Signal',{' '},'40%'));
        N = length(no_silence_sig); % signal length
        n = 0:N-1;
        ts = n*(1/fs); % time for signal
        axes(handles.axes2);
        plot(ts,no_silence_sig);
        ylim([-1 1]);
        
        xlabel(strcat('Sample Number (fs = ', num2str(fs), ')'));
        ylabel('amplitude');
        title(strcat('Input Signal for',{' '},handles.item_selected,{' '},'After Silence Removal using ZCR STE with',{' '},wind,{' '},'windowing'));
        set(gca,'FontSize',8,'fontWeight','bold');
        set(findall(gcf,'type','text'),'FontSize',8,'fontWeight','bold');
        waitbar(0.7,h,strcat('ZCR STE Truncating Signal',{' '},'70%'));

        percentage = 100 - (length(no_silence_sig)/ length(audio)) * 100;
        pcnt = strcat(num2str(sprintf('%.2f',percentage)),'%');
        set(handles.axes2_pcnt,'String',pcnt);
        set(handles.zcrste_text,'String',pcnt);
        set(handles.text_pcnt_axes2,'String',strcat('Percentage of silent remove by ZCR STE with',{' '},wind,{' '},'windowing'));
        setappdata(hMainGui,'silenceSig',no_silence_sig);
        setappdata(hMainGui,'currentSig',no_silence_sig); %current
        setappdata(hMainGui,'axes2play',no_silence_sig);
        waitbar(0.99,h,strcat('ZCR STE Done!',{' '},'99%'));
        delete(h);
        
        set(handles.sil_current_txt,'String','Selected Silence : ZCR+STE');
        
    end
   
% --- Executes on button press in hcode_btn.
function hcode_btn_Callback(hObject, eventdata, handles)
% hObject    handle to hcode_btn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
hMainGui = getappdata(0,'hMainGui');
audio = getappdata(hMainGui,'currentSig');
fs = getappdata(hMainGui,'getFs');

    prompt = {'Remove Amplitude Value Lower than:'};
    dlg_title = 'Amplitude Range';
    num_lines = 1;
    defaultans = {'0.02'};
    options.WindowStyle = 'modal';
    answer = inputdlg(prompt,dlg_title,num_lines,defaultans,options);

    if ~isempty(answer)
        if isnumeric(str2double(answer{1}))
            level = str2double(answer{1});
            h=waitbar(0.1,strcat('Hard Code Implementation',{' '},'10%'));
            set(h,'Name','Please Wait');
            set(h,'WindowStyle','modal');
            waitObj = findobj(h,'Type','Patch');
            set(waitObj, 'FaceColor',[0 0 1]);

            set(handles.current_sil,'String',strcat('Current: Hard Code Removal amplitude below',{' '},answer{1}));
            no_silence_sig = silence_removal(fs,audio,level);

            waitbar(0.4,h,strcat('Hard Code Truncating Signal',{' '},'40%'));

            N = length(no_silence_sig); % signal length
            n = 0:N-1;
            ts = n*(1/fs); % time for signal
            axes(handles.axes2);
            plot(ts,no_silence_sig);
            ylim([-1 1]);
            
            xlabel(strcat('Sample Number (fs = ', num2str(fs), ')'));
            ylabel('amplitude');
            title(strcat('Input Signal for',{' '},handles.item_selected,{' '},'After Silence Removal with Hard code below',{' '},answer{1}));
            set(gca,'FontSize',8,'fontWeight','bold');
            set(findall(gcf,'type','text'),'FontSize',8,'fontWeight','bold');

            waitbar(0.7,h,strcat('Hard Code Truncating Signal',{' '},'70%'));

            percentage = 100 - (length(no_silence_sig)/ length(audio)) * 100;
            pcnt = strcat(num2str(sprintf('%.2f',percentage)),'%');
            set(handles.axes2_pcnt,'String',pcnt);
            set(handles.hcode_text,'String',pcnt);
            set(handles.text_pcnt_axes2,'String',strcat('Percentage of silent remove by Hard Code below',{' '},answer{1}));

            setappdata(hMainGui,'silenceSig',no_silence_sig);
            setappdata(hMainGui,'currentSig',no_silence_sig); %current
            setappdata(hMainGui,'axes2play',no_silence_sig);
            
            waitbar(0.99,h,strcat('Hard Code Done!',{' '},'99%'));

            delete(h);
            
            set(handles.sil_current_txt,'String','Selected Silence : Hard Code');
        end
    end
% --- Executes on button press in ste_btn.
function ste_btn_Callback(hObject, eventdata, handles)
% hObject    handle to ste_btn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

hMainGui = getappdata(0,'hMainGui');
audio = getappdata(hMainGui,'currentSig');
fs = getappdata(hMainGui,'getFs');


Title = 'Windowing';
%%%% SETTING DIALOG OPTIONS
Options.WindowStyle = 'modal';
Options.Resize = 'off';
Options.Interpreter = 'tex';
Options.CancelButton = 'on';
Options.ApplyButton = 'off';
Options.ButtonNames = {'Apply','Cancel'}; %<- default names, included here just for illustration
Option.Dim = 4; % Horizontal dimension in fields

Prompt = {};
Formats = {};
DefAns = {};

Prompt = {'Choose Windowing type?','Windowing',[]};
Formats.type = 'list';
Formats.format = 'text';
Formats.style = 'radiobutton';
Formats.items = {'hamming' 'hanning';'blackman' 'rectangle'};
DefAns.Windowing = '';

[Answer,Cancelled] = inputsdlg(Prompt,Title,Formats,DefAns,Options);

    if Cancelled ~= 1
        wind = Answer.Windowing;
        h=waitbar(0.1,strcat('STE Implementation with',{' '},wind,{' '},'10%'));
        set(h,'Name','Please Wait');
        set(h,'WindowStyle','modal');
        waitObj = findobj(h,'Type','Patch');
        set(waitObj, 'FaceColor',[0 0 1]);

        set(handles.current_sil,'String',strcat('Current: Short Term Energy with',{' '},wind,{' '},'windowing'));
        no_silence_sig = ste_removal(fs,audio,wind);

        waitbar(0.4,h,strcat('STE Truncating Signal',{' '},'40%'));

        N = length(no_silence_sig); % signal length
        n = 0:N-1;
        ts = n*(1/fs); % time for signal
        axes(handles.axes2);
        plot(ts,no_silence_sig);
        ylim([-1 1]);
        
        xlabel(strcat('Sample Number (fs = ', num2str(fs), ')'));
        ylabel('amplitude');
        title(strcat('Input Signal for',{' '},handles.item_selected,{' '},'After Silence Removal using STE with',{' '},wind,{' '},'windowing'));
        set(gca,'FontSize',8,'fontWeight','bold');
        set(findall(gcf,'type','text'),'FontSize',8,'fontWeight','bold');

        waitbar(0.7,h,strcat('STE Truncating Signal',{' '},'70%'));

        percentage = 100 - (length(no_silence_sig)/ length(audio)) * 100;
        pcnt = strcat(num2str(sprintf('%.2f',percentage)),'%');
        set(handles.axes2_pcnt,'String',pcnt);
        set(handles.ste_text,'String',pcnt);
        set(handles.text_pcnt_axes2,'String',strcat('Percentage of silent remove by STE with',{' '},wind,{' '},'windowing'));

        setappdata(hMainGui,'silenceSig',no_silence_sig);
        setappdata(hMainGui,'currentSig',no_silence_sig); %current
        setappdata(hMainGui,'axes2play',no_silence_sig);
        
        waitbar(0.99,h,strcat('STE Done!',{' '},'99%'));

        delete(h);
        
        set(handles.sil_current_txt,'String','Selected Silence : STE');
    end

% --- Executes on button press in specsub_filter.
function specsub_filter_Callback(hObject, eventdata, handles)
% hObject    handle to specsub_filter (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
hMainGui = getappdata(0,'hMainGui');
audio = getappdata(hMainGui,'currentSig');
fs = getappdata(hMainGui,'getFs');


Title = 'Windowing for Spectral Subtraction';
%%%% SETTING DIALOG OPTIONS
Options.WindowStyle = 'modal';
Options.Resize = 'off';
Options.Interpreter = 'tex';
Options.CancelButton = 'on';
Options.ApplyButton = 'off';
Options.ButtonNames = {'Apply','Cancel'}; %<- default names, included here just for illustration
Option.Dim = 4; % Horizontal dimension in fields

Prompt = {};
Formats = {};
DefAns = {};

Prompt = {'Choose Windowing type?','Windowing',[]};
Formats.type = 'list';
Formats.format = 'text';
Formats.style = 'radiobutton';
Formats.items = {'hamming' 'hanning';'blackman' 'rectangle'};
DefAns.Windowing = '';

[Answer,Cancelled] = inputsdlg(Prompt,Title,Formats,DefAns,Options);

if Cancelled ~= 1
   wind = Answer.Windowing;
   setappdata(hMainGui,'noiwin',wind);
   set(handles.current_sil,'String',strcat('Current: Spectral Subtraction with',{' '},wind));
   
   h=waitbar(0.1,strcat('Spectral Subtraction Implementation with',{' '},wind,{' '},'10%'));
   set(h,'Name','Please Wait');
   set(h,'WindowStyle','modal');
   waitObj = findobj(h,'Type','Patch');
   set(waitObj, 'FaceColor',[0 0 1]);
   
   waitbar(0.5,h,strcat('Enchancing Noise Estimation...',{' '},'50%'));
   no_noise_sig = specsubtrac(mat2vec(audio),fs,wind);
   
   waitbar(0.6,h,strcat('Enchancing Noise Estimation...',{' '},'60%'));
   N = length(no_noise_sig); % signal length
   n = 0:N-1;
   ts = n*(1/fs); % time for signal
   axes(handles.axes2);
   plot(ts,no_noise_sig);
   ylim([-1 1]);
   
   xlabel(strcat('Sample Number (fs = ', num2str(fs), ')'));
   ylabel('amplitude');
   title(strcat('Input Signal for',{' '},handles.item_selected,{' '},'After Noise Removal using Spectral Subtraction with',{' '},wind,{' '},'windowing'));
   set(gca,'FontSize',8,'fontWeight','bold');
   set(findall(gcf,'type','text'),'FontSize',8,'fontWeight','bold');
   
   waitbar(0.7,h,strcat('Ploting Spectral Subtraction',{' '},'70%'));
    
   a = zeros(length(audio),1);
   for i = 1:length(audio)
       if audio(i)> no_noise_sig(i)
           per = (audio(i) - no_noise_sig (i));
           a(i) = (per/audio(i));        
       end
   end

   a(a==0) = [];
   a(a==inf) = [];
   percentage = sum(a)/length(audio) * 100;

   pcnt = strcat(num2str(sprintf('%.2f',percentage)),'%');
   set(handles.axes2_pcnt_n,'String',pcnt);
   set(handles.specsub_text,'String',pcnt);
   set(handles.text_pcnt_axes2_n,'String',strcat('Percentage of noise removed by Spectral Subtraction with',{' '},wind,{' '},'windowing'));

   setappdata(hMainGui,'noiseSig',no_noise_sig);
   setappdata(hMainGui,'axes2play',no_noise_sig);
   setappdata(hMainGui,'currentSig',no_noise_sig); %current

   waitbar(0.99,h,strcat('Spectral Subtraction Done!',{' '},'99%'));

   delete(h);
   set(handles.noi_current_txt,'String','Selected Noise : Spectral Subtraction');
end


function hcode_text_Callback(hObject, eventdata, handles)
% hObject    handle to hcode_text (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of hcode_text as text
%        str2double(get(hObject,'String')) returns contents of hcode_text as a double


% --- Executes during object creation, after setting all properties.
function hcode_text_CreateFcn(hObject, eventdata, handles)
% hObject    handle to hcode_text (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function ste_text_Callback(hObject, eventdata, handles)
% hObject    handle to ste_text (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of ste_text as text
%        str2double(get(hObject,'String')) returns contents of ste_text as a double


% --- Executes during object creation, after setting all properties.
function ste_text_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ste_text (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function zcrste_text_Callback(hObject, eventdata, handles)
% hObject    handle to zcrste_text (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of zcrste_text as text
%        str2double(get(hObject,'String')) returns contents of zcrste_text as a double


% --- Executes during object creation, after setting all properties.
function zcrste_text_CreateFcn(hObject, eventdata, handles)
% hObject    handle to zcrste_text (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function specsub_text_Callback(hObject, eventdata, handles)
% hObject    handle to specsub_text (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of specsub_text as text
%        str2double(get(hObject,'String')) returns contents of specsub_text as a double


% --- Executes during object creation, after setting all properties.
function specsub_text_CreateFcn(hObject, eventdata, handles)
% hObject    handle to specsub_text (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in noicancel_filter.
function noicancel_filter_Callback(hObject, eventdata, handles)
% hObject    handle to noicancel_filter (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)



function noican_text_Callback(hObject, eventdata, handles)
% hObject    handle to noican_text (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of noican_text as text
%        str2double(get(hObject,'String')) returns contents of noican_text as a double


% --- Executes during object creation, after setting all properties.
function noican_text_CreateFcn(hObject, eventdata, handles)
% hObject    handle to noican_text (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in final_plot.
function final_plot_Callback(hObject, eventdata, handles)
% hObject    handle to final_plot (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

hMainGui = getappdata(0,'hMainGui');
fs = getappdata(hMainGui,'getFs');
output = getappdata(hMainGui,'currentSig');

if isempty(getappdata(hMainGui,'silenceSig'))
    msgbox('Please select silence technique!','Error','error','modal');
elseif isempty(getappdata(hMainGui,'noiseSig'))
    msgbox('Please select noise technique!','Error','error','modal');
else 
    temp = handles.item_selected(1:end-4);
    new_files = strcat(temp,'_output_clean.wav');
    [nfname,npath]=uiputfile('.wav','Save output',new_files);
    if isequal(nfname,0) || isequal(npath,0)
        return
    else
        %loading
        h=waitbar(0.3,strcat('Saving..',{' '},'30%'));
        set(h,'Name','Please Wait');
        set(h,'WindowStyle','modal');
        waitObj = findobj(h,'Type','Patch');
        set(waitObj, 'FaceColor',[0 0 1]);
        
        disp(new_files);
        nwavfile=fullfile(npath, nfname);
               
        %writing files
        audiowrite(nwavfile,output,fs,'Comment','This is new output files.');

        %removing waitbar
        waitbar(0.99,h,strcat('Almost There',{' '},'99%'));
        delete(h);
    end
end


% --- Executes on button press in reco_filter_btn.
function reco_filter_btn_Callback(hObject, eventdata, handles)
% hObject    handle to reco_filter_btn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

    set(handles.current_sil,'String','Current: Recommended Run');
    hMainGui = getappdata(0,'hMainGui');
    audio = getappdata(hMainGui,'normalSig');
    fs = getappdata(hMainGui,'getFs'); 
    
    h=waitbar(0.1,strcat('Start Generate',{' '},'10%'));
    set(h,'Name','Please Wait');
    set(h,'WindowStyle','modal');
    waitObj = findobj(h,'Type','Patch');
    set(waitObj, 'FaceColor',[0 0 1]);
    
    set(handles.current_sil,'String','Current: Removing with all techniques');
    
    % windows
    wind = [{'hamming'} {'hanning'} {'blackman'} {'rectangle'}];
    get = cellstr(wind);
    
    set(handles.current_sil,'String','Current: Noise removal');
    
    %% remove silence signal
    set(handles.current_sil,'String','Current: Silence removal');
    
    waitbar(0.15,h,strcat('Start Implementing Silence Removal Techniques',{' '},'15%'));
    % ste
    count = zeros(4,1);
    storeA = cell(4,1);
    for i=1:length(wind)
        waitbar(0.2,h,strcat('Implementing STE with',{' '},char(get(i)),{' '},'20%'));
        temp = ste_removal(fs,audio,char(get(i)));
        storeA(i) = {temp};
        count(i) = 100 - (length(storeA{i})/ length(audio)) * 100;
    end
    [getmax,~] = find(count==max(count(:)));
    bigste = max(count);
    ste = [{char(get(getmax))} {num2str(bigste)}];
    no1 = storeA{getmax};
    
    pcnt = strcat(num2str(sprintf('%.2f',bigste)),'%');
    set(handles.ste_text,'String',pcnt);
    
    silste = bigste;
    
    % zcrste
    count = zeros(4,1);
    storeA = cell(4,1);
    for i=1:length(wind)
        waitbar(0.4,h,strcat('Implementing ZCR STE with',{' '},char(get(i)),{' '},'40%'));
        temp = zcrste_removal(fs,audio,char(get(i)));
        storeA(i) = {temp};
        count(i) = 100 - (length(storeA{i})/ length(audio)) * 100;
    end
    [getmax,~] = find(count==max(count(:)));
    bigzcrste = max(count);
    zcrste = [{char(get(getmax))} {num2str(bigzcrste)}];
    no2 = storeA{getmax};
    
    pcnt = strcat(num2str(sprintf('%.2f',bigzcrste)),'%');
    set(handles.zcrste_text,'String',pcnt);
    
    silzcrste = bigzcrste;
        
    % hard code
    no3 = silence_removal(fs,audio);
    waitbar(0.5,h,strcat('Implementing Hard Code < 0.2',{' '},'50%'));
    percentage = 100 - (length(no3)/ length(audio)) * 100;
    pcnt = strcat(num2str(sprintf('%.2f',percentage)),'%');
    set(handles.hcode_text,'String',pcnt);
    silhard = percentage;
    
    % display
    set(handles.current_sil,'String','Current: Choosing most silence removed by percentage');
    waitbar(0.6,h,strcat('Choosing most silence removed by percentage',{' '},'60%'));
    
    % choose most removed silence by percentage
    valuep = [silste silzcrste silhard];
    [~,getm] = find(valuep==max(valuep(:)));
    pau = {};
    if getm == 1
       init = cellstr(ste);
       getwin = char(init(1));
       getpcnt = str2double(char(init(2)));
       set(handles.text_pcnt_axes2,'String',strcat('Percentage of silence removed by STE with',{' '},getwin,{' '},'windowing'));
       
       %set appdata
       pcnt = strcat(num2str(sprintf('%.2f',getpcnt)),'%');
       set(handles.axes2_pcnt,'String',pcnt);
       setappdata(hMainGui,'sil_edit',pcnt);
       pau = no1;
       setappdata(hMainGui,'silenceSig',pau);
       setappdata(hMainGui,'noiwin',getwin);
    elseif getm == 2
       init = cellstr(zcrste);
       getwin = char(init(1));
       getpcnt = str2double(char(init(2)));
       set(handles.text_pcnt_axes2,'String',strcat('Percentage of silence removed by ZCR STE with',{' '},getwin,{' '},'windowing'));
       
       %set appdata
       pcnt = strcat(num2str(sprintf('%.2f',getpcnt)),'%');
       set(handles.axes2_pcnt,'String',pcnt);
       setappdata(hMainGui,'sil_edit',pcnt);
       pau = no2;
       setappdata(hMainGui,'silenceSig',pau);
       setappdata(hMainGui,'noiwin',getwin);
    elseif getm == 3
       set(handles.text_pcnt_axes2,'String',strcat('Percentage of silence removed by Hard Code below 0.2'));
       
       %set appdata
       pcnt = strcat(num2str(sprintf('%.2f',percentage)),'%');
       set(handles.axes2_pcnt,'String',pcnt);
       setappdata(hMainGui,'sil_edit',pcnt);
       pau = no3;
       setappdata(hMainGui,'silenceSig',pau);
    end
    
    %% noise removal
    waitbar(0.7,h,strcat('Implementing Noise Removal Techniques',{' '},'70%'));
    
    count = zeros(4,1);
    storeA = cell(4,1);
    storeDis = cell(4,1); % display purpose at view signal GUI
    for g=1:length(wind)
        set(handles.current_sil,'String',strcat('Current: Spectral Subtraction Calculating with',{' '},char(get(g))));
        waitbar(0.8,h,strcat('Spectral Subtraction with',{' '},char(get(g)),{' '},'80%'));
    
        %%%%%%%%%%%%%
        temps = specsubtrac(mat2vec(audio),fs,char(get(g)));
        storeDis(g) = {temps};
        %%%%%%%%%%%%%
        temps = specsubtrac(mat2vec(pau),fs,char(get(g)));
        storeA(g) = {temps};
        
        temp = storeA{g};
        a = zeros(length(pau),1);
        for i = 1:length(pau)
            if pau(i)> temp(i)
                per = (pau(i) - temp(i));
                a(i) = (per/pau(i));        
            end
        end
        a(a==0) = [];
        a(a==inf) = [];
        count(g) = sum(a)/length(pau) * 100;
    end
    [getmax,~] = find(count==max(count(:)));
    bigspec = max(count);
    specsub = [{char(get(getmax))} {num2str(bigspec)}];
    getspec = cellstr(specsub);
    getwin = char(getspec(1));
    getpcnt = str2double(char(getspec(2)));
    
    output_sig = storeA{getmax}; % Output clean signal
    clean_noise = storeDis{getmax}; % audio after noise removal
    
    set(handles.text_pcnt_axes2_n,'String',strcat('Percentage of noise removed by Spectral Subtraction with',{' '},getwin,{' '},'windowing'));    
    pcnt = strcat(num2str(sprintf('%.2f',getpcnt)),'%');
    set(handles.specsub_text,'String',pcnt);
    set(handles.axes2_pcnt_n,'String',pcnt);
    
    %set appdata
    setappdata(hMainGui,'noi_edit',pcnt);
    setappdata(hMainGui,'noiwin',getwin);
    setappdata(hMainGui,'noiseSig',clean_noise);
    setappdata(hMainGui,'outputSig',output_sig);
    setappdata(hMainGui,'axes2play',output_sig);
    
    set(handles.current_sil,'String','Current: Plotting Final Output');
    waitbar(0.9,h,strcat('Plotting Final Output',{' '},'90%'));
    N = length(output_sig); % signal length
    n = 0:N-1;
    ts = n*(1/fs); % time for signal
    axes(handles.axes2);
    plot(ts,output_sig);
    ylim([-1 1]);
    xlabel(strcat('Sample Number (fs = ', num2str(fs), ')'));
    ylabel('amplitude');
    title(strcat('Final Output Signal for',{' '},handles.item_selected,{' '}));
    set(gca,'FontSize',8,'fontWeight','bold');
    set(findall(gcf,'type','text'),'FontSize',8,'fontWeight','bold');
    
    set(handles.current_sil,'String','Current: Recommeded Run Finish');
    waitbar(0.99,h,strcat('Done!',{' '},'99%'));
    delete(h);
    
    
    temp = handles.item_selected(1:end-4);
    new_files = strcat(temp,'_output_clean.wav');
    [nfname,npath]=uiputfile('.wav','Save output',new_files);
    if isequal(nfname,0) || isequal(npath,0)
        return
    else
        %loading
        h=waitbar(0.3,strcat('Saving..',{' '},'30%'));
        set(h,'Name','Please Wait');
        set(h,'WindowStyle','modal');
        waitObj = findobj(h,'Type','Patch');
        set(waitObj, 'FaceColor',[0 0 1]);
        
        disp(new_files);
        nwavfile=fullfile(npath, nfname);
               
        %writing files
        audiowrite(nwavfile,output_sig,fs,'Comment','This is new output files.');

        %removing waitbar
        waitbar(0.99,h,strcat('Almost There',{' '},'99%'));
        delete(h);
    end
