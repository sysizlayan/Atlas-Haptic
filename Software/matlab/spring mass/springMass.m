clc
clear all

M = 25;
k = 24;
B = 8;


A = [0 1; -k/M -B/M];
B = [0;1/M];
C = [1 0];
D = 0;
Ts = 1e-3;

sys1 = ss(A,B,C,D);
sys2 = c2d(sys1, Ts);

figure
step(sys1,sys2);
% step(sys2);