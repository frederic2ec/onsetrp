let translations = {
  en: {
    idTitle: "Onset City",
    name: "Name: ",
    age: "Age: ",
    job: "Job: ",
    jobTitle: "Job Title: ",
    issued: "Issued: ",
    signature: "Signature: ",
    hide: "Hide"
  },
  fr: {
    idTitle: "Onset City",
    name: "Nom: ",
    age: "Âge: ",
    job: "Travail: ",
    jobTitle: "Poste: ",
    issued: "Délivrée: ",
    signature: "Signature: ",
    hide: "Fermer"
  }
}

// ----------------

// CONFIGS : 
let language = 'fr'
let backgroundBlurredWhenReadingIdCard = true

// ----------------

let cardInfoDiv = document.getElementById('card-info')
let hideElement = document.getElementById('hide')

function t(key) {
  return translations[language][key]
}

function LoadCardFromData(data) {
  document.getElementById('id-card').classList.remove('hidden')
  cardInfoDiv.innerHTML = ''

  let keys = ['name', 'age', 'job', 'jobTitle', 'issued']

  for (var i = 0; i < keys.length; i++) {
    let key = keys[i]

    if (data[key] && data[key] != '') {
      cardInfoDiv.innerHTML = cardInfoDiv.innerHTML + `<tr class="one-info">
        <td class="info-title">${t(key)}</span>
        <td class="info-content">${data[key]}</span>
      </tr>`
    } else {
      cardInfoDiv.innerHTML = cardInfoDiv.innerHTML + `<tr class="one-info"><td class="info-title">&nbsp;</span><td class="info-content">&nbsp;</span></tr>`
    }
  }

  cardInfoDiv.innerHTML = cardInfoDiv.innerHTML + `<tr><td>${t('signature')}</td><td class="sign">${data['name']}</td></tr>`

  document.getElementById('id-card-generated').innerHTML = `${data['name'].replace(/[^\w]/gi, '').toUpperCase()}${data['id'] ? '-' + data['id'] : ''}`
}

// INITLALIZERS

if (!backgroundBlurredWhenReadingIdCard) {
  document.getElementById('blurred').classList.add('hidden')
}

hideElement.innerHTML = t('hide')

// LISTENERS

hideElement.addEventListener('click', function () {
  if (window.ue) {
    window.ue.game.callevent("HideIdCard", "[]");
  } else {
    console.warn('You can\'t close the ID card viewer in development mode. \n-> In game, window.ue.game.callevent("HideIdCard", "[]") will be triggered')
  }
})

// ONLY FOR DEVELOPMENT MODE

if (!window.ue) {
  document.getElementsByTagName('body')[0].style['background-image'] = 'url(https://playonset.com/images/OnsetCountyDesert.PNG)'
  document.getElementsByTagName('body')[0].style['background-repeat'] = 'no-repeat'
  document.getElementsByTagName('body')[0].style['background-size'] = 'auto 100%'
  document.getElementsByTagName('body')[0].style['background-position'] = 'center top'
  document.getElementsByTagName('body')[0].style['background-attachment'] = 'fixed'

  LoadCardFromData({
    id: 8745,
    name: "John Doe",
    age: "32",
    job: "Police",
    jobTitle: "Officer",
    issued: "23/12/2019"
  })
}
