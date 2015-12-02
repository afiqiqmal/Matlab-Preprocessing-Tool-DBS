function zcrste_silence_sig = zcrste_removal(fs,get_audio,wintype)
    
    if ~exist('wintype','var')|isempty(wintype)
        wintype = 'hamming';
    elseif isequal(wintype,'rectangle')
        wintype = 'rectwin';
    elseif isequal(wintype,'hamming')
        wintype = 'hamming';
    elseif isequal(wintype,'hanning')
        wintype = 'hanning';
    elseif isequal(wintype,'blackman')
        wintype = 'blackman';
    end

    frame_len = 0.01*fs; % 0.01 per frame
    N = length(get_audio);
    num_frames = floor(N/frame_len);
    new_sig = zeros(N,1);
    count = 0;
    
    [zc,E,out] = zcr_ste(get_audio,wintype);
    out = logical(out);
    zc = zc(out);
    for k=1:num_frames
       frame = get_audio((k-1)*frame_len+1 : frame_len*k);
       framezc = zc((k-1)*frame_len+1 : frame_len*k);
       
       max_zc = max(framezc);
       max_val = max(frame);
       
       if(max_val >= max_zc && max_val>0.001)
            count = count+1;
            new_sig((count-1)*frame_len+1 : frame_len*count) = frame;
       end
    end
    
    % remove trailing zero in signal
    zcrste_silence_sig=new_sig(1:find(new_sig, 1, 'last'));
end