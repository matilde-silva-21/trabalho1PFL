import Data.List.Split
import Data.List


-- funcao que transforma Maybe Int em Int
maybeToInt :: Maybe Int -> Int
maybeToInt (Just n) = n
maybeToInt Nothing = -1

--funçoes para ler os tuples
tup0 :: (String, Int, Int) -> String
tup0 (x,_,_) = x

tup1 :: (String, Int, Int) -> Int
tup1 (_,x,_) = x

tup2 :: (String, Int, Int) -> Int
tup2 (_,_,x) = x

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



--assumptions feitas: o coeficiente vem SEMPRE antes das variaveis a*x*y
--os termos sao separados pelos sinais e por espaços e nao pode haver um sinal junto ao coeficiente

--primeiro separar o polinomio, dando origem a uma lista de listas, as quais estao divididas entre coeficiente e variavel*grau de variavel
--exemplo: "7*y^2 + 3*y + 5*z" ---> [["y^2","7"],["+"],["y","3"],["+"],["z","5"]]
splitPolinomio :: String -> [[String]]
splitPolinomio x = [reverse (sortOn length (splitOneOf "*" y)) | y<-(split (oneOf " +-") x), y/="", y/=" "]



parseMultipleVariables :: [String] -> (String, Int, Int)
parseMultipleVariables [] = []
parseMultipleVariables (x:xs) = --se for digito vai direto para o coeficiente, depois fazer parse do resto dos elementos (que sao variaveis), se nao tiver grau meter na string de variaveis logo e adicionar 1 ao coeficiente, se tiver grau usar o splitOneOf e adicionar o grau, e concatenar a string 
-- nao esquecer dar sort a string das variaveis





--interface que vai transformar o polinomio separado em uma lista de Truples com (variavel, grau da variável, coeficiente)
traversePolinomio :: [[String]] -> [(String, Int, Int)]
traversePolinomio xs = traversePolinomioHelper xs True


--funçao que faz o trabalho pesado da funçao traversePolinomio

-- 1º verifica se o elemento atual é um sinal ou uma variavel, ou se o coeficiente é zero, se for um sinal positivo chama a funcao com positivo = True, se for sinal negativo chama a funçao com positivo = False, para a prox variavel saber o seu sinal. se for um termo com coeficiente zero é ignorado
-- 2º verifica se está perante um termo independente ou perante um termo de grau e coeficiente igual a 1, para um qualquer termo independente n o tuple é ('~', 0, n), duas guardas separadas para se coeficiente for neg ou positivo 
-- 3º para variáveis sozinhas (sem ser x*y por exemplo) verifica se tem length maior que 1, se sim a string é do tipo "x^n", se nao o grau é 1. mais duas guardas caso o coeficiente seja neg ou positivo
traversePolinomioHelper :: [[String]] -> Bool -> [(String, Int, Int)]
traversePolinomioHelper [] _ = []
traversePolinomioHelper (x:xs) positive
    -- 1º
    | (((x!!0) == "+") || ((tail (x)!!0) == "0")) = (traversePolinomioHelper(xs) True)
    | ((x!!0) == "-") = (traversePolinomioHelper(xs) False)
    -- 2º
    | ((length x) == 1 && positive) = if(isNumber(firstTerm)) then [("~",0, (number))] ++ (traversePolinomioHelper(xs) True) else [(firstTerm, 1, 1)] ++ (traversePolinomioHelper(xs) True)
    | ((length x) == 1 && not positive) = if(isNumber(firstTerm)) then [("~",0, negate (number))] ++ (traversePolinomioHelper(xs) True) else [(firstTerm, 1, -1)] ++ (traversePolinomioHelper(xs) True)
    -- 3º variaveis de grau 1
    | ((length x) == 2 && positive && length (x!!0) == 1) = [(x!!0, 1, coeficiente)] ++ (traversePolinomioHelper(xs) True)
    | ((length x) == 2 && not positive && length (x!!0) == 1) = [(x!!0, 1, negate coeficiente)] ++ (traversePolinomioHelper(xs) True)
    -- 3º variaveis de grau n
    | ((length x) == 2 && positive && length (x!!0) > 1) = [(x!!0, grau, coeficiente)] ++ (traversePolinomioHelper(xs) True)
    | ((length x) == 2 && not positive && length (x!!0) > 1) = [(x!!0, grau, negate coeficiente)] ++ (traversePolinomioHelper(xs) True)

    | otherwise = (traversePolinomioHelper(xs) True)
    where {
        firstTerm = (x!!0);
        number = (read (x !! 0) :: Int);
        coeficiente = (read (x !! 1) :: Int);
        grau = read [((x !! 0) !! 2)] :: Int;
    }






--funçao que adapta um polinomio em string para um array de truples
--exemplo: "7*y^2 + 3*y + 5*z" ---> [('y',2,7),('y',1,3),('z',1,5)]
adaptPolinomio :: String -> [(String, Int, Int)]
adaptPolinomio xs = traversePolinomio (splitPolinomio xs)


printPolinomio :: [(String, Int, Int)] -> String
printPolinomio xs = printPolinomioHelper xs True

printPolinomioHelper :: [(String, Int, Int)] -> Bool -> String
printPolinomioHelper [] _ = ""
printPolinomioHelper (x:xs) first 
    | ((tup2 x) == 0) = printPolinomioHelper xs first
    | (((tup0 x) == "~") && ((tup2 x) < 0)) = negativePrepend ++ (show (negate (tup2 x))) ++ (printPolinomioHelper xs False)
    | (((tup0 x) == "~") && ((tup2 x) > 0)) = positivePrepend ++ (show (tup2 x))++ (printPolinomioHelper xs False)
    | ((tup2 x) < 0 && ((tup1 x) == 1)) = negativePrepend ++ negativeCoeficient ++ variable ++ (printPolinomioHelper xs False)
    | ((tup2 x) < 0 && ((tup1 x) /= 1)) = negativePrepend ++ negativeCoeficient ++ variable ++ "^" ++ (show (tup1 x)) ++ (printPolinomioHelper xs False)
    | ((tup2 x) > 0 && ((tup1 x) == 1)) = positivePrepend ++  positiveCoeficient ++ variable ++ (printPolinomioHelper xs False)
    | otherwise = (positivePrepend) ++ positiveCoeficient ++ variable ++ "^" ++ (show (tup1 x)) ++ (printPolinomioHelper xs False)
    where {
        negativePrepend = if (first) then "- " else (" - ");
        positivePrepend = if (first) then "" else (" + ");
        negativeCoeficient = if ((tup2 x) == -1) then "" else ((show (negate (tup2 x)))  ++ "*");
        positiveCoeficient = if ((tup2 x) == 1) then "" else ((show (tup2 x))  ++ "*");
        variable = (tup0 x);
    } 




findMoreVarsWithSameDegree :: String -> Int -> [(String, Int, Int)] -> [(String, Int, Int)]
findMoreVarsWithSameDegree cr dgr xs = [ x | x<-xs, ((tup0 x) == cr) && (dgr == (tup1 x))]

sumVarsWithSameDegree :: [(String, Int, Int)] -> (String, Int, Int)
sumVarsWithSameDegree xs =  ((tup0 (xs !! 0)), (tup1 (xs !! 0)), y)
    where y = sum ([(tup2 x) | x<-xs])

reducePolinomio :: [(String, Int, Int)] -> [(String, Int, Int)]
reducePolinomio xs = removeDuplicates [ sumVarsWithSameDegree (findMoreVarsWithSameDegree (tup0 x) (tup1 x) xs) | x<-xs]

normalizarPolinomio :: String -> String
normalizarPolinomio xs = printPolinomio (reverse (sortOn tup1 (reducePolinomio (adaptPolinomio xs))))

adicionarPolinomio :: String -> String -> String
adicionarPolinomio x y = normalizarPolinomio (x ++ " " ++ y)

