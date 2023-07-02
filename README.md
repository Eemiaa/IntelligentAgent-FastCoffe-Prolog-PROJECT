# IntelligentAgent-FastCoffe-Prolog-PROJECT


Especificação do OrderFlowController.pl
=======================================

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

Especificação do filaPrioridades.pl
===================================

Esse arquivo contém, basicamente, a fila de prioridades, bem como as suas funcionalidades, que foram construídas a partir de regras específicas, como: adicionar um pedido na fila, remover e alterar a prioridade. Além disso, outras regras auxiliares foram construídas, como a de comparar a prioridade de dois pedidos, para inseri-los na posição certa na fila, a de reordenar os itens da fila com base na nova prioridade adicionada a um outro pedido e, por fim, a de obter o último pedido sem prioridade da fila, a fim de inseri-lo no início da fila, para realizar a gerência de starvation com êxito.

Fato/Regra | Descrição
:---------:|:----------
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

Exemplo de uso das regras executadas pelo cliente
=================================================
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
