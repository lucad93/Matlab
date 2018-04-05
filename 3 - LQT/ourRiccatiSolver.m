function [L, Lg, g] = ourRiccatiSolver(A,B,C,Q,Qf,R,T,z)
    N = length(T);          %numero di istanti di tempo
    P(:,:,N) = C'*Qf*C;     %inizializzazione P
    g(:,N) = C'*Qf*z;       %inizializzazione g
    E = B*inv(R)*B';
    W = C'*Q;
    I = eye(length(A));
    
    %calcolo P e g a ritroso
    for t=N:-1:2
       P(:,:,t-1) = A'*P(:,:,t)*inv(I+E*P(:,:,t))*A + C'*Q*C;
       g(:,t-1) = A' * (I - inv(inv(P(:,:,t))+E)*E) * g(:,t) + W*z;
    end
    
    %calcolo L e Lg in avanti
    for t=1:N-1
       Lg(:,:,t) = inv(R + B'*P(:,:,t+1)*B) * B';
       L(:,:,t) = Lg(:,:,t) * P(:,:,t+1) * A;
    end
end