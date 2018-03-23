function [P,K,K_infinito] = riccati_P_K(A,B,Q,Qf,R,T)
N=length(T)-1;
 
%calcolo K a tempo finito
P(:,:,N+1)=Qf; %P è settata come matrice a 3 dimensioni per far avere evoluzione temporale
for i=N:-1:1 % ne calcoliamo uno in più, dovrebbe essere fino a 1
P(:,:,i)=Q+A'*P(:,:,i+1)*A-A'*P(:,:,i+1)*B*...
     (inv(R+B'*P(:,:,i+1)*B))*B'*P(:,:,i+1)*A;
end
 
for i=1:N
K(:,:,i)=-inv(R + B'*P(:,:,i+1)*B)*...
          B'*P(:,:,i+1)*A;
end
 
%calcolo K a tempo infinito(almeno 5/6 istanti)
P_inf(:,:,101)=Qf;
for i=100:-1:1
P_inf(:,:,i)=Q+A'*P_inf(:,:,i+1)*A-A'*P_inf(:,:,i+1)*B*...
     (inv(R+B'*P_inf(:,:,i+1)*B))*B'*P_inf(:,:,i+1)*A;
end
 
for i=1:100
K_inf(:,:,i)=-inv(R + B'*P_inf(:,:,i+1)*B)*...
          B'*P_inf(:,:,i+1)*A;
end
 
K_infinito=K_inf(:,:,1);
end

