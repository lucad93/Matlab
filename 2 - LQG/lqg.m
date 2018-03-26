clear
clc

% Matrice dello stato
%A = [-0.5 0 0; 0 -0.5 0; 0 2 -0.5];
A = eye(3);

% Matrice degli ingressi
%B = zeros(3,5);
B = [4 0 -1 0 0; 0 1 0 -1 0; 0 0 1 1 -1];

% Matrice delle uscite
%C = eye(3);
C = [1 1 -1];
D = 0;

u = zeros(5,1);

abs(eig(A))

%Suppongo che lo stato iniziale sia distribuito come una gaussiana con
%valor medio [5 5 5] e covarianza [1 1 1; 1 1 1; 1 1 1]
x(:,1) = [5 5 5]';      extX(:,1) = [5 5 5]';
covX = ones(3);

%Suppongo che i rumori sullo stato e sull'uscita siano a media nulla e
%varianza unitaria
Q = ones(3);    R = eye(3);

%Simulazione per 8 istanti:
% T = 0:7;
sampleTime = 1;
horizon = 7;
T = 0:sampleTime:horizon;


for t=1:length(T)-1
    x(:,t+1) = A*x(:,t) + normrnd(0,1,[3,1]);                   %vero stato
    y = C*x(:,t+1) + normrnd(0,1,[3,1]);                        %vera uscita
    [extX(:,t+1), covX] = ourKalman(A,B,C,x(:,t),u,y,covX,Q,R); %stima stato
end

Qf = Q;
[K_finito, K_infinito] = ourRiccatiSolver(A,B,Q,Qf,R,T);