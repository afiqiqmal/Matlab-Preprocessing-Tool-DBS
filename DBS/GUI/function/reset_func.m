function reset_func(hObject, eventdata, handles)
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
end