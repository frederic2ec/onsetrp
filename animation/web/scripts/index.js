(function(obj) {
    ue.game = {};
    ue.game.callevent = function(name, ...args) {
        if (typeof name != "string") {
            return;
        }
        if (args.length == 0) {
            obj.callevent(name, "");
        } else {
            let params = [];
            for (let i = 0; i < args.length; i++) {
                params[i] = args[i];
            }
            obj.callevent(name, JSON.stringify(params));
        }
    };
})(ue.game);
CallEvent = ue.game.callevent;

function playAnimation(id) {
    CallEvent("OnPlayerAnimation", id);
}

var piemenu = new wheelnav("piemenu");
piemenu.clockwise = false;
piemenu.wheelRadius = piemenu.wheelRadius * 0.83;
piemenu.createWheel();