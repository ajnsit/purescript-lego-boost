module Lego.Boost.FFI
  ( Boost
  , Hub
  , Speed
  , hubUuid
  , hubName
  , Duration
  , Motor
  , motorA
  , motorB
  , motorAB
  , _newBoostInstance
  , _initiateScan
  , _onBoost
  , _onHub
  , _connect
  , _sleep
  , _setMotorSpeed
  -- Debug only
  , debugLog
  ) where

import Control.Promise (Promise)
import Data.Newtype (class Newtype)
import Data.Nullable (Nullable)
import Data.Unit (Unit)
import Effect (Effect)
import Effect.Uncurried (EffectFn1)
import Unsafe.Coerce (unsafeCoerce)

---------------------------------
-- DATA STRUCTURES --------------

-- | Boost
data Boost

-- | A Boost Hub
data Hub

-- | Get the UUID of the hub
hubUuid :: Hub -> String
hubUuid hub = (unsafeCoerce hub).uuid

-- | Get the name of the hub
hubName :: Hub -> String
hubName hub = (unsafeCoerce hub).name

-- | Duration in milliseconds
type Duration = Int

-- | Motor speed 0-100
type Speed = Int

-- | A boost motor
newtype Motor = Motor String
derive instance newtypeMotor :: Newtype Motor _

-- | The left motor
motorA :: Motor
motorA = Motor "A"

-- | The right motor
motorB :: Motor
motorB = Motor "B"

-- | Both the right and left motors
motorAB :: Motor
motorAB = Motor "AB"


--------------------------------
-- FFI -------------------------

foreign import _newBoostInstance :: Effect Boost
foreign import _initiateScan :: forall a. Boost -> Effect a
foreign import _onBoost :: Boost -> String -> (EffectFn1 Hub Unit) -> Effect Unit
foreign import _onHub :: Hub -> String -> (EffectFn1 Hub Unit) -> Effect Unit
foreign import _connect :: Hub -> Effect (Promise Unit)
foreign import _sleep :: Hub -> Duration -> Effect (Promise Unit)
foreign import _setMotorSpeed :: Hub -> String -> Speed -> Nullable Duration -> Effect (Promise Unit)

-- DEBUGGING ONLY
foreign import debugLog :: forall a. a -> Effect Unit
