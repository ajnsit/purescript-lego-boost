var _Boost = require("node-poweredup/dist/node/index-browser");
var Boost = window.PoweredUP;

exports._newBoostInstance = function() {
  return new Boost.PoweredUP();
};

exports._isWebBluetoothAvailable = function() {
  return Boost.isWebBluetooth;
};

exports._initiateScan = function(boost) {
  return function() {
    boost.scan();
  };
};

exports._getConnectedHubs = function(boost) {
  return function() {
    return boost.getConnectedHubs();
  };
};


exports._getConnectedHubByUuid = function(boost) {
  return function(uuid) {
    return function() {
      return boost.getConnectedHubByUuid(uuid);
    };
  };
};

exports._onBoost = function(boost) {
  return function(evt) {
    return function(f) {
      return function() {
        boost.on(evt, f);
      };
    };
  };
};

exports._onHub = function(hub) {
  return function(evt) {
    return function(f) {
      return function() {
        hub.on(evt, f);
      };
    };
  };
};

exports._connect = function(hub) {
  return function() {
    return hub.connect();
  };
};

exports._disconnect = function(hub) {
  return function() {
    return hub.disconnect();
  };
};

exports._sleep = function(hub) {
  return function(duration) {
    return function() {
      return hub.sleep();
    };
  };
};

exports._setMotorSpeed = function(hub) {
  return function(motor) {
    return function(speed) {
      return function(duration) {
        return function() {
          return hub.setMotorSpeed(motor, speed, duration);
        };
      };
    };
  };
};

exports._getAvailableLedColors = Boost.Consts.ColorNames;

exports._setLedColor = function(hub) {
  return function(color) {
    return function() {
      return hub.setLEDColor(color);
    };
  };
};

exports.debugLog = function(x) {
  return function() {
    console.log(x);
  };
};