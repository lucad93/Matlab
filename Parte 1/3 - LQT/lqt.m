clear
clc

%Parametri della simulazione
sampleTime = 1;
horizon = 7;
T = 0:sampleTime:horizon;

%Matrici dei costi per lo stato (Q) e per i controlli (R)
b = 10000;
c = 1;
for t=1:horizon
   if t==5 || t==6
      a = b; 
   else
      a = 0; 
   end
   Q(:,:,t) = [a+1 -2 -1; -2 b+4 2; -1 2 c+1];
end
a = 0;
Qf = [a+1 -2 -1; -2 b+4 2; -1 2 c+1];

R = [17 0 -4 0 0; 0 1 0 0 0; -4 0 2 0 0; 0 0 0 2 -2; 0 0 0 -2 5];

% Matrice dello stato
A = eye(3);

% Matrice degli ingressi
B = [4 0 -1 0 0; 0 1 0 -1 0; 0 0 1 1 -1];

% Matrice delle uscite
C = eye(3);
D = 0;

%Stato iniziale e segnale di riferimento
x0 = [8 5 7]';
for t=1:length(T)
   z(1,t) = 10;
   z(2,t) = -10;
   z(3,t) = 0;
end

%Ottengo le matrici per il controllo ottimo
[L, Lg, g] = ourRiccatiSolver(A,B,C,Q,Qf,R,T,z);

%Simulo il sistema
x(:,1) = x0;
for t=1:sampleTime:horizon
   u(:,t) = -L(:,:,t)*x(:,t) + Lg(:,:,t)*g(:,t+1);
   x(:,t+1) = A*x(:,t) + B*u(:,t);
end

%Grafici dello stato del sistema
subplot(3,1,1);     plot(T,x(1,:));     title('x1');
subplot(3,1,2);     plot(T,x(2,:));     title('x2');
subplot(3,1,3);     plot(T,x(3,:));     title('x3');