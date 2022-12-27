module ParcConsumeDemo where
import Prelude hiding (pred, seq, any, fail)

import ParcConsume (parsing, fail, pred, seq, alt)

chara = pred (\ch (a,b,c) -> if ch == 'a' then Just (a+1,b,c) else Nothing)
charb = pred (\ch (a,b,c) -> if ch == 'b' then Just (a,b+1,c) else Nothing)
charc = pred (\ch (a,b,c) -> if ch == 'c' then Just (a,b,c+1) else Nothing)
charx = pred (\ch (a,b,c) -> if ch == 'x' && a == b && b == c then Just (a,b,c) else Nothing)

counta = alt (seq chara counta) countb
countb = alt (seq charb countb) countc
countc = alt (seq charc countc) charx

--- Demo

test1 = counta $ parsing "abcx" (0,0,0)
test2 = counta $ parsing "aabbccx" (0,0,0)
test3 = counta $ parsing "aaccx" (0,0,0)
test4 = counta $ parsing "aabccx" (0,0,0)
