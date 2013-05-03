o = [];
n = [];

for i = 0:2
    n_name = ['N2_' num2str(i) '.mat']
%     n_cent = mycentroids(n_name, 0.58, 1, 1, 120, 1, 0.8, 0);
    n_cent=kiacentroids(n_name, 4, 30, 200, 0.8,0.65,0);
    n_count = length(n_cent)/30;
    o_name = ['O2_' num2str(i) '.mat'];
%    o_cent = mycentroids(o_name, 0.58, 1, 1, 120, 1, 0.8, 0);
    o_cent=kiacentroids(o_name, 4, 30, 200, 0.8,0.65,0);
    o_count = length(o_cent)/30;
    o = [o o_count];
    n = [n n_count];
end

o_norm = o./o(1);
n_norm = n./n(1);

plot(0:20, o_norm, 0:20, n_norm);
