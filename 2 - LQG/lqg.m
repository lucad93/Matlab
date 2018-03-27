clear
clc

%Matrici dei costi per lo stato (Q) e per i controlli (R)
Q = [2 -2 -2; -2 5 2; -2 2 2];
Qf = Q;
R = [17 0 -4 0 0; 0 1 0 0 0; -4 0 2 0 0; 0 0 0 2 -2; 0 0 0 -2 5];

% Matrice dello stato
A = eye(3);

% Matrice degli ingressi
B = [4 0 -1 0 0; 0 1 0 -1 0; 0 0 1 1 -1];

% Matrice delle uscite
C = [1 1 -1];
D = 0;

u = zeros(5,1);

abs(eig(A))

%Suppongo che lo stato iniziale sia distribuito come una gaussiana con
%valor medio [10 5 -3] e covarianza [1 0 0; 0 1 0; 0 0 1]
x0 = [10 5 -3]';
x(:,1) = x0;      extX(:,1) = x0;
covX = eye(3);

%Suppongo che i rumori sullo stato e sull'uscita siano a media nulla e
%varianza unitaria
covErrX = eye(3);    covErrY = 1;

%Simulazione per 8 istanti:
sampleTime = 1;
horizon = 7;
T = 0:sampleTime:horizon;

for t=1:length(T)-1
    x(:,t+1) = A*x(:,t) + normrnd(0,1,[3,1]);                               %vero stato
    y = C*x(:,t+1) + normrnd(0,1);                                          %vera uscita
    [extX(:,t+1), covX] = ourKalman(A,B,C,x(:,t),u,y,covX,covErrX,covErrY); %stima stato
end

subplot(2,1,1);     plot(T,x(:,:));     title("Vero stato");
subplot(2,1,2);     plot(T,extX(:,:));  title("Stato stimato");

% Determinazione di K_finito e di K_infinito tramite nostra funzione di
% Riccati
[K_finito, K_infinito] = ourRiccatiSolver(A,B,Q,Qf,R,T);

% Variabile per il grafico
f_k_infinito = figure;

% Utilizzo di K_infinito
sistema = ss(A+B*K_infinito,B,C,D,sampleTime);
U = zeros(5,length(T));
[Y,Tsim,X] = lsim(sistema,U,T,x0);
figure(f_k_infinito);

% Grafici dell'andamento dello stato in LQG
subplot(3,1,1); plot(Tsim,X(:,1));  title('x1');
subplot(3,1,2); plot(Tsim,X(:,2));  title('x2');
subplot(3,1,3); plot(Tsim,X(:,3));  title('x3');
