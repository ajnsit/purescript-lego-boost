# Purescript Lego Boost

Lego Boost BLE protocol bindings for Purescript.

## Usage

```purescript
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
```

You can see the full code for this example in the file test/Main.purs. Try it out yourself -

> git clone https://github.com/ajnsit/purescript-lego-boost

> cd purescript-lego-boost

> npm install

> npm run test

When the screen says "Searching for a nearby hub", press the green button on your lego boost hub. Then you should see the left motor run for 1 second.

Sample Output:

```
λ npm run test

> spago test

Installation complete.
Build succeeded.
Searching for a nearby hub
LEGO Move Hub (UUID: 1005f82fb8154e438065b733dcb3d013) discovered!
Connecting...
Running motor A at half speed for 1 second...
All Done!
```
