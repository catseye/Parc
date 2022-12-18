module ParcStExpr where
import Prelude hiding (pred, seq, any)

import ParcSt

-- Helpers

char x = pred (\c v -> if x == c then Just v else Nothing)
try c = alt c ok
many1 c = seq c (many c)

-- Grammar

expr0 = seq (expr1) (many (seq (char '+') expr1))
expr1 = seq (expr2) (many (seq (char '*') expr2))
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

accumDigit Failure = Failure
accumDigit (Parsing s v) =
    case digit (Parsing s 0) of
        Failure -> Failure
        Parsing s' dv -> Parsing s' ((v * 10) + dv)

number = seq (update $ \v -> 0) (many1 accumDigit)
