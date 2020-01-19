var speedOpts = {
    angle: 0.05, // The span of the gauge arc
    lineWidth: 0.04, // The line thickness
    radiusScale: 1, // Relative radius
    pointer: {
      length: 0.6, // // Relative to gauge radius
      strokeWidth: 0.035, // The thickness
      color: '#fff' // Fill color
    },
    limitMax: false,     // If false, max value increases automatically if value > maxValue
    limitMin: false,     // If true, the min value of the gauge will be fixed
    colorStart: '#e67e22',   // Colors
    colorStop: '#e67e22',    // just experiment with them
    strokeColor: '#666',  // to see which ones work best for you
    generateGradient: true,
    shadowColor: 'transparent',
    highDpiSupport: true,     // High resolution support
};
var speedGauge = new Donut(document.getElementById('speedgauge')).setOptions(speedOpts); // create sexy gauge!
speedGauge.maxValue = 210; // set max gauge value
speedGauge.animationSpeed = 10; // set animation speed (32 is default value)

function SetVehicleSpeed(speed) {
    speed = Math.abs(speed)
    speedGauge.set(speed);
    document.getElementById('speed-display').innerHTML = speed
}

var fuelOpts = {
    angle: 0.2, // The span of the gauge arc
    lineWidth: 0.06, // The line thickness
    radiusScale: 1, // Relative radius
    pointer: {
      length: 0.6, // // Relative to gauge radius
      strokeWidth: 0.035, // The thickness
      color: '#fff' // Fill color
    },
    limitMax: false,     // If false, max value increases automatically if value > maxValue
    limitMin: false,     // If true, the min value of the gauge will be fixed
    colorStart: '#ccc',   // Colors
    colorStop: '#ccc',    // just experiment with them
    strokeColor: '#666',  // to see which ones work best for you
    generateGradient: true,
    shadowColor: 'transparent',
    highDpiSupport: true,     // High resolution support
};
var fuelGauge = new Donut(document.getElementById('fuelgauge')).setOptions(fuelOpts); // create sexy gauge!
fuelGauge.maxValue = 100; // set max gauge value
fuelGauge.animationSpeed = 10; // set animation speed (32 is default value)

function SetVehicleFuel(fuel) {
    fuelGauge.set(fuel);
}

function SetVehicleHealth(health) {
  if (health == 0) {
    document.getElementById('engine').style.display = 'block'
    document.getElementById('speed').style.display = 'none'
  } else {
    document.getElementById('engine').style.display = 'none'
    document.getElementById('speed').style.display = 'block'
  }
}

SetVehicleSpeed(0)
SetVehicleFuel(0)
SetVehicleHealth(5000)