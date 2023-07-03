# IntelligentAgent-FastCoffe-Prolog-PROJECT

<div align="center">
  <a href="https://github.com/oJordany/estanteVirtual/">

  <a/>
  <h1>Fast Coffe</h1>

<h2 style="text-align: left;">&#x2714 lista de conteúdos</h2>
<ul type="pointer">
  <li style="text-align: left;"><a href="#DefinicaoAmbiente">Objetivos e definição do ambiente</a></li>

  <li style="text-align: left;"><a href="#tarefas">Definição das tarefas</a></li>
  <li style="text-align: left;"><a href="#especificacaoConhecimento">Especificação do conhecimento</a></li>
  <ul>
    <li style="text-align: left;"><a href="OrderFlowController.pl"> OrderFlowController.pl</a></li>
     <ul>
     <li style="text-align: left;"><a href="filaPrioridades.pl"> filaPrioridades.pl</a></li>
     </ul>
    <li style="text-align: left;"><a href="#fluxoDePagamento"> fluxoDePagamento.pl</a>
      <ul>
        <li><a href="#FluxoDePagamentoExemplosDeUso"> Exemplos de Uso</a></li>
      </ul>
    </li>
    <li style="text-align: left;"><a href="cozinha.pl">cozinha.pl</a></li>
    <li style="text-align: left;"><a href="controleFinanceiro.pl"> controleFinanceiro.pl</a></li>
  </ul>
  <li style="text-align: left;"><a href="#authors">Autores</a></li>
</ul>

<h1></h1>

<h2><a name="DefinicaoAmbiente">☕Objetivos e definição do ambiente</a></h2>
<p>➥ 
O objetivo do Agente Explorador em Prolog para o Fast Coffe é fornecer um sistema inteligente de gerenciamento para um estabelecimento de fast food especializado em café. O agente será responsável por coordenar e automatizar diversas tarefas relacionadas ao fluxo de pedidos, prioridades de atendimento, processamento de pagamentos, gerenciamento da cozinha e controle financeiro.

**Contextualização do Ambiente de Atuação**

O agente inteligente atuará em um ambiente dinâmico do Fast Coffe, que consiste em uma lanchonete com foco em café. O estabelecimento recebe pedidos de bebidas e alimentos, atendendo a demanda dos clientes e oferecendo um serviço de qualidade e eficiência.

</p>

<h1></h1>

<h2><a name="tarefas">📋 Definição das tarefas</a></h2>
<p>➥ O ambiente do Fast Coffe possui diferentes áreas e subdomínios que o agente explorador irá gerenciar:

1. **OrderFlowController.pl**: O arquivo OrderFlowController.pl é responsável por controlar o fluxo dos pedidos no Fast Coffe. Ele gerencia o recebimento dos pedidos, a fila de espera e o direcionamento para a cozinha ou atendimento, dependendo das preferências dos clientes.

3. **fluxoDePagamento.pl**: O arquivo fluxoDePagamento.pl lida com o processo de pagamento dos pedidos no Fast Coffe. Ele inclui a realização de compras, o cálculo de volor total de pedido, a emissão de recibos e cálculo de troco.

4. **cozinha.pl**: O arquivo cozinha.pl controla as atividades da cozinha no Fast Coffe. Ele monitora o estoque de ingredientes, os itens do cardápio, coordena a preparação dos diversos tipos de café e registra o tempo de preparo para garantir a eficiência operacional.

5. **controleFinanceiro.pl**: O arquivo controleFinanceiro.pl é responsável por controlar as finanças do Fast Coffe. Ele registra as receitas, despesas e lucros, oferece resumo do caixa, auxilia no controle de estoque podendo servir de auxílio na tomada de decisões estratégicas relacionadas aos aspectos financeiros do estabelecimento.

Essa documentação fornece uma visão geral do objetivo do agente explorador em Prolog para o Fast Coffe e contextualiza o ambiente em que ele irá interagir. A partir dessa contextualização, será possível detralhar os fatos e regras da base de conhecimento para dar suporte às funcionalidades do agente inteligente.</p>

<h1></h1>

<h2 style="text-align: center;"><a name="especificacaoConhecimento">🗃️ Especificação do conhecimento</a></h2>
<ul style="text-align: left;" type="none">
  <li><h3><a name="OrderFlowController.pl">📝 OrderFlowController.pl</a></h3></li>
  

Esse arquivo, basicamente, é o controlador de fluxo de pedidos. Ele realiza atividades de gerência dos pedidos através de uma fila de prioridades, sendo que tais pedidos possuem uma prioridade, podendo ser true ou false. Nesse sentido, para que não ocorra um starvation de nenhum deles, são feitas mudanças na fila de prioridade após a finalização de cada 3 pedidos com prioridade true, colocando sempre o último da fila, cuja prioridade é false, na primeira posição, adiando os demais pedidos que estiverem atrás dele.

Além disso, esse arquivo realiza a gerência das notificações dos pedidos, para emitir um aviso no sistema, mostrando que ele está pronto. Somado a isso, essa parte do programa também realiza todo o tratamento necessário para manipular a ordem de emissão dessas notificações.

Fato/Regra | Descrição
:---------:|:----------
` itemCardapio/4 `| Fato que descreve um item do cardápio, contendo o número do item, preço, tempo de espera e descrição. </br> **1º termo**: número do item </br> **2º termo**: preço </br> **3º termo**: tempo de espera </br> **4º termo**: descrição/nome do item </br> **`⚙️ FATO AUXILIAR DINÂMICO`**
`criarMensagem/2` | Regra que cria a mensagem de pedido que será exibida na notificação, com base na lista de itens passadas nas especificações do pedido.</br>**1º termo**: Lista de itens e quantidade de cada item do pedido</br>**2º termo**: Mensagem devolvida como resposta</br>**`🔔GERÊNCIA DE NOTIFICAÇÕES`**</br>**`⚙️ REGRA AUXILIAR`**
`buscarPedidoPeloID/6` | Regra que busca um pedido pelo seu ID na fila de prioridades \[primeiro termo da regra\] e retorna suas informações (preço, prioridade, itens e tempo de espera).</br>**1º termo**: fila de prioridades</br>**2º termo**: ID do pedido</br>**3º termo**: Preço total do pedido</br>**4º termo**: Prioridade do pedido</br>**5º termo**: Itens e suas quantidade no pedido</br>**6º termo**: Tempo de espera (considerando apenas os itens que vão ser preparados)</br> **`📝GERÊNCIA DE PEDIDOS`**</br> **`⚙️ REGRA AUXILIAR`**
`obterNumeroDoItemEQuantidade/3` | Regra que obtém o número do item e a quantidade a partir de uma lista de itens.</br>**1º termo**: lista do item \[ Item, Quantidade\]</br>**2º termo**: Número do item</br>**3º termo**: Quantidade do item</br> **`📝GERÊNCIA DE PEDIDOS`**</br>**`⚙️ REGRA AUXILIAR`**</br>
`criarIDPedido/1` | Regra que cria um ID único para um novo pedido. Esses IDs só vão até 10 (capacidade máxima de pedidos da cafeteria)</br>**1º termo**: Variável de resposta contendo o ID do pedido</br> **`📝GERÊNCIA DE PEDIDOS`**</br>**`⚙️ REGRA AUXILIAR`**
`calcularPrecoEEsperaTotal/3` | Regra que calcula o preço total e o tempo de espera total com base em uma lista de itens.</br>**1º termo**: Lista do item \[ Item, Quantidade\]</br>**2º termo**: Preço total**3º termo**: Espera total</br> **`📝GERÊNCIA DE PEDIDOS`**</br>**`⚙️ REGRA AUXILIAR`**
`calcularPrecoEEsperaTotal/5` | Sobrecarga da regra calcularPrecoEEsperaTotal/3.</br>**1º termo**: Lista do item \[ Item, Quantidade\]</br>**2º termo**: Preço somador auxiliar</br>**3º termo**: Espera somadora auxiliar</br>**4º termo**: Preço total devolvido como resposta</br>**5º termo**: Espera total devolvida como resposta</br> **`📝GERÊNCIA DE PEDIDOS`**</br>**`⚙️ REGRA AUXILIAR`**
`obterEsperasDosPedidosAFrente/2` | Regra que obtém o somatório dos tempos de espera dos pedidos na frente de um pedido específico na fila de prioridades.</br>**1º termo**: ID do pedido especíico</br>**2º termo**: Soma das esperas</br>**`📝GERÊNCIA DE PEDIDOS`**</br>**`⚙️ REGRA AUXILIAR`**
`adiarEsperasDosPedidosDeTras/3` | Regra que adia os tempos de espera dos pedidos que estão atrás de um pedido específico.</br>**1º termo**: Fila de prioridades</br>**2º termo**: ID do pedido específico</br>**3º termo**: Quantidade em segundos que se deseja adiar</br>**` 📝GERÊNCIA DE PEDIDOS`**</br>**` ⚙️ REGRA AUXILIAR`**
`adiarEsperasDosPedidosDeTras/2` | Sobrecarga da regra adiarEsperasDosPedidosDeTras/3 após achar o ID do pedido dentro da fila, adiando todos os demais de trás.</br>**1º termo**: lista de pedidos restantes de atrás</br>**2º termo**: Quantidade de segundos que se deseja adiar</br>**` 📝GERÊNCIA DE PEDIDOS`**</br> **`⚙️ REGRA AUXILIAR`**
`contPedidosProntos/1` | Fato dinâmico que armazena a quantidade de pedidos de prioridade true que já ficaram prontos.</br>**1º termo**: quantidade de pedidos prontos</br> **`⚙️ FATO AUXILIAR DINÂMICO`**
`obterTempoAtualEmSegundos/1` | </br>Regra que obtém o tempo atual do sistema em segundos.</br>**1º termo**: tempo atual do sistema em segundos</br> **`⚙️ REGRA AUXILIAR`**</br> **`🔔GERÊNCIA DE NOTIFICAÇÕES`**
`lerVerificador/1` | Regra que lê o valor do verificador (true ou false) do arquivo "verificador.txt". Esse arquivo fica sendo alterado dinamicamente para monitorar quando o processo de emissão de notificação morre (quando o pedido finaliza).</br>**1º termo**: valor do verificador obtido como resposta (true ou false)</br> **`⚙️ REGRA AUXILIAR`**</br> **`🔔GERÊNCIA DE NOTIFICAÇÕES`**
`lerPid/1` | Regra que lê o valor do PID do arquivo "pid.txt" e converte para um número. Esse arquivo fica sendo alterado dinamicamente para que se possa obter o PID do processo que cria uma emissão de notificação agendada.</br>**1º termo**: valor do PID obtido como resposta</br> **`⚙️ REGRA AUXILIAR`**</br> **`🔔GERÊNCIA DE NOTIFICAÇÕES`**
`agendarNotificacao/2` | Regra que agenda uma notificação para um tempo futuro em segundos.</br>**1º termo**: Quantidade em segundos para agendar a notificação</br>**2º termo**: ID do pedido para o qual a notificação será exibida</br>**` ⚙️ REGRA AUXILIAR`**</br>**` 🔔GERÊNCIA DE NOTIFICAÇÕES`**</br>
`cancelarNotificacao/1` | Regra que cancela a notificação de um pedido específico.</br>**1º termo**: ID do pedido que se deseja cancelar</br> **`⚙️ REGRA AUXILIAR`**</br>**` 🔔GERÊNCIA DE NOTIFICAÇÕES`**
`adiarNotificacao/2` | </br>Regra que adia uma notificação em segundos para um pedido específico.</br>**1º termo**: Quantidade de segundos que se deseja adiar a notificação</br>**2º termo**: ID do pedido que se deseja adiar a notificação</br> **`⚙️ REGRA AUXILIAR`**</br>**` 🔔GERÊNCIA DE NOTIFICAÇÕES`**
`gerenciarStarvation/1` | Regra que gerencia o starvation de pedidos com base em sua prioridade.</br>**1º termo**: prioridade do pedido tirado da fila (a cada 3 pedidos de prioridade true, um pedido false do fim da fila é colocado para frente com prioridade true e contPedidosProntos/1 é reiniciado com valor 0)</br>**` 🔔GERÊNCIA DE NOTIFICAÇÕES`**</br>**` 📝GERÊNCIA DE PEDIDOS`**</br> **`⚙️ REGRA AUXILIAR`**
`monitorarProcesso/2` | Regra que monitora um processo de notificação em execução.</br>**1º termo**: PID do processo que criou a notificação</br>agendada</br>**2º termo**: ID do pedido que vai emitir a notificação</br> **`⚙️ REGRA AUXILIAR`**</br>**` 🔔GERÊNCIA DE NOTIFICAÇÕES`**
`repetirVerificacao/2` | Regra que verifica repetidamente se um processo de notificação de um determinado pedido ainda está em execução.</br>**1º termo**: PID do processo de notificação</br>**2º termo**: ID do pedido</br> **`⚙️ REGRA AUXILIAR`**</br>**` 🔔GERÊNCIA DE NOTIFICAÇÕES`**
`processoEstaEmExecucao/1` | </br>Regra que verifica se um processo identificado pelo PID ainda está em execução..</br>**1º termo**: PID do processo</br> **`⚙️ REGRA AUXILIAR`**</br>**` 🔔GERÊNCIA DE NOTIFICAÇÕES`**
`cardapio/0` | Regra que exibe o cardápio na tela.</br> **`👤 REGRA USADA PELO CLIENTE`**
`mostrarCardapio/1` | Regra auxiliar de cardapio/0</br>**1º termo**: lista com todos os itens do cardápio</br> **`⚙️ REGRA AUXILIAR`**
`fazerPedido/2` | Regra que permite ao cliente fazer um pedido, recebendo como resposta o preço total e o ID do pedido.</br>**1º termo**: Preço total do pedido</br>**2º termo**: ID do pedido</br> **`👤 REGRA USADA PELO CLIENTE`**
`verStatusDoPedido/1` | Regra que permite ao cliente verificar o status do seu pedido, fornecendo o ID do pedido como entrada.</br>**1º termo**: ID do pedido</br>**`👤 REGRA USADA PELO CLIENTE`**
`cancelarPedido/1` | Regra que permite ao cliente cancelar um pedido, fornecendo o ID do pedido como entrada.</br>**1º termo**: ID do pedido</br> **`👤 REGRA USADA PELO CLIENTE`**
`pegarPedido/1` | Regra que permite ao cliente pegar o pedido pronto, fornecendo o ID do pedido como entrada.</br>**1º termo**: ID do pedido</br> **`👤 REGRA USADA PELO CLIENTE`**
`pedidoPronto/5` | Fato dinâmico que serve para adicionar os pedidos que já estão prontos na base de conhecimento, contendo informações relevantes sobre eles:  ID, Preço, Prioridade Itens e o tempo de espera</br>**1º termo**: ID do pedido</br>**2º termo**: Preço total do pedido</br>**3º termo**: Prioridade do pedido</br>**4º termo**: Itens do pedido e a quantidade de cada um</br>**5º termo**: Tempo de espera total do pedido, considerando o tempo de preparo de cada item</br>**` ⚙️ FATO AUXILIAR DINÂMICO`**</br>**` 📝GERÊNCIA DE PEDIDOS`**
`notificacaoAgendada/3` | Fato dinâmico que guarda o PID de um processo que criou uma notificação agendada, o ID do pedido cuja notificação será emitida e o tempo previsto para que essa notificação dispare</br>**1º termo**: PID do processo que iniciou a notificação agendada</br>**2º termo**: ID do pedido</br>**3º termo**: tempo previsto para emitir a notificação</br>**` ⚙️ FATO AUXILIAR DINÂMICO`**</br>**` 🔔GERÊNCIA DE NOTIFICAÇÕES`**
`idDoVerificador/2` | Fato dinâmico que armazena o ID da thread que fica monitorando quando o processo de emissão de notificação agendada morre e o ID do pedido da notificação agendada para relacionar pedido e notificação.</br>**1º termo**: ID do pedido</br>**2º termo**: ID da thread </br>**` ⚙️ FATO AUXILIAR DINÂMICO`**</br>**` 🔔GERÊNCIA DE NOTIFICAÇÕES`**

<ul>
  <li><h3><a name="filaPrioridades.pl"> filaPrioridades.pl</a></h3></li>

  Esse arquivo contém, basicamente, a fila de prioridades, bem como as suas funcionalidades, que foram construídas a partir de regras específicas, como: adicionar um pedido na fila, remover e alterar a prioridade. Além disso, outras regras auxiliares foram construídas, como a de comparar a prioridade de dois pedidos, para inseri-los na posição certa na fila, a de reordenar os itens da fila com base na nova prioridade adicionada a um outro pedido e, por fim, a de obter o último pedido sem prioridade da fila, a fim de inseri-lo no início da fila, para realizar a gerência de starvation com êxito.

Fato/Regra | Descrição
:---------:|:---------
`fila\_prioridades/1` | Fato dinâmico que armazena a fila de prioridades.</br>**1º termo**: fila de prioridades em forma de lista</br>**` ⚙️ FATO AUXILIAR DINÂMICO`**</br>**` 📝GERÊNCIA DE PEDIDOS`**
`cont/1` | Fato dinâmico que armazena o contador de pedidos para adicionar a ordem em que cada pedido foi inserido na fila.</br>**1º termo**: quantidade de pedidos na fila</br>**` ⚙️ FATO AUXILIAR DINÂMICO`**</br>**` 📝GERÊNCIA DE PEDIDOS`**
`adicionar\_pedido/5` | Regra que adiciona um pedido à fila de prioridades.</br>**1º termo**: ID do pedido</br>**2º termo**: Preço total do pedido</br>**3º termo**: Prioridade do pedido</br>**4º termo**: Descrição do pedido</br>**5º termo**: Tempo de espera do pedido</br> **`⚙️ REGRA AUXILIAR`**</br>**` 📝GERÊNCIA DE PEDIDOS`**
`remover\_pedido/1` | Regra que remove um pedido da fila de prioridades.</br>**1º termo**: ID do pedido </br> **`⚙️ REGRA AUXILIAR`**</br>**` 📝GERÊNCIA DE PEDIDOS`**
`alterar\_prioridade/2` | Regra que altera a prioridade de um pedido na fila de prioridades e reordena a fila.</br>**1º termo**: ID do pedido que se deseja mudar a prioridade</br>**2º termo**: Nova prioridade que se deseja colocar no pedido</br> **`⚙️ REGRA AUXILIAR`**</br> **`📝GERÊNCIA DE PEDIDOS`**
`inserir\_pedido/3` | Regra auxiliar da adicionar\_pedido/5 que insere um pedido na fila de prioridades.</br>**1º termo**: Fila de prioridades na forma de lista</br>**2º termo**: pedido, na forma de termo complexo: pedido(ID, Preco, Prioridade, Ordem de Inserção, Descrição, Espera)</br>**3º termo**: Nova fila que será dada como resposta, com o novo pedido já inserido</br> **`⚙️ REGRA AUXILIAR`**</br>**` 📝GERÊNCIA DE PEDIDOS`**
`remover\_pedido/3` | Regra auxiliar da remover\_pedido/1 que remove um pedido da fila de prioridades.</br>**1º termo**: Fila de prioridades em forma de lista</br>**2º termo**: ID do pedido que se deseja remover</br>**3º termo**: Nova fila obtida como resposta, com o pedido já removido</br> **`⚙️ REGRA AUXILIAR`**</br>**` 📝GERÊNCIA DE PEDIDOS`**
`alterar\_prioridade/4` | Regra auxiliar da alterar\_prioridade/2 que altera a prioridade de um pedido na fila de prioridades.</br>**1º termo**: Fila de prioridades em forma de lista</br>**2º termo**: ID do pedido que se deseja alterar a prioridade</br>**3º termo**: Nova prioridade que se deseja colocar no pedido</br>**4º termo**: Nova fila resultante da alteração da prioridade do pedido na lista e da reordenação dele nela</br> **`⚙️ REGRA AUXILIAR`**</br>**` 📝GERÊNCIA DE PEDIDOS`**
`compara\_prioridades/2` | Regra que compara as prioridades entre dois pedidos. Caso seja um true e um false, ele considera o true com maior prioridade. Caso seja dois true ou dois false, ele considera quem entrou primeiro, considerando que cada pedido tem um contador de ordem de chegada.</br>**1º termo**: Pedido 1</br>**2º termo**: Pedido 2</br> **`⚙️ REGRA AUXILIAR`**</br>**` 📝GERÊNCIA DE PEDIDOS`**
`reordenar\_fila\_prioridades/2` | Regra que reordena a fila de prioridades com base nas novas prioridades, quando se usa a regra alterar\_prioridade/2.</br>**1º termo**: Fila de prioridades</br>**2º termo**: Fila reordenada obtida como resposta</br> **`⚙️ REGRA AUXILIAR`**</br>**` 📝GERÊNCIA DE PEDIDOS`**
`pegar\_ultimo\_false\_da\_fila/1` | Regra que obtém o ID do último pedido sem prioridade na fila.</br>**1º termo**: ID do pedido obtido como resposta</br> **`⚙️ REGRA AUXILIAR`**</br>**` 📝GERÊNCIA DE PEDIDOS`**
`pegar\_ultimo\_false\_da\_fila/2` | Sobrecarga da regra pegar\_ultimo\_false\_da\_fila/1 com o ID do pedido como argumento inicial.</br>**1º termo**: Fila de prioridades em forma de lista</br>**2º termo**: ID do pedido obtido como resposta </br> **`⚙️ REGRA AUXILIAR`**</br>**` 📝GERÊNCIA DE PEDIDOS`**
</ul>

<h2 id="FluxoDePagamentoExemplosDeUso" > Exemplos de Uso </h2>
Exemplo de uso das regras executadas pelo agente ou cliente.

=================================================
- `inicializeCaixa/0`
~~~prolog
?- inicializeCaixa.
~~~
~~~
Caixa inicializado com sucesso!
true.
~~~
- A base de conhecimento recebe dinâmicamente os fatos receita_diaria(DataDoSistema,0) e despesa_diaria(DataDoSistema,0). 

- `cardapio/0`
~~~prolog
?- cardapio.
~~~
~~~
 =================== ☕ CARDAPIO ☕ ====================
1. Americano                                      R$3.00
2. Cappuccino                                     R$2.00
3. Double Expresso                                R$4.00
4. Latte                                          R$3.00
5. Macchiato                                      R$5.00
6. Mint chocolate                                 R$6.50
7. Expresso                                       R$8.00
 =======================================================

true.
~~~
- Mostra os itens do cardápio em uma tabela
- Esses itens são inseridos dinamicamente na base de conhecimento
---
- `fazerPedido/2`
~~~prolog
?- fazerPedido(Preco, ID).
~~~
~~~
Insira seu pedido em uma lista de listas: 
[[< Numero do item >, < Quantidade >], ...]
|: [[1,1]].

Prioridade [true/false]: 
|: true.

Compra realizada com sucesso!Ingrediente usado com sucesso!Compra realizada com sucesso!Ingrediente usado com sucesso!Alimento cozinhado com sucesso
Preco = 3,
ID = 9.

?- listing(pedidoPronto).
:- dynamic pedidoPronto/5.

pedidoPronto(9, 3, true, [[1, 1]], 1).

true.
~~~
- Realiza um pedido através de uma lista de listas: [[< Numero do item >, < Quantidade >], ...]
- Em seguida, é definida a prioridade do pedido
- Por fim, é devolvido ao cliente o preço total e o ID do pedido.
---
- `verStatusDoPedido/1`
~~~prolog
?- verStatusDoPedido(ID).
~~~
~~~
O Pedido 3 já está pronto. O valor total deu R$3.00
true. 
~~~
- Verifica o status do pedido, que pode ser: pronto, ainda não está pronto e inexistente, caso um ID inválido seja passado
---
- `cancelarPedido/1`
~~~prolog
?- cancelarPedido(ID).
~~~
~~~
Pedido cancelado com sucesso!

true.
~~~
- Cancela um pedido em andamento pelo ID dele
---
- `pegarPedido/1`
~~~prolog
?- pegarPedido(ID).
~~~
~~~
Está aqui o seu pedido, volte sempre :)

true.
~~~
- Obtem o pedido quando ele está pronto 
- Caso ele não esteja pronto, vai ser exibido um false
- Caso ele esteja pronto, acontece o mesmo caso do exemplo acima.

  <li><h3 id="fluxoDePagamento">💵 fluxoDePagamento.pl</a></h3>
Esse módulo especifica as diretivas de pagamento de cada cliente, recebendo uma determinada quantia, calculando o troco e emitindo um recibo. Utiliza a API disponibilizada pelo `orderFlowController.pl` para receber os valores.

Fato/Regra | Descrição
:---------:| :----------
`realizar_compra/2` | Simula a compra de uma lista de produtos por um cliente no café. Chama o predicado `fornecer_recibo/2`  e `recebaPagamento/1` <br> **1º termo**: ID do Pedido <br> **2º termo**: Recebimento em dinheiro do caixa <br> **`💰 Fluxo de Pagamento`**
`fornecer_recibo/2` | Gera o recibo com todos os produtos comprados pelo cliente, além do troco e do valor total. Utiliza a API disponibilizada por `orderFlowController.pl` para encontrar os itens atrelados ao pedido e o seu valor total. <br> **1º Termo**: ID do pedido. <br> **2º Termo**: Quantia em dinheiro recebida pelo caixa <br> **`💰 Fluxo de Pagamento`** 
`calcular_troco/3` | Calcula o troco do pedido, baseado em seu valor total. <br> **1º Termo**: ID do pedido <br> **2º Termo**: Quantia recebida pelo caixa <br> **3º Termo**: Valor de retorno do troco. <br> **`💰 Fluxo de Pagamento`**
`imprimir_produto_recibo/1` | Imprime um produto no recibo. Ele age de forma recursiva até imprimir todos os pedidos na lista recebida. <br> **1º Termo**: Uma lista de listas que contenham, em cada item da lista primária, uma sublista contendo `[Número do Pedido no Cardápio, Quantidade deste pedido]`. <br> **`💰 Fluxo de Pagamento`**

<h2 id="FluxoDePagamentoExemplosDeUso" > Exemplos de Uso </h2>

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



  </li>




  <li><h3><a name="cozinha.pl">👩‍🍳 cozinha.pl</a></h3></li>
  


  <li><h3><a name="controleFinanceiro.pl">📊 controleFinanceiro.pl</a></h3></li>
 O arquivo controleFinanceiro.pl desempenha um papel crucial no gerenciamento das finanças do Fast Coffe, fornecendo um sistema para registrar e analisar as receitas, despesas, lucros e prejuízos diários. Ele contém as seguintes regras e funcionalidades:

Fato/Regra | Descrição
:---------:|:----------:
` receita_diaria/2. `| Fato indica a receita diária do Fast Coffe.</br>**1º termo**: Data do sistema</br>**2º termo**: Valor da Receita atual.
` despesa_diaria/2. `| Fato indica a receita despesa diária do Fast Coffe.</br>**1º termo**: Data do sistema</br>**2º termo**: Valor da despesa atual.
` receita/3. `| Fato relaciona uma receita com o a data e hora do seu recebimento bem como o id do pedido a que gerou.</br>**1º termo**: Data e hora do sistema</br>**2º termo**: Valor da receita.</br>**3º termo**: Id do pedido relacionado a receita</br>
` despesa/2. `| Fato registra na base de conhecimento a data e hora de uma despesa.</br>**1º termo**: Data e hora do sistema</br>**2º termo**: Valor da despesa.
`data/2` | Essa regra retorna a data e hora formatadas. Ela utiliza o predicado get_time/1 para obter a data e hora atuais e o predicado format_time/3 para formatá-las de acordo com o padrão desejado.</br>**1º termo**: Retorna data do sistema</br>**2º termo**: retorna a data e hora do sistema</br>**`⚙️ REGRA AUXILIAR`**
` inicializeCaixa/0 `| Fato indica que o caixa do Fast Coffe é inicializado diariamente. Ele adiciona na base de dados os fatos dinâmicos receita_diaria/2. e despesa_diaria/2 com a data atual com o valor 0, servindo como ponto de partida para registrar as transações financeiras ao longo do dia.
`totalRecebido/0` |  Regra tem o objetivo exibir o valor total recebido no dia. 
`totalDespesas/0` | Regra tem o objetivo exibir o valor total de despesas do dia.*
`recebaPagamento/1` | Regra responsável por registrar o valor de um pedido como receita ao receber um pagamento.</br>**1º termo**: Variável contendo o ID do pedido</br>
`registreDespesa/4` | Regra que permite registrar um valor como despesa no sistema. Recebe como parâmetro nome do produto adquirido, seu valor e quantidade, e registra essas informações como despesa. </br>**1º termo**: Recebe o nome do produto comprado que gerou a despesa</br>**2º termo**: Recebe o valor gasto com o produto comprado</br>**3º termo**: Recebe a quantidade do produto comprado
`calculeLucro/1` | Regra que calcula o lucro obtido na data atual, o resultado do cálculo é atribuído à variável Lucro. Ela utiliza os predicados data/2, receita_diaria/2 e despesa_diaria/2 para obter os valores necessários. O lucro é calculado subtraindo o total de despesas da receita total do dia.</br>**1º termo**: Variável usada como retorno da consulta com o valor do lucro atual</br>**`⚙️ REGRA AUXILIAR`**
`calculeDeficit/1` | Regra que calcula o déficit obtido na data atual. Utiliza os predicados data/2, receita_diaria/2 e despesa_diaria/2 para obter os valores necessários. O déficit é calculado subtraindo a receita total do dia pelo total de despesas.</br>**1º termo**: Variável usada como retorno da consulta com o valor do déficit atual</br>**`⚙️ REGRA AUXILIAR`**
`listeEntradas/0` | Regra que lista a data e hora, o valor e o ID de todos os pedidos recebidos. Ela utiliza o predicado listing/1 para exibir as informações armazenadas no fato receita/3.
`listeSaidas/0` |  Regra que lista a data e hora e o valor de todas as saídas registradas, ou seja, as despesas realizadas durante o dia. Utiliza o predicado listing/1 para exibir as informações armazenadas no fato despesa/2.
`resumaCaixa/0` |  Regra que mostra um resumo do caixa, exibindo o total recebido, o total gasto e o lucro ou prejuízo do dia. Utiliza os predicados data/2, receita_diaria/2 e despesa_diaria/2 para obter as informações necessárias e as exibe na tela formatadas de acordo com o resultado obtido.

<h2 id="FluxoDePagamentoExemplosDeUso" > Exemplos de Uso </h2>

- `inicializeCaixa/0`
~~~prolog
?- inicializeCaixa.
~~~
- Acrescenta na base de conhecimento os fatos dinâmicos receita_diaria(Data,0) e despesa_diaria(Data,0) com a Data do dia e o valor zero.

- `totalRecebido/0`
~~~prolog    
?- totalRecebido.
~~~
~~~prolog
Total recebido em 03 Jul 2023: R$140.0 .
true.
~~~~

- `totalDespesas/0`
~~~prolog    
?- totalDespesas.
~~~
~~~prolog
Total de despesas em 03 Jul 2023 : R$51 .
true.
~~~~

- `recebaPagamento/1`
~~~prolog    
?- recebaPagamento(2).
~~~
    - Busca o valor recebido pelo pedido de ID 2 e registra como valor de receita.

- `registreDespesa/4`
~~~prolog    
?- registreDespesa('acucar', 6.99,1).
~~~
    - Atualiza o valor da despesa diária e registra na base de conhecimento a despesas e as informações do nome e da quantidade do produto que a gerou relacionando-as com a data e hora da despesa realizada. 

- `calculeLucro/1`
~~~prolog    
?- calculeLucro(Lucro).
~~~
~~~prolog 
Lucro = 89.0.
~~~
- `calculeDeficit/1`
~~~prolog    
?- calculeDeficit(Deficit).
~~~
~~~prolog 
Deficit = 9.0.
~~~

- `listeEntradas./0`
~~~prolog    
?- listeEntradas.
~~~
~~~prolog 

receita("03 Jul 2023 00:07:29", 96.0, 10).
receita("03 Jul 2023 00:08:10", 44.0, 1).
true.
~~~

- `listeSaidas./0`
~~~prolog    
?- listeSaidas.
~~~
~~~prolog 

:- dynamic despesa/4.

despesa("03 Jul 2023 00:06:46", 5, 'Acucar', 5).
despesa("03 Jul 2023 00:06:46", 5, 'Cafe', 5).
despesa("03 Jul 2023 00:06:46", 5, 'Canela', 10).
despesa("03 Jul 2023 00:06:46", 1, 'Acucar', 1).
despesa("03 Jul 2023 00:06:46", 1, 'Cafe', 1).
despesa("03 Jul 2023 00:06:46", 1, 'Leite', 1).
despesa("03 Jul 2023 00:06:46", 3, 'Leite', 3).
despesa("03 Jul 2023 00:06:46", 3, 'Cafe', 3).
despesa("03 Jul 2023 00:06:46", 3, 'Canela', 6).
despesa("03 Jul 2023 00:07:11", 2, 'Acucar', 2).
despesa("03 Jul 2023 00:07:11", 2, 'Cafe', 2).
despesa("03 Jul 2023 00:07:11", 2, 'Chocolate', 4).
despesa("03 Jul 2023 00:07:11", 2, 'Cafe', 2).
despesa("03 Jul 2023 00:07:11", 2, 'Canela', 4).
despesa("03 Jul 2023 00:07:11", 2, 'Acucar', 2).

true.
~~~
- `resumaCaixa/0`
~~~prolog    
?- resumaCaixa.
~~~
~~~prolog 

######## Resumo do Caixa  03 Jul 2023 #########
Total Recebido: R$140.0
Total Gasto: R$51
Lucro: R$89.0
true.
~~~


<h2 style="text-align: center;"><a name="authors">&#x1F465 Autores</a></h2>

  <li style="text-align: left;"><a href="https://github.com/Eemiaa">👤 Aimeê Miranda Ribeiro</a></li>
  <li style="text-align: left;"><a href="https://github.com/oJordany">👤 Luiz Jordany de Sousa Silva</a></li>
  <li style="text-align: left;"><a href="https://github.com/Stopfield">👤 Thiago P.</a></li>
  <li style="text-align: left;"><a href="https://github.com/syannekaroline">👤 Syanne Karoline Moreira Tavares</a></li>



