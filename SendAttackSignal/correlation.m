function [aligned_signal1, aligned_signal2] = correlation(signal1, signal2)
% 用 corr 对齐两个信号
% 假设 signal1 和 signal2 是你的两个信号
% preamble 是前导码的长度

% 1. 计算交叉相关
xcorr_result = xcorr(signal1, signal2);

% 2. 找到最大峰值的位置
[max_peak, max_peak_index] = max(xcorr_result);

% 3. 计算时间偏移
time_offset = max_peak_index - length(signal1);

% 4. 对齐信号
if time_offset > 0
    % signal2 的起始时间晚于 signal1，需要向前移动 signal2
    aligned_signal2 = [zeros(time_offset, 1); signal2(1:end-time_offset)];
    % 对齐后的信号长度和 signal1 相同，需要对 signal1 进行裁剪
    aligned_signal1 = signal1;
elseif time_offset < 0
    % signal2 的起始时间早于 signal1，需要向后移动 signal2
    aligned_signal2 = signal2(abs(time_offset):end);
    % 对齐后的信号长度和 signal2 相同，需要对 signal2 进行裁剪
    aligned_signal1 = signal1(1:length(aligned_signal2));
else
    % 时间已经对齐，不需要额外操作
    aligned_signal1 = signal1;
    aligned_signal2 = signal2;
end
