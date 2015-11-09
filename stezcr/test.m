function y = test(x) 
assert( ismatrix(x) );

[M,N] = size(x);

if isvector(x) 
L = length(x); 
else 
assert( M>=2 && N>=2 ); 
L = M; 
end 
assert( L >= 1 );

y = sum(abs(diff(x>0))) / L;

end