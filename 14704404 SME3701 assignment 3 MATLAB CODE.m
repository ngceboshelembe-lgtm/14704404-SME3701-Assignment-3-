%% SME3701 - ASSIGNMENT 2 - 2026
% Student Number: 14704404
% Question 1: Geared-Shaft Torsional Vibration System with Broken Tooth
% ----------------------------------------------------------------------

clear; close all; clc;

%% ==================== QUESTION 1.1 ====================
% Develop a model of the geared-shaft system incorporating
% the torque disturbance caused by the broken tooth.

% System parameters
J0  = 0.10;                     % Mass moment of inertia (N·m·s²)
d   = 0.050;                    % Shaft diameter (m)
L   = 1.00;                     % Shaft length (m)
G   = 79.3e9;                   % Shear modulus of steel (Pa)

% Calculate polar moment of inertia and torsional stiffness
Jp  = pi * d^4 / 32;            % Polar moment of inertia (m^4)
kt  = G * Jp / L;               % Torsional stiffness (N·m/rad)

fprintf('========== QUESTION 1.1 ==========\n');
fprintf('Polar moment of inertia Jp = %.6e m^4\n', Jp);
fprintf('Torsional stiffness kt     = %.2f N·m/rad\n', kt);
fprintf('Natural frequency fn       = %.2f Hz\n\n', sqrt(kt/J0)/(2*pi));

% Torque disturbance model (broken tooth)
% Driving gear has 16 teeth, one broken.
% Assuming gear ratio ≈ 1, driven gear speed = 1000 rpm
% → Revolution period = 0.06 s
% → Missing tooth duration = 1/16 of the period

T_rev = 60/1000;                % Revolution period (s) = 0.06 s

% Mt(t) = 1000 N·m normally, drops to 0 for 1/16 of each revolution
Mt = @(t) 1000 * (mod(t, T_rev) >= T_rev/16);

fprintf('Torque disturbance: Periodic pulse\n');
fprintf('  Period          = %.3f s (1000 rpm)\n', T_rev);
fprintf('  Pulse width     = 6.25 %% (1 missing tooth out of 16)\n');
fprintf('  Amplitude       = 1000 N·m (drops to 0 when tooth is missing)\n\n');

% Governing equation implemented as ODE:
% J0 * θ̈ + kt * θ = Mt(t)
% State vector y = [θ; ω]

odefun = @(t, y) [ y(2);
                   (Mt(t) - kt * y(1)) / J0 ];

%% ==================== QUESTION 1.2 ====================
% Simulate and plot the angular displacement θ(t)
% and angular velocity θ̇(t) of the driven gear.

fprintf('========== QUESTION 1.2 ==========\n');
fprintf('Simulating the system...\n');

% Initial conditions (start from healthy steady-state)
theta0 = 1000 / kt;             % Healthy steady-state angle (rad)
y0     = [theta0; 0];           % [θ(0); ω(0)]

% Simulation settings
tspan   = [0 0.6];              % Simulate for 0.6 seconds
options = odeset('RelTol', 1e-8, 'AbsTol', 1e-10);

[t, y] = ode45(odefun, tspan, y0, options);

theta = y(:,1);                 % Angular displacement (rad)
omega = y(:,2);                 % Angular velocity (rad/s)

% Plot results
figure('Name', 'Question 1.2 - Driven Gear Response', ...
       'NumberTitle', 'off', 'Position', [100 100 900 650]);

% Subplot 1: Angular displacement
subplot(2,1,1)
plot(t, theta, 'b', 'LineWidth', 1.2)
hold on
yline(1000/kt,  'r--', 'LineWidth', 1.0)
yline(937.5/kt, 'g--', 'LineWidth', 1.0)
hold off
grid on
ylabel('\theta (rad)', 'FontSize', 12)
title('Angular Displacement \theta(t) of the Driven Gear', 'FontSize', 13)
legend('\theta(t)', 'Healthy steady-state', 'Mean torque (15/16)', ...
       'Location', 'northeast')
xlim([0 0.6])

% Subplot 2: Angular velocity
subplot(2,1,2)
plot(t, omega, 'r', 'LineWidth', 1.2)
grid on
xlabel('Time (s)', 'FontSize', 12)
ylabel('\omega = d\theta/dt (rad/s)', 'FontSize', 12)
title('Angular Velocity \omega(t) of the Driven Gear', 'FontSize', 13)
xlim([0 0.6])

sgtitle(sprintf('Student 14704404 | Geared-Shaft System with Broken Tooth (k_t = %.0f N·m/rad, f_n ≈ %.1f Hz)', ...
        kt, sqrt(kt/J0)/(2*pi)), 'FontSize', 12)

fprintf('Plots generated successfully.\n\n');

%% ==================== QUESTION 1.3 ====================
% From the simulation, determine the maximum angular
% displacement (rad) and maximum angular velocity (rad/s).

fprintf('========== QUESTION 1.3 ==========\n');

max_theta = max(theta);
min_theta = min(theta);
max_omega = max(abs(omega));

fprintf('Maximum angular displacement θ_max = %.5f rad\n', max_theta);
fprintf('Minimum angular displacement θ_min = %.5f rad\n', min_theta);
fprintf('Maximum angular velocity |ω|_max   = %.4f rad/s\n\n', max_omega);

fprintf('Reported answers for Question 1.3:\n');
fprintf('  Maximum angular displacement = %.4f rad\n', max_theta);
fprintf('  Maximum angular velocity     = %.2f rad/s\n', max_omega);

%% End of script
