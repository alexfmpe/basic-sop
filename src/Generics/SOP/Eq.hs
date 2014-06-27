module Generics.SOP.Eq (geq) where

import Data.Function
import Generics.SOP

geq :: (Generic a, All2 Eq (Code a)) => a -> a -> Bool
geq = go sing `on` from
  where
    go :: forall xss. (All2 Eq xss) => Sing xss -> SOP I xss -> SOP I xss -> Bool
    go SCons (SOP (Z xs))  (SOP (Z ys))  = and . hcollapse $ hcliftA2 p eq xs ys
    go SCons (SOP (S xss)) (SOP (S yss)) = go sing (SOP xss) (SOP yss)
    go _     _             _             = False

    p :: Proxy Eq
    p = Proxy

    eq :: forall (a :: *). Eq a => I a -> I a -> K Bool a
    eq (I a) (I b) = K (a == b)