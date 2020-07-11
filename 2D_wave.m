% limpeza de variáveis ??na memória e na tela de comando do Matlab
clear all;
clc;

tipo_g = 1;
% dimensão da grade nas direções x (tam_grade_x) e y (tam_grade_y)
tam_grade_x=200;
tam_grade_y=200;
% Número total de etapas de tempo
tempo_total=230;
% Posição da fonte (centro do domínio)
xcentro=100;
ycentro=100;

epsilon_0=(1/(36*pi))*1e-9;
mu_0=4*pi*1e-7;
c=physconst('LightSpeed');
% comprimento da etapa da grade espacial (etapa da grade espacial = 1 mícron)
d=10.^(-6);
% Etapa da grade temporal obtida usando a condição Courant
dt=d*1.0005/(c*sqrt(2));
% Inicialização de matrizes de campo
Ez=zeros(tam_grade_x,tam_grade_y);
Hy=zeros(tam_grade_x,tam_grade_y);
Hx=zeros(tam_grade_x,tam_grade_y);
% Inicialização de matrizes de permissividade e permeabilidade
epsilon=epsilon_0*ones(tam_grade_x,tam_grade_y);
mu=mu_0*ones(tam_grade_x,tam_grade_y);
% Inicializando matrizes de condutividade elétrica e magnética
%sigma=4e-4*ones(tam_grade_x,tam_grade_y);
%sigma_star=4e-4*ones(tam_grade_x,tam_grade_y);
sigma = 0*zeros(tam_grade_x,tam_grade_y);
sigma_star=0*zeros(tam_grade_x,tam_grade_y);
% De matrizes de fator de multiplicação para atualização da matriz H, para evitar serem calculadas muitas vezes
% no loop de atualização de tempo, de modo a aumentar a velocidade de computação
Da=((mu-0.5*dt*sigma_star)./(mu+0.5*dt*sigma_star)); 
Db=(dt/d)./(mu+0.5*dt*sigma_star);
                          
% De matrizes de fator de multiplicação para atualização da matriz E, para evitar serem calculadas muitas vezes
% no loop de atualização de tempo, de modo a aumentar a velocidade de computação                         
Ca=((epsilon-0.5*dt*sigma)./(epsilon+0.5*dt*sigma)); 
Cb=(dt/d)./(epsilon+0.5*dt*sigma);                     
% Comeco do loop
figure('Renderer', 'painters', 'Position', [0 0 800 600]);
for n=1:1:tempo_total
    % Definir limites dependentes do tempo para atualizar apenas partes relevantes do vetor
    % onde a onda atingiu, para evitar atualizações desnecessárias.
    if n<xcentro-2
        n_1=xcentro-n-1;
    else
        n_1=1;
    end
    if n<tam_grade_x-1-xcentro
        n_2=xcentro+n;
    else
        n_2=tam_grade_x-1;
    end
    if n<ycentro-2
        n_1_1=ycentro-n-1;
    else
        n_1_1=1;
    end
    if n<tam_grade_y-1-ycentro
        n_2_1=ycentro+n;
    else
        n_2_1=tam_grade_y-1;
    end
    
    % Atualização de vetor em vez de loop for para campos Hy e Hx
    Hy(n_1:n_2,n_1_1:n_2_1)=Da(n_1:n_2,n_1_1:n_2_1).*Hy(n_1:n_2,n_1_1:n_2_1)+Db(n_1:n_2,n_1_1:n_2_1).*(Ez(n_1+1:n_2+1,n_1_1:n_2_1)-Ez(n_1:n_2,n_1_1:n_2_1));
    Hx(n_1:n_2,n_1_1:n_2_1)=Da(n_1:n_2,n_1_1:n_2_1).*Hx(n_1:n_2,n_1_1:n_2_1)-Db(n_1:n_2,n_1_1:n_2_1).*(Ez(n_1:n_2,n_1_1+1:n_2_1+1)-Ez(n_1:n_2,n_1_1:n_2_1));
    
    % Atualização de vetor em vez de loop for para o campo Ez
    Ez(n_1+1:n_2+1,n_1_1+1:n_2_1+1)=Ca(n_1+1:n_2+1,n_1_1+1:n_2_1+1).*Ez(n_1+1:n_2+1,n_1_1+1:n_2_1+1)+Cb(n_1+1:n_2+1,n_1_1+1:n_2_1+1).*(Hy(n_1+1:n_2+1,n_1_1+1:n_2_1+1)-Hy(n_1:n_2,n_1_1+1:n_2_1+1)-Hx(n_1+1:n_2+1,n_1_1+1:n_2_1+1)+Hx(n_1+1:n_2+1,n_1_1:n_2_1));
    
    % Condição de limite do condutor elétrico perfeito - PEC
    Ez(1:tam_grade_x,1)=0;
    Ez(1:tam_grade_x,tam_grade_y)=0;
    Ez(1,1:tam_grade_y)=0;
    Ez(tam_grade_x,1:tam_grade_y)=0;
    
    % Pulso gaussiano
    if n<=42
        Ez(xcentro,ycentro)=(10-15*cos(n*pi/20)+6*cos(2*n*pi/20)-cos(3*n*pi/20))/32;
    else
        Ez(xcentro,ycentro)=0;
    end

    if tipo_g == 1
        imagesc(Ez);
        title(['\fontsize{14}Propagação de uma onda cilídrinca em 2D (Ez) em n = ',num2str(n),'']); 
    end
    if tipo_g == 2
        imagesc(Hx);
        title(['\fontsize{14}Propagação de uma onda cilídrinca em 2D (Hx) em n = ',num2str(n),'']); 
    end
    if tipo_g== 3
        imagesc(Hy);
        title(['\fontsize{14}Propagação de uma onda cilídrinca em 2D (Hy) em n = ',num2str(n),'']); 
    end

    colormap(hsv);
    colorbar;
    xlabel('x (em 10^-^6)','FontSize',14);
    ylabel('y (em 10^-^6)','FontSize',14);
    set(gca,'FontSize',14);
    getframe;
end
