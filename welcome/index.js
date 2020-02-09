function initWelcome(created) {
    if (created) {
        document.querySelector('#spawn').classList.remove("hidden")
    } else {
        document.querySelector('#create-character').classList.remove("hidden")
    }
}

document.querySelector('#create-character-btn').addEventListener('click', function() {
    window.ue.game.callevent("CloseAndCreateCharacter", "[]");
})

document.querySelector('#spawn-and-close').addEventListener('click', function() {
    window.ue.game.callevent("CloseAndSpawn", "[]");
})