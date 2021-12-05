clear;close all;

%������� ����������� ������ 

c = 343;
f_re = 2000;%������� ��� ������� ��������� ��
lamda = c/f_re;%����� ����� 
N_one = 10;%���-�� ��������
f_up = 4000;    %������� ������� 
f_down = 0;  %������ �������
f_den = 0.5;    %��� ������
freq_range = f_down:f_den:f_up; %�������� ������
d = lamda/2;%���������� ����� ���������
thetaad = 0;       %������������ ����

osh_two = [];


    
[noise,fs] = audioread('nois.wav');%�������� ���

    t_duration = 2;%������������ �������
    t = 0:1/fs:t_duration-1/fs;
    NSampPerFrame = length(t);
    
hap = dsp.AudioPlayer('SampleRate',fs);
    %.................................������......................................
    dftFileReader = dsp.AudioFileReader('dft_voice_8kHz.wav',...
        'SamplesPerFrame',NSampPerFrame);
    sig = step(dftFileReader);
    

%�������� ������� ����. � ��
ula = phased.ULA(N_one,d);  %������ ����������� �������� ������
ula.Element.BackBaffled = true;
w = [];     %������ ������� �����.


thetaan = 30;
%���� ��� �������� ������� ������������� ��� ��������� ������
for freq_range_while = f_down:f_den:f_up;    %��������� �� ������ �������
    lamda_sig = c/(freq_range_while);    %����� ����� ��� ������������ �������
    
    wn = steervec(getElementPosition(ula)/lamda_sig,thetaan);   %������ � ������������ �����

    wd = steervec(getElementPosition(ula)/lamda_sig,thetaad);   %������ � ����������� �����

    rn = wn'*wd/(wn'*wn);   %���������� ����� �� �������

    wi = wd-wn*rn;          %���������� ����� �������
    
    w = cat(1,w,wi');       %����� ������ ���.�������������
    
    
end


w_2zona = conj(w(8000:-1:2,:));
w(end,:) = real(w(end,:));

w_w = [w ; w_2zona];%������� ������������

w_w = conj(w_w); %���������� ��������,� ������� ���
%������ ��
imp_har = ifft(w_w,length(w_w(:,1)),1);%�� ���� ������� �������������
for i = 1:10
    imp_har1(:,i) = fftshift(imp_har(:,i));    
end



%������� ��� ��������� ��������
n_down = 7950;
n_up = 8050;
imp_har_p = [];
for n_n = 1:10
    imp_har_p = [imp_har_p  imp_har1(n_down:1:n_up,n_n)];
    
end

for fi = 25:35

%�������� ����/������� ��� �� ����� ������ ���� ������� ���
for p = 1
    N = 10;%���-�� �������
    f_re = 2000;%�������
    %����,��� ������� ������ ���
    N_one = 10;%����� �������� � ����� ������������������

    %�������� �������� �����
    
    

    

    nois = noise(1:length(sig));%���������� ���-�� �������� ����,��� �� ���������

    %��������� ��������
    tau = (d*sind(fi))/(c);

    dt = 1/fs;
    n_tau = (tau/dt); %�������� � �������



    spec = fft(nois);%��� ����

    %������ �������,������� ������ ���� ������������

    y_s_1zona = [];% ������ ���� ���������
    y_s_2zona = [];%������ ���� ���������
    nois_onMR = [];%������ �� ������ �������
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
            k1 = spec(2+i*N_one:1+N_one+i*N_one) .* exp(-1i*2*pi*n_tau_i*f_tau_i/length(spec));%��������/��� ---
            y_s_1zona = cat(1,y_s_1zona,k1);%����������� � ������� �������

        end  

        y_s_1zona = [y_s_1zona (spec(N_end1:N_end2).*exp(-1i*2*pi*n_tau_i*N_centr/length(spec)))];%�������� �������,�� �������� � �������� ������

        y_s_1zona(end) = real(y_s_1zona(end));%��� ��� �������� ������ ���-��,�� ����� �������� ����������� ������ 

        y_s_2zona(1:N_end2 - 2) = conj(y_s_1zona((length(sig)/2)-1:-1:(length(sig)/2)-N_end2 + 2));%���������� �������� � ������� ������� ��� ������ ���� ���������

        y_f = [0 y_s_1zona.' y_s_2zona];%�������� � �������

        y_delayforMR = ifft(y_f); 

        y_delayforMR = y_delayforMR;%�������� ������//��� �� ���������� ���������� �������� � �������� ��������,���� �������� y_delayforMR �� sig.'       

        nois_onMR = cat(1,nois_onMR,y_delayforMR);%����������� ���������� ������ � ��� ��� ������ �������



        %������� �������
        y_s_1zona = [];
        y_s_2zona = [];
        y_f = [];
        y_delayforMR = [];

    end

end

%������ ���������
nois_onMR = fft(nois_onMR,length(nois_onMR(1,:)),2);
nois_onMR(:,1) = 0;
nois_onMR = ifft(nois_onMR,length(nois_onMR(1,:)),2);

sig = fft(sig);
sig(1) = 0;
sig = ifft(sig);


%��� ��� ����������



Power_one_exp_sig = mean(sig.^2);%�������� �������

nois_onMR_sre = mean(nois_onMR);%�������� ���
Power_one_exp_nois = mean(nois_onMR_sre.^2);%�������� ����


OSH_one_exp_notfiltr = Power_one_exp_sig/Power_one_exp_nois;







%�������� ������
out_dec_sig = [];%������ �� ������
out_dec_nois = [];%��� �� ������

for m = 1:10
    out_d = filter(imp_har_p(:,m),1,nois_onMR(m,:));
    out_dec_nois = [out_dec_nois; out_d];
    out_d = filter(imp_har_p(:,m),1,sig.');
    out_dec_sig = [out_dec_sig; out_d];
    out_d = [];
    
end

%������ ���������
out_dec_sig = fft(out_dec_sig,length(out_dec_sig(1,:)),2);
out_dec_sig(:,1) = 0;
out_dec_sig = ifft(out_dec_sig,length(out_dec_sig(1,:)),2);


out_dec_nois = fft(out_dec_nois,length(out_dec_nois(1,:)),2);
out_dec_nois(:,1) = 0;
out_dec_nois = ifft(out_dec_nois,length(out_dec_nois(1,:)),2);

%�������� ������ � ���

out_dec_mean_sig = mean(out_dec_sig);

out_dec_mean_nois = mean(out_dec_nois);

%������ �������� ����� ���������� 

Power_two_exp_sig = mean(out_dec_mean_sig.^2);

Power_two_exp_nois = mean(out_dec_mean_nois.^2);



OSH_two_exp_filtr = Power_two_exp_sig/Power_two_exp_nois;


osh_two = [osh_two OSH_two_exp_filtr];
end

osh_two = db(osh_two-OSH_one_exp_notfiltr);
angle = -5:5;
%%

plot(angle,osh_two);
grid on;
ylabel('������� � ���, ��');
xlabel("������ ���������, ����");
