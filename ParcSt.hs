module ParcSt where

data ParseState a = Parsing String a
                  | Failure
    deriving (Show, Ord, Eq)

type Parser a = (ParseState a -> ParseState a)

ok :: Parser a
ok p = p

fail :: Parser a
fail p = Failure

pred :: (Char -> a -> Maybe a) -> Parser a
pred _ Failure = Failure
pred _ (Parsing [] _) = Failure
pred f (Parsing (c:cs) v) = case f c v of
    Just v' -> Parsing cs v'
    Nothing -> Failure

update :: (a -> a) -> Parser a
update _ Failure = Failure
update f (Parsing cs v) = Parsing cs (f v)

seq :: Parser a -> Parser a -> Parser a
seq p q s = case p s of
    Failure -> Failure
    other   -> q other

alt :: Parser a -> Parser a -> Parser a
alt p q s = case p s of
    Failure -> q s
    other   -> other

many :: Parser a -> Parser a
many p s = case p s of
    Failure      -> s
    Parsing [] v -> Parsing [] v
    other        -> many p other
