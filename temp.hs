import Data.List.Split
import Data.List


--funçoes para ler os tuples
tupleGetVar :: (Char, Int)  -> Char
tupleGetVar (x,_) = x

tupleGetDegree :: (Char, Int)  -> Int
tupleGetDegree (_,x) = x

arrGetCoef :: ([(Char, Int)], Int) -> Int
arrGetCoef (_,x) = x

arrGetVarTuple :: ([(Char, Int)], Int) -> [(Char, Int)]
arrGetVarTuple (x,_) = x
 
arrGetDegree :: ([(Char, Int)], Int) -> Int
arrGetDegree (x,y) = sum [tupleGetDegree (a) | a<-x]

--funçao que pega nos ultimos n elementos de uma string
lastN :: Int -> [a] -> [a]
lastN n xs = drop (length xs - n) xs

-- funcao para remover elementos duplicados de uma lista
removeDuplicates :: (Eq a) => [a] -> [a]
removeDuplicates list = remDups list []

remDups :: (Eq a) => [a] -> [a] -> [a]
remDups [] _ = []
remDups (x:xs) list2
    | (x `elem` list2) = remDups xs list2
    | otherwise = x : remDups xs (x:list2)


-- funcao para verificar se string é um numero valido
isNumber :: String -> Bool
isNumber str =
    case (reads str) :: [(Double, String)] of
      [(_, "")] -> True
      _         -> False


--funçao que obtem o grau de uma variavel x^n
getVarDegree :: String -> Int
getVarDegree x = if(length x == 1) then 1 else read (lastN ((length (x))-2) (x)) :: Int;

--funcao que pega no array de um termo e guarda todas as variaveis num tuple(variavel, grau variavel)
parseMultipleVariables :: [String] -> [(Char, Int)]
parseMultipleVariables [] = []
parseMultipleVariables (x:xs) = sort ([(y, getVarDegree x) | y<-x, (((fromEnum y) > 64 && (fromEnum y) < 91) || ((fromEnum y) > 96 && (fromEnum y) < 123))] ++ parseMultipleVariables xs)


--assumptions feitas:
--      o coeficiente vem SEMPRE antes das variaveis a*x*y
--      nao existem vars do tipo x*x

--primeiro separar o polinomio, dando origem a uma lista de listas, as quais estao divididas entre coeficiente e variavel*grau de variavel
--exemplo: "7*y^2 + 3*y + 5*z" ---> [["y^2","7"],["+"],["y","3"],["+"],["z","5"]]
splitPolinomio :: String -> [[String]]
splitPolinomio x =  [if (length (sortOn isNumber (splitOneOf "*" y)) /= 1) then ((removeNumbers(sortOn isNumber (splitOneOf "*" y))) ++ [show (multiplyArray(findNumbers(sortOn isNumber (splitOneOf "*" y))))]) else ((removeNumbers(sortOn isNumber (splitOneOf "*" y)))) | y <-(split (oneOf " +-") x), y/="", y/=" "]

findNumbers :: [String] ->  [Int]
findNumbers y = [(read a) :: Int | a<-y, (isNumber a)]

removeNumbers :: [String] -> [String]
removeNumbers xs = [a | a<-xs, not (isNumber a)]

multiplyArray :: [Int] -> Int
multiplyArray (x:xs) = x*(multiplyArray xs)
multiplyArray [] = 1


--interface que vai transformar o polinomio separado em uma lista de tuples com o primeiro argumento igual a uma outra lista de tuples (variavel, grau) e segundo argumento igual a coeficiente
traversePolinomio :: [[String]] -> [([(Char, Int)], Int)]
traversePolinomio xs = traversePolinomioHelper xs True


--funçao que faz o trabalho pesado da funçao traversePolinomio

-- 1º verifica se o elemento atual é um sinal ou uma variavel, ou se o coeficiente é zero, se for um sinal positivo chama a funcao com positivo = True, se for sinal negativo chama a funçao com positivo = False, para a prox variavel saber o seu sinal. se for um termo com coeficiente zero é ignorado
-- 2º verifica se está perante um termo independente ou perante um termo de coeficiente igual a 1, para um qualquer termo independente n o tuple é ('~', 0, n), duas guardas separadas para se coeficiente for neg ou positivo 
-- 3º para variáveis sozinhas (sem ser x*y por exemplo) verifica se tem length maior que 1, se sim a string é do tipo "x^n", se nao o grau é 1. mais duas guardas caso o coeficiente seja neg ou positivo
-- 4º para variaveis complexas (x*y) usa uma funcao helper
traversePolinomioHelper :: [[String]] -> Bool -> [([(Char, Int)], Int)]
traversePolinomioHelper [] _ = []
traversePolinomioHelper (x:xs) positive
    -- 1º
    | (((x!!0) == "+") || (last x) == "0") = (traversePolinomioHelper(xs) True)
    | ((x!!0) == "-") = (traversePolinomioHelper(xs) False)
    -- 2º termos com modulo do coef e grau igual a 1 ou termos independentes menores que 10
    | ((length x) == 1 && positive && (length (x!!0) == 1)) = if(isNumber([firstTerm])) then [([('~',0)], (number))] ++ (traversePolinomioHelper(xs) True) else [([(firstTerm, 1)], 1)] ++ (traversePolinomioHelper(xs) True)
    | ((length x) == 1 && not positive && (length (x!!0) == 1)) = if(isNumber([firstTerm])) then [([('~',0)], negate (number))] ++ (traversePolinomioHelper(xs) True) else [([(firstTerm, 1)], -1)] ++ (traversePolinomioHelper(xs) True)
    
    -- 2º termos com modulo do coef igual a 1 e grau > 1 ou termos independentes maiores ou igual a 10
    | ((length x) == 1 && positive && (length (x!!0) /= 1)) = if(isNumber([firstTerm])) then [([('~',0)], (number))] ++ (traversePolinomioHelper(xs) True) else [([(firstTerm, grau)], 1)] ++ (traversePolinomioHelper(xs) True)
    | ((length x) == 1 && not positive && (length (x!!0) /= 1)) = if(isNumber([firstTerm])) then [([('~',0)], negate (number))] ++ (traversePolinomioHelper(xs) True) else [([(firstTerm, grau)], -1)] ++ (traversePolinomioHelper(xs) True)
    
    -- 3º variaveis de grau 1 e modulo coef > 1
    | ((length x) == 2 && positive && length (x!!0) == 1) = [([(firstTerm, 1)], coeficiente)] ++ (traversePolinomioHelper(xs) True)
    | ((length x) == 2 && not positive && length (x!!0) == 1) = [([(firstTerm, 1)], negate coeficiente)] ++ (traversePolinomioHelper(xs) True)
    
    -- 3º variaveis de grau n e modulo coef > 1
    | ((length x) == 2 && positive && length (x!!0) > 1) = [([(firstTerm, grau)], coeficiente)] ++ (traversePolinomioHelper(xs) True)
    | ((length x) == 2 && not positive && length (x!!0) > 1) = [([(firstTerm, grau)], negate coeficiente)] ++ (traversePolinomioHelper(xs) True)
    
    -- 4º variaveis nao simples
    | ((length x) > 2 && positive) = [(parseMultipleVariables x, (read (last x)) :: Int)] ++ (traversePolinomioHelper(xs) True)
    | ((length x) > 2 && not positive) = [(parseMultipleVariables x, negate (read (last x)) :: Int)] ++ (traversePolinomioHelper(xs) True)

    | otherwise = (traversePolinomioHelper(xs) True)
    
    where {
        firstTerm = (x!!0) !! 0;
        number = (read (x !! 0) :: Int);
        coeficiente = (read (x !! 1) :: Int);
        grau = read (lastN ((length (x !! 0))-2) (x !! 0)) :: Int; -- lastN ((length x)-2)
    }





--funçao que adapta um polinomio em string para um array de truples
--exemplo: "7*y^2 + 3*y + 5*z" ---> [('y',2,7),('y',1,3),('z',1,5)]
adaptPolinomio :: String -> [([(Char, Int)], Int)]
adaptPolinomio xs = traversePolinomio (splitPolinomio xs)


printVars :: [(Char, Int)]-> String
printVars [] = ""
printVars (x:xs)
    | ((tupleGetVar x) == '~' || (tupleGetDegree x) == 0) = printVars xs
    | ((tupleGetDegree x) == 1) = var ++ lastVar ++ printVars xs
    | otherwise = var ++ "^" ++ show (tupleGetDegree x) ++ lastVar ++ printVars xs
    
    where {
        lastVar = if(xs == []) then "" else "*";
        var = [tupleGetVar x];
    }

printPolinomio :: [([(Char, Int)], Int)] -> String
printPolinomio xs = printPolinomioHelper xs True

--funcao para dar print de um polinomio
printPolinomioHelper :: [([(Char, Int)], Int)] -> Bool -> String
printPolinomioHelper [] _ = ""
printPolinomioHelper (x:xs) first 
    -- 1º se o coeficiente for 0, nao dar print do termo
    | ((arrGetCoef x) == 0) = printPolinomioHelper xs first
    
    -- 2º se for um termo independente
    | (vars == "") && ((arrGetCoef x) < 0) = negativePrepend ++ (show (negate (arrGetCoef x))) ++ (printPolinomioHelper xs False)
    | (vars == "") && ((arrGetCoef x) > 0) = positivePrepend ++ (show (arrGetCoef x))++ (printPolinomioHelper xs False)
    
    -- 3º se for uma variavel com coeficiente 1 / -1
    | ((arrGetCoef x) < 0) = negativePrepend ++ negativeCoeficient ++ vars ++ (printPolinomioHelper xs False)
    | ((arrGetCoef x) > 0) = positivePrepend ++  positiveCoeficient ++ vars ++ (printPolinomioHelper xs False)

    | otherwise = positivePrepend ++  positiveCoeficient ++ vars ++ (printPolinomioHelper xs False)
    
    where {
        vars = printVars (arrGetVarTuple x);
        negativePrepend = if (first) then "-" else (" - ");
        positivePrepend = if (first) then "" else (" + ");
        negativeCoeficient = if ((arrGetCoef x) == -1) then "" else ((show (negate (arrGetCoef x)))  ++ "*");
        positiveCoeficient = if ((arrGetCoef x) == 1) then "" else ((show (arrGetCoef x))  ++ "*");
    } 




findMoreVarsWithSameDegree :: [(Char, Int)] -> [([(Char, Int)], Int)] -> [([(Char, Int)], Int)]
findMoreVarsWithSameDegree cr xs = [ x | x<-xs, (arrGetVarTuple(x)) == cr]

doesTermContainVar :: ([(Char, Int)], Int) -> Char -> Bool
doesTermContainVar ([], _) _ = False
doesTermContainVar (x:xs,y) cr = if((tupleGetVar x)==cr) then True else doesTermContainVar (xs,y) cr



sumVarsWithSameDegree :: [([(Char, Int)], Int)] -> ([(Char, Int)], Int)
sumVarsWithSameDegree xs = ( arrGetVarTuple (xs!!0), (sum ([(arrGetCoef(x)) | x<-xs])))


reducePolinomio :: [([(Char, Int)], Int)] -> [([(Char, Int)], Int)]
reducePolinomio xs = removeDuplicates [ sumVarsWithSameDegree (findMoreVarsWithSameDegree (arrGetVarTuple x) xs) | x<-xs]


normalizarPolinomio :: String -> String
normalizarPolinomio xs = printPolinomio (reverse (sortOn arrGetDegree (reducePolinomio (adaptPolinomio xs))))


adicionarPolinomio :: String -> String -> String
adicionarPolinomio x y = normalizarPolinomio (x ++ " " ++ y)

getSpecificVarDegree :: [(Char, Int)] -> Char -> Int
getSpecificVarDegree (x:xs) y = if(tupleGetVar(x) == y) then (tupleGetDegree x) else getSpecificVarDegree xs y
getSpecificVarDegree [] _ = 1


-- tenho que travessar a lista de termos e encontrar termos com a variavel pretendida, se tiver baixar em 1 a variavel, se o grau ficar 0, remover da lista de termos
-- se nao tiver a variavel pretendida, todo esse termo é eliminado

reduceDegree :: [(Char, Int)] -> Char -> [(Char, Int)]
reduceDegree (x:xs) var = if((tupleGetVar x) == var && (tupleGetDegree x) /= 1) then [(tupleGetVar x, (tupleGetDegree x) -1)] ++ reduceDegree xs var else if ((tupleGetVar x) == var && (tupleGetDegree x) == 1) then (reduceDegree xs var) else ([(tupleGetVar x, tupleGetDegree x)] ++ reduceDegree xs var)
reduceDegree [] var = []

derivarPolinomio :: String -> Char -> String
derivarPolinomio xs var = printPolinomio (derivarPolinomioHelper (adaptPolinomio (normalizarPolinomio(xs))) var)

derivarPolinomioHelper :: [([(Char, Int)], Int)] -> Char -> [([(Char, Int)], Int)] 
derivarPolinomioHelper xs var = [(reduceDegree a var, b*(getSpecificVarDegree a var)) |(a,b)<-xs, (doesTermContainVar (a,b) var)]
