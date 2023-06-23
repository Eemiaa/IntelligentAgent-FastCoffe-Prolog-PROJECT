:- consult('filaPrioridades.pl').

:- dynamic pedido/2.
:- dynamic notificacaoAgendada/3.

/* =============================== ITENS DO CARDÁPIO =============================== */

item(1, 3.0, 60).
item(2, 2.0, 120).
item(3, 4.0, 180).
item(4, 3.0, 60).
item(5, 5.0, 120).
item(6, 6.50, 120).
item(7, 8.0, 180).

/* =========================== REGRAS E FATOS AUXILIARES =========================== */

obterNumeroDoItemEQuantidade([I, Q | _], I, Q). 


criarIDPedido(ID):- random_between(1, 10, Numero),
                    not(pedido(Numero,_)),
                    ID = Numero, !.

criarIDPedido(ID):- criarIDPedido(ID).


calcularPrecoEEsperaTotal([], PTotal, ETotal, PTotal, ETotal).

calcularPrecoEEsperaTotal([ItemN|Restante], PTotalAux, ETotalAux, PTotal, ETotal):- obterNumeroDoItemEQuantidade(ItemN, NumeroItem, Quantidade),
                                                                                    item(NumeroItem, Preco, Espera),
                                                                                    AuxP is PTotalAux + Preco * Quantidade,
                                                                                    AuxE is ETotalAux + Espera * Quantidade,
                                                                                    calcularPrecoEEsperaTotal(Restante, AuxP, AuxE, PTotal, ETotal), !.

calcularPrecoEEsperaTotal(Itens, PTotal, ETotal) :- calcularPrecoEEsperaTotal(Itens, 0, 0, PTotal, ETotal).


obterTempoAtualEmSegundos(TempoSegundos) :-
    get_time(Tempo),
    floor(Tempo, TempoSegundos).


lerPid(PID) :- open('pid.txt', read, Stream),
                read_line_to_string(Stream, PIDString),
                close(Stream),
                number_string(PID, PIDString).


agendarNotificacao(Segundos, ID) :-
    format(string(Comando), "sleep ~w && DISPLAY=:0 notify-send 'O pedido ~w está pronto' & echo $! > pid.txt", [Segundos, ID]),
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

cardapio :- write('+------------------------------------+'), nl,
            write('|              CARDAPIO              |'), nl,
            write('+------------------------------------+'), nl,
            write('| 1. Americano................R$3,00 |'), nl,
            write('| 2. Cappuccino...............R$2,00 |'), nl,
            write('| 3. Double Expresso..........R$4,00 |'), nl,
            write('| 4. Latte....................R$3,00 |'), nl,
            write('| 5. Macchiato................R$5,00 |'), nl,
            write('| 6. Mint chocolate...........R$6,50 |'), nl,
            write('| 7. Expresso.................R$8,00 |'), nl,
            write('+------------------------------------+').
                                                                
fazerPedido(Espera, ID) :-  findall(pedido(X,Y), pedido(X,Y), Pedidos),
                            write(Pedidos), nl,
                            length(Pedidos, Tamanho),
                            Tamanho < 10,
                            write('Insira seu pedido em uma lista de listas: '), nl,
                            write('[[< Numero do item >, < Quantidade >], ...]'), nl,
                            read(Itens), nl, 
                            write('Prioridade? [true/false]: '), nl,
                            read(Prioridade), nl, 
                            calcularPrecoEEsperaTotal(Itens, PTotal, Espera),
                            criarIDPedido(ID),
                            adicionar_pedido(ID, PTotal, Prioridade),
                            % verificarEntrada(ID),
                            agendarNotificacao(Espera, ID), !.
                            % asserta(pedido(ID, PTotal)), !.

fazerPedido(_, _) :- write('Temos muitos pedidos em andamento, volte mais tarde...').                            