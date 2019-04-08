module Lego.Boost
  ( module FFIExport
  , withFirstDiscoveredHub
  , newBoostInstance
  , isWebBluetoothAvailable
  , initiateScan
  , discoverFirstHub
  , onDiscoverHub
  , connect
  , disconnect
  , getConnectedHubs
  , getConnectedHubByUuid
  , sleep
  , setMotorSpeed
  , setMotorSpeedForDuration
  , getAvailableLedColors
  , setLedColor
  ) where


import Control.Applicative (pure, (<$>))
import Control.Bind (bind, discard)
import Control.Promise (toAffE)
import Data.Array (concatMap, fromFoldable)
import Data.Function (($), (<<<))
import Data.Functor (void)
import Data.Maybe (Maybe)
import Data.Monoid (mempty)
import Data.Newtype (unwrap)
import Data.Nullable as Nullable
import Data.Unit (Unit)
import Effect (Effect)
import Effect.AVar as Evar
import Effect.Aff (Aff, launchAff_, makeAff)
import Effect.Uncurried (mkEffectFn1)
import Lego.Boost.FFI (Boost, Duration, Hub, Motor, Speed)
import Lego.Boost.FFI (Boost, Duration, Hub, Motor, Speed, LedColor(..), hubUuid, hubName, motorA, motorB, motorAB) as FFIExport
import Lego.Boost.FFI as FFI

-- | Conveniently perform some action with the first discovered hub
withFirstDiscoveredHub :: (Hub -> Aff Unit) -> Effect Unit
withFirstDiscoveredHub f = do
  -- Signal that execution is complete
  ended <- Evar.empty
  -- Create Boost instance
  boost <- newBoostInstance
  -- Initiate scan
  initiateScan boost
  -- Wait until a hub is discovered and perform the supplied operation
  onDiscoverHub boost f

-- | Construct a new Boost instance
newBoostInstance :: Effect Boost
newBoostInstance = FFI._newBoostInstance

-- | Check if web bluetooth is available (Currently only Chrome (56+) supports this)
-- | Returns false when web bluetooth is not available, or when not running in a browser
isWebBluetoothAvailable :: Effect Boolean
isWebBluetoothAvailable = FFI._isWebBluetoothAvailable

-- | Start scanning for hubs
initiateScan :: Boost -> Effect Unit
initiateScan = FFI._initiateScan

-- | Fetch the first discovered nearby hub
-- | Note that due to the way aff works, this will only happen *once*, for the first hub encountered
-- | If you need to handle multiple hubs, use callback style `onDiscoverHub`
discoverFirstHub :: Boost -> Aff Hub
discoverFirstHub boost = makeAff \handler -> do
  FFI._onBoost boost "discover" do mkEffectFn1 \hub -> handler (pure hub)
  pure mempty

-- | Attach a handler which will be called once for each hub discovered
-- | If only one hub is expected nearby, use the easier to use `discoverFirstHub`
-- | TODO: ??? HOW DO I STOP LISTENING????
onDiscoverHub :: Boost -> (Hub -> Aff Unit) -> Effect Unit
onDiscoverHub boost f = FFI._onBoost boost "discover" $ mkEffectFn1 \hub -> do launchAff_ do f hub

-- | Connect to the hub
-- | You must do this before performing any actions on the hub
connect :: Hub -> Aff Unit
connect h = toAffE do FFI._connect h

-- | Disconnect from a hub
disconnect :: Hub -> Aff Unit
disconnect h = toAffE do FFI._disconnect h

-- | Get the list of currently connected hubs
getConnectedHubs :: Boost -> Effect (Array Hub)
getConnectedHubs = FFI._getConnectedHubs

-- | When connected to multiple hubs, you can fetch a specific hub by its UUID
-- | Returns `Nothing` when a hub with the supplied UUID does not exist (or is not connected)
getConnectedHubByUuid :: Boost -> String -> Effect (Maybe Hub)
getConnectedHubByUuid boost uuid = Nullable.toMaybe <$> FFI._getConnectedHubByUuid boost uuid

-- | Sleep for the given duration (ms)
sleep :: Hub -> Duration -> Aff Unit
sleep h d = toAffE do FFI._sleep h d

-- | Initiate a motor speed change
setMotorSpeed :: Hub -> Motor -> Speed -> Effect Unit
setMotorSpeed h m s = void do FFI._setMotorSpeed h (unwrap m) s Nullable.null

-- | Set the motor speed for the specified duration (ms) and wait for the duration to elapse
setMotorSpeedForDuration :: Hub -> Motor -> Speed -> Duration -> Aff Unit
setMotorSpeedForDuration h m s d = toAffE do FFI._setMotorSpeed h (unwrap m) s (Nullable.notNull d)

-- | Get the list of available Led Colors. This is a constant
getAvailableLedColors :: Array FFI.LedColor
getAvailableLedColors = concatMap (fromFoldable <<< FFI._internalIdToLedColor) FFI._getAvailableLedColors

-- | Set the color of the Led
setLedColor :: Hub -> FFI.LedColor -> Effect Unit
setLedColor hub color = FFI._setLedColor hub (FFI._ledColorToInternalId color)
