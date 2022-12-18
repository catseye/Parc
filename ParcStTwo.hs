module ParcStTwo where

data ParseState a = Parsing String a
                  | Failure
    deriving (Show, Ord, Eq)

type Parser a b = (ParseState a -> ParseState b)

ok p = p

fail p = Failure

pred :: (Char -> a -> Maybe b) -> Parser a b
pred _ Failure = Failure
pred _ (Parsing [] _) = Failure
pred f (Parsing (c:cs) v) = case f c v of
    Just v' -> Parsing cs v'
    Nothing -> Failure

update :: (a -> b) -> Parser a b
update _ Failure = Failure
update f (Parsing cs v) = Parsing cs (f v)

seq :: Parser a b -> Parser b c -> Parser a c
seq p q s = case p s of
    Failure -> Failure
    other   -> q other

alt :: Parser a b -> Parser a b -> Parser a b
alt p q s = case p s of
    Failure -> q s
    other   -> other

many :: Parser a a -> Parser a a
many p s = case p s of
    Failure      -> s
    Parsing [] v -> Parsing [] v
    other        -> many p other
