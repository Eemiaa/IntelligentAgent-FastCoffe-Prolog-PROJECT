%itemLoja: nome, preço
:- dynamic itemLoja/2.

itemLoja("Acucar", 1).
itemLoja("Cafe", 1).
itemLoja("Leite", 1).
itemLoja("Canela", 2).
itemLoja("Chocolate", 2).
itemLoja("Ortela", 2).

%estoque: produto, quantidade
:- dynamic estoque/2.

%itemCardapio: id, preço, tempo de preparo, nome
:- dynamic itemCardapio/4.

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
      write("Compra realizada com sucesso!"),true,!
    );
    write("O produto não está disponível na loja."),false,!.


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
      write("Ingrediente usado com sucesso!")
    ).

addReceita(Nome, Ingredientes) :- 
    (
      Ingredientes = [],
      write("Você não pode fornecer uma lista vazia de ingredientes."), 
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
    write("Receita adicionada com sucesso!").

addItemCardapio(Id, Preco, Tempo, Nome) :- 
      (
        not(livroReceitas(Nome,_)),
        write("Nao existe uma receita com esse nome."),
        !
      );
      (
        (
          Id < 1;
          Id > 5
        ),
        write("O id nao esta no intervalo correto"),
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
      write("Item adicionado com sucesso no cardapio!")
      .

cozinhar([], _) :- !.

cozinhar([K | T], Qtd) :-
      usarIngrediente(K, Qtd),
      cozinhar(T, Qtd).

cozinhar(Id, Qtd) :- 
      itemCardapio(Id,_,_,Nome),
      livroReceitas(Nome, Ingredientes),
      cozinhar(Ingredientes, Qtd), 
      write("Alimento cozinhado com sucesso").

cozinharPedido([]) :- !.

cozinharPedido([[Id | Qtd]| Itens]) :- 
      cozinhar(Id, Qtd),
      cozinharPedido(Itens).