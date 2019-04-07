module Test.Main where

import Control.Bind (discard)
import Data.Function (($))
import Data.Semigroup ((<>))
import Data.Unit (Unit)
import Effect (Effect)
import Effect.Class (liftEffect)
import Effect.Console (log)
import Lego.Boost (connect, hubName, hubUuid, motorA, setMotorSpeedForDuration, withFirstDiscoveredHub)

main :: Effect Unit
main = do
  log "Searching for a nearby hub"
  withFirstDiscoveredHub \hub -> do
    liftEffect $ log $ hubName hub <> " (UUID: " <> hubUuid hub <> ") discovered!"
    liftEffect $ log "Connecting..."
    connect hub
    liftEffect $ log "Running motor A at half speed for 1 second..."
    setMotorSpeedForDuration hub motorA 50 1000
    liftEffect $ log "All Done!"
