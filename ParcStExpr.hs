module ParcStExpr where
import Prelude hiding (pred, seq, any)

-- Under development!

import ParcSt

-- Extra combinators

transform :: (ParseState a -> ParseState b) -> (a -> b -> c) -> ParseState a -> ParseState c
transform c f =
    (\st ->
        case st of
            Failure -> Failure
            Parsing s0 v0 ->
                case c st of
                    Failure -> Failure
                    Parsing s v1 -> Parsing s (f v0 v1))

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

accDigit = transform digit (\v0 v1 -> v0 * 10 + v1)

number = seq (update $ \v -> 0) (many1 accDigit)
