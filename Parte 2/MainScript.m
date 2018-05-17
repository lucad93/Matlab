clear
clc

% Dichiaro i job
n = 3;
jobs = 1:n;

% Ogni stadio i (i va da 0 a 11) ha uno stato per ognuna delle combinazioni degli 11 job
% presi a gruppi di i
for i = 1:n
    stadio{i} = combnk(jobs,i-1);
end

% Ad ognuna di queste combinazioni in ogni stadio va associato uno stato
% Si potrebbe usare una struttura dati per implementare i nodi, perché in
% ognuno devo memorizzare i job che contiene, i successori e il costo ottimo 
for i=1:length(stadio)
   for j=1:length(stadio{i})
       node(i,j).jobs = stadio{i}(j,:);
       node(i,j).succ = [];
       node(i,j).cost = [];
   end
end   