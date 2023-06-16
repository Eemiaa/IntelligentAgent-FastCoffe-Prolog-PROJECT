:- dynamic pedido/2.

item(1, 3.0, 5).
item(2, 2.0, 4).
item(3, 4.0, 8).
item(4, 3.0, 4).
item(5, 5.0, 8).
item(6, 6.50, 5).
item(7, 8.0, 9).

criarIDPedido(ID):- random_between(1, 10, Numero),
                    not(pedido(Numero,_)),
                    ID = Numero, !.

criarIDPedido(ID):- write('Já tem'), 
                    criarIDPedido(ID).
        
cardapio :- write('1. Americano................R$3,00'), nl,
            write('2. Cappuccino...............R$2,00'), nl,
            write('3. Double Expresso..........R$4,00'), nl,
            write('4. Latte....................R$3,00'), nl,
            write('5. Macchiato................R$5,00'), nl,
            write('6. Mint chocolate...........R$6,50'), nl,
            write('7. Expresso.................R$8,00').

obterNumeroDoItemEQuantidade([I, Q | _], I, Q). 

calcularPrecoEEsperaTotal([], PTotal, ETotal, PTotal, ETotal).

calcularPrecoEEsperaTotal([ItemN|Restante], PTotalAux, ETotalAux, PTotal, ETotal) :-  obterNumeroDoItemEQuantidade(ItemN, NumeroItem, Quantidade),
                                                                                      item(NumeroItem, Preco, Espera),
                                                                                      AuxP is PTotalAux + Preco * Quantidade,
                                                                                      AuxE is ETotalAux + Espera * Quantidade,
                                                                                      calcularPrecoEEsperaTotal(Restante, AuxP, AuxE, PTotal, ETotal), !.


calcularPrecoEEsperaTotal(Itens, PTotal, ETotal) :- calcularPrecoEEsperaTotal(Itens, 0, 0, PTotal, ETotal).
                                                                
fazerPedido(Espera, ID) :-  findall(pedido(X,Y), pedido(X,Y), Pedidos),
                            write(Pedidos), nl,
                            length(Pedidos, Tamanho),
                            Tamanho =< 10,
                            write('Insira seu pedido em uma lista de listas: '), nl,
                            write('[[< Numero do item >, < Quantidade >], ...]'), nl,
                            read(Itens), nl, 
                            calcularPrecoEEsperaTotal(Itens, PTotal, Espera),
                            criarIDPedido(ID),
                            asserta(pedido(ID, PTotal)), !.

fazerPedido(_, _) :- write('Temos muitos pedidos em andamento, volte mais tarde...').
                            
                            