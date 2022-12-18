module ParcMergeDemo where
import Prelude hiding (pred, seq, any)

import ParcSt2St
import ParcMerge

-- Helpers

char x = pred (\c v -> if x == c then Just v else Nothing)
try c = alt c ok
many1 c = seq c (many c)

-- Grammar

expr0 = seq (expr1) (many (merge (seq (char '+') expr1) (\v0 v1 -> v0 + v1)))
expr1 = seq (expr2) (many (merge (seq (char '*') expr2) (\v0 v1 -> v0 * v1)))
expr2 = alt number parenthesized
parenthesized = seq (char '(') (seq expr0 (char ')'))

digit = pred (\c v -> case c of
    '0' -> Just 0
    '1' -> Just 1
    '2' -> Just 2
    '3' -> Just 3
    '4' -> Just 4
    '5' -> Just 5
    '6' -> Just 6
    '7' -> Just 7
    '8' -> Just 8
    '9' -> Just 9
    _   -> Nothing)

accDigit = merge digit (\v0 v1 -> v0 * 10 + v1)

number = seq (update $ \v -> 0) (many1 accDigit)

--- Demo

test1 = expr0 $ Parsing "3*(3*3+1*1)+1*1" 0
test2 = expr0 $ Parsing "3*2+1*9" 0
test3 = expr0 $ Parsing "3*(2+1)*9" 0
