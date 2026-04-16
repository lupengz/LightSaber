%==========================================================================
% Fake Gesture Attack Signal Generator
%
% Purpose:
% Generate a fake Doppler-based attack signal a(t) by:
%   1) Fitting frequency trajectory f_a(t) from annotated (time, freq) points
%   2) Integrating f_a(t) to obtain phase
%   3) Generating acoustic attack signal a(t)
%
% This follows:
%   a(t) = A0 * cos(2*pi * integral f_a(t) dt)
%
% The generated signal can be:
%   -> saved as .mat
%   -> or sent to phone for injection attack
%==========================================================================

clc; clear; close all;

%% ------------------------------------------------------------------------
% 1. User-defined Doppler trajectory (gesture shape)
% -------------------------------------------------------------------------

% Segment 1 (e.g., moving towards sensor)
t1 = [0.17, 0.18, 0.23, 0.34, 0.39, 0.42, 0.45, 0.46];
f1 = [20003, 19962, 19927, 19927, 19927, 19945, 19962, 19992];

% Segment 2 (e.g., moving away)
t2 = [0.56, 0.63, 0.67, 0.71, 0.74, 0.84, 0.93, 0.99];
f2 = [20003, 19962, 19927, 19927, 19927, 19945, 19962, 19992];

%% ------------------------------------------------------------------------
% 2. Fit smooth frequency function f_a(t)
% -------------------------------------------------------------------------

poly_order = 2;

p1 = polyfit(t1, f1, poly_order);
p2 = polyfit(t2, f2, poly_order);

% continuous time axis
fs = 48000;                 % sampling rate
T_total = 1.2;              % total duration (seconds)
t = 0:1/fs:T_total;

% construct piecewise frequency
f_t = zeros(size(t));

idx1 = t >= min(t1) & t <= max(t1);
idx2 = t >= min(t2) & t <= max(t2);

f_t(idx1) = polyval(p1, t(idx1));
f_t(idx2) = polyval(p2, t(idx2));

% fill gaps (optional smoothing)
f_t(f_t == 0) = 20000;   % base carrier

%% ------------------------------------------------------------------------
% 3. Generate attack signal a(t)
% -------------------------------------------------------------------------

A0 = 1.0;   % amplitude

% phase = integral of frequency
phase = 2 * pi * cumsum(f_t) / fs;

attack_signal = A0 * cos(phase);

%% ------------------------------------------------------------------------
% 4. Visualization
% -------------------------------------------------------------------------

figure;
subplot(2,1,1);
plot(t, f_t);
title('Frequency trajectory f_a(t)');
xlabel('Time (s)');
ylabel('Frequency (Hz)');

subplot(2,1,2);
plot(t(1:2000), attack_signal(1:2000));
title('Generated attack signal a(t)');
xlabel('Time (s)');

%% ------------------------------------------------------------------------
% 5. Save signal (for later injection)
% -------------------------------------------------------------------------

save('fake_gesture_attack.mat', 'attack_signal', 'fs');

disp('Attack signal generated and saved.');