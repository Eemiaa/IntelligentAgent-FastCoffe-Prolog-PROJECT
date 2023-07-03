% Calcular o valor total do pedido
:- dynamic pedidoPago/1.

:- dynamic tesouro/1.
 
% tesouro/1
% tesouro( quantia_atual )
tesouro(0).
 
% preco/2
% preco( nome_produto, preco_numérico )
preco(maca_doce, 2.50).
preco(batata_frita, 3.5).
preco(latte, 15.50).
 
% realizar_compra/1
% Simula a compra de uma lista de produtos por um cliente no café.
% Parâmetros:
%     ID: ID do pedido.
%     Recebimento: O quanto o caixa recebeu do cliente.
realizar_compra(ID, Recebimento) :-
%    pedidoPronto(ID, ValorTotal, _, _, _),
    fornecer_recibo(ID, Recebimento),
    recebaPagamento(ID), 
    asserta(pedidoPago(ID)),!.
 
% valor_total_pedido/2
% Calcula o valor total do pedido, iniciando o contador de
% calcular_item/3 como zero.
% Parâmetros:
%     ListaProdutos: Lista contendo todos os produtos do cliente.
% Retorna:
%     ValorTotal: O valor total do pedido
valor_total_pedido(ListaProdutos, ValorTotal) :-
    % Para cada item na ListaProdutos, calcule seu valor
    calcular_item(ListaProdutos, 0, ValorTotal), !.
 
% calcular_item/3
% Calcula o preço total, varrendo a lista item por item.
% Parâmetros:
%     ListaProdutos: Lista com os produtos.
%     Contador: Conta o preço total. Começa com zero.
% Retorna:
%     Total: O valor total do pedido.
calcular_item([Item | RestoLista], Contador, Total) :-
    preco(Item, ValorItem),
    NewContador is Contador + ValorItem,
    calcular_item(RestoLista, NewContador, Total).
 
calcular_item([], NewTotal, NewTotal) :- !.
 
 
% fornecer_recibo/2
% Gera o recibo com todos os produtos comprados pelo cliente,
% além do troco e do valor total.
% Parâmetros:
%     ID: ID do pedido.
%     Recebimento: Quanto o caixa recebeu do cliente.
fornecer_recibo(ID, Recebimento) :-
    pedidoPronto(ID, ValorTotal, _, _, _),
    calcular_troco(ID, Recebimento, Troco),
    Recebimento >= ValorTotal,
    format("--- Fast Cofee (TM) ---\n"),
    pedidoPronto(ID, _, _, Itens, _),
    imprimir_produto_recibo(Itens),
    write("-----------------------\n"),
    format("Total Pedido ~15|: ~2f\n", [ValorTotal]),
    format("Troco ~15|: ~2f\n", [Troco]),
    write("-----------------------\n"),
    !.
 
% calcular_troco/3
% Receber o pagamento e dar o troco
% Parâmetros:
%     ID - ID do Pedido;
%     Recebimento - Quantia recebida pelo cliente
% Retorna:
%     Troco - O troco calculado
calcular_troco(ID, Recebimento, Troco) :-
    pedidoPronto(ID, ValorTotal, _, _, _),
    Troco is Recebimento - ValorTotal, !.

% imprimir_produto_recibo/1
% Imprime um produto do recibo, atravessando a lista de produtos.
% Parâmetros:
%     ListaProdutos: Todos os produtos.
imprimir_produto_recibo([[Numero, Quantidade] | RestoLista]) :-
    itemCardapio(Numero, Preco, _, Item),
    ValorItemTotal is Preco * Quantidade,
    format("~w ~w~15| : ~2f~5|~n", [Quantidade, Item, ValorItemTotal]),
    imprimir_produto_recibo(RestoLista).

imprimir_produto_recibo([]) :- !.