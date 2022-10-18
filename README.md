# Trabalho 1 - PFL



## TO-DO
- [x] Normalizar Polinómios
- [x] Adicionar Polinómios
- [ ] Multiplicar Polinómios
- [x] Calcular a derivada de um polinómio




## Justificação / Descrição da representação interna de um polinómio

A estrutura utilizada para representar o polinómio foi um array de tuples, um tuple por termo, portanto. O tuple é constituído por um array e um int.
O array representa as variaveis e o int representa o coeficiente do termo. 
Por sua vez, o array que guarda as variáveis tem como elementos um tuple com um Char (para representar a letra da variável) e um Int (para guardar o grau da variavel). 
No final, tudo isto junto, dá origem à estrutura [ ( [(Char, Int)] , Int ) ] 

Vejamos um exemplo:

O polinómio "```4*x*y^3```" tem coeficiente 4 e como variáveis tem x com grau 1 e y com grau 3, pelo que a lista de variáveis seria igual a [('x',1),('y',3)]. Por isso, o termo na sua íntegra é representavel pelo tuple ([('x',1),('y',3)], 4). Neste caso, como o polinómio só tem um termo, o array de termos vai ter length 1, e será igual a [([('x',1),('y',3)], 4)].

Mais um exemplo:

"```-2*x + 5*y^6 - 32```"  ---> [([('x',1)],-2) , ([('y',6)],5), ([('~', 0)],-32)]


Esta foi a estrutura escolhida pois garantia o armazenamento do grau de cada variável de um termo de forma individual (preservando, assim, o seu grau) sem abdicar da possibilidade de mexer nas variáveis como um conjunto.


