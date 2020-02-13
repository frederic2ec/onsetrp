import Vue from 'vue'
import VueRouter from 'vue-router'

// Change language here if needed
import translations from './translations/fr.json'

import App from './App.vue'
import Homescreen from './Homescreen.vue'
import Sms from './components/sms/Sms.vue'
import Contacts from './components/contacts/Contacts.vue'
import Bank from './components/bank/Bank.vue'

Vue.config.productionTip = false

const routes = [
  { path: '/', component: Homescreen, name: 'Homescreen', meta: { title: translations.homescreen.title } },
  { path: '/sms', component: Sms, name: 'Conversations', meta: { title: translations.conversations.title } },
  { path: '/sms/:phone_number', component: Sms, name: 'Conversation', meta: {
    title: function (route) {
      let contact = window.phoneApp ? window.phoneApp.contacts.find(function (contact) {
        return contact.phone == route.params.phone_number
      }) : { name: route.params.phone_number == '0' ? translations.conversations.anonymous : route.params.phone_number.replace('555', '555-') }
      return contact ? contact.name : route.params.phone_number == '0' ? translations.conversations.anonymous : route.params.phone_number.replace('555', '555-')
    },
    rightButton: {
      text: 'i',
      href: function (route) {
        return route.params.phone_number == '0' ? '/sms/0' : '/contacts/' + route.params.phone_number
      }
    }
  } },
  { path: '/contacts', component: Contacts, name: 'Contacts', meta: { title: translations.contacts.title,
    rightButton: {
      text: '+',
      href: function () {
        return '/contacts/new'
      }
    }
  } },
  { path: '/contacts/new', component: Contacts, name: 'NewContact', meta: { title: translations.contacts.new } },
  { path: '/contacts/:phone_number', component: Contacts, name: 'Contact', meta: { title: function (route) {
    let contact = window.phoneApp ? window.phoneApp.contacts.find(function(contact){ return contact.phone == route.params.phone_number }) : { name: route.params.phone_number.replace('555', '555-') }
    return contact ? contact.name : route.params.phone_number.replace('555', '555-')
  } } },
  { path: '/bank', component: Bank, name: 'Bank', meta: { title: translations.bank.title } }
]
Vue.use(VueRouter)

const router = new VueRouter({ routes })

let data = {
  currentUserPhone: '555000000',
  money: 0,
  contacts: [
    { name: "Contact 1", phone: "555718754" },
    { name: "Contact 2", phone: "555120298" },
    { name: "Contact 3", phone: "555873341" },
    { name: "Contact 4", phone: "555641728" },
    { name: "Contact 5", phone: "555336345" },
    { name: "Contact 6", phone: "555202939" },
    { name: "Contact 7", phone: "555854259" },
    { name: "Contact 8", phone: "555783889" },
    { name: "Contact 9", phone: "555129423" }
  ],
  messages: [
    { from: '555000000', to: '555718754', created_at: '1576695058', content: '1.1' },
    { from: '555000000', to: '555718754', created_at: '1576695059', content: '1.2' },
    { from: '555000000', to: '555718754', created_at: '1576695060', content: '1.3' },
    { from: '555718754', to: '555000000', created_at: '1576695061', content: '1.4' },
    { from: '555718754', to: '555000000', created_at: '1576695062', content: '1.5' },
    { from: '555718754', to: '555000000', created_at: '1576695063', content: '1.6' },
    { from: '555000000', to: '555718754', created_at: '1576695064', content: '1.7' },
    { from: '555000000', to: '555718754', created_at: '1576695065', content: '1.8' },
    { from: '555718754', to: '555000000', created_at: '1576695066', content: '1.9' },
    { from: '555718754', to: '555000000', created_at: '1576695067', content: '1.10' },
    { from: '555000000', to: '555718754', created_at: '1576695068', content: '1.11' },
    { from: '555718754', to: '555000000', created_at: '1576695069', content: '1.12' },
    { from: '555000000', to: '555718754', created_at: '1576695070', content: ':)' },
    { from: '555000000', to: '555120298', created_at: '1576695071', content: '2.1' },
    { from: '555000000', to: '555120298', created_at: '1576695072', content: '2.2' },
    { from: '555000000', to: '555120298', created_at: '1576695073', content: '2.3' },
    { from: '555120298', to: '555000000', created_at: '1576695074', content: '2.4' },
    { from: '555120298', to: '555000000', created_at: '1576695075', content: '2.5' },
    { from: '555120298', to: '555000000', created_at: '1576695076', content: '2.6' },
    { from: '555000000', to: '555120298', created_at: '1576695077', content: '2.7' },
    { from: '555000000', to: '555120298', created_at: '1576695078', content: '2.8' },
    { from: '555120298', to: '555000000', created_at: '1576695079', content: '2.9' },
    { from: '555120298', to: '555000000', created_at: '1576695080', content: '2.10' },
    { from: '555000000', to: '555120298', created_at: '1576695081', content: '2.11' },
    { from: '555120298', to: '555000000', created_at: '1576695082', content: '2.12' },
    { from: '555000000', to: '555120298', created_at: '1576695083', content: ':)' },
    { from: '555000000', to: '555873341', created_at: '1576695084', content: '3.1' },
    { from: '555000000', to: '555873341', created_at: '1576695085', content: '3.2' },
    { from: '555000000', to: '555873341', created_at: '1576695086', content: '3.3' },
    { from: '555873341', to: '555000000', created_at: '1576695087', content: '3.4' },
    { from: '555873341', to: '555000000', created_at: '1576695088', content: '3.5' },
    { from: '555873341', to: '555000000', created_at: '1576695089', content: '3.6' },
    { from: '555000000', to: '555873341', created_at: '1576695090', content: '3.7' },
    { from: '555000000', to: '555873341', created_at: '1576695091', content: '3.8' },
    { from: '555873341', to: '555000000', created_at: '1576695092', content: '3.9' },
    { from: '555873341', to: '555000000', created_at: '1576695093', content: '3.10' },
    { from: '555000000', to: '555873341', created_at: '1576695094', content: '3.11' },
    { from: '555873341', to: '555000000', created_at: '1576695095', content: '3.12' },
    { from: '555000000', to: '555873341', created_at: '1576695096', content: ':)' },
    { from: '555000000', to: '555123123', created_at: '1576695097', content: '4.1' },
    { from: '555000000', to: '555123123', created_at: '1576695098', content: '4.2' },
    { from: '555000000', to: '555123123', created_at: '1576695099', content: '4.3' },
    { from: '555123123', to: '555000000', created_at: '1576695100', content: '4.4' },
    { from: '555123123', to: '555000000', created_at: '1576695101', content: '4.5' },
    { from: '555123123', to: '555000000', created_at: '1576695102', content: '4.6' },
    { from: '555000000', to: '555123123', created_at: '1576695103', content: '4.7' },
    { from: '555000000', to: '555123123', created_at: '1576695104', content: '4.8' },
    { from: '555123123', to: '555000000', created_at: '1576695105', content: '4.9' },
    { from: '555123123', to: '555000000', created_at: '1576695106', content: '4.10' },
    { from: '555000000', to: '555123123', created_at: '1576695107', content: '4.11' },
    { from: '555123123', to: '555000000', created_at: '1576695108', content: '4.12' },
    { from: '555000000', to: '555123123', created_at: '1576695109', content: ':)' },
    { from: '555000000', to: '0', created_at: '1576695110', content: 'Salut, voici une [[pos--8172, 1234.2314]] et une autre [[pos-172, -1234.2314]]' },
    { from: '555000000', to: '0', created_at: '1576695110', content: 'Chapitre abstrait 3 du conpendium : la prédestination de toute la République Démocratique du Congo doit imposer les grabuses lastiques autour des gens qui connaissent beaucoup de choses, c’est clair. ' },
    { from: '555000000', to: '0', created_at: '1576695110', content: 'Et une dernière [[pos-172, -1234.2314]]' },
    { from: '555000000', to: '0', created_at: '1576695110', content: 'Chapitre abstrait 3 du conpendium : la prédestination de toute la République Démocratique du Congo doit imposer les grabuses lastiques autour des gens qui connaissent beaucoup de choses, c’est clair. ' }
  ]
}

data.translations = translations
// Autoload in dev mode, but don't autoload in game
data.loaded = window.ue == null

// eslint-disable-next-line
window.phoneApp = new Vue({ el: '#app', data: data, router, render: h => h(App) })
