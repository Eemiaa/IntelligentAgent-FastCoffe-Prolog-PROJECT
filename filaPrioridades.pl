:- dynamic fila_prioridades/1.
:- dynamic cont/1.
fila_prioridades([]).
cont(0).

% Adicionar um pedido à fila de prioridades
adicionar_pedido(ID, Preco, Prioridade) :-
    retract(cont(C)),
    NewC is C + 1,
    asserta(cont(NewC)),
    retract(fila_prioridades(Fila)),
    inserir_pedido(Fila, pedido(ID, Preco, Prioridade, C), NovaFila),
    assertz(fila_prioridades(NovaFila)).

% Remover um pedido da fila de prioridades
remover_pedido(ID) :-
    retract(fila_prioridades(Fila)),
    remover_pedido(Fila, ID, NovaFila),
    assertz(fila_prioridades(NovaFila)).

% Alterar a prioridade de um pedido na fila de prioridades
alterar_prioridade(ID, NovaPrioridade) :-
    retract(fila_prioridades(Fila)),
    alterar_prioridade(Fila, ID, NovaPrioridade, NovaFila),
    assertz(fila_prioridades(NovaFila)).

% Inserir um pedido na fila de prioridades
inserir_pedido([], Pedido, [Pedido]).
inserir_pedido([Pedido1|Resto], Pedido2, [Pedido2,Pedido1|Resto]) :-
    compara_prioridades(Pedido2, Pedido1).
inserir_pedido([Pedido1|Resto], Pedido2, [Pedido1|NovaFila]) :-
    inserir_pedido(Resto, Pedido2, NovaFila).

% Remover um pedido da fila de prioridades
remover_pedido([], _, []).
remover_pedido([Pedido|Resto], ID, NovaFila) :-
    Pedido = pedido(ID, _, _, _),
    remover_pedido(Resto, ID, NovaFila).
remover_pedido([Pedido|Resto], ID, [Pedido|NovaFila]) :-
    remover_pedido(Resto, ID, NovaFila).

% Alterar a prioridade de um pedido na fila de prioridades
alterar_prioridade([], _, _, []).
alterar_prioridade([pedido(ID, Preco, _)|Resto], ID, NovaPrioridade, [pedido(ID, Preco, NovaPrioridade)|NovaFila]) :-
    !,
    alterar_prioridade(Resto, ID, NovaPrioridade, NovaFila).
alterar_prioridade([Pedido|Resto], ID, NovaPrioridade, [Pedido|NovaFila]) :-
    alterar_prioridade(Resto, ID, NovaPrioridade, NovaFila).

% Comparar as prioridades entre dois pedidos
compara_prioridades(pedido(_, _, true, _), pedido(_, _, false, _)).
compara_prioridades(pedido(_, _, true, C1), pedido(_, _, true, C2)) :-
    C1 =< C2.