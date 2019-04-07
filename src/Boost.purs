module Lego.Boost
  ( module FFIExport
  , withFirstDiscoveredHub
  , newBoostInstance
  , initiateScan
  , discoverFirstHub
  , onDiscoverHub
  , connect
  , sleep
  , setMotorSpeed
  , setMotorSpeedForDuration
  ) where


import Control.Applicative (pure)
import Control.Bind (bind, discard)
import Control.Promise (toAffE)
import Data.Function (($))
import Data.Functor (void)
import Data.Monoid (mempty)
import Data.Newtype (unwrap)
import Data.Nullable as Nullable
import Data.Unit (Unit)
import Effect (Effect)
import Effect.AVar as Evar
import Effect.Aff (Aff, launchAff_, makeAff)
import Effect.Uncurried (mkEffectFn1)
import Lego.Boost.FFI (Boost, Duration, Hub, Motor, Speed)
import Lego.Boost.FFI (Boost, Duration, Hub, Motor, Speed, hubUuid, hubName, motorA, motorB, motorAB) as FFIExport
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

-- | Sleep for the given duration (ms)
sleep :: Hub -> Duration -> Aff Unit
sleep h d = toAffE do FFI._sleep h d

-- | Initiate a motor speed change
setMotorSpeed :: Hub -> Motor -> Speed -> Effect Unit
setMotorSpeed h m s = void do FFI._setMotorSpeed h (unwrap m) s Nullable.null

-- | Set the motor speed for the specified duration (ms) and wait for the duration to elapse
setMotorSpeedForDuration :: Hub -> Motor -> Speed -> Duration -> Aff Unit
setMotorSpeedForDuration h m s d = toAffE do FFI._setMotorSpeed h (unwrap m) s (Nullable.notNull d)
