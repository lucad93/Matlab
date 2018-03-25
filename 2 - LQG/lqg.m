clear
clc

%Test della funzione di Kalman
A = [-0.5 0 0; 0 -0.5 0; 0 2 -0.5];
B = zeros(3,5);
C = eye(3);
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
T = 0:7;

for t=1:length(T)-1
    x(:,t+1) = A*x(:,t) + normrnd(0,1,[3,1]);                   %vero stato
    y = C*x(:,t+1) + normrnd(0,1,[3,1]);                        %vera uscita
    [extX(:,t+1), covX] = ourKalman(A,B,C,x(:,t),u,y,covX,Q,R); %stima stato
end

subplot(2,1,1); plot(T,x(:,:));     title('Vero stato');
subplot(2,1,2); plot(T,extX(:,:));  title('Stato stimato');