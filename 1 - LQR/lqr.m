clear;
clc;

%matrici dei costi per lo stato (Q) e per i controlli (R)
Q = [2 -2 -2; -2 5 2; -2 2 2];
Qf = Q;
R = [17 0 -4 0 0; 0 1 0 0 0; -4 0 2 0 0; 0 0 0 2 -2; 0 0 0 -2 5];

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
x0 = [10 5 -3]';                    %stato inziziale (a caso)

%CONTROLLO LQR
%Equazione di Riccati per determinare K
[P, K, K_infinito] = riccati_P_K(A,B,Q,Qf,R,T);

%provo prima con K_infinito
sys = ss(A+B*K_infinito,B,C,D,sampleTime);
U = zeros(5,length(T));
[Y,Tsim,X] = lsim(sys,U,T,x0);
subplot(3,1,1); plot(Tsim,X(:,1));  title('x1');
subplot(3,1,2); plot(Tsim,X(:,2));  title('x2');
subplot(3,1,3); plot(Tsim,X(:,3));  title('x3');

%Guardando i grafici si nota che la condizione x1(t)~2*x2(t)+x3(t) è
%verificata a regime.
%Facendo una stampa dei controlli si nota che anche le condizioni
%u3(t)~4*u1(t) e u4(t)~2*u5(t) sono (più o meno) soddisfatte per t>1