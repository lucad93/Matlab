%% Fase di creazione del grafo
clear
clc
tic

% Parametri del problema
n = 4;                                              % numero di job
jobs = 1:n;
constraints = [];                                   % matrice dei vincoli
proc_time = [8 6 10 7];                             % processing time di ogni job
due_time = [14 9 16 16];                            % due time di ogni job
weight = [0.25 0.25 0.25 0.25];                     % peso di ogni job

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
       state{i}(j).cost = [];                       % contiene tutti i costi per tutti gli stati successivi
       state{i}(j).optimal = [];                    % contiene il costo ottimo e lo stato successivo ottimo
   end
end

% Faccio i collegamenti tra gli stati di ogni stadio
for i=1:n                               % esamino gli stadi contigui a coppie (i,i+1)
   % Esamino tutte le possibili coppie formabili tra gli stati di due stadi contigui
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
              % lo stato attuale è sottoinsieme del successivo
              if all(ismember(state{i}(j).jobs, state{i+1}(k).jobs)) == 1
                  state{i}(j).next(end+1) = k;
                  state{i+1}(k).prev(end+1) = j;
              end
          end
      end
      % In ogni caso alloco il vettore dei costi di ogni stato come vettore di infiniti
      state{i}(j).cost = Inf(1, length(state{i+1}));
   end
end
toc


%% Fase backward della programmazione dinamica
tic
% Calcolo i costi per andare da uno stato all'altro, partendo dall'ultimo stadio
% All'unico stato dell'ultimo stadio viene assegnato costo nullo
state{n+1}.optimal = [0 0];
% Per tutti gli altri stadi
for i=n:-1:1
    % Guardo tutti gli archi per passare dallo stadio attuale a quello successivo
    % Itero tra gli stati dello stadio attuale
    for j=1:length(state{i})
       % Per ogni stato guardo tutti gli archi uscenti
       for k=1:length(state{i}(j).next)
          % Calcolo il costo tra lo stato attuale e il successivo (con l'arco che sto considerando)
          nextStateIndex = state{i}(j).next(k);
          % Il costo è dato dalla somma dei processing time dei job eseguiti nello stato 
          % in considerazione (st) + la tardiness (T) pesata (w), con
          % T = massimo tra (st + processing time del job da eseguire per andare
          % nello stato successivo - sua due time) e 0
          % + il costo per andare nel nuovo stato
          % Se però l'arco viola uno dei vincoli, viene lasciato costo infinito
          if verifyConstraints(constraints, state{i}(j).jobs, state{i+1}(nextStateIndex).jobs)
              % Calcolo st, sommando sui processing time dei job dello stato
              st = 0;
              stateJobs = state{i}(j).jobs;
              for o=1:length(stateJobs)
                  st = st + proc_time(stateJobs(o));
              end
              %Trovo il job che deve essere scelto
              nextJob = setdiff(state{i+1}(nextStateIndex).jobs, state{i}(j).jobs);
              % Calcolo T
              T = max([(st+proc_time(nextJob)-due_time(nextJob)), 0]);
              % Il costo totale è il costo dello stato successivo + la tardiness pesata
              state{i}(j).cost(nextStateIndex) = weight(nextJob)*T + ...
                  state{i+1}(nextStateIndex).optimal(1);
          end
       end
       % Quando ho calcolato tutti i costi per andare negli stati
       % successivi, trovo quello minimo
       [minCost, optStateIndex] = min(state{i}(j).cost);
       % Assegno il minimo trovato a state.optimal nella forma [costoOttimo, statoOttimo]
       state{i}(j).optimal = [minCost optStateIndex];
    end
end
toc
