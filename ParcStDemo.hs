module ParcStDemo where
import Prelude hiding (pred, seq, any)

import ParcSt

-- Helpers

char x = pred (\c v -> if x == c then Just v else Nothing)
try c = alt c ok
many1 c = seq c (many c)

-- Grammar

whitespace = char ' '
zero = (seq (char '0') (update $ \v -> v * 2))
one = (seq (char '1') (update $ \v -> v * 2 + 1))
bit = alt zero one
bits = many1 bit
bitstring = seq bits (try (char 'B'))
docco = many (seq (many whitespace) bitstring)

-- Demo
test1 = docco $ Parsing "1110B   100B" 0
test2 = docco $ Parsing "1110G   100B" 0
