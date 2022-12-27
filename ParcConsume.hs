module ParcConsume (parsing, fail, pred, seq, alt) where
import Prelude hiding (pred, seq, fail)

data ParseState a = Parsing String a
                  | Failure
    deriving (Show, Ord, Eq)

type Parser a b = (ParseState a -> ParseState b)

-- We want to expose the constructor only
parsing s st = Parsing s st

-- Note, we have no 'ok'
fail p = Failure

-- Promise you won't pass in anything too complex for f!
pred :: (Char -> a -> Maybe b) -> Parser a b
pred _ Failure = Failure
pred _ (Parsing [] _) = Failure
pred f (Parsing (c:cs) v) = case f c v of
    Just v' -> Parsing cs v'
    Nothing -> Failure

seq :: Parser a b -> Parser b c -> Parser a c
seq p q s = case p s of
    Failure -> Failure
    other   -> q other

alt :: Parser a b -> Parser a b -> Parser a b
alt p q s = case p s of
    Failure -> q s
    other   -> other

