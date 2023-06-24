%itemLoja: nome, preço
:- dynamic itemLoja/2.

itemLoja("Açucar", 1).
itemLoja("Café", 1).
itemLoja("Leite", 1).
itemLoja("Canela", 2).
itemLoja("Chocolate", 2).
itemLoja("Ortela", 2).

%estoque: produto, quantidade
:- dynamic estoque/2.

%itemCardapio: id, preço, tempo de preparo, nome
:- dynamic itemCardapio/3.

%livroReceitas: nome, lista de ingredientes 
:- dynamic livroReceitas/2.

%adicionar RegistreDespesa
comprarIngrediente(Nome, Qtd) :-
    (
      itemLoja(Nome,_),
      (
        (
          estoque(Nome, QtdExistente),
          Aux is Qtd+QtdExistente,
          retract(estoque(Nome, QtdExistente)),
          assertz(estoque(Nome, Aux))
        );
          assertz(estoque(Nome, Qtd))
      ),
      format("Compra realizada com sucesso!"),true,!
    );
    format("O produto não está disponível na loja."),false,!.


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
      )
    ).

addItemCardapio(Preco, Tempo, Nome, Ingredientes) :- 
    (
      Ingredientes = [],
      format("Você não pode fornecer uma lista vazia de ingredientes."), 
      !
    );
    (
      (
        itemCardapio(_,_,Nome),
        retract(itemCardapio(_,_,Nome)),
        retract(livroReceitas(Nome, Ingredientes)),
        assertz(itemCardapio(Preco,Tempo,Nome)),
        assertz(livroReceitas(Nome, Ingredientes))
      )
      ;
      assertz(itemCardapio(Preco,Tempo,Nome)),
      assertz(livroReceitas(Nome, Ingredientes))
    ).
