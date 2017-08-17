{-# LANGUAGE ConstraintKinds #-}
{-# LANGUAGE TemplateHaskell #-}
{-# LANGUAGE TypeFamilies #-}
{-# LANGUAGE FlexibleInstances #-}
{-# LANGUAGE MultiParamTypeClasses #-}
{-# LANGUAGE GeneralizedNewtypeDeriving #-}

module Data.Digit.DD where

import Control.Lens hiding ((<.>))
import Data.Functor.Apply
import Data.Functor.Bind
import Data.Semigroup
import Data.Semigroup.Foldable
import Data.Void
import Text.Parser.Char
import Text.Parser.Combinators((<?>), choice)

class DD d where
  dD ::
    Prism'
      d
      ()
  xD ::
    d
  xD =
    dD # ()

instance DD () where
  dD =
    id
    
-- |
--
-- >>> parse (parseD <* eof) "test" "D" :: Either ParseError (DigitD ())
-- Right (DigitD ())
--
-- >>> parse parseD "test" "Dxyz" :: Either ParseError (DigitD ())
-- Right (DigitD ())
--
-- >>> isn't _Right (parse parseD "test" "xyz" :: Either ParseError (DigitD ()))
-- True
--
-- prop> \c -> c /= 'D' ==> isn't _Right (parse parseD "test" [c] :: Either ParseError (DigitD ()))
parseD ::
  (DD d, CharParsing p) =>
  p d
parseD =
  xD <$ char 'D' <?> "D"

instance DD d => DD (Either d x) where
  dD =
    _Left . dD