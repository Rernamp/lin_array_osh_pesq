clear;

f_re = 2000;%������� ��� ������� ��������� ��
c = 343;%�������� �����
lamda = c/f_re;%����� ����� 
N_one = 10;%���-�� ��������
omega = -90:2:90;
f_up = 4000;    %������� ������� 
f_down = 300;  %������ �������
f_den = 100;    %��� ������

d = lamda/2;%���������� ����� ���������

thetaad = 10;       %������������ ����
thetaan = 40;       %����������� ���� 

ula = phased.ULA(N_one,d);  %������ ����������� �������� ������
ula.Element.BackBaffled = true;
w = [];     %������ ������� �����.
ff_sig = f_down:f_den:f_up; %�������� ������

%���� ��� �������� ������� ������������� ��� ��������� ������
for fff_sig = f_down:f_den:f_up;    %��������� �� ������ �������
    lamda_sig = c/(fff_sig);    %����� ����� ��� ������������ �������
    
    wn = steervec(getElementPosition(ula)/lamda_sig,thetaan);   %������ � ������������ �����

    wd = steervec(getElementPosition(ula)/lamda_sig,thetaad);   %������ � ����������� �����

    rn = wn'*wd/(wn'*wn);   %���������� ����� �� �������

    wi = wd-wn*rn;          %���������� ����� �������
    
    w = cat(1,w,wi');       %����� ������ ���.�������������
    
end



%��������������� ����������
P = 0;
P_out = [];

%�������� ��������� �������������
for j = 1:length(ff_sig)    %��������� �� ������ �������
    for i = 0:N_one-1   %������ ����� ��� ��
    P_i = exp((-1i*i*2*pi*ff_sig(j)*d*(sind(omega)))/c)*w(j,i+1);%�������� ��� ������� ������� �� ������� (1.21)
    P = P + P_i;
    end
    BP = 20*log10((abs(P))/(max(abs(P))));%�������� ������������� �� ������� (1.20)
    P_out = cat(1,P_out,BP);    %����� ������ ��� ������ ������
    P = 0;
    BP = 0;
end 


%%

figure(1);
hold on;
plot(90:-2:-90,P_out(1,:));
plot(90:-2:-90,P_out(2,:));
plot(90:-2:-90,P_out(3,:));
plot(90:-2:-90,P_out(4,:));
plot(90:-2:-90,P_out(5,:));
plot(90:-2:-90,P_out(6,:));
plot(90:-2:-90,P_out(7,:));
plot(90:-2:-90,P_out(8,:));
plot(90:-2:-90,P_out(9,:));
plot(90:-2:-90,P_out(10,:));
plot(90:-2:-90,P_out(11,:));
plot(90:-2:-90,P_out(12,:));
plot(90:-2:-90,P_out(13,:));
plot(90:-2:-90,P_out(14,:));
plot(90:-2:-90,P_out(15,:));
plot(90:-2:-90,P_out(16,:));
plot(90:-2:-90,P_out(17,:));
plot(90:-2:-90,P_out(18,:));
plot(90:-2:-90,P_out(19,:));
plot(90:-2:-90,P_out(20,:));
plot(90:-2:-90,P_out(21,:));
plot(90:-2:-90,P_out(22,:));
plot(90:-2:-90,P_out(23,:));
plot(90:-2:-90,P_out(24,:));
plot(90:-2:-90,P_out(25,:));
plot(90:-2:-90,P_out(26,:));
line([10,10], [-400,30]);
line([40,40], [-400,30]);
ylim([-300,30]);
grid on;
xlim([-90,90]);
ylim([-100, 10])
xlabel("���� �������, ����");
ylabel("BP, ��");

figure(2);
[X,Y] = meshgrid(f_up:-f_den:f_down,90:-2:-90);
surf(X,Y,P_out.');
xlabel("�������,��");
ylabel("���� �������, ����");
zlabel("BP, ��");
shading interp; % ������� ����
ylim([-90,90]);
zlim([-40,0])


grid on %��������� �����
colormap('gray'); %������� ������
caxis([-40, 0])

