module ParcDemo where
import Prelude hiding (pred, seq, any)

import Parc

-- Helpers

char x = pred (\c -> x == c)
try c = alt c ok
many1 c = seq c (many c)

-- Grammar

whitespace = char ' '
whitespaces = many whitespace
bit = alt (char '0') (char '1')
bits = many1 bit
bitstring = seq bits (try (char 'B'))
docco = many (seq whitespaces bitstring)

-- Demo

test1 = docco $ Parsing "1110B   100B"
test2 = docco $ Parsing "1110G   100B"

-- Demo backtracking behaviour

one = char '1'
five = seq one (seq one (seq one (seq one one)))
nine = seq one (seq one (seq one (seq one (seq one (seq one (seq one (seq one one)))))))

-- This is greedy.  It won't backtrack to before the last `alt`.
multiple = seq (many (alt five nine)) (char '*')

testb1 = multiple $ Parsing "11111*"                 --  5
testb2 = multiple $ Parsing "111111111*"             --  9
testb3 = multiple $ Parsing "1111111111*"            -- 10
testb4 = multiple $ Parsing "1111111111111111111*"   -- 19
testb5 = multiple $ Parsing "111111111111111111111*" -- 21

-- This is exhaustive.  It will backtrack to before the last `alt`.
recurso = alt (char '*') (alt (seq five recurso) (seq nine recurso))

testr1 = recurso $ Parsing "11111*"                 --  5
testr2 = recurso $ Parsing "111111111*"             --  9
testr3 = recurso $ Parsing "1111111111*"            -- 10
testr4 = recurso $ Parsing "1111111111111111111*"   -- 19
testr5 = recurso $ Parsing "111111111111111111111*" -- 21
