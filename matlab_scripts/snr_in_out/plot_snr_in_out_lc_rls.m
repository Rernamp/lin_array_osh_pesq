clear;
close all;

N = 16; 
c = 343;
L = 32;
fs = 8000;
f = 2000;
phi_sig = 0;
teta_sig = 0;
phi_noise = 0;
teta_noise = 55;
c = 343;
d = c/(2*f);
d = 0.04;
p_loc = gen_place_el(4,4,d,d,1)';

[noise,fs] = audioread('nois.wav');

[sig,fs] = audioread('speech_dft_8kHz.wav');

t = 2;
m = 500;
time = 0:1/fs:(length(noise)-1)/fs;
%%
sig = sig(1:t*fs);
noise = noise(1:t*fs);
power_sig = mean(sig.^2);
power_noise = mean(noise.^2);
noise = noise./sqrt(power_noise);

SNR = -40:5:20;



for i = 1:length(SNR)
    
    
    disp_noise(i) = mean(sig.^2)/(10^(SNR(i)/10));
    noise_i(:,i) = noise * sqrt(disp_noise(i));
    
    osh_in(i) = 10*log10(mean(sig.^2)/mean(noise_i(:,i).^2));
    
    signal_shift = shift_plane(sig,phi_sig,teta_sig,p_loc,fs);
    noise_shift = shift_plane(noise_i(:,i),phi_noise,teta_noise,p_loc,fs);
    
    signal_shift = awgn(signal_shift,35);
    noise_shift = awgn(noise_shift,35);
    
    [y_signal,W_n] = func_LC_RLS(signal_shift, L, N);
    [y_noise,W_n] = func_LC_RLS(noise_shift, L, N);
    
    y_signal = y_signal(m:end);
    y_noise = y_noise(m:end);
    osh_out(i) = 10*log10(mean(y_signal.^2)/mean(y_noise.^2));
    osh_out(i) = osh_out(i) - osh_in(i);
end

%%
figure()
plot(osh_in, osh_out)
grid on

legend('LC RLS')
xlabel("SNR_{input}")
ylabel("Выигрышь ОСШ")
save SNR_LC_RLS osh_out osh_in