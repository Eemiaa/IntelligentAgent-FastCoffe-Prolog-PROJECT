%:- consult('controleFinanceiro.pl').

%itemLoja: nome, preço
:- dynamic itemLoja/2.

itemLoja('Acucar', 1).
itemLoja('Cafe', 1).
itemLoja('Leite', 1).
itemLoja('Canela', 2).
itemLoja('Chocolate', 2).
itemLoja('Ortela', 2).

%estoque: produto, quantidade
:- dynamic estoque/2.

%itemCardapio: id, preço, tempo de preparo, nome
:- dynamic itemCardapio/4.

%livroReceitas: nome, lista de ingredientes 
:- dynamic livroReceitas/2.

%adicionar RegistreDespesa
%registreDespesa(Valor)

infoCozinha :- write("\u001b[44m Livro de Receitas:\n"),
            listing(livroReceitas/2),
            write("\u001b[41m Estoque:\n"),
            listing(estoque/2),
            write("\u001b[41m Itens da Loja:\n"),
            listing(itemLoja/2).
    
comprarIngrediente(Nome, Qtd) :-
    (
      itemLoja(Nome,Preco),
      (
        (
          estoque(Nome, QtdExistente),
          Aux is Qtd+QtdExistente,
          (
            Auxpreco is Qtd*Preco,
            registreDespesa(Nome, Auxpreco, Qtd)
          ),
          retract(estoque(Nome, QtdExistente)),
          assertz(estoque(Nome, Aux))
        );
          (
            Auxpreco is Qtd*Preco,
            registreDespesa(Nome, Auxpreco, Qtd)
          ),
          assertz(estoque(Nome, Qtd))
      ),
      write("\u001b[42m\nCompra realizada com sucesso!\u001b[m"),true,!
    );
    write("\nO produto não está disponível na loja."),false,!.


usarIngrediente(Nome, Qtd) :-
    (
      %verifica se o ingrediente existe no estoque, se não existir, realiza a compra
      (
        estoque(Nome, QtdExistente),
        QtdExistente >= Qtd,
        Aux is QtdExistente - Qtd,
        retract(estoque(Nome, QtdExistente)),
        assertz(estoque(Nome, Aux))
      )
      ;
      (
        comprarIngrediente(Nome, Qtd),
        Aux is 0,
        retract(estoque(Nome, Qtd)),
        assertz(estoque(Nome, Aux))
      ),
      write("\u001b[42m\nIngrediente usado com sucesso!\u001b[m")
    ).

addReceita(Nome, Ingredientes) :- 
    (
      Ingredientes = [],
      write("\nVocê não pode fornecer uma lista vazia de ingredientes."), 
      !
    );
    (
      (
        livroReceitas(Nome,_),
        retract(livroReceitas(Nome, Ingredientes)),
        assertz(livroReceitas(Nome, Ingredientes))
      );
      (
        assertz(livroReceitas(Nome, Ingredientes)) 
      )
    ),
    write("\u001b[42m\nReceita adicionada com sucesso!\u001b[m").

addItemCardapio(Id, Preco, Tempo, Nome) :- 
      (
        not(livroReceitas(Nome,_)),
        write("\nNao existe uma receita com esse nome."),
        !
      );
      (
        (
          Id < 1;
          Id > 5
        ),
        write("\nO id nao esta no intervalo correto"),
        !
      );
      (
        retract(itemCardapio(_,_,_,Nome)),
        retract(itemCardapio(Id,_,_,_)),
        assertz(itemCardapio(Id,Preco,Tempo,Nome))
      );
      (
        retract(itemCardapio(Id,_,_,_))
      );
      assertz(itemCardapio(Id,Preco,Tempo,Nome)),
      write("\u001b[42m\nItem adicionado com sucesso no cardapio!\u001b[m")
      , !.

cozinhar([], _) :- !.

cozinhar([K | T], Qtd) :-
      usarIngrediente(K, Qtd),
      cozinhar(T, Qtd).

cozinhar(Id, Qtd) :- 
      itemCardapio(Id,_,_,Nome),
      livroReceitas(Nome, Ingredientes),
      cozinhar(Ingredientes, Qtd).

cozinharPedido([]) :- !.

cozinharPedido([[Id, Qtd | _]| Itens]) :- 
      cozinhar(Id, Qtd),
      cozinharPedido(Itens).   