module Main where

import Concur.React.DOM as D
import Concur.React.Props as P
import Concur.React.Run (runWidgetInDom)
import Control.Alt (void)
import Control.Bind (discard)
import Data.Function (($))
import Data.Semigroup ((<>))
import Data.Unit (Unit)
import Effect (Effect)
import Effect.Class (liftEffect)
import Effect.Console (log)
import Lego.Boost (connect, hubName, hubUuid, motorA, setMotorSpeedForDuration, withFirstDiscoveredHub)

main :: Effect Unit
main = runWidgetInDom "root" do
  void $ D.div' [D.button [P.onClick] [D.text "Start!"]]
  liftEffect $ log "Searching for a nearby hub"
  liftEffect $ withFirstDiscoveredHub \hub -> do
    liftEffect $ log $ hubName hub <> " (UUID: " <> hubUuid hub <> ") discovered!"
    liftEffect $ log "Connecting..."
    connect hub
    liftEffect $ log "Running motor A at half speed for 1 second..."
    setMotorSpeedForDuration hub motorA 50 1000
    liftEffect $ log "All Done!"
