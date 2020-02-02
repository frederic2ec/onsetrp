function ResetScoreboard() {
    let table = document.getElementsByTagName("table")[0];
    table.getElementsByTagName("tbody")[0].innerHTML = table.rows[0].innerHTML;

    let tableOuter = document.getElementsByClassName("table")[0];
    tableOuter.scrollTop = 0;
}

function AddPlayer(id, name, steamid, ping) {
    let table = document.getElementsByTagName("table")[0];
    let tableContent = table.getElementsByTagName("tbody")[0].innerHTML;

    table.getElementsByTagName("tbody")[0].innerHTML =
        tableContent +
        `<tr>
    <td>#${id}</td>
    <td>${name}</td>
    <td>${steamid}</td>
    <td>${ping}ms</td>
    <td class="right">
        <button class="btn-level-0" onclick="spec(${id})"><img src="admin-icons/binoculars.png"/> SPEC</button>&nbsp;    
        <button class="btn-level-0" onclick="heal(${id})"><img src="admin-icons/pill.png"/> HEAL</button>&nbsp;    
        <button class="btn-level-0" onclick="rez(${id})"><img src="admin-icons/reanimation.png"/> REZ</button>&nbsp;    
        <button class="btn-level-1" onclick="goto(${id})"><img src="admin-icons/teleport.png"/> GOTO</button>&nbsp;
        <button class="btn-level-1" onclick="bring(${id})"><img src="admin-icons/teleport.png"/> BRING</button>&nbsp;
        <button class="btn-level-2" onclick="freeze(${id})"><img src="admin-icons/freeze.png"/> FREEZE</button>&nbsp;
        <button class="btn-level-2" onclick="ragdoll(${id})"><img src="admin-icons/doll.png"/> RAGDOLL</button>&nbsp;
        <button class="btn-level-3 btn-margin-left" onclick="kick(${id})"><img src="admin-icons/kick.png"/> KICK</button>&nbsp;
        <button class="btn-level-3" onclick="ban(${id})"><img src="admin-icons/law.png"/> BAN</button>     
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

function SetInformation(name, players, maxplayers) {
    let infoName = document.getElementsByClassName("name")[0];
    infoName.getElementsByTagName("small")[0].innerHTML = `Server: ${name}`;

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