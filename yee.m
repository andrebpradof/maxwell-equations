function [Ez, Hx, Hy] = yee(n, Ca, Cb, Da, Db,tam_grade_x,tam_grade_y, Ez, Hx, Hy)
    
    % Posição da fonte (centro do domínio)
    xcentro=100;
    ycentro=100;
    
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
    
    % Atualização de vetor para campos Hy e Hx
    Hy(n_1:n_2,n_1_1:n_2_1)=Da(n_1:n_2,n_1_1:n_2_1).*Hy(n_1:n_2,n_1_1:n_2_1)+Db(n_1:n_2,n_1_1:n_2_1).*(Ez(n_1+1:n_2+1,n_1_1:n_2_1)-Ez(n_1:n_2,n_1_1:n_2_1));
    Hx(n_1:n_2,n_1_1:n_2_1)=Da(n_1:n_2,n_1_1:n_2_1).*Hx(n_1:n_2,n_1_1:n_2_1)-Db(n_1:n_2,n_1_1:n_2_1).*(Ez(n_1:n_2,n_1_1+1:n_2_1+1)-Ez(n_1:n_2,n_1_1:n_2_1));
    
    % Atualização de vetor para o campo Ez
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
    
    