function ResetScoreboard() {
    let table = document.getElementsByTagName("table")[0];
    table.getElementsByTagName("tbody")[0].innerHTML = table.rows[0].innerHTML;

    let tableOuter = document.getElementsByClassName("table")[0];
    tableOuter.scrollTop = 0;
}

function AddPlayer(id, accountid, name, ping, job, health, hunger, thirst, admin) {
    let table = document.getElementsByTagName("table")[0];
    let tableContent = table.getElementsByTagName("tbody")[0].innerHTML;

    table.getElementsByTagName("tbody")[0].innerHTML =
        tableContent +
        `<tr class="${job != "" ? "job-"+job:""} ${admin == 1 ? "is-admin":""}">
    <td>#${accountid}</td>
    <td class="name">${name}</td>
    <td>${job}</td>
    <td>
        <span class="btn health">${health} %</span>&nbsp;
        <span class="btn hunger">${hunger} %</span>&nbsp;
        <span class="btn thirst">${thirst} %</span>
    </td>
    <td>${ping} ms</td>
    <td class="right">
        <button class=" btn btn-level-0" onclick="spec(${id})">SPC</button>&nbsp;    
        <button class=" btn btn-level-0" onclick="heal(${id})">HEAL</button>&nbsp;    
        <button class=" btn btn-level-0" onclick="rez(${id})">REZ</button>&nbsp;    
        <button class=" btn btn-level-0" onclick="cuff(${id})">CUFF</button>&nbsp;    
        <button class=" btn btn-level-1" onclick="goto(${id})">GOTO</button>&nbsp;
        <button class=" btn btn-level-1" onclick="bring(${id})"> BRING</button>&nbsp;
        <button class=" btn btn-level-2" onclick="freeze(${id})">FRZ</button>&nbsp;
        <button class=" btn btn-level-2" onclick="ragdoll(${id})">RGD</button>&nbsp;
        <button class=" btn btn-level-3 btn-margin-left" onclick="kick(${id})">KICK</button>&nbsp;
        <button class=" btn btn-level-3" onclick="ban(${id})">BAN</button>     
    </td>
  </tr>`;
}

function SecondsToTime(d) {
    d = Number(d);
    var h = Math.floor(d / 3600);
    var m = Math.floor((d % 3600) / 60);
    var s = Math.floor((d % 3600) % 60);

    var hDisplay = h > 0 ? h + (h == 1 ? " hr, " : " hrs, ") : "";
    var mDisplay = m > 0 ? m + (m == 1 ? " min, " : " mins, ") : "";
    var sDisplay = s > 0 ? s + (s == 1 ? " sec" : " secs") : "";
    return hDisplay + mDisplay + sDisplay;
}

function SetInformation(players, maxplayers) {
    let infoPlayers = document.getElementsByClassName("players")[0];
    infoPlayers.getElementsByTagName(
        "small"
    )[0].innerHTML = `Players: ${players}/${maxplayers}`;
}

function heal(player) {
    window.ue.game.callevent("scoreboard:admin:heal", player);
}

function rez(player) {
    window.ue.game.callevent("scoreboard:admin:rez", player);
}

function cuff(player) {
    window.ue.game.callevent("scoreboard:admin:cuff", player);
}

function freeze(player) {
    window.ue.game.callevent("scoreboard:admin:freeze", player);
}

function ragdoll(player) {
    window.ue.game.callevent("scoreboard:admin:ragdoll", player);
}

function bring(player) {
    window.ue.game.callevent("scoreboard:admin:bring", player);
}

function goto(player) {
    window.ue.game.callevent("scoreboard:admin:goto", player);
}

function kick(player) {
    window.ue.game.callevent("scoreboard:admin:kick", player);
}

function ban(player) {
    window.ue.game.callevent("scoreboard:admin:ban", player);
}

function spec(player) {
    window.ue.game.callevent("scoreboard:admin:spectate", player);
}