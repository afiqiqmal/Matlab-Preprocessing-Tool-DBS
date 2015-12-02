function [zc,E,out] = zcr_ste(x,wintype)
x = x.';
N = length(x); % signal length
% define the window
winlen = N;
winamp = [0.5,1]*(1/winlen);
zc = zerocross(x,wintype,winamp(1),winlen);
E = energy(x,wintype,winamp(2),winlen);
% time index for the ST-ZCR and STE after delay compensation
out = (winlen-1)/2:(N+winlen-1)-(winlen-1)/2;
