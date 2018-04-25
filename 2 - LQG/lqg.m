clear
clc

%Matrici dei costi per lo stato (Q) e per i controlli (R)
Q = [2 -2 -1; -2 5 2; -1 2 2];
Qf = Q;
R = [17 0 -4 0 0; 0 1 0 0 0; -4 0 2 0 0; 0 0 0 2 -2; 0 0 0 -2 5];

% Matrice dello stato
A = eye(3);

% Matrice degli ingressi
B = [4 0 -1 0 0; 0 1 0 -1 0; 0 0 1 1 -1];

% Matrice delle uscite
C = [1 1 -1];
D = 0;

estU = zeros(5,1);
y = zeros(1,1);

abs(eig(A))

%Suppongo che lo stato iniziale sia distribuito come una gaussiana con
%valor medio [10 5 7] e covarianza nota
mu = [10 5 7]';
x(:,1) = mu;
var = 0.5;
sigma = var*eye(3);

%Suppongo che i rumori sullo stato e sull'uscita siano a media nulla e
%covarianza nota
Q_noise = var*eye(3);    R_noise = var;

%Parametri della simulazione
sampleTime = 1;
horizon = 7;
T = 0:sampleTime:horizon;

% Determinazione di K_finito e di K_infinito tramite nostra funzione di
% Riccati
[K_finito, K_infinito] = ourRiccatiSolver(A,B,Q,Qf,R,T);

%SIMULAZIONE DEL SISTEMA
%Inizializzazione Kalman
y(1) = C*x(:,1) + normrnd(0,var);
predX = mu; predSigma = sigma;
predY = C*predX;
S = C*predSigma*C' + R_noise;
H = predSigma*(C')*inv(S);
estX(:,1) = predX + H*(y - predY);
sigma = predSigma - H*S*H';

%Simulazione al primo istante
estU(:,1) = K_finito(:,:,1) * estX(:,1);
x(:,2) = A*x(:,1) + B*estU(:,1) + normrnd(0,var,[3,1]);

%Simulazione agli istanti successivi
for t=2:sampleTime:horizon
   y(t) = C*x(:,t) + normrnd(0,var);
   [estX(:,t),sigma] = ourKalman(A,B,C,estX(:,t-1),estU(:,t-1),y(t),sigma,Q_noise,R_noise);
   estU(:,t) = K_finito(:,:,t) * estX(:,t);
   x(:,t+1) = A*x(:,t) + B*estU(:,t) + normrnd(0,var,[3,1]);
end
%Ultimo step (per i grafici)
y(t+1) = C*x(:,t+1) + normrnd(0,var);
[estX(:,t+1),sigma] = ourKalman(A,B,C,estX(:,t),estU(:,t),y(t+1),sigma,Q_noise,R_noise);

%Grafici
figure(1);
subplot(3,1,1);     plot(T,x(1,:));      title('x1 vero');
subplot(3,1,2);     plot(T,x(2,:));      title('x2 vero');
subplot(3,1,3);     plot(T,x(3,:));      title('x3 vero');

figure(2);
subplot(3,1,1);     plot(T,estX(1,:));      title('x1 stimato');
subplot(3,1,2);     plot(T,estX(2,:));      title('x2 stimato');
subplot(3,1,3);     plot(T,estX(3,:));      title('x3 stimato');