module ParcDemo where
import Prelude hiding (pred, seq, any)

import Parc

-- Helpers

char x = pred (\c -> x == c)
try c = alt c ok

-- Grammar

whitespace = char ' '
bit = alt (char '0') (char '1')
bits = seq bit (many bit)
bitstring = seq bits (try (char 'B'))
docco = many (seq (many whitespace) bitstring)

-- Demo
test1 = docco $ Parsing "1110B   100B"
test2 = docco $ Parsing "1110G   100B"
