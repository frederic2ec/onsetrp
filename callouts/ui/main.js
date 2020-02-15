function AddCallout(id, from, job, reason, distance, taken) {
    switch (taken) {
        case 'me':
            takenElement = document.createElement('div')
            takenElement.className = 'btn btn-error'
            takenElement.innerText = "Terminer l'appel"
            takenElement.addEventListener('click', function () {
                apiCall('callouts:ui:stop', `[${this.parentElement.parentElement.id}]`)
            })
            break;

        case false:
            takenElement = document.createElement('div')
            takenElement.className = 'btn btn-success'
            takenElement.innerText = "Prendre l'appel"
            takenElement.addEventListener('click', function () {
                apiCall('callouts:ui:take', `[${this.parentElement.parentElement.id}]`)
            })
            break;

        case null:
            takenElement = document.createElement('div')
            takenElement.className = 'btn btn-success'
            takenElement.innerText = "Prendre l'appel"
            takenElement.addEventListener('click', function () {
                apiCall('callouts:ui:take', `[${this.parentElement.parentElement.id}]`)
            })
            break;
    
        default:
            takenElement = document.createElement('span')
            takenElement.innerText = taken
            break;
    }

    let tr = document.createElement('tr')
    tr.id = id

    let nameTd = document.createElement('td')
    let jobText = job == null ? "" : `<span class="label label-${job}">${job}</span>&nbsp;&nbsp;`
    nameTd.innerHTML = `${jobText}${from}`

    let reasonTd = document.createElement('td')
    reasonTd.innerText = reason
    
    let distanceTd = document.createElement('td')
    distanceTd.innerText = `${distance}m`

    let takenTd = document.createElement('td')
    takenTd.appendChild(takenElement)

    tr.appendChild(nameTd)
    tr.appendChild(reasonTd)
    tr.appendChild(distanceTd)
    tr.appendChild(takenTd)

    document.getElementById('callouts').appendChild(tr)
}

document.querySelector('#cross').addEventListener('click', function (e) {
    e.preventDefault()

    apiCall('callouts:ui:close', '[]')
})

function apiCall(event, parameters) {
    if (window.ue) {
        window.ue.game.callevent(event, parameters);
    } else {
        console.warn(`window.ue.game.callevent("${event}", "${parameters}") will be triggered`)
    }
}

callouts = []

function LoadCallouts(calls) {
    document.getElementById('callouts').innerHTML = ''

    callouts = calls

    if (callouts.length > 0) {
        for (let i = 0; i < callouts.length; i++) {
            let callout = callouts[i];
            if (document.getElementById(callout.id)) {
    
            } else {
                AddCallout(callout.id, callout.from, callout.job, callout.reason, callout.distance, callout.taken)
            }
        }
    } else {
        document.getElementById('callouts').innerHTML = '<tr><td>Aucun appel</td><td></td><td></td><td></td></tr>'
    }
}

// AddCallout(1, "John Doe", "police", "A L'AIDE JAI PEUR BORDEL DE MERDE ON M'A VOLE MA CULOTTE", 711, "me")
// AddCallout(1, "Jamie O'Brian", "police", "Besoin de renforts !", 1792, "Albert Newman")
// AddCallout(1, "Jean Claude", "medic", "J'ai tombé", 47, null)
// AddCallout(1, "Maurice Lucette", null, "Il est quelle heure SVP?", 3114, null)

// AddCallout(1, "John Doe", null, "A L'AIDE JAI PEUR BORDEL DE MERDE ON M'A VOLE MA CULOTTE", 711, "me")
// AddCallout(1, "Jamie O'Brian", null, "Besoin de renforts !", 1792, "Albert Newman")
// AddCallout(1, "Jean Claude", "medic", "J'ai tombé", 47, null)
// AddCallout(1, "Maurice Lucette", null, "Il est quelle heure SVP?", 3114, null)

// AddCallout(1, "John Doe", null, "A L'AIDE JAI PEUR BORDEL DE MERDE ON M'A VOLE MA CULOTTE", 711, "me")
// AddCallout(1, "Jamie O'Brian", null, "Besoin de renforts !", 1792, "Albert Newman")
// AddCallout(1, "Jean Claude", "medic", "J'ai tombé", 47, null)
// AddCallout(1, "Maurice Lucette", null, "Il est quelle heure SVP?", 3114, null)

// AddCallout(1, "John Doe", "police", "A L'AIDE JAI PEUR BORDEL DE MERDE ON M'A VOLE MA CULOTTE", 711, "me")
// AddCallout(1, "Jamie O'Brian", "police", "Besoin de renforts !", 1792, "Albert Newman")
// AddCallout(1, "Jean Claude", "medic", "J'ai tombé", 47, null)
// AddCallout(1, "Maurice Lucette", null, "Il est quelle heure SVP?", 3114, null)

// AddCallout(1, "John Doe", "police", "A L'AIDE JAI PEUR BORDEL DE MERDE ON M'A VOLE MA CULOTTE", 711, "me")
// AddCallout(1, "Jamie O'Brian", "police", "Besoin de renforts !", 1792, "Albert Newman")
// AddCallout(1, "Jean Claude", "medic", "J'ai tombé", 47, null)
// AddCallout(1, "Maurice Lucette", null, "Il est quelle heure SVP?", 3114, null)