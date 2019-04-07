const PoweredUP = require("node-poweredup");

const poweredUP = new PoweredUP.PoweredUP();
poweredUP.scan(); // Start scanning

console.log("Looking for Vernie...");

const Modes = {
    AVOIDING: 0,
    MOVING: 1
}

poweredUP.on("discover", async (hub) => { // Wait to discover Vernie and Remote

    const vernie = hub;
    await vernie.connect();
    console.log("Connected to Vernie!");

    let mode = Modes.MOVING;

    vernie.setMotorSpeed("AB", 100);

    vernie.on("distance", async (port, distance) => {

        if (distance < 180 && mode === Modes.MOVING) {
            mode = Modes.AVOIDING;
            await vernie.setMotorSpeed("AB", 0, 100);
            await vernie.setMotorSpeed("AB", -50, 500);
            await vernie.setMotorSpeed("AB", 0, 100);
            vernie.setMotorSpeed("A", 30, 500);
            await vernie.setMotorSpeed("B", -30, 500);
            await vernie.setMotorSpeed("AB", 0, 100);
            vernie.setMotorSpeed("AB", 100);
            mode = Modes.MOVING;
        }

    });

});
