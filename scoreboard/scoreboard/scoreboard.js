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
        <button onclick="freeze(${id})">FREEZE</button>&nbsp;
        <button onclick="ragdoll(${id})">RAGDOLL</button>&nbsp;
        <button onclick="bring(${id})">BRING</button>&nbsp;
        <button onclick="goto(${id})">GOTO</button>&nbsp;
        <button onclick="spec(${id})">SPEC</button>&nbsp;
        <button onclick="kick(${id})">KICK</button>&nbsp;
        <button onclick="ban(${id})">BAN</button>     
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
    // TODO
}