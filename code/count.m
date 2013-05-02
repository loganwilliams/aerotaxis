n2 = mycentroids('bac_4_25_N2_2.mat', 0.57, 1, 1, 50, 1, 0.5);
o2 = mycentroids('bac_4_25_O2_2.mat', 0.57, 1, 1, 50, 1, 0.5);

<<<<<<< HEAD
o = [];
n = [];

for i = 0:20
    i
    n_name = ['N2_' num2str(i) '.mat'];
    n_cent = mycentroids(n_name, 0.58, 1, 1, 120, 1, 0.8, 0);
    n_count = length(n_cent)/30;
    o_name = ['O2_' num2str(i) '.mat'];
    o_cent = mycentroids(o_name, 0.58, 1, 1, 120, 1, 0.8, 0);
    o_count = length(o_cent)/30;
    o = [o o_count];
    n = [n n_count];
end

o_norm = o./o(1);
n_norm = n./n(1);

plot(0:20, o_norm, 0:20, n_norm);
=======
num_n2 = length(n2) / 30;
num_o2 = length(o2) / 30;
>>>>>>> parent of b53d4d4... moved data
