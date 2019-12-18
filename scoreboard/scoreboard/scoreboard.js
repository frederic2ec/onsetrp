function ResetScoreboard() {
    let table = document.getElementsByTagName("table")[0];
    table.getElementsByTagName("tbody")[0].innerHTML = table.rows[0].innerHTML;

    let tableOuter = document.getElementsByClassName("table")[0];
    tableOuter.scrollTop = 0;
}

function AddPlayer(name, ping) {
    let table = document.getElementsByTagName("table")[0];
    let tableContent = table.getElementsByTagName("tbody")[0].innerHTML;

    table.getElementsByTagName("tbody")[0].innerHTML =
        tableContent +
        `<tr>
    <td>${name}</td>
    <td>${ping}ms</td>
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