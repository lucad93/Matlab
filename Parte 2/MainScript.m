%% Fase di creazione del grafo
clear
clc
tic

% Parametri del problema
n = 3;                                              % numero di job
jobs = 1:n;
constraints = [2 1];                                % matrice dei vincoli

% Ogni stadio i (i va da 0 a 11) ha uno stato per ognuna delle combinazioni degli 11 job
% presi a gruppi di i
comb{n+1} = [];
for i = 1:n+1
    % Con le graffe creo matrici che hanno elementi con dimensioni variabili
    comb{i} = combnk(jobs,i-1);
end

% Ad ognuna di queste combinazioni in ogni stadio va associato uno stato
% Uso una struttura dati per implementare i nodi, perché in oguno devo
% memorizzare i job che contiene, i successori, i precedenti e il costo ottimo
state{n+1} = [];
for i=1:n+1                                         % per ongi stadio
   for j=1:size(comb{i},1)                          % per ogni stato in questo stadio
       state{i}(j).jobs = comb{i}(j,:);
       state{i}(j).next = [];
       state{i}(j).prev = [];
       state{i}(j).cost = [];  
   end
end

% Faccio i collegamenti tra gli stati di ogni stadio
for i=1:n                               % esamino gli stadi contigui a coppie (i,i+1)
   % esamino tutte le possibili coppie formabili tra gli stati di due stadi contigui
   for j=1:length(state{i})
      for k=1:length(state{i+1})
          % se i==1 sto esaminando lo stadio 0, dove tutti i collegamenti sono possibili
          % in next e prev memorizzo gli indici degli stati, non l'insieme
          % dei job che contengono
          if i==1
              state{i}(j).next(end+1) = k;
              state{i+1}(k).prev(end+1) = j;
          else
              % controllo che il collegamento sia ammissibile, ovvero se
              % hanno almeno un job in comune (intersezione degli insiemi
              % dei job diversa da insieme vuoto)
              if ~isempty(intersect(state{i}(j).jobs, state{i+1}(k).jobs))
                  state{i}(j).next(end+1) = k;
                  state{i+1}(k).prev(end+1) = j;
              end
          end
      end
   end
end
toc


%% Fase backward della programmazione dinamica
tic
% Considero due stadi contigui, partendo dall'ultimo
for i=n+1:-1:2
    
end
toc

