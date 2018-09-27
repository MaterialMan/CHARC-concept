
function [A, p,h] = statCheck(x,y, var)
if var ~=1
    [p,h,st] = ranksum(x,y,'alpha',0.05);
    N = length(x);
    M = length(y);
    A = ((st.ranksum/N - (N+1)/2)/M); 
else
    [h,p,st] = kstest2(x,y,'alpha',0.05);
    N = length(x);
    M = length(y);
    A = ((st/N - (N+1)/2)/M);
end

if A < 0.5
    A = 1-A;
else
    A;
end