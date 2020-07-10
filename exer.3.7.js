function yee(){
    // Declaração de ctes
    var c = 299792458;
    var sigma = 1;
    var mi = 4*math.pi*(10**(-7));
    var epsilon = 1/(mi*(c**2));
    var N = 100;
    var I = 100;
    var J = 100;
    var d = 10;
    var dt = d/(c*math.sqrt(2));

    // Cálculo das ctes
    var Jz = 0;
    var Mx = 0;
    var My = 0;
    var Ca = (1 - sigma*dt/(2*epsilon))/(1 + sigma*dt/(2*epsilon));
    var Cb = (dt/(epsilon*d))/(1 + sigma*dt/(2*epsilon));
    var Da = (1 - sigma*dt/(2*mi))/(1 + sigma*dt/(2*mi));
    var Db = (dt/(mi*d))/(1 + sigma*dt/(2*mi));

    //Script Principal
    //Ez = ((N+1, I+1, J+3))      // Saltos n = 1/2, i = 1/2, j = 1/2
    //Hx = ((N+1, I+1, J+1))      // Saltos n = 1, i = 1/2, j = 1
    //Hy = ((N+1, I+1, J+1))      // Saltos n = 1, i = 1, j = 1/2

    var Ez = Array.apply(null, Array(N+1)).map(Number.prototype.valueOf, 0);
    var Hz = Array.apply(null, Array(N+1)).map(Number.prototype.valueOf, 0);
    var Hy = Array.apply(null, Array(N+1)).map(Number.prototype.valueOf, 0);
    for(var i = 0; i < I+1; i++){
        Ez[i] = Array.apply(null, Array(I+1)).map(Number.prototype.valueOf, 0);
        Hz[i] = Array.apply(null, Array(I+1)).map(Number.prototype.valueOf, 0);
        Hy[i] = Array.apply(null, Array(I+1)).map(Number.prototype.valueOf, 0);
        for(var j = 0; j < J+3; j++){
            Ez[i][j] = Array.apply(null, Array(J+1)).map(Number.prototype.valueOf, 0);
            if(j < J+1){
                Hz[i][j] = Array.apply(null, Array(J+1)).map(Number.prototype.valueOf, 0);
                Hy[i][j] = Array.apply(null, Array(J+1)).map(Number.prototype.valueOf, 0);
            }
        }
    }

    for(var n = 0; n < N; n++){
        for(var i = 0; i < I; i++){
            for(var j = 0; j < J; j++)
                if(i != 0){
                    Ez[n+1][i-1][j+1] = Ca*Ez[n-1][i-1][j+1] + Cb * (Hy[n][i][j+1] - Hy[n][i-1][j+1] + Hx[n][i-1][j] - Hx[n][i-1][j+1] - Jz*d);
                    Hx[n+1][i-1][j+1] = Da*Hx[n][i-1][j+1] + Db * (Ez[n+1][i-1][j+1] - Ez[n+1][i-1][j+3] - Mx*d);
                    Hy[n+1][i][j+1] = Da*Hy[n][i][j+1] + Db * (Ez[n+1][i+1][j+1] - Ez[n+1][i-1][j+1] - My*d);
                }
                
        }
    }
}

window.onload = function() {
    yee();
};
