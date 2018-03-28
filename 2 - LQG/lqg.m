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
extU = zeros(5,1);

abs(eig(A))

%Suppongo che lo stato iniziale sia distribuito come una gaussiana con
%valor medio [10 5 -3] e covarianza nota
mu = [10 5 -3]';
x(:,1) = mu;
sigma = 0.1*eye(3);

%Suppongo che i rumori sullo stato e sull'uscita siano a media nulla e
%covarianza nota
Q_noise = 0.1*eye(3);    R_noise = 0.1;

%Parametri della simulazione
sampleTime = 1;
horizon = 7;
T = 0:sampleTime:horizon;

% Determinazione di K_finito e di K_infinito tramite nostra funzione di
% Riccati
[K_finito, K_infinito] = ourRiccatiSolver(A,B,Q,Qf,R,T);

%Simulazione del sistema reale
stato_reale = figure;
for t=1:sampleTime:horizon
   u(:,t) = K_finito(:,:,t) * x(:,t);
   x(:,t+1) = A*x(:,t) + B*u(:,t) + normrnd(0,0.1,[3,1]);
   y(t) = C*x(:,t) + normrnd(0,0.1);
end
y(length(T)) = C*x(:,length(T)) + normrnd(0,0.1);          %serve per la simulazione successiva
figure(stato_reale);
subplot(3,1,1);     plot(T,x(1,:));     title('x1');
subplot(3,1,2);     plot(T,x(2,:));     title('x2');
subplot(3,1,3);     plot(T,x(3,:));     title('x3');

%Simulazione manuale usando K_finito
extX(:,1) = mu;
stato_stimato = figure;
for t=1:sampleTime:horizon
    extU(:,t) = K_finito(:,:,t) * extX(:,t);
   [extX(:,t+1), sigma] = ourKalman(A,B,C,extX(:,t),extU(:,t),y(t+1),sigma,Q_noise,R_noise);
end
figure(stato_stimato);
subplot(3,1,1);     plot(T,extX(1,:));     title('x1');
subplot(3,1,2);     plot(T,extX(2,:));     title('x2');
subplot(3,1,3);     plot(T,extX(3,:));     title('x3');