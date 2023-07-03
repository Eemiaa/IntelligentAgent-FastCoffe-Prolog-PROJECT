:- dynamic pedidoPago/1.

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