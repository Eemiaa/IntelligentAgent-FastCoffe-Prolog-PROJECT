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


fazerPedido(Espera, ID) :-  findall(pedido(X,Y), pedido(X,Y), Pedidos),
                            write(Pedidos),
                            length(Pedidos, Quantidade),
                            not(Quantidade =:= 2),
                            Total = 0,
                            write('Numero do item do cardapio: '), nl,
                            read(Item), nl,
                            write('Quantidade: '), nl,
                            read(Quantidade),
                            item(Item, Preco, Espera), !.
                            criarIDPedido(ID),
                            asserta(pedido(ID, ))

fazerPedido(Espera, ID) :- write('Temos muitos pedidos em andamento, volte mais tarde...').
                            
                            