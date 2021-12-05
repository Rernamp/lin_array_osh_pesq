clear;
%����� ��������� ���������

N = 10;%���-�� �������
c = 343;%�������� �����
f = 2000;%�������
lamda = c/f;
d = lamda/2;%���������� ����� ���������
fi = 40;%����,��� ������� ������ ���

[noise,fs] = audioread('nois.wav');%�������� ���

t_duration = 2;%������������ �������
t = 0:1/fs:t_duration-1/fs;
NSampPerFrame = length(t);

hap = dsp.AudioPlayer('SampleRate',fs);
%.................................������......................................
dftFileReader = dsp.AudioFileReader('dft_voice_8kHz.wav',...
    'SamplesPerFrame',NSampPerFrame);
sig = step(dftFileReader);

nois = noise(1:length(sig));%���������� ���-�� �������� ����,��� �� ���������

%��������� ��������
tau = (d*sind(fi))/(c);

dt = 1/fs;
n_tau = 300; %�������� � �������

N_one = 50;%����� �������� � ����� ������������������


spec = fft(nois);%��� ����,��� ������ �������� ��� 0 ���� � �� ������������ �������� �� �� ����� �������

%������ �������,������� ������ ���� ������������

y_s_1 = [];% ������ ���� ���������
y_s_2 = [];%������ ���� ���������
y_s_v = [];%������ �� ������ �������
N_onezona =fix(length(sig)/(2*N_one))-1%���-�� ����� ���������� � ������ ���� ���������
N_end1 = (fix(length(sig)/(2*N_one))*N_one)+2;%������ ���������� ��������
N_end2 = (length(sig)/2)+1;%����� ���������� ���������
N_ser = (N_end1 + N_end2)/2; % ����������� ������ ���������� ���������
%��� ������ ������� ������ �� ��� ����� ��������
for m = 1:N %���� ��� ������ �������
    n_tau_i = n_tau*(m-1);%���-�� ���������� �������� ��� ������ �������
    for i = 0:N_onezona% ����,������� ���������� �������� ����
        
        
        f_tau_i = ((2+2+N_one-1)/2 + i*N_one);%������,��������������� ����������� ������� ��� ������� ���������
        k1 = spec(2+i*N_one:1+N_one+i*N_one) .* exp(1i*2*pi*n_tau_i*f_tau_i/length(spec));%��������
        y_s_1 = cat(1,y_s_1,k1);%����������� � ������� �������
        
    end 

    y_s_1 = [y_s_1 (spec(N_end1:N_end2).*exp(1i*2*pi*n_tau_i*N_ser/length(spec)))];%�������� �������,�� �������� � �������� ������
    y_s_1(end) = real(y_s_1(end));%��� ��� �������� ������ ���-��,�� ����� �������� ����������� ������ 
    y_s_2(1:N_end2 - 2) = conj(y_s_1((length(sig)/2)-1:-1:(length(sig)/2)-N_end2 + 2));%���������� �������� � ������� ������� ��� ������ ���� ���������
    y_f = [spec(1) y_s_1.' y_s_2];%�������� � �������
    y_fdel = ifft(y_f); 
    y_fdel = y_fdel + sig.';%�������� ������
        
    y_s_v = cat(1,y_s_v,y_fdel);%����������� ���������� ������ � ��� ��� ������ �������
    
    %������� �������
    
    y_s_1 = [];
    y_s_2 = [];
    y_f = [];
    y_fdel = [];
    
end
 

%%
set(0,'DefaultAxesFontSize',14,'DefaultAxesFontName','Times New Roman');
set(0,'DefaultTextFontSize',14,'DefaultTextFontName','Times New Roman'); 

k = 100;
N_zad = 3;
nois_T_zad = [nois(N_zad+1:end,1); zeros(N_zad,1)];
sig_T_zad = nois + sig;
figure(1);
hold on;
grid on;
plot(t,sig_T_zad);
plot(t,y_s_v(2,:));

ylabel('���������, ���.��');
xlabel('�����, �');