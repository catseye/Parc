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
multiple = many (alt nine five)

testb1 = multiple $ Parsing "11111"
testb2 = multiple $ Parsing "111111111"
testb3 = multiple $ Parsing "1111111111111111111" -- 19, fail (9+9=18)
testb4 = multiple $ Parsing "111111111111111111111" -- 21, fail
