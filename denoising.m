
% Read audio file
addpath('H:\DSP_project\');  
%[x, fs] = audioread('filtered_signal_improved_set1.wav');  
%[x, fs] = audioread('filtered_signal_improved_Set1_xx.wav');  
[x, fs] = audioread('filtered_signal_improved_Set2.wav');
%[x, fs] = audioread('denoised_v_specsub_twice.wav'); 
%[x, fs] = audioread('set2_denoised_v_specsub.wav');
%[x, fs] = audioread('set2_denoised_v_specsub_twice.wav');
%[x, fs] = audioread('set2_denoised_v_specsub_twice_MMSE_twice.wav');
%[x, fs] = audioread('Set1_denoised_MMSESTSA85.wav');  

% Denoise using MMSESTSA85 or VoiceBox
%y = MMSESTSA85(x, fs, 0.7); 
y = v_specsub(x,fs); 

% Ensure lengths match
%min_len = min(length(x), length(y)); 
%x = x(1:min_len);  % Truncate x
%y = y(1:min_len);  % Truncate y

% Play and save the denoised audio
sound(y, fs);  
audiowrite('Set1_denoised_MMSESTSA85.wav', y, fs);  

% Calculate Signal-to-Interference Ratio (SIR)
signal_energy = sum(x.^2);  % Energy of the original signal
interference = y - x;       % Interference signal
interference_energy = sum(interference.^2); % Energy of interference
SIR = 10 * log10(signal_energy / interference_energy); % SIR in dB

disp('SIR (dB):');
disp(SIR);
