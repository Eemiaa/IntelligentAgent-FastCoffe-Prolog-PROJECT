:- consult('teste.pl').
:- dynamic pedido/5.
:- dynamic notificacaoAgendada/3.

/* =============================== ITENS DO CARDAPIO =============================== */

item(1, 3.0, 1, 'Americano').
item(2, 2.0, 2, 'Cappuccino').
item(3, 4.0, 3, 'Double Expresso').
item(4, 3.0, 1, 'Latte').
item(5, 5.0, 2, 'Macchiato').
item(6, 6.50, 2, 'Mint chocolate').
item(7, 8.0, 3, 'Expresso').

/* =========================== REGRAS E FATOS AUXILIARES =========================== */

/* *************************** Gerencia de Pedidos ********************************* */

criarMensagem([], ''). 
criarMensagem([ Item ], Mensagem) :- obterNumeroDoItemEQuantidade(Item, I, Q),
                                     item(I, _, _, Nome),
                                     atomic_list_concat([Q, Nome], ' ', Mensagem).
criarMensagem([ Item | Resto ], Mensagem) :- 
    obterNumeroDoItemEQuantidade(Item, I, Q),
    item(I, _, _, Nome),
    criarMensagem(Resto, MensagemResto),
    atomic_list_concat([Q, ' ', Nome, ', ', MensagemResto], Mensagem).


buscarPedidoPeloID([pedido(ID, Preco, _, _, Itens) | _], ID, Preco, Itens) :- !.
buscarPedidoPeloID([pedido(_, _, _, _, _) | Resto], ID, Preco, Itens) :- buscarPedidoPeloID(Resto, ID, Preco, Itens).


obterNumeroDoItemEQuantidade([I, Q | _], I, Q). 


criarIDPedido(ID):- 
    random_between(1, 10, Numero),
    fila_prioridades(Fila),
    not(buscarPedidoPeloID(Fila, Numero, _, _)),
    ID = Numero, !.


criarIDPedido(ID):- criarIDPedido(ID).


calcularPrecoEEsperaTotal([], PTotal, ETotal, PTotal, ETotal).


calcularPrecoEEsperaTotal([ItemN|Restante], PTotalAux, ETotalAux, PTotal, ETotal):- 
    obterNumeroDoItemEQuantidade(ItemN, NumeroItem, Quantidade),
    item(NumeroItem, Preco, Espera, _),
    AuxP is PTotalAux + Preco * Quantidade,
    AuxE is ETotalAux + Espera * Quantidade,
    calcularPrecoEEsperaTotal(Restante, AuxP, AuxE, PTotal, ETotal), !.


calcularPrecoEEsperaTotal(Itens, PTotal, ETotal) :- calcularPrecoEEsperaTotal(Itens, 0, 0, PTotal, ETotal).

/* ************************* Gerencia de Notificacoes ****************************** */

obterTempoAtualEmSegundos(TempoSegundos) :-
    get_time(Tempo),
    floor(Tempo, TempoSegundos).


lerPid(PID) :- open('pid.txt', read, Stream),
                read_line_to_string(Stream, PIDString),
                close(Stream),
                number_string(PID, PIDString).


agendarNotificacao(Segundos, ID) :-
    fila_prioridades(Fila),
    buscarPedidoPeloID(Fila, ID, _, Itens),
    criarMensagem(Itens, Mensagem),
    format(string(Comando), "sleep ~w && echo '\nO pedido ~w está pronto: \n ~w' > /dev/pts/1 & echo $! > pid.txt", [Segundos, ID, Mensagem]),
    shell(Comando),
    lerPid(PID),
    obterTempoAtualEmSegundos(TempoAtual),
    write('tempo atual = '), write(TempoAtual), nl,
    TempoPrevisto is TempoAtual + Segundos,
    assertz(notificacaoAgendada(PID, ID, TempoPrevisto)).


cancelarNotificacao(ID) :-
    retract(notificacaoAgendada(PID, ID, _)),
    format(string(Comando), 'kill ~w', [PID]),
    shell(Comando).


adiarNotificacao(MaisSegundos, ID) :-
    notificacaoAgendada(_, ID, TempoPrevisto),
    obterTempoAtualEmSegundos(TempoAtual),
    TempoDecorrido is TempoPrevisto - TempoAtual,
    write('Quanto ta faltando pra finalizar o pedido '), write(ID), write('= '), write(TempoDecorrido), nl,
    NovosSegundos is TempoDecorrido + MaisSegundos,
    cancelarNotificacao(ID),
    agendarNotificacao(NovosSegundos, ID).

/* =========================== REGRAS USADAS PELO CLIENTE ========================== */

cardapio :- findall(item(Numero, Preco, _, Descricao), item(Numero, Preco, _, Descricao), Itens),
            write('\u001b[45m =================== \u2615 CARDAPIO \u2615 ====================\u001b[m'), nl,
            mostrarCardapio(Itens).

mostrarCardapio([]) :-  write('\u001b[45m =======================================================\u001b[m'), nl, !.
mostrarCardapio([item(Numero, Preco, _, Descricao) | Resto]) :- 
    format('~w. ~w....................~w', [Numero, Descricao, Preco]), nl,
    mostrarCardapio(Resto).

                                                                
fazerPedido(Espera, ID) :-  
    fila_prioridades(Fila),
    length(Fila, Tamanho),
    Tamanho < 10,
    write('Insira seu pedido em uma lista de listas: '), nl,
    write('[[< Numero do item >, < Quantidade >], ...]'), nl,
    read(Itens), nl, 
    write('Prioridade [true/false]: '),nl,
    read(Prioridade), nl,
    calcularPrecoEEsperaTotal(Itens, PTotal, Espera),
    criarIDPedido(ID),
    adicionar_pedido(ID, PTotal, Prioridade, Itens),
    agendarNotificacao(Espera, ID),
    % asserta(pedido(ID, PTotal)), 
    !.

fazerPedido(_, _) :- write('Temos muitos pedidos em andamento, volte mais tarde...').                            