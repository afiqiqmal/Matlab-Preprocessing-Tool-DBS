function [E,out] = ste(x,wintype)
x = x.';
N = length(x); % signal length
% define the window
winlen = 201;
winamp = [0.5,1]*(1/winlen);
E = energy(x,wintype,winamp(2),winlen);
% time index for the ST-ZCR and STE after delay compensation
out = (winlen-1)/2:(N+winlen-1)-(winlen-1)/2;
