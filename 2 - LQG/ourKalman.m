%Questa funzione implementa il filtro di Kalman
%Va chiamata ad ogni passo della simulazione
%Input: stima dello stato precedente, controllo precedente, covarianze,
%       uscita reale del sistema, modello del sistema
%Covarianze: dello stato (sigma), rumori sullo stato (Q) e sull'uscita (R)
%Output: stima dello stato e della covarianza dello stato ad un dato istante
function [nextX,nextSigma] = ourKalman(A,B,C,prevX,prevU,y,prevSigma,Q,R)
    extX = A*prevX + B*prevU;                  %predizione dello stato
    extSigma = A*prevSigma*A' + Q;             %predizione covarianza stato
    extY = C*extX;                             %predizione dell'uscita
    S = C*extSigma*C' + R;                     %predizione covarianza uscita
    H = extSigma*(C')*inv(S);                  %calcolo guadagno di Kalman
    nextX = extX + H*(y - extY);               %stima dello stato
    nextSigma = extSigma - H*S*H';             %stima covarianza stato
end