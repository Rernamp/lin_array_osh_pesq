clear;close all;

c = 343;
f_re = 4000;
lamda = c/f_re;
K = 2;
d = 0.04;


thetaan = 15; 

% [noise,fs] = audioread('sound_44.1kHz.wav');
[noise,fs] = audioread('sound.wav');

t = 2;

noise = noise(1:t*fs);



tau = (d*sind(thetaan))/(c)
% tau = 0.8/fs;

noise_shift = zeros(K, length(noise));

%%
for k = 1:K
    [y_shift] = shift( noise, tau*(k-1), fs);
    noise_shift(k,:) = y_shift;
end


t = 0:1/fs:2-1/fs;

%%
N_fft = 400;

fft_noise = [fft(noise_shift(1,:)) ; fft(noise_shift(2,:))];

R = (fft_noise(1,:).*conj(fft_noise(2,:)));
R = R./abs(R);
R_t = ifft(R);
R_t = R_t(end:-1:1);
[max_val max_in] = max(R_t);
tau_f = t(max_in)

tau_f/tau

tau_est = gccphat(noise_shift',noise)


%%


%%

