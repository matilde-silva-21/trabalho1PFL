# Trabalho 1 - PFL

## Grupo G09_01

Mariana Rocha up202004656
Matilde Silva up202007928


## Justificação / Descrição da representação interna de um polinómio

A estrutura utilizada para representar o polinómio é um ___array___ de ___tuples___, um ___tuple___ por termo, portanto. <br><br>
Este <u>_tuple_</u> é constituído por um ___array___ e um ___int___. O _array_ representa as __variáveis__ e o _int_ representa o __coeficiente__ do termo. <br>
Por sua vez, o ___array___ que guarda as variáveis tem como elementos um ___tuple___ com um __Char__ (para representar a __letra da variável__) e um __Int__ (para guardar o __grau da variável__). <br><br>
No final, tudo isto junto, dá origem à estrutura ``[ ( [(Char, Int)] , Int ) ]``. <br>

Vejamos alguns exemplos:

- O polinómio ```4*x*y^3``` tem:
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
 - O polinómio ```-2*x + 5*y^6 - 32``` tem:


     | Termo  | Coeficiente | Variável | Grau | Representação |
     | ------------- | ------------- |------------- |------------- |------------- |
     | -2*x  | -2  | x | 1 | __[ ( [ ('x',1)],-2) ]__ |
     |  5*y^6 | 5  | y | 6 | __[ ( [ ('y',6)],5) ]__ |
     |  -32 | -32  | - | 0 | __[ ( [ ('~',0)],32 ) ]__ |
  
<br>

Logo: <br> ```-2*x + 5*y^6 - 32```  &rarr; [ ``( [ ('x',1) ],-2 )`` , ``( [ ('y',6) ] ,5 )`` , ``( [ ('~', 0) ],-32 )`` ]


Esta foi a estrutura escolhida pois garantia o armazenamento do grau de cada variável de um termo de forma individual (preservando, assim, o seu grau) sem abdicar da possibilidade de mexer nas variáveis como um conjunto.

<br>

## Implementação de cada funcionalidade

### Checklist
- [x] Normalizar Polinómios
- [x] Adicionar Polinómios
- [x] Multiplicar Polinómios
- [x] Calcular a derivada de um polinómio

### Normalização de polinómios

Primeiro, aquando o parse inicial da string do polinómio, descarta termos que são multiplicados por 0. Além disso, verifica também se o termo tem mais que um coeficiente a multiplicar e guarda na estrutura o valor de coeficiente já multiplicado. 
<br>

No entanto, para os casos em que é ```x*x``` ou semelhante, a multiplicação de variáveis só ocorre após o polinómio já ter sido guardado.   

<br>

Portanto, inicialmente o polinómio 
<div align="center">

```-2*x*x^2 + 5*10*y - 32 + 4*x^3```
</div>

transforma-se, através do splitPolinomio, em: 



<div align="center">

```[["-"],["x","x^2","2"],["+"],["y","50"],["-"],["32"],["+"],["x^3","4"]]``` 
</div>

<br>
<br>

Depois a função traversePolinomio transforma 
<div align="center">

```[ [ "-" ] , [ "x" , "x^2" , "2" ] , [ "+" ] , [ "y" , "50" ] , [ "-" ],[ "32" ],[ "+" ],[ "x^3" , "4" ] ]```
</div>

em:
<div align="center">

```[ ( [ ( 'x' , 1 ) , ( 'x' , 2 ) ] , -2 ) , ( [ ( 'y' , 1 ) ] , 50 ) , ( [ ( '~' , 0 ) ] ,-32 ) , ( [ ( 'x' , 3 ) ] , 4 ) ]``` 

</div>
e só depois de chamar a função multiplyVarsInSameTerm é que o polinómio fica convertido na sua íntegra:


<div align="center">
<br>

```[ ( [ ( 'x' , 3 ) ] , -2 ) , ( [ ( 'y' , 1 ) ] , 50 ) , ( [ ( '~' , 0 ) ] , -32 ) , ( [ ( 'x' , 3 ) ] , 4 ) ]```.
</div> 

De notar, continuamos a ter dois termos distintos para a variável x com grau 3. Para finalizar a normalização, chamamos uma função que reune todos os membros do array com igual variável e grau e soma os seus coeficientes. Portanto, passamos de 
<div align="center">

```[([('x',3)],-2),([('y',1)],50),([('~',0)],-32),([('x',3)],4)]```
</div>

para 
<div align="center">

```[([('x',3)],2),([('y',1)],50),([('~',0)],-32)]```

</div>
Resta apenas fazer print ao polinomio (função printPolinomio).

<br>normalizarPolinomio "```-2*x*x^2 + 5*10*y - 32 + 4*x^3```" --> "```2*x^3 + 50*y - 32```"

A ordenação do polinómio é feita depois por grau.
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

A função ```haskell multiplicarMonomio``` tendo dois monómios, multiplica-os da seguinte forma: concatena as variáveis (o que é equivalente a juntá-los ou seja multiplicar) e multiplica os coeficientes. 
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
<br>```derivarPolinomio "-2*x*x^2 + 5*10*y - 32 + 4*x^3" 'z'``` --> ```"0"```


## Exemplos de utilização

<br>

### Normalizar Polinómio

<br>

```normalizarPolinomio "" --> "0"```
<br>```normalizarPolinomio "3*x*y*z + 3*x^3*y*y - 37*y^2*x^3 -438+21" --> "-34*x^3*y^2 + 3*x*y*z - 417"```
<br>```normalizarPolinomio "6*2*x*x" --> "12*x^2"```
<br>```normalizarPolinomio "-  2*w+    7*w^2" --> "7*w^2 - 2*w"```

<br>

### Adicionar Polinómio

<br>

```adicionarPolinomio "2" "-2" --> "0"```
<br>```adicionarPolinomio "2*x" "-2*y" --> "-2*y + 2*x"```
<br>```adicionarPolinomio "-7*x^2*y*x + 5*32" "-2*y" --> "-7*x^3*y - 2*y + 160"```
<br>```adicionarPolinomio "-7*x^2*y*x" "120*y*x^3" --> "113*x^3*y"```

