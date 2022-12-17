module Parc where

data ParseState = Parsing String
                | Failure
    deriving (Show, Ord, Eq)

type Parser = (ParseState -> ParseState)

ok :: ParseState -> ParseState
ok p = p

fail :: ParseState -> ParseState
fail p = Failure

pred :: (Char -> Bool) -> ParseState -> ParseState
pred _ Failure = Failure
pred _ (Parsing []) = Failure
pred f (Parsing (c:cs)) = if f c then (Parsing cs) else Failure

seq :: Parser -> Parser -> ParseState -> ParseState
seq p q s = case p s of
    Failure -> Failure
    other   -> q other

alt :: Parser -> Parser -> ParseState -> ParseState
alt p q s = case p s of
    Failure -> q s
    other   -> other

many :: Parser -> ParseState -> ParseState
many p s = case p s of
    Failure    -> s
    Parsing [] -> Parsing []
    other      -> many p other
