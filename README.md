# Trabalho 1 - PFL



## TO-DO
- [x] Normalizar Polinómios
- [x] Adicionar Polinómios
- [x] Multiplicar Polinómios
- [x] Calcular a derivada de um polinómio


<br>
<br>

## Justificação / Descrição da representação interna de um polinómio
<br>

A estrutura utilizada para representar o polinómio é um <u>_array_ de _tuples_</u>, um _tuple_ por termo, portanto. <br><br>
Este <u>_tuple_</u> é constituído por um <u>_array_</u> e um <u>_int_</u>. O _array_ representa as __variáveis__ e o _int_ representa o __coeficiente__ do termo. <br>
Por sua vez, o _array_ que guarda as variáveis tem como elementos um _tuple_ com um __Char__ (para representar a __letra da variável__) e um __Int__ (para guardar o __grau da variável__). <br><br>
No final, tudo isto junto, dá origem à estrutura **[ ( [(Char, Int)] , Int ) ]**. <br>

Vejamos alguns exemplos:

- O polinómio "```4*x*y^3```" tem:
  - 1 termo;
  - __coeficiente__ 4;
  - como __variáveis__:

     | Termo Independente  | Grau |
     | ------------- | ------------- |
     | x  | 1  |
     | y | 3  |

  A lista de variáveis seria então: __[('x',1),('y',3)]__
  Por isso, o termo na sua íntegra é representável pelo tuple __([('x',1),('y',3)], 4)__. <br>
  Neste caso, como o polinómio só tem um termo, o array de termos vai ter _length_ 1, e será igual a: **[([('x',1),('y',3)], 4)]**.
<br><br>
 - O polinómio "```-2*x + 5*y^6 - 32```" tem:
    - 3 termos:
      - (a) -2*x;
      - (b) 5*y^6;
      - (c) -32.
  
   - O termo (a) tem:
  
     - __coeficiente__ -2;
     - como __variáveis__: x com grau 1;
     - a sua representação seria: **[([('x',1)],-2)]**.<br>
  
   - O termo (b) tem:
     - **coeficiente** 5;
     - como **variáveis**: y com grau 6;
     - a sua representação seria: **[([('y',6)],5)]**<br>
  
   - O termo (c) tem:
     - **coeficiente** -32;
     - sem variáveis (grau 0);
     - a sua representação seria: **[([('~',0)],32)]**<br>
  
Logo: <br>"```-2*x + 5*y^6 - 32```"  ---> [([('x',1)],-2) , ([('y',6)],5), ([('~', 0)],-32)]


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

<br>```haskell
adicionarPolinomio "-2*x*x^2 + 5*10*y - 32 + 4*x^3" "7*y^3 - 24*x^2*z*y^2 - 6*y"``` --> ```"-24*x^2*y^2*z + 7*y^3 + 2*x^3 + 44*y - 32"```


<br>

### Multiplicar polinómios

A multiplicação dos polinómios é feita a partir da função ```haskell multiplicarPolinomio```.  Esta recebe dois polinómios, adapta-os à representação do programa e aplica-lhes a função ```haskell multiplicarMonomio```.
<br>
Relembremos a representação dos termos no programa:

``5*x`` seria ``[([('x',1)],5)]`` e ``4*m + 20*x`` seria ``[([('m',1)],4),([('x',1)],20)]``

A função ```haskkel multiplicarMonomio``` tendo dois monómios, multiplica-os da seguinte forma: concatena as variáveis (o que é equivalente a juntá-los ou seja multiplicar) e multiplica os coeficientes. 
<br>
Após esta multiplicação dos monómios, volta a normalizar o resultado antes de o apresentar.
<br>
Testemos com os resultados acima representados:<br>
``*Main> multiplicarPolinomio "4*m + 20*x" "5*x"``<br>
``"100*x^2 + 20*m*x"``


<br>

### Derivar polinómios

A função derivarPolinomio recebe como argumentos a string polinómio e um char que será a variável à ordem da qual o polinómio será derivado. A função antes de proceder a qualquer operação, normaliza o polinómio. Uma vez normalizado, é verificado se um dado termo contem a variável passada como argumento, se o termo não contiver a variável é eliminado. Se contiver a variável, o seu grau será diminuido em 1 unidade e o coeficiente do termo será multiplicado pelo anterior grau da variável. 

<br>```derivarPolinomio "-2*x*x^2 + 5*10*y - 32 + 4*x^3" 'x'``` --> ```"6*x^2"```
<br>```derivarPolinomio "-2*x*x^2 + 5*10*y - 32 + 4*x^3" 'y'``` --> ```"50"```
<br>```derivarPolinomio "-2*x*x^2 + 5*10*y - 32 + 4*x^3" 'z'``` --> ```""```



