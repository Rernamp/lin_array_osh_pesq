clear;

c = 343;
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


w_2zona = conj(w(8000:-1:2,:));
w(end,:) = real(w(end,:));

w_w = [w ; w_2zona];%������� ������������

%������ ��
imp_har = ifft(w_w,length(w_w(:,1)),1);%�� ���� ������� �������������
for i = 1:10
    imp_har1(:,i) = fftshift(imp_har(:,i));%������� ������� ������� � �����
end



%������� ��� ��������� ��������
n_down = 7950;
n_up = 8050;
imp_har_p = [];
for n_n = 1:10
    imp_har_p = [imp_har_p  imp_har1(n_down:1:n_up,n_n)];
    
end

for l = 1:10
    imp_har_p(:,l) = ifftshift(imp_har_p(:,l));%������� ������� ������� ������� �� �����
end

fes_koef = fft(imp_har_p,length(imp_har_p(:,1)),1);%������� ������������

fes_koef_for_imp = fes_koef(1:51,:);
omega = -90:1:90;
ff_sig = 0:80:4000;

P = 0;
P_out = [];
%����� ��
for j = 1:length(ff_sig)    %��������� �� ������ �������
    for i = 0:N_one-1   %������ ����� ��� ��
    P_i = exp((-1i*i*2*pi*ff_sig(j)*d*(sind(omega)))/c)*(fes_koef_for_imp(j,i+1));%�������� ��� ������� ������� �� ������� (1.21)
    P = P + P_i;
    end
    BP = 20*log10((abs(P))/(max(abs(P))));%�������� ������������� �� ������� (1.20)
    P_out = cat(1,P_out,BP);    %����� ������ ��� ������ ������
    P = 0;
    BP = 0;
end 

f_up = 4000;
f_den = 80;
f_down = 0;
%%
[X,Y] = meshgrid(f_up:-f_den:f_down,omega);
C = X.*Y;
surf(X,Y,P_out.');
zlim([-60 0])
xlabel("�������,��");
ylabel("���� �������, ����");
zlabel("BP, ��");
colormap('gray'); %������� ������
shading interp % ������� ����
grid on %��������� �����
colormap('gray'); %������� ������
caxis([-40, 0])
