function no_silence_sig = silence_removal(fs,get_audio,level)
    
    if ~exist('level','var') | isempty(level)
        level = 0.02;
    end
    %silence removal at amplitude <0.02
    frame_len = 0.01*fs; % 0.01 per frame
    N = length(get_audio);
    num_frames = floor(N/frame_len);
    new_sig = zeros(N,1);
    count = 0;
    for k=1:num_frames
       frame = get_audio((k-1)*frame_len+1 : frame_len*k);
       max_val = max(frame);
       if(max_val > level)
            count = count+1;
            new_sig((count-1)*frame_len+1 : frame_len*count) = frame;
       end
    end    
    % remove trailing zero in signal
    no_silence_sig=new_sig(1:find(new_sig, 1, 'last'));
end