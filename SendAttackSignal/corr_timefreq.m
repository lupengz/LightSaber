clc;
clear;
close all;


% Load received signal
data = load('Traces/trace_18khz_pa.mat');
rece_sw = data.audioAll;

% 提取接收到的信号
rece_sw = squeeze(rece_sw(:, 2, 1));

% Sampling parameters
FS = 48000;                 % sample rate (Hz)
PERIOD = 960;              % period of one repetition of sensing
CHIRP_LEN = 960;           % signal length (shorter than period) 
REPEAT_CNT = 100;       % total repetition of signal to play


rece_sw_repeatcnt_periods = rece_sw(1:PERIOD*REPEAT_CNT);
time_rw = (0:length(rece_sw_repeatcnt_periods)-1) / FS;

% send chirp signal

CHIRP_FREQ_START = 18000;   % signal min freq (Hz)
CHIRP_FREQ_END = 22000;     % signal max freq (Hz)
APPLY_FADING_TO_SIGNAL = 1; % fade in/out of the singal for being inaudible
FADING_RATIO = 0.2;         % ratio of singals being "faded"
SIGNAL_GAIN = 0.8;          % gain to scale signal



trans_sw = [data.audioSource.preambleSource.preambleToAdd*data.audioSource.preambleGain; repmat(ApplyFadingInStartAndEndOfSignal(data.audioSource.signal, FADING_RATIO),40, 1)];

% % Generate chirp signal
time = (0:length(trans_sw)-1)./FS;

% 计算交叉相关
xcorr_result = xcorr(trans_sw,rece_sw_repeatcnt_periods);

% 2. 找到最大峰值的位置
[max_peak, max_peak_index] = max(xcorr_result);

% 3. 计算时间偏移
time_offset = max_peak_index - length(trans_sw);

% 4. 对齐信号
if time_offset > 0
    % rece_sw_repeatcnt_periods 的起始时间晚于 signal1，需要向前移动 signal2
    aligned_rece_sw_repeatcnt_periods = [zeros(time_offset, 1); rece_sw_repeatcnt_periods(1:end-time_offset)];
elseif time_offset < 0
    % signal2 的起始时间早于 signal1，需要向后移动 signal2
    aligned_rece_sw_repeatcnt_periods = rece_sw_repeatcnt_periods(abs(time_offset):end);
else
    % 时间已经对齐
    aligned_rece_sw_repeatcnt_periods = rece_sw_repeatcnt_periods;
end

time_arw = (0:length(aligned_rece_sw_repeatcnt_periods)-1) / FS;

% Plot time-domain of trans_sw
figure;
subplot(2, 2, 1);
plot(time, trans_sw);
xlabel('Time (s)');
ylabel('Amplitude');
title('Transmitted Chirp Signal (Time Domain)');

% Plot time-domain of rece_sw
subplot(2, 2, 2);
plot(time_arw, aligned_rece_sw_repeatcnt_periods);
xlabel('Time (s)');
ylabel('Amplitude');
title('Repeated Chirp Signal (Time Domain)');


% Plot time-frequency domain of trans_sw
subplot(2, 2, 3);
spectrogram(trans_sw, hann(256), 128, 256, FS, 'yaxis');
xlabel('Time (s)');
ylabel('Frequency (kHz)');
title('Transmitted Chirp Signal (Time-Frequency Domain)');


% Plot time-frequency domain of rece_sw
subplot(2, 2, 4);
spectrogram(aligned_rece_sw_repeatcnt_periods, hann(256), 128, 256, FS, 'yaxis');
xlabel('Time (s)');

title('Transmitted Chirp Signal (Time-Frequency Domain)');

