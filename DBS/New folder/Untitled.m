disp('Reading files...');
[x,fs] = audioread('C:\Users\user\Dropbox\Matlab\data\Driver data\raw\khalid_dat1.wav.mp3');

[m,n] = size(x);
if n>1
   x = (x(:,1)+x(:,2))/2;
end
%silence removal at amplitude <0.02
    frame_len = 120*fs; % 0.01 per frame
    N = length(x);
    num_frames = floor(N/frame_len);
    new_sig = zeros(N,1);
    count = 0;
    for k=1:num_frames
       frame = x((k-1)*frame_len+1 : frame_len*k);
       
       audiowrite(strcat('Sound',num2str(k),'.wav'),frame,fs);
       
       calc = floor(k/num_frames * 100);
       disp(strcat(num2str(calc),'%'));
    end 
    
    disp('done!');