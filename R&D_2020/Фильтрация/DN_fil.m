clear;

%�������� ������ ��� ������ ��


N = 10;%���-�� �������
c = 343;%�������� �����
f = 2000;%�������
lamda = c/f;
d = lamda/2;%���������� ����� ���������
fi = 30;%����,��� ������� ������ ���
N_one = 1;%����� �������� � ����� ������������������

%�������� �������� �����

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
n_tau = (tau/dt); %�������� � �������



spec = fft(nois);%��� ����

%������ �������,������� ������ ���� ������������

y_s_1zona = [];% ������ ���� ���������
y_s_2zona = [];%������ ���� ���������
y_s_oneMR = [];%������ �� ������ �������
N_onezona =fix(length(sig)/(2*N_one))-1;%���-�� ����� ���������� � ������ ���� ���������
N_end1 = (fix(length(sig)/(2*N_one))*N_one)+2;%������ ���������� ��������
N_end2 = (length(sig)/2)+1;%����� ���������� ���������
N_centr = (N_end1 + N_end2)/2; % ����������� ������ ���������� ���������

%��� ������ ������� ������ �� ��� ����� ��������

%���� ����
for m = 1:N %���� ��� ������ �������
    
    for i = 0:N_onezona% ����,������� ���������� �������� ����
        
        n_tau_i = n_tau*(m-1);%���-�� ���������� �������� ��� ������ �������
        f_tau_i = ((2+2+N_one-1)/2 + i*N_one);%������,��������������� ����������� ������� ��� ������� ���������
        k1 = spec(2+i*N_one:1+N_one+i*N_one) .* exp(-1i*2*pi*n_tau_i*f_tau_i/length(spec));%��������
        y_s_1zona = cat(1,y_s_1zona,k1);%����������� � ������� �������
        
    end;  

    y_s_1zona = [y_s_1zona (spec(N_end1:N_end2).*exp(-1i*2*pi*n_tau_i*N_centr/length(spec)))];%�������� �������,�� �������� � �������� ������
   
    y_s_1zona(end) = real(y_s_1zona(end));%��� ��� �������� ������ ���-��,�� ����� �������� ����������� ������ 
   
    y_s_2zona(1:N_end2 - 2) = conj(y_s_1zona((length(sig)/2)-1:-1:(length(sig)/2)-N_end2 + 2));%���������� �������� � ������� ������� ��� ������ ���� ���������
   
    y_f = [spec(1) y_s_1zona.' y_s_2zona];%�������� � �������
   
    y_delayforMR = ifft(y_f); 
  
    y_delayforMR = y_delayforMR;%�������� ������//��� �� ���������� ���������� �������� � �������� ��������,���� �������� y_delayforMR �� sig.'       
  
    y_s_oneMR = cat(1,y_s_oneMR,y_delayforMR);%����������� ���������� ������ � ��� ��� ������ �������
    
    
    
    %������� �������
    y_s_1zona = [];
    y_s_2zona = [];
    y_f = [];
    y_delayforMR = [];
    
end;

%��� ������� ��� ������ �������
spec = [];

for m = 1:10
    spec_foroneMR = fft(y_s_oneMR(m,:));
    spec = [spec ; spec_foroneMR];
end


f_re = 2000;%������� ��� ������� ��������� ��
lamda = c/f_re;%����� ����� 
N_one = 10;%���-�� ��������
f_up = 4000;    %������� ������� 
f_down = 0;  %������ �������
f_den = 0.5;    %��� ������

d = lamda/2;%���������� ����� ���������

thetaad = 0;       %������������ ����
thetaan = 30;       %����������� ���� 

ula = phased.ULA(N_one,d);  %������ ����������� �������� ������
ula.Element.BackBaffled = true;
w = [];     %������ ������� �����.
freq_range = f_down:f_den:f_up; %�������� ������

%���� ��� �������� ������� ������������� ��� ��������� ������
for freq_range_while = f_down:f_den:f_up;    %��������� �� ������ �������
    lamda_sig = c/(freq_range_while);    %����� ����� ��� ������������ �������
    
    wn = steervec(getElementPosition(ula)/lamda_sig,thetaan);   %������ � ������������ �����

    wd = steervec(getElementPosition(ula)/lamda_sig,thetaad);   %������ � ����������� �����

    rn = wn'*wd/(wn'*wn);   %���������� ����� �� �������

    wi = wd-wn*rn;          %���������� ����� �������
    
    w = cat(1,w,wi');       %����� ������ ���.�������������
    
    
end


%������� �� ������� ������������
y_foroneMR = [];
y_foroneMR_range = [];
y_forMR_onezona = [];
for i = 1:length(sig)/2+1
    y_foroneMR = [];
      


    for n = 1:10%������� ��������� ������� �� �������������� ������� ������������
        y_foroneMR_range = spec(n,1+1+(i-1)*1:i*1+1).*conj(w(i,n));  
        y_foroneMR = [y_foroneMR ; y_foroneMR_range];
    end
    
    y_forMR_onezona = cat(2,y_forMR_onezona,y_foroneMR);%������� �� ������
    
end

y_forMR_onezona(1) = real(y_forMR_onezona(1));
y_forMR_twozona = conj(y_forMR_onezona(:,8000:-1:2));%���������� ���������
%�������� �������� �����
y_forMR_onezona(:,end) =real(y_forMR_onezona(:,end));

y_forMR_spec = [y_forMR_onezona y_forMR_twozona];%��������


y_forMR = zeros(1,16000);

y_forMR = ifft(y_forMR_spec,length(y_forMR_spec),2);%�������� ���

set(0,'DefaultAxesFontSize',14,'DefaultAxesFontName','Times New Roman');
set(0,'DefaultTextFontSize',14,'DefaultTextFontName','Times New Roman'); 
%%
figure(1);
plot(t,mean(y_forMR));
ylabel("���������, ���.��")
xlabel("�����,�");
grid on;
figure(2);
plot(t,mean(y_s_oneMR));
ylabel("���������, ���.��")
grid on;
xlabel("�����,�");
