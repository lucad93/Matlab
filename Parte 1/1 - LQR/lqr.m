clear;
clc;

%matrici dei costi per lo stato (Q) e per i controlli (R)
% Q = [2 -2 -1; -2 5 2; -1 2 2];
% R = [17 0 -4 0 0; 0 1 0 0 0; -4 0 2 0 0; 0 0 0 2 -2; 0 0 0 -2 5];
% Qf = Q;

%TEST: Modifico Q e vedo che succede
% min a*x(1)^2 + b*x(2)x^2 + c*x(3)^2 + (d*x(1) - e*x(2) - f*x(3))^2
a=2; b=3; c=1; d=4; e=2; f=3;
Q = [a+d^2 -d*e -d*f
     -d*e b+e^2 e*f
     -d*f e*f c+f^2];
Qf = Q;

%TEST: Modifico R e vedo che succede
% min g*u(1)^2 + h*u(2)^2 + l*u(3)^2 + m*u(4)^2 + n*u(5)^2 + 
% + (o*u(1) - p*u(2) - q*u(3) - r*u(4) - s*u(5))^2
g=1; h=2; l=3; m=2; n=1; o=2; p=3; q=2; r=1; s=2; 
R = [g+o^2 -o*p -o*q -o*r -o*s;
     -o*p h+p^2 p*q p*r p*s
     -o*q p*q l+q^2 q*r q*s
     -o*r p*r q*r m+r^2 r*s
     -o*s p*s q*s r*s n+s^2];

%Matrice dello stato
A = eye(3);

%Matrice degli ingressi
B = [4 0 -1 0 0; 0 1 0 -1 0; 0 0 1 1 -1];

%Matrice delle uscite
C = eye(3);
D = 0;

%Parametri della simulazione
horizon = 7;                        %giorni
sampleTime = 1;
T = 0:sampleTime:horizon;           %vettore che contiene tutti gli istanti temporali
x0 = [10 5 7]';                     %stato inziziale (a caso)

%CONTROLLO LQR
%Equazione di Riccati per determinare K
[K, K_infinito] = ourRiccatiSolver(A,B,Q,Qf,R,T);

%provo prima con K_infinito
sys = ss(A+B*K_infinito,B,C,D,sampleTime);
U = zeros(5,length(T));
[Y,Tsim,X] = lsim(sys,U,T,x0);
figure(1);
subplot(3,1,1); plot(Tsim,X(:,1));  title('x1');
subplot(3,1,2); plot(Tsim,X(:,2));  title('x2');
subplot(3,1,3); plot(Tsim,X(:,3));  title('x3');

%provo ora con K
%sys = ss(A+B*K(:,:,1),B,C,D,sampleTime);
U = zeros(5, 1);

figure(2);
x(:,1) = x0;

%Simulazione manuale su un orizzonte finito
for t = 1:horizon
    u(:,t) = K(:,:,t) * x(:,t);
    x(:,t+1) = A * x(:,t) + B * u(:,t);
end

subplot(3,1,1); plot(T,x(1,:,:));  title('x1');
subplot(3,1,2); plot(T,x(2,:,:));  title('x2');
subplot(3,1,3); plot(T,x(3,:,:));  title('x3');

%Guardando i grafici si nota che la condizione x1(t)~2*x2(t)+x3(t) è
%verificata a regime.
%Facendo una stampa dei controlli si nota che anche le condizioni
%u3(t)~4*u1(t) e u4(t)~2*u5(t) sono (più o meno) soddisfatte per t>1
%faccio vedere questa cosa graficamente
figure(3)
subplot(2,1,1);     plot(T(1:horizon),u(3,:)-4*u(1,:));      title('U3 - 4U1');
subplot(2,1,2);     plot(T(1:horizon),u(4,:)-2*u(5,:));      title('U4 - 2U5');