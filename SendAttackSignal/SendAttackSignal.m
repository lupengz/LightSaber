%==========================================================================
% Fake Gesture Attack Signal Sender
%
% Purpose:
% This MATLAB script runs on the computer and connects to the phone app
% through a socket server. After the phone app connects, the script sends
% a pre-recorded fake gesture attack waveform loaded from:
%     traces/mimic (the mimic samples)
%
% The phone app then plays this waveform through its audio output interface.
% In our attack setup, the phone audio output is further connected to the
% external laser driving circuit / driver board, so that the fake gesture
% signal can be physically emitted to perform an injection attack.
%
% Main functionality kept in this simplified version:
%   1) Load the fake gesture attack trace from s2_3.mat
%   2) Send it repeatedly to the connected phone
%   3) Allow easy configuration of:
%        - replay frequency / repetition interval
%        - total sending count
%==========================================================================

close all;
clear;
clc;

import edu.umich.cse.yctung.*

% Close previous open sockets if any
JavaSensingServer.closeAll();

%% ------------------------------------------------------------------------
% 1. Communication settings
% -------------------------------------------------------------------------
SERVER_PORT = 50008;   % Port for communication with the phone app

%% ------------------------------------------------------------------------
% 2. Attack signal transmission settings
% -------------------------------------------------------------------------
SAMPLE_RATE = 48000;   % Audio sample rate used by the phone app (Hz)

% User-configurable parameters:
SEND_REPEAT_COUNT = 100;     % Total number of times to replay the attack signal
SEND_FREQUENCY_HZ = 2;       % How many times to send the signal per second

% Convert replay frequency to period (in samples)
SEND_PERIOD_SAMPLES = round(SAMPLE_RATE / SEND_FREQUENCY_HZ);

%% ------------------------------------------------------------------------
% 3. Load fake gesture attack trace
% -------------------------------------------------------------------------
attack_data = load('traces/mimic/s1_4.mat');

% Assumption: the .mat file stores the fake gesture waveform in doppler_signal
fake_gesture_signal = attack_data.doppler_signal(:);

% Optional amplitude scaling
SIGNAL_GAIN = 1.0;
fake_gesture_signal = fake_gesture_signal * SIGNAL_GAIN;

% Length of the loaded attack waveform
attack_signal_length = length(fake_gesture_signal);

% Ensure one replay period is not shorter than the waveform itself
if SEND_PERIOD_SAMPLES < attack_signal_length
    error(['SEND_FREQUENCY_HZ is too high. The replay period is shorter ', ...
           'than the loaded fake gesture signal length. Reduce the sending frequency.']);
end

% Pad zeros so that each replay occupies exactly one period
tx_signal_one_period = zeros(SEND_PERIOD_SAMPLES, 1);
tx_signal_one_period(1:attack_signal_length) = fake_gesture_signal;

% Plot part of the waveform for quick inspection
figure;
plot(tx_signal_one_period);
title('One Period of Fake Gesture Attack Signal');
xlabel('Sample Index');
ylabel('Amplitude');

%% ------------------------------------------------------------------------
% 4. Build audio source for repeated transmission
% -------------------------------------------------------------------------
% The AudioSource object is what will be delivered to the connected phone app.
% The phone app will replay this waveform SEND_REPEAT_COUNT times.
audio_source = AudioSource( ...
    'fake_gesture_attack_s2_3', ...
    tx_signal_one_period, ...
    SAMPLE_RATE, ...
    SEND_REPEAT_COUNT, ...
    1.0 ...
);

%% ------------------------------------------------------------------------
% 5. Build server and wait for phone connection
% -------------------------------------------------------------------------
global sensing_server;

% We keep the callback interface because SensingServer requires it,
% but the callback itself does not perform any detection logic here.
sensing_server = SensingServer( ...
    SERVER_PORT, ...
    @DummyCallback, ...
    SensingServer.DEVICE_AUDIO_MODE_PLAY_AND_RECORD, ...
    audio_source ...
);

% Do not start automatically right after connection initialization
sensing_server.startSensingAfterConnectionInit = 0;

disp('Server created successfully.');
disp(['Waiting for phone app connection on port ', num2str(SERVER_PORT), ' ...']);

sensing_server.start();

disp('Phone connected. You can now start transmission from the app / server workflow.');

%% ------------------------------------------------------------------------
% Dummy callback
% -------------------------------------------------------------------------
function DummyCallback(~, ~)
% This simplified script only keeps the transmission functionality.
% No sensing, detection, or callback-based processing is needed here.
end