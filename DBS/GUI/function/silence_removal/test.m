% Computation of ST-ZCR and STE of a speech signal.
%
% Functions required: zerocross, sgn, winconv.
%
% Author: Nabin Sharma
% Date: 2009/03/15

[x, Fs] = audioread('C:\Users\user\Dropbox\Matlab\data\testing\Pre recorded data\Clear\pre-recorded - Automated - Synchronization - Sound1.wav');
x = x.';

N = length(x); % signal length
n = 0:N-1;
ts = n*(1/Fs); % time for signal

% define the window
wintype = 'hamming';
winlen = N+1;
winamp = [0.5,1]*(1/winlen);

% find the zero-crossing rate
zc = zerocross(x,wintype,winamp(1),winlen);

% find the zero-crossing rate
E = energy(x,wintype,winamp(2),winlen);

% time index for the ST-ZCR and STE after delay compensation
out = (winlen-1)/2:(N+winlen-1)-(winlen-1)/2;
t = (out-(winlen-1)/2)*(1/Fs);

figure;
plot(ts,x); hold on;
plot(t,zc(out),'r','Linewidth',2); xlabel('t, seconds');
title('Short-time Zero Crossing Rate');
legend('signal','STZCR');

figure;
plot(ts,x); hold on;
plot(t,E(out),'r','Linewidth',2); xlabel('t, seconds');
title('Short-time Energy');
legend('signal','STE');

frame_len = 0.01*Fs; % 0.01 per frame
    N = length(x);
    num_frames = floor(N/frame_len);
    new_sig = zeros(N,1);
    count = 0;
    
    for k=1:num_frames
       frame = x((k-1)*frame_len+1 : frame_len*k);
       framezc = zc((k-1)*frame_len+1 : frame_len*k);
       
       max_zc = max(framezc);
       max_val = max(frame);
       
       if(max_val >= max_zc)
            count = count+1;
            new_sig((count-1)*frame_len+1 : frame_len*count) = frame;
       end
    end
    
    % remove trailing zero in signal
    zcrste_silence_sig=new_sig(1:find(new_sig, 1, 'last'));
    
figure;
plot(zcrste_silence_sig);