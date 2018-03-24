clc;
% close all;
haptic_experiment_with_filter;
DEGREE_TO_RADIAN = 0.0174532925;
N = length(filtered_angPos); % Number of samples
%UNDER_DAMPED
k_spring = 1.0; % N/cm
M_mass = 10.0; % g
b_damper = 0.001; % N*s/cm

% Discrete model from matlab with Ts = 0.001s
A_0_0 = 1.0;
A_0_1 = 0.001;
A_1_0 = -0.0001;
A_1_1 = 1.0;

B_0_0 = 0.00000005;
B_0_1 = 0.00000000005;
B_1_0 = 0.0001;
B_1_1 = 0.0000001;
R_pedal = 17.0; % cm

g_fMassPosition = 0;
g_fMassPosition_prev = 100;
g_fMassVelocity = 0;
g_fMassVelocity_prev = 0;

g_fposition_filtered_plus = filtered_angPos - mean(filtered_angPos); % around zero
g_fgyroVelocity = gyro_angVel;

pedalLinearPosition = R_pedal .* sin(DEGREE_TO_RADIAN .* g_fposition_filtered_plus);

pedalLinearVelocity = R_pedal .* cos(g_fposition_filtered_plus .* DEGREE_TO_RADIAN) .* g_fgyroVelocity;

for i= 2: N
    g_fMassPosition = A_0_0 * g_fMassPosition_prev + A_0_1 * g_fMassVelocity_prev;
    g_fMassPosition = B_0_0 * pedalLinearPosition  + B_0_1 * pedalLinearVelocity;

    g_fMassVelocity = A_1_0 * g_fMassPosition_prev + A_1_1 * g_fMassVelocity_prev;
    g_fMassVelocity = B_1_0 * pedalLinearPosition  + B_1_1 * pedalLinearVelocity;

    g_fMassPosition_prev = g_fMassPosition;
    g_fMassVelocity_prev = g_fMassVelocity;
end
