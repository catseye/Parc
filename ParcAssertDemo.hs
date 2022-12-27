module ParcAssertDemo where
import Prelude hiding (pred, seq, any, fail)

import ParcSt2St

-- Helpers

char x = pred (\c v -> if x == c then Just v else Nothing)
try c = alt c ok
many1 c = seq c (many c)

-- Assert

assert :: (a -> Bool) -> Parser a a
assert f = (\st@(Parsing s x) -> if f x then st else Failure)

-- Grammar

counta :: Parser (Int,Int,Int) (Int,Int,Int)
counta = try (seq (seq (char 'a') (update $ \(a,b,c) -> (a+1,b,c))) counta)

countb :: Parser (Int,Int,Int) (Int,Int,Int)
countb = try (seq (seq (char 'b') (update $ \(a,b,c) -> (a,b+1,c))) countb)

countc :: Parser (Int,Int,Int) (Int,Int,Int)
countc = try (seq (seq (char 'c') (update $ \(a,b,c) -> (a,b,c+1))) countc)

--- Demo (parsing context-sensitive languages)

test1 = counta $ Parsing "aaaaa" (0,0,0)

fiveas = seq (counta) (assert $ \(a,b,c) -> a == 5)

test2a = fiveas $ Parsing "aaaa" (0,0,0)
test2b = fiveas $ Parsing "aaaaa" (0,0,0)
test2c = fiveas $ Parsing "aaaaaa" (0,0,0)

anbncn = seq (counta) (seq (countb) (seq (countc) (assert $ \(a,b,c) -> a == b && b == c)))

test3a = anbncn $ Parsing "aaabbbccc" (0,0,0)
test3b = anbncn $ Parsing "aaabbccc" (0,0,0)
test3c = anbncn $ Parsing "aaacccbbb" (0,0,0)
