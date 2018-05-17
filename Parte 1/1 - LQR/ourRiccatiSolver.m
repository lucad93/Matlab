function [K, K_infinite] = ourRiccatiSolver(A,B,Q,Qf,R,T)
    %CALCOLO K
    N = length(T);      %numero di istanti di tempo
    P(:,:,N) = Qf;      %inizializzazione P
    
    %calcolo P a ritroso
    for t=N:-1:2
       P(:,:,t-1) = Q + A'*P(:,:,t)*A - A'*P(:,:,t)*B * inv(R + B'*P(:,:,t)*B)*B'*P(:,:,t)*A; 
    end
    
    %calcolo K in avanti
    for t=1:N-1
       K(:,:,t) = -inv(R + B'*P(:,:,t+1)*B)*B'*P(:,:,t+1)*A;
    end
    %-----------------------------------------------------------------------------------------
    %CALCOLO K_infinite: stessa procedura ma N=100 (per esempio)
    N = 100;
    P(:,:,N) = Qf;
    
    for t=N:-1:2
       P(:,:,t-1) = Q + A'*P(:,:,t)*A - A'*P(:,:,t)*B * inv(R + B'*P(:,:,t)*B)*B'*P(:,:,t)*A; 
    end
    
    %K_inf: variabile per eseguire l'iterazione
    for t=1:N-1
       K_inf(:,:,t) = -inv(R + B'*P(:,:,t+1)*B)*B'*P(:,:,t+1)*A;
    end
    
    %K_infinite viene preso tra i primi valori di K_inf, per esempio il primo
    K_infinite = K_inf(:,:,1);
end