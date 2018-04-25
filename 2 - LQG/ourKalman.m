%Questa funzione implementa il filtro di Kalman
%Va chiamata ad ogni passo della simulazione
%Input: stima dello stato precedente, controllo precedente, covarianze,
%       uscita reale del sistema, modello del sistema (matrici A,B e C)
%Covarianze: dello stato (sigma), rumori sullo stato (Q) e sull'uscita (R)
%Output: stima dello stato e della covarianza dello stato ad un dato istante
function [estX,estSigma] = ourKalman(A,B,C,prevX,prevU,y,prevSigma,Q,R)
    predX = A*prevX + B*prevU;                   %predizione dello stato
    predSigma = A*prevSigma*A' + Q;              %predizione covarianza stato
    predY = C*predX;                             %predizione dell'uscita
    S = C*predSigma*C' + R;                      %predizione covarianza uscita
    H = predSigma*(C')*inv(S);                   %calcolo guadagno di Kalman
    estX = predX + H*(y - predY);                %stima dello stato
    estSigma = predSigma - H*S*H';               %stima covarianza stato
end