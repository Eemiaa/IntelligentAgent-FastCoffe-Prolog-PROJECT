% Fatos
:- dynamic receita_diaria/2.
:- dynamic despesa_diaria/2.
:- dynamic receita/3.
:- dynamic despesa/2.

% Regras
% retorna a data formatada
data(Date,DateTime) :- 
                get_time(T),
                format_time(string(Date),"%d %b %Y",T),
                format_time(string(DateTime),"%d %b %Y %T",T).

% inicializa a receita e despesa diária com o valor zero
inicializeCaixa:-
                    data(Data,_),
                    assertz(receita_diaria(Data,0)),
                    assertz(despesa_diaria(Data,0)),
                    write('Caixa inicializado com sucesso!').

% Mostra o valor total recebido no dia
totalRecebido:-    
                    data(Data,_),
                    receita_diaria(Data,Valor),
                    format('Total recebido em ~w: R$~w .',[Data,Valor]).

% Mostra o total de despesas do dia
totalDespesas:-   
                    data(Data,_),
                    despesa_diaria(Data,Valor),
                    format('Total de despesas em ~w : R$~w .',[Data,Valor]).

% Recebe como parâmetro o ID do pedido e registra seu valor como receita.
recebaPagamento(Id) :-      pedidoPronto(Id, Valor, _, _, _),
                            data(Data,DateTime),
                            assertz(receita(DateTime,Valor,Id)),
                            receita_diaria(Data,ReceitaAntiga),
                            ReceitaAtual is ReceitaAntiga + Valor,
                            retract(receita_diaria(Data,ReceitaAntiga)),
                            assertz(receita_diaria(Data,ReceitaAtual)).

% Recebe como parâmetro um valor e o registra como despesa.                           
registreDespesa(Valor):-
                            data(Data,DateTime),
                            assertz(despesa(DateTime,Valor)),
                            despesa_diaria(Data,ValorAntigo),
                            ValorAtual is ValorAntigo + Valor,
                            retract(despesa_diaria(Data,ValorAntigo)),
                            assertz(despesa_diaria(Data,ValorAtual)).

% Calcula o lucro obtido na data atual.                          
calculeLucro(Lucro) :-		data(Data,_),
                                receita_diaria(Data,Receita),
                                despesa_diaria(Data, Despesa),
                                Lucro is Receita - Despesa.

% Calcula o défict obtido na data atual.                          
calculeDeficit(Deficit) :-		    data(Data,_),
                                    receita_diaria(Data,Receita),
                                    despesa_diaria(Data, Gasto),
                                    Deficit is Gasto - Receita.

% lista a data e hora, o valor e o id de todos pedido recebidos.
listeEntradas:- 
                listing(receita).

% lista data e hora e o valor de todas as saídas registradas.
listeSaidas:- 
                listing(despesa).

% Mostra o resumo do caixa com o total recebido, o total gasto e o lucro ou prejuízo do dia.    
resumaCaixa:-  
                data(Data,_),
                receita_diaria(Data,Receita),
                despesa_diaria(Data,Despesa),
                format('######## Resumo do Caixa  ~w #########',[Data]),nl,
                format('Total Recebido: R$~w',[Receita]),nl,
                format('Total Gasto: R$~w',[Despesa]),nl,
                Lucro is Receita - Despesa,
                ((Lucro > 0,
                format('Lucro: R$~w',[Lucro])),!;
                (Deficit is Despesa - Receita,
                format('Prejuízo: R$~w',[Deficit]))). 

% inicializeCaixa,recebaPagamento(1),totalRecebido,registreDespesa(5),totalDespesas,calculeLucro(Lucro),calculeDeficit(Deficit),listeEntradas,listeSaidas,resumaCaixa,registreDespesa(10),resumo_caixa.