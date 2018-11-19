function G = torusGraph(N,self_loop,N_rings)
%%  N > 8 tends to visualise better

if nargin < 2
    N_rings = N;
    self_loop = 0;
else
    if nargin < 3
        N_rings = N;
    end
end

s = [];
t=[];

%rings
for i = 1:N_rings
    s(i,:) = (i-1)*N+1:i*N;
    t(i,:) = [(i-1)*N+2:i*N (i-1)*N+1];   
end

%connecting rings
if N_rings > 1
    for i = N_rings+1:N_rings*2-1
        s(i,:) = s(i-(N_rings-1),:);
        t(i,:) =  s(i-N_rings,:);
    end
    
    %last ring
    s(i+1,:) = s(1,:);
    t(i+1,:) = s(i,:);
end


%add self connections
if self_loop
    start_sloop = i+2;
    for j = 1:N_rings
        s(j+start_sloop-1,:) = s(j,:);
        t(j+start_sloop-1,:) = s(j,:);
    end
end

G = graph(s(:),t(:));

%% plot torus
% figure
% plot(G,'Layout','subspace3')