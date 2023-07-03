:- use_module(library(thread)).
% :- use_module(library(process)).
:- consult('filaPrioridades.pl').
:- dynamic pedidoPronto/5.
:- dynamic notificacaoAgendada/3.
:- dynamic contPedidosProntos/1.
:- dynamic idDoVerificador/2.

/* =============================== ITENS DO CARDAPIO =============================== */

%itemCardapio(1, 3.0, 1, 'Americano').
%itemCardapio(2, 2.0, 2, 'Cappuccino').
%itemCardapio(3, 4.0, 3, 'Double Expresso').
%itemCardapio(4, 3.0, 1, 'Latte').
%itemCardapio(5, 5.0, 2, 'Macchiato').
%itemCardapio(6, 6.50, 2, 'Mint chocolate').
%itemCardapio(7, 8.0, 3, 'Expresso').

/* =========================== REGRAS E FATOS AUXILIARES =========================== */

/* *************************** Gerencia de Pedidos ********************************* */
contPedidosProntos(0).


criarMensagem([], ''). 
criarMensagem([ Item ], Mensagem) :- obterNumeroDoItemEQuantidade(Item, I, Q),
                                     itemCardapio(I, _, _, Nome),
                                     atomic_list_concat([Q, Nome], ' ', Mensagem).
criarMensagem([ Item | Resto ], Mensagem) :- 
    obterNumeroDoItemEQuantidade(Item, I, Q),
    itemCardapio(I, _, _, Nome),
    criarMensagem(Resto, MensagemResto),
    atomic_list_concat([Q, ' ', Nome, ', ', MensagemResto], Mensagem).


buscarPedidoPeloID([pedido(ID, Preco, Prioridade, _, Itens, Espera) | _], ID, Preco, Prioridade, Itens, Espera) :- !.
buscarPedidoPeloID([pedido(_, _, _, _, _, _) | Resto], ID, Preco, Prioridade, Itens, Espera) :- buscarPedidoPeloID(Resto, ID, Preco, Prioridade, Itens, Espera).


obterNumeroDoItemEQuantidade([I, Q | _], I, Q). 


criarIDPedido(ID):- 
    random_between(1, 10, Numero),
    fila_prioridades(Fila),
    not(buscarPedidoPeloID(Fila, Numero, _, _, _, _)),
    not(pedidoPronto(Numero,_, _, _, _)),
    ID = Numero, !.


criarIDPedido(ID):- criarIDPedido(ID).


calcularPrecoEEsperaTotal([], PTotal, ETotal, PTotal, ETotal).


calcularPrecoEEsperaTotal([ItemN|Restante], PTotalAux, ETotalAux, PTotal, ETotal):- 
    obterNumeroDoItemEQuantidade(ItemN, NumeroItem, Quantidade),
    itemCardapio(NumeroItem, Preco, Espera, _),
    AuxP is PTotalAux + Preco * Quantidade,
    AuxE is ETotalAux + Espera * Quantidade,
    calcularPrecoEEsperaTotal(Restante, AuxP, AuxE, PTotal, ETotal), !.


calcularPrecoEEsperaTotal(Itens, PTotal, ETotal) :- calcularPrecoEEsperaTotal(Itens, 0, 0, PTotal, ETotal).


obterEsperasDosPedidosAFrente(ID, SomatorioDasEsperas) :- fila_prioridades(Fila),
                                                          obterEsperasDosPedidosAFrente(Fila, ID, 0, SomatorioDasEsperas).



obterEsperasDosPedidosAFrente([pedido(ID, _, _, _, _, _) | _], ID, SomatorioDasEsperas, SomatorioDasEsperas) :- !.
obterEsperasDosPedidosAFrente([pedido(DiffID, _, _, _, _, _) | Resto], ID, SomaAux, SomatorioDasEsperas) :- 
        fila_prioridades(Fila),
        buscarPedidoPeloID(Fila, DiffID, _, _, _, Espera),
        NewSomaAux is SomaAux + Espera,
        obterEsperasDosPedidosAFrente(Resto, ID, NewSomaAux, SomatorioDasEsperas).
                                                      

adiarEsperasDosPedidosDeTras([], _) :- !.
adiarEsperasDosPedidosDeTras([pedido(ID, _, _, _, _, _) | Resto], MaisSegundos) :- adiarNotificacao(MaisSegundos,ID),
                                                                                   adiarEsperasDosPedidosDeTras(Resto, MaisSegundos).


adiarEsperasDosPedidosDeTras([pedido(ID, _, _, _, _, _)| Resto], ID, MaisSegundos) :- adiarEsperasDosPedidosDeTras(Resto, MaisSegundos), !.
adiarEsperasDosPedidosDeTras([pedido(_, _, _, _, _, _)| Resto], ID, MaisSegundos) :- adiarEsperasDosPedidosDeTras(Resto, ID, MaisSegundos).

/* ************************* Gerencia de Notificacoes ****************************** */

obterTempoAtualEmSegundos(TempoSegundos) :-
    get_time(Tempo),
    floor(Tempo, TempoSegundos).

lerVerificador(Check, PID) :- 
        format(string(Arquivo), 'verificador~w.txt', [PID]),
        open(Arquivo, read, Stream),
        read_line_to_string(Stream, Check),
        close(Stream).



lerPid(PID) :- open('pid.txt', read, Stream),
                read_line_to_string(Stream, PIDString),
                close(Stream),
                number_string(PID, PIDString).


agendarNotificacao(Segundos, ID) :-
    fila_prioridades(Fila),
    buscarPedidoPeloID(Fila, ID, _, _, Itens, _),
    criarMensagem(Itens, Mensagem),
    format(string(Comando), "sleep ~w && echo 'O pedido ~w está pronto: ~w' > /dev/pts/3 & echo $! > pid.txt", [Segundos, ID, Mensagem]),
%    format(string(Comando), "sleep ~w && DISPLAY=:0 notify-send 'O pedido ~w está pronto: ~w' & echo $! > pid.txt", [Segundos, ID, Mensagem]),
    shell(Comando),
    lerPid(PID),
    obterTempoAtualEmSegundos(TempoAtual),
    write('tempo atual = '), write(TempoAtual), nl,
    TempoPrevisto is TempoAtual + Segundos,
    assertz(notificacaoAgendada(PID, ID, TempoPrevisto)),
    monitorarProcesso(PID, ID).


cancelarNotificacao(ID) :-
    retract(idDoVerificador(ID, IDVerificador)),
    thread_signal(IDVerificador, thread_exit(_)),
    retract(notificacaoAgendada(PID, ID, _)),
    format(string(Comando1), 'rm verificador~w.txt', [PID]),
    shell(Comando1),
    format(string(Comando2), 'kill ~w', [PID]),
    shell(Comando2).


adiarNotificacao(MaisSegundos, ID) :-
    notificacaoAgendada(_, ID, TempoPrevisto),
    obterTempoAtualEmSegundos(TempoAtual),
    TempoDecorrido is TempoPrevisto - TempoAtual,
%    write('Quanto ta faltando pra finalizar o pedido '), write(ID), write('= '), write(TempoDecorrido), nl,
    NovosSegundos is TempoDecorrido + MaisSegundos,
    cancelarNotificacao(ID),
    agendarNotificacao(NovosSegundos, ID), !.


gerenciarStarvation(Prioridade) :- 
        Prioridade == true,
        retract(contPedidosProntos(CPP)),
        CPP < 2,
        NewCPP is CPP + 1,
        assertz(contPedidosProntos(NewCPP)).


gerenciarStarvation(Prioridade) :-
        Prioridade == false,
        !.


gerenciarStarvation(_) :- 
        assertz(contPedidosProntos(0)),
        pegar_ultimo_false_da_fila(IDUltimoFalse),
        alterar_prioridade(IDUltimoFalse, true),
        fila_prioridades(Fila),
        buscarPedidoPeloID(Fila, IDUltimoFalse, _, _, _, Espera),
        adiarEsperasDosPedidosDeTras(Fila, IDUltimoFalse, Espera).


monitorarProcesso(PID, IDdoPedido) :-
    thread_create(repetirVerificacao(PID, IDdoPedido), IDVerificador, [detached(true)]),
%    format('PID da thread: ~w', [IDVerificador]),
    asserta(idDoVerificador(IDdoPedido, IDVerificador)).
    
repetirVerificacao(PID, ID) :-
    repeat,
    (
        processoEstaEmExecucao(PID)
        -> sleep(1),
            fail
        ;  !,
            format(string(Comando), 'rm verificador~w.txt', [PID]),
            shell(Comando),
            fila_prioridades(Fila),
            buscarPedidoPeloID(Fila, ID, Preco, Prioridade, Itens, Espera),
            assertz(pedidoPronto(ID,Preco,Prioridade,Itens,Espera)),
            ((gerenciarStarvation(Prioridade), 
            retract(notificacaoAgendada(_, ID, _)),
            remover_pedido(ID));
            retract(notificacaoAgendada(_, ID, _)),
            remover_pedido(ID))
    ).

processoEstaEmExecucao(PID) :-
    format(string(Comando), 'if ps -p ~w > /dev/null; then echo "true" > verificador~w.txt; else echo "false" > verificador~w.txt; fi', [PID, PID, PID]),
    shell(Comando),
    sleep(0.2),
    lerVerificador(Check, PID),
    Check == "true",
    shell(Comando).
    
    
/* =========================== REGRAS USADAS PELO CLIENTE ========================== */

cardapio :- findall(itemCardapio(Numero, Preco, _, Descricao), itemCardapio(Numero, Preco, _, Descricao), Itens),
            write('\u001b[45m =================== \u2615 CARDAPIO \u2615 ====================\u001b[m'), nl,
            mostrarCardapio(Itens).

mostrarCardapio([]) :-  write('\u001b[45m =======================================================\u001b[m'), nl, !.
mostrarCardapio([itemCardapio(Numero, Preco, _, Descricao) | Resto]) :- 
    format('\u001b[44m~w~2|. ~|~w~47+R$~2f\u001b[m', [Numero, Descricao, Preco]), nl,
    mostrarCardapio(Resto).

                                                                
fazerPedido(PTotal, ID) :-  
    fila_prioridades(Fila),
    length(Fila, Tamanho1),
    findall(pedidoPronto(ID,Preco,Prioridade,Itens,Espera), pedidoPronto(ID,Preco,Prioridade,Itens,Espera), BagProntos),
    length(BagProntos, Tamanho2),
    Tamanho is Tamanho1 + Tamanho2,
    Tamanho < 10,
    write('Insira seu pedido em uma lista de listas: '), nl,
    write('[[< Numero do item >, < Quantidade >], ...]'), nl,
    read(Itens), nl, 
    write('Prioridade [true/false]: '),nl,
    read(Prioridade), nl,
    (calcularPrecoEEsperaTotal(Itens, PTotal, Espera),
    criarIDPedido(ID),
    adicionar_pedido(ID, PTotal, Prioridade, Itens, Espera),
    obterEsperasDosPedidosAFrente(ID, SomaDasEsperas),
    EsperaNotificacao is SomaDasEsperas + Espera,
    agendarNotificacao(EsperaNotificacao, ID),
    fila_prioridades(NewFila),
    adiarEsperasDosPedidosDeTras(NewFila, ID, Espera),
    cozinharPedido(Itens),    
    !;
    write('Numero do Item Inválido.'), !).
    

fazerPedido(_, _) :- write('\u001b[41mTemos muitos pedidos em andamento, volte mais tarde...\u001b[m').                            


verStatusDoPedido(ID) :- pedidoPronto(ID, Preco, _, _, _),
                         format('O Pedido ~w já está pronto. O valor total deu R$~w', [ID, Preco]), !.


verStatusDoPedido(ID) :- fila_prioridades(Fila),
                         buscarPedidoPeloID(Fila, ID, _, _, _, _),
                         format('O Pedido ~w ainda não está pronto.', [ID]), !.

                        
verStatusDoPedido(_) :- write('Pedido Inexistente').

cancelarPedido(ID) :- cancelarNotificacao(ID),
                      remover_pedido(ID).

pegarPedido(ID) :- pedidoPago(ID),
                   retract(pedidoPronto(ID, _, _, _, _)),
                   retract(pedidoPago(ID)),
                   write('Aqui está o seu pedido \u2615, volte sempre :)'), !.

pegarPedido(_) :- write('\u001b[41mID do pedido inválido\u001b[m'), !.