Especificação do FluxoDePagamento.pl
=======================================

Esse módulo especifica as diretivas de pagamento de cada cliente, recebendo uma determinada quantia, calculando o troco e emitindo um recibo. Utiliza a API disponibilizada pelo `orderFlowController.pl` para receber os valores 

Fato/Regra | Descrição
:----------: | :----------:
`realizar_compra/2` | Simula a compra de uma lista de produtos por um cliente no café. Chama o predicado `fornecer_recibo/2`  e `recebaPagamento/1` <br> **1º termo**: ID do Pedido <br> **2º termo**: Recebimento em dinheiro do caixa <br> **`💰 Fluxo de Pagamento`**
`fornecer_recibo/2` | Gera o recibo com todos os produtos comprados pelo cliente, além do troco e do valor total. Utiliza a API disponibilizada por `orderFlowController.pl` para encontrar os itens atrelados ao pedido e o seu valor total. <br> **1º Termo**: ID do pedido. <br> **2º Termo**: Quantia em dinheiro recebida pelo caixa <br> **`💰 Fluxo de Pagamento`** 
`calcular_troco/3` | Calcula o troco do pedido, baseado em seu valor total. <br> **1º Termo**: ID do pedido <br> **2º Termo**: Quantia recebida pelo caixa <br> **3º Termo**: Valor de retorno do troco. <br> **`💰 Fluxo de Pagamento`**
`imprimir_produto_recibo/1` | Imprime um produto no recibo. Ele age de forma recursiva até imprimir todos os pedidos na lista recebida. <br> **1º Termo**: Uma lista de listas que contenham, em cada item da lista primária, uma sublista contendo `[Número do Pedido no Cardápio, Quantidade deste pedido]`. <br> **`💰 Fluxo de Pagamento`**

Exemplo de Uso
=====================
- `realizar_compra/1` <br>

~~~prolog
?- realizar_compra(ID, Recebimento).
~~~

Cria-se um pedido com  `fazer_pedido(ID, Preco)`.
~~~prolog    
? - fazer_pedido(ID, Preco).
~~~

Depois de realizado um pedido, e retornado o ID, neste exemplo, `4`. Podemos utilizar o predicado com o `ID` do pedido e com a quantia que o caixa recebeu.
~~~prolog
?- realizar_compra(4, 20).
~~~
Caso a quantia seja suficiente, a saída sera o recibo do pedido atrelado ao `ID`.
```
--- Fast Cofee (TM) ---
2 Double Expresso : 8.00
2 Cappuccino    : 4.00
-----------------------
Total Pedido   : 12.00
Troco          : 8.00
-----------------------
```
Se a quantia for insuficiente `false` será retornado.

- `fornecer_recibo/2`
~~~prolog
?- fornecer_recibo(ID, Recebimento).
~~~

Fornece o recibo baseado no ID do pedido, avaliando a quantia recebida pelo caixa. Se chamado sozinho, o predicado `recebaPagamento/1` não será chamado, não registrando o valor recebido. 

```
--- Fast Cofee (TM) ---
2 Double Expresso : 8.00
2 Cappuccino    : 4.00
-----------------------
Total Pedido   : 20.00
Troco          : 8.00
-----------------------
```
- `calcular_troco/3`

~~~prolog
?- calcular_troco(ID, Recebimento, Troco).
~~~

Pega o valor total do pedido relacionado ao ID, a partir do predicado `pedido_pronto(ID, ValorTotal, _, _, _)`. Depois calcular o valor recebido pelo caixa e retorna o troco.

- `imprimir_produto_recibo/1`

~~~prolog
?- imprimir_produto_recibo([[Numero, Quantidade] | RestoLista])
~~~

Pega as informações do cardápio e calcula o preço total. Assim, é imprimido um item do recibo neste formato. Essa função é utilizada recursivamente até não haver mais nenhum produto.
