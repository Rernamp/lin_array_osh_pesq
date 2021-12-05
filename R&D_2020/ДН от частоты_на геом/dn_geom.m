clear;

f_re = 3000;%������� ��� ������� ��������� ��
c = 343;%�������� �����
lamda = c/f_re;%����� ����� 
N_one = 10;%���-�� ��������
omega = -90:2:90;
f_up = 4000;    %������� ������� 
f_down = 100;  %������ �������
f_den = 100;    %��� ������

d = lamda/2;%���������� ����� ���������


w = [];     %������ ������� �����.
ff_sig = f_down:f_den:f_up; %�������� ������
ww = [];
ksi = 0;
%���� ��� �������� ������� ������������� ��� ��������� ������
    %��������� �� ������ �������
    
       %����� ����� ��� ������������ �������
F = zeros(1,length(omega));
Ff = [];
for fff_sig = f_down:f_den:f_up
    lamda_i = c/fff_sig;
    for i = 1:N_one
        F = F + ((-exp((-1i*2*pi*d*(i-1)*sind(omega-ksi))/(lamda_i)))/((N_one)^0.5));
    end
    Ff = [Ff ; F];
    F = F*0;
end



set(0,'DefaultAxesFontSize',14,'DefaultAxesFontName','Times New Roman');
set(0,'DefaultTextFontSize',14,'DefaultTextFontName','Times New Roman'); 
kF = abs(Ff);
for fff_sig = (f_down:f_den:f_up)/f_down
    kF(fff_sig,:) = kF(fff_sig,:)/max(kF(fff_sig,:));
end
    
   
%%

[X,Y] = meshgrid(f_up:-f_den:f_down,omega);
C = X.*Y;
surf(X,Y,db(kF).');
zlim([-40 0]);
xlabel("�������,��");
ylabel("���� �������, ����");
colormap('gray'); %������� ������
caxis([-40, 0])
zlabel("BP, ��");
colormap('gray'); %������� ������
shading interp % ������� ����
grid on %��������� �����
