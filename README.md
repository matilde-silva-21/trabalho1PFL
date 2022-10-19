# Trabalho 1 - PFL



## TO-DO
- [x] Normalizar Polinómios
- [x] Adicionar Polinómios
- [ ] Multiplicar Polinómios
- [x] Calcular a derivada de um polinómio


<br>
<br>

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

<br>
<br>

## Implementação de cada funcionalidade

<br>

### Normalização de polinómios

Primeiro, aquando o parse inicial da string do polinómio, discarda termos que são multiplicados por 0. Além disso, verifica também se o termo tem mais que um coeficiente a multiplicar e guarda na estrutura o valor de coeficiente já multiplicado. No entanto, para os casos em que é ```x*x``` ou semelhante, a multiplicação de variáveis só ocorre após o polinómio já ter sido guardado. 

Portanto, inicialmente o polinómio "```-2*x*x^2 + 5*10*y - 32 + 4*x^3```", transforma-se em ```[["-"],["x","x^2","2"],["+"],["y","50"],["-"],["32"],["+"],["x^3","4"]]``` através de splitPolinomio. Depois a função traversePolinomio transforma ```[["-"],["x","x^2","2"],["+"],["y","50"],["-"],["32"],["+"],["x^3","4"]]``` em ```[([('x',1),('x',2)],-2),([('y',1)],50),([('~',0)],-32),([('x',3)],4)]``` e só depois de chamar a função multiplyVarsInSameTerm é que o polinómio fica convertido na sua íntegra, ```[([('x',3)],-2),([('y',1)],50),([('~',0)],-32),([('x',3)],4)]```.

De notar, continuamos a ter dois termos distintos para a variável x com grau 3. Para finalizar a normalização, chamamos uma função que reune todos os membros do array com igual variável e grau e soma os seus coeficientes. Portanto, passamos de ```[([('x',3)],-2),([('y',1)],50),([('~',0)],-32),([('x',3)],4)]``` para ```[([('x',3)],2),([('y',1)],50),([('~',0)],-32)]```. Resta apenas fazer print ao polinomio (função printPolinomio).

<br>normalizarPolinomio "```-2*x*x^2 + 5*10*y - 32 + 4*x^3```" --> "```2*x^3 + 50*y - 32```"

<br>

### Adicionar polinómios

Para adicionar dois polinómios, o programa concatena as strings dos dois polinómios e depois normalizar essa junção. 

<br>```adicionarPolinomio "-2*x*x^2 + 5*10*y - 32 + 4*x^3" "7*y^3 - 24*x^2*z*y^2 - 6*y"``` --> ```"-24*x^2*y^2*z + 7*y^3 + 2*x^3 + 44*y - 32"```


<br>

### Multiplicar polinómios



<br>

### Derivar polinómios

A função derivarPolinomio recebe como argumentos a string polinómio e um char que será a variável à ordem da qual o polinómio será derivado. A função antes de proceder a qualquer operação, normaliza o polinómio. Uma vez normalizado, é verificado se um dado termo contem a variável passada como argumento, se o termo não contiver a variável é eliminado. Se contiver a variável, o seu grau será diminuido em 1 unidade e o coeficiente do termo será multiplicado pelo anterior grau da variável. 

<br>```derivarPolinomio "-2*x*x^2 + 5*10*y - 32 + 4*x^3" 'x'``` --> ```"6*x^2"```
<br>```derivarPolinomio "-2*x*x^2 + 5*10*y - 32 + 4*x^3" 'y'``` --> ```"50"```
<br>```derivarPolinomio "-2*x*x^2 + 5*10*y - 32 + 4*x^3" 'z'``` --> ```""```



