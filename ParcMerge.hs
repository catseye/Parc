module ParcMerge (ok, fail, pred, update, seq, alt, many, merge, ParseState(Parsing, Failure)) where

import Prelude hiding (fail, pred, seq)
import ParcSt2St

merge :: (ParseState a -> ParseState b) -> (a -> b -> c) -> ParseState a -> ParseState c
merge c f =
    (\st ->
        case st of
            Failure -> Failure
            Parsing s0 v0 ->
                case c st of
                    Failure -> Failure
                    Parsing s v1 -> Parsing s (f v0 v1))
