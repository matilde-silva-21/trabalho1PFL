import Data.List.Split
import Data.List

-- funcao que transforma Maybe Int em Int
maybeToInt :: Maybe Int -> Int
maybeToInt (Just n) = n
maybeToInt Nothing = -1


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
-- 3º para variáveis com grau superior a 1, verifica se o coeficiente de um numero é 0, porque se for, nem vale a pena adicionar a lista de Truples (esta parte tambem está incluida na 2ª verificaçao)
traversePolinomioHelper :: [[String]] -> Bool -> [(Char, Int, Int)]
traversePolinomioHelper (x:xs) positive
    | ((x!!0) == "+") = (traversePolinomioHelper(xs) True)
    | ((x!!0) == "-") = (traversePolinomioHelper(xs) False)
    | ((length (x!!0)) == 1) = if (positive) then [((x !! 0) !! 0, 1, (read (x !! 1) :: Int))] ++ (traversePolinomioHelper(xs) True) else if ((x !! 1)=="0") then traversePolinomioHelper(xs) True else [((x !! 0) !! 0, 1, negate (read (x !! 1) :: Int))] ++ (traversePolinomioHelper(xs) True)
    | ((x !! 1)=="0") = traversePolinomioHelper(xs) True
    | ((x !! 1)/="0") = if (positive) then [((x !! 0) !! 0, read [((x !! 0) !! 2)] :: Int, (read (x !! 1) :: Int))] ++ (traversePolinomioHelper(xs) True) else [((x !! 0) !! 0, read [((x !! 0) !! 2)] :: Int, negate (read (x !! 1) :: Int))] ++ (traversePolinomioHelper(xs) True)
    | otherwise = (traversePolinomioHelper(xs) True)
traversePolinomioHelper [] _ = []


--funçao que normaliza um polinomio em string
--exemplo: "7*y^2 + 3*y + 5*z" ---> [('y',2,7),('y',1,3),('z',1,5)]
normalizePolinomio :: String -> [(Char, Int, Int)]
normalizePolinomio xs = traversePolinomio (splitPolinomio xs)




