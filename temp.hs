import Data.List.Split
import Data.List
import Data.Char


-- funcao que transforma Maybe Int em Int
maybeToInt :: Maybe Int -> Int
maybeToInt (Just n) = n
maybeToInt Nothing = -1

--funçoes para ler os tuples
tup0 :: (Char, Int, Int) -> Char
tup0 (x,_,_) = x

tup1 :: (Char, Int, Int) -> Int
tup1 (_,x,_) = x

tup2 :: (Char, Int, Int) -> Int
tup2 (_,_,x) = x

-- funcao para remover elementos duplicados de uma lista
removeDuplicates :: (Eq a) => [a] -> [a]
removeDuplicates list = remDups list []

remDups :: (Eq a) => [a] -> [a] -> [a]
remDups [] _ = []
remDups (x:xs) list2
    | (x `elem` list2) = remDups xs list2
    | otherwise = x : remDups xs (x:list2)


--assumptions feitas: um termo só pode ser do tipo a*(variavel^grau) ou a*variavel ou variavel ou termo independente
--os termos sao separados pelos sinais e por espaços e nao pode haver um sinal junto ao coeficiente

--primeiro separar o polinomio, dando origem a uma lista de listas, as quais estao divididas entre coeficiente e variavel*grau de variavel
--exemplo: "7*y^2 + 3*y + 5*z" ---> [["y^2","7"],["+"],["y","3"],["+"],["z","5"]]
splitPolinomio :: String -> [[String]]
splitPolinomio x = [reverse (splitOneOf "*" y) | y<-(splitOneOf " " x), y/=""]

--interface que vai transformar o polinomio separado em uma lista de Truples com (variavel, grau da variável, coeficiente)
traversePolinomio :: [[String]] -> [(Char, Int, Int)]
traversePolinomio xs = traversePolinomioHelper xs True


--funçao que faz o trabalho pesado da funçao traversePolinomio

-- 1º verifica se o elemento atual é um sinal ou uma variavel, se for um sinal positivo chama a funcao com positivo = True, se for sinal negativo chama a funçao com positivo = False, para a prox variavel saber o seu sinal
-- 2º verifica se está perante uma variavel com grau igual ou superior a 1 (se length da variavel for igual que 1 entao nao tem "^" no meio da sua string e por isso o grau é 1)
-- 3º verifica se está perante um termo independente ou perante um termo de grau e coeficiente 1, para um qualquer termo independente n o tuple é ('~', 0, n)
-- 4º para variáveis com grau superior a 1, verifica se o coeficiente de um numero é 0, porque se for, nem vale a pena adicionar a lista de Truples (esta parte tambem está incluida na 2ª verificaçao)
traversePolinomioHelper :: [[String]] -> Bool -> [(Char, Int, Int)]
traversePolinomioHelper (x:xs) positive
    | ((x!!0) == "+") = (traversePolinomioHelper(xs) True)
    | ((x!!0) == "-") = (traversePolinomioHelper(xs) False)
    | ((length x) == 1 && positive) = if(isDigit((x!!0) !! 0)) then [('~',0, (read (x !! 0) :: Int))] ++ (traversePolinomioHelper(xs) True) else [((x!!0) !! 0, 1, 1)] ++ (traversePolinomioHelper(xs) True)
    | ((length x) == 1 && not positive) = if(isDigit((x!!0) !! 0)) then [('~',0, negate (read (x !! 0) :: Int))] ++ (traversePolinomioHelper(xs) True) else [((x!!0) !! 0, 1, -1)] ++ (traversePolinomioHelper(xs) True)
    | ((length (x!!0)) == 1) = if (positive) then [((x !! 0) !! 0, 1, (read (x !! 1) :: Int))] ++ (traversePolinomioHelper(xs) True) else if ((x !! 1)=="0") then traversePolinomioHelper(xs) True else [((x !! 0) !! 0, 1, negate (read (x !! 1) :: Int))] ++ (traversePolinomioHelper(xs) True)
    | ((x !! 1)=="0") = traversePolinomioHelper(xs) True
    | ((x !! 1)/="0") = if (positive) then [((x !! 0) !! 0, read [((x !! 0) !! 2)] :: Int, (read (x !! 1) :: Int))] ++ (traversePolinomioHelper(xs) True) else [((x !! 0) !! 0, read [((x !! 0) !! 2)] :: Int, negate (read (x !! 1) :: Int))] ++ (traversePolinomioHelper(xs) True)
    | otherwise = (traversePolinomioHelper(xs) True)
traversePolinomioHelper [] _ = []


--funçao que normaliza um polinomio em string
--exemplo: "7*y^2 + 3*y + 5*z" ---> [('y',2,7),('y',1,3),('z',1,5)]
adaptPolinomio :: String -> [(Char, Int, Int)]
adaptPolinomio xs = traversePolinomio (splitPolinomio xs)


printPolinomio :: [(Char, Int, Int)] -> String
printPolinomio xs = printPolinomioHelper xs True

printPolinomioHelper :: [(Char, Int, Int)] -> Bool -> String
printPolinomioHelper (x:xs) first 
    | ((tup2 x) == 0) = printPolinomioHelper xs first
    | (((tup0 x) == '~') && ((tup2 x) < 0)) = (if (first) then "" else (" - ")) ++ (show (negate (tup2 x))) ++ (printPolinomioHelper xs False)
    | (((tup0 x) == '~') && ((tup2 x) > 0)) = (if (first) then "" else (" + ")) ++ (show (tup2 x))++ (printPolinomioHelper xs False)
    | ((tup2 x) < 0 && ((tup1 x) == 1)) = (if (first) then "" else (" - ")) ++ (if ((tup2 x) == -1) then "" else ((show (negate (tup2 x)))  ++ "*")) ++ [(tup0 x)] ++ (printPolinomioHelper xs False)
    | ((tup2 x) < 0 && ((tup1 x) /= 1)) = (if (first) then "" else (" - ")) ++ (if ((tup2 x) == -1) then "" else ((show (negate (tup2 x)))  ++ "*")) ++ [(tup0 x)] ++ "^" ++ (show (tup1 x)) ++ (printPolinomioHelper xs False)
    | ((tup2 x) > 0 && ((tup1 x) == 1)) = (if (first) then "" else (" + ")) ++  (if ((tup2 x) == 1) then "" else ((show (tup2 x))  ++ "*")) ++ [(tup0 x)] ++ (printPolinomioHelper xs False)
    | otherwise = (if (first) then "" else (" + ")) ++ (if ((tup2 x) == 1) then "" else ((show (tup2 x))  ++ "*")) ++ [(tup0 x)] ++ "^" ++ (show (tup1 x)) ++ (printPolinomioHelper xs False)
printPolinomioHelper [] _ = "" 



findMoreVarsWithSameDegree :: Char -> Int -> [(Char, Int, Int)] -> [(Char, Int, Int)]
findMoreVarsWithSameDegree cr dgr xs = [ x | x<-xs, ((tup0 x) == cr) && (dgr == (tup1 x))]

sumVarsWithSameDegree :: [(Char, Int, Int)] -> (Char, Int, Int)
sumVarsWithSameDegree xs =  ((tup0 (xs !! 0)), (tup1 (xs !! 0)), y)
    where y = sum ([(tup2 x) | x<-xs])

reducePolinomio :: [(Char, Int, Int)] -> [(Char, Int, Int)]
reducePolinomio xs = removeDuplicates [ sumVarsWithSameDegree (findMoreVarsWithSameDegree (tup0 x) (tup1 x) xs) | x<-xs]

normalizarPolinomio :: String -> String
normalizarPolinomio xs = printPolinomio(reducePolinomio (adaptPolinomio xs))
