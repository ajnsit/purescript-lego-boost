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
  , _isWebBluetoothAvailable
  , _initiateScan
  , _onBoost
  , _onHub
  , _connect
  , _disconnect
  , _getConnectedHubs
  , _getConnectedHubByUuid
  , _sleep
  , _setMotorSpeed
  , LedColor(..)
  , _getAvailableLedColors
  , _setLedColor
  , _ledColorToInternalId
  , _internalIdToLedColor
  -- Debug only
  , debugLog
  ) where

import Control.Promise (Promise)
import Data.Maybe (Maybe(..))
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

-- | Available LED Colors
data LedColor
  = Black
  | Blue
  | Cyan
  | Green
  | LightBlue
  | None
  | Orange
  | Pink
  | Purple
  | Red
  | White
  | Yellow

-- Convert an LedColor to a representation usable by the JS API
_ledColorToInternalId :: LedColor -> String
_ledColorToInternalId color = case color of
  Black -> "BLACK"
  Blue -> "BLUE"
  Cyan -> "CYAN"
  Green -> "GREEN"
  LightBlue -> "LIGHT_BLUE"
  None -> "NONE"
  Orange -> "ORANGE"
  Pink -> "PINK"
  Purple -> "PURPLE"
  Red -> "RED"
  White -> "WHITE"
  Yellow -> "YELLOW"

-- Get an LedColor from a value returned by the JS API
_internalIdToLedColor :: String -> Maybe LedColor
_internalIdToLedColor color = case color of
  "BLACK" -> Just Black
  "BLUE" -> Just Blue
  "CYAN" -> Just Cyan
  "GREEN" -> Just Green
  "LIGHT_BLUE" -> Just LightBlue
  "NONE" -> Just None
  "ORANGE" -> Just Orange
  "PINK" -> Just Pink
  "PURPLE" -> Just Purple
  "RED" -> Just Red
  "WHITE" -> Just White
  "YELLOW" -> Just Yellow
  "0" -> Just Black
  "1" -> Just Pink
  "2" -> Just Purple
  "3" -> Just Blue
  "4" -> Just LightBlue
  "5" -> Just Cyan
  "6" -> Just Green
  "7" -> Just Yellow
  "8" -> Just Orange
  "9" -> Just Red
  "10" -> Just White
  "255" -> Just None
  _ -> Nothing

--------------------------------
-- FFI -------------------------

foreign import _newBoostInstance :: Effect Boost
foreign import _isWebBluetoothAvailable :: Effect Boolean
foreign import _initiateScan :: forall a. Boost -> Effect a
foreign import _onBoost :: Boost -> String -> (EffectFn1 Hub Unit) -> Effect Unit
foreign import _onHub :: Hub -> String -> (EffectFn1 Hub Unit) -> Effect Unit
foreign import _getConnectedHubs :: Boost -> Effect (Array Hub)
foreign import _getConnectedHubByUuid :: Boost -> String -> Effect (Nullable Hub)
foreign import _connect :: Hub -> Effect (Promise Unit)
foreign import _disconnect :: Hub -> Effect (Promise Unit)
foreign import _sleep :: Hub -> Duration -> Effect (Promise Unit)

-- Motors
foreign import _setMotorSpeed :: Hub -> String -> Speed -> Nullable Duration -> Effect (Promise Unit)

-- Colors
foreign import _getAvailableLedColors :: Array String
foreign import _setLedColor :: Hub -> String -> Effect Unit

-- DEBUGGING ONLY
foreign import debugLog :: forall a. a -> Effect Unit
