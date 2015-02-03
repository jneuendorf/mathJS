var sy = require("shunting-yard");

// 8
// var result = sy.compute("2 * (2 * (1 + 1))");
var shuntingYard = function(str) {
    return sy.compute(str);
};
