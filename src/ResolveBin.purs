module GulpPurescript.ResolveBin
  ( ResolveBin()
  , Options(..)
  , resolveBin
  ) where

import Control.Monad.Aff (Aff(), makeAff)
import Control.Monad.Eff (Eff())
import Control.Monad.Eff.Exception (Error())

import Data.Function

foreign import data ResolveBin :: !

type Options = { executable :: String }

resolveBin :: forall eff. String -> Options -> Aff (resolveBin :: ResolveBin | eff) String
resolveBin pkg opts = makeAff $ runFn4 resolveBinFn pkg opts

foreign import resolveBinFn """
function resolveBinFn(pkg, options, errback, callback) {
  return function(){
    var resolveBin = require('resolve-bin');

    resolveBin(pkg, options, function(e, bin){
      if (e) errback(e)();
      else callback(bin)();
    })
  };
}
""" :: forall eff. Fn4 String
                       Options
                       (Error -> Eff (resolveBin :: ResolveBin | eff) Unit)
                       (String -> Eff (resolveBin :: ResolveBin | eff) Unit)
                       (Eff (resolveBin :: ResolveBin | eff) Unit)
