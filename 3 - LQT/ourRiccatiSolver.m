function [L, Lg, g] = ourRiccatiSolver(A,B,C,Q,Qf,R,T,z)
    N = length(T);          %numero di istanti di tempo
    P(:,:,N) = Qf;          %inizializzazione P
    g(:,N) = C'*Qf*z;       %inizializzazione g
    E = B*inv(R)*B';
    W = C'*Q;
    I = eye(length(A));
    
    %calcolo P e g a ritroso
    for t=N:-1:2
       P(:,:,t-1) = Q + A'*P(:,:,t)*A - A'*P(:,:,t)*B * inv(R + B'*P(:,:,t)*B)*B'*P(:,:,t)*A;
       g(:,t-1) = A' * (I - inv(inv(P(:,:,t))*E)) * g(:,t) + W*z;
    end
    
    %calcolo L e Lg in avanti
    for t=1:N-1
       Lg(:,:,t) = inv(R + B'*P(:,:,t+1)*B) * B';
       L(:,:,t) = Lg(:,:,t) * P(:,:,t+1) * A;
    end
end