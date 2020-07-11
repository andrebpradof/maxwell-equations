%% Limpeza de variáveis
clear all;
clc;

%% Constantes
% 1 = Ez, 2 = Hx, 3 = Hy
tipo_g = 1;

% dimensão da grade nas direções x (tam_grade_x) e y (tam_grade_y)
tam_grade_x=200;
tam_grade_y=200;

% Número total de etapas de tempo
tempo_total=250;

epsilon_0=(1/(36*pi))*1e-9;
mu_0=4*pi*1e-7;
c=physconst('LightSpeed');

% comprimento da etapa da grade espacial
d=1;

% Etapa da grade temporal obtida usando a condição Courant
% 3.7 dt = (d)/(c*sqrt(2))  |   3.9 dt = (d*1.0005)/(c*sqrt(2))
dt=(d)/(c*sqrt(2));

%% Inicialização de matrizes de permissividade e permeabilidade
epsilon=epsilon_0*ones(tam_grade_x,tam_grade_y);
mu=mu_0*ones(tam_grade_x,tam_grade_y);

%% Inicializando matrizes de condutividade elétrica e magnética
sigma = 0*zeros(tam_grade_x,tam_grade_y);
sigma_star=0*zeros(tam_grade_x,tam_grade_y);

% sigma para o exercicio 3.8 animacao a
%sigma = 10^(-3)*one(tam_grade_x,tam_grade_y);
%sigma_star= 10^(-3)*ones(tam_grade_x,tam_grade_y);

% sigma para o exercicio 3.8 animacao b
%sigma = 10^(-2)*ones(tam_grade_x,tam_grade_y);
%sigma_star=10^(-2)*ones(tam_grade_x,tam_grade_y);

%% Fator de multiplicação para atualização da matriz H
Da=((mu-0.5*dt*sigma_star)./(mu+0.5*dt*sigma_star)); 
Db=(dt/d)./(mu+0.5*dt*sigma_star);
                          
%% Fator de multiplicação para atualização da matriz E                       
Ca=((epsilon-0.5*dt*sigma)./(epsilon+0.5*dt*sigma)); 
Cb=(dt/d)./(epsilon+0.5*dt*sigma);  

%% Seta vetores
Ez=zeros(tam_grade_x,tam_grade_y);
Hy=zeros(tam_grade_x,tam_grade_y);
Hx=zeros(tam_grade_x,tam_grade_y);

%% Salvar a animação em gif
figure('Renderer', 'painters', 'Position', [0 0 800 600]);
filename = '3_7_hy.gif';

%% Algoritmo de Yee
for n=1:1:tempo_total
    
    [Ez, Hx, Hy] = yee(n, Ca, Cb, Da, Db,tam_grade_x,tam_grade_y, Ez, Hx, Hy);

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
    set(gca,'FontSize',14);
    %% Adicionando as imagens a gif
    frame = getframe(1);
    im = frame2im(frame);
    [imind,cm] = rgb2ind(im,256);
    if n == 1;
        imwrite(imind,cm,filename,'gif', 'Loopcount',inf);
    else
        imwrite(imind,cm,filename,'gif','WriteMode','append');
    end
end
%%
