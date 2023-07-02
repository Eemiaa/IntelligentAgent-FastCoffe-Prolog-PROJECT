Especificação do FluxoDePagamento.pl
=======================================

Esse módulo especifica as diretivas de pagamento de cada cliente, recebendo uma determinada quantia, calculando o troco e emitindo um recibo. Utiliza a API disponibilizada pelo `orderFlowController.pl` para receber os valores 

Fato/Regra | Descrição
:----------: | :----------:
`realizar_compra/1` | Simula a compra de uma lista de produtos por um cliente no café. A partir do ID do pedido, descobre-se os itens relacionados à este. <br> **1º termo**: ID do Pedido <br> **2º termo**: Recebimento em dinheiro do caixa <br> **`💰 Fluxo de Pagamento`**
`fornecer_recibo/2` | Gera o recibo com todos os produtos comprados pelo cliente, além do troco e do valor total. Utiliza a API disponibilizada por `orderFlowController.pl` para encontrar os itens atrelados ao pedido e o seu valor total. <br> **1º Termo**: ID do pedido. <br> **2º Termo**: Quantia em dinheiro recebida pelo caixa <br> **`💰 Fluxo de Pagamento`**
`calcular_troco/3` | Calcula o troco do pedido, baseado em seu valor total. <br> **1º Termo**: ID do pedido <br> **2º Termo**: Quantia recebida pelo caixa <br> **3º Termo**: Valor de retorno do troco. <br> **`💰 Fluxo de Pagamento`**
`imprimir_produto_recibo/1` | Imprime um produto no recibo. Ele age de forma recursiva até imprimir todos os pedidos na lista recebida. <br> **1º Termo**: Uma lista de listas que contenham, em cada item da lista primária, uma sublista contendo `[Número do Pedido no Cardápio, Quantidade deste pedido]`. <br> **`💰 Fluxo de Pagamento`**