var Boost = require("node-poweredup");

exports._newBoostInstance = function() {
  return new Boost.PoweredUP();
};

exports._initiateScan = function(boost) {
  return function() {
    boost.scan();
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


exports.debugLog = function(x) {
  return function() {
    console.log(x);
  };
};