<template>
  <div class="contacts">
    <contacts-list v-if="$route.name == 'Contacts'"></contacts-list>
    <contact v-if="$route.name == 'Contact' || $route.name == 'NewContact'" :contact="$root.contacts.find(function(contact){ return contact.phone == $route.params.phone_number })"></contact>
  </div>
</template>

<script>
import ContactsList from './ContactsList'
import Contact from './Contact'
export default {
  name: 'contacts',
  components: {
    ContactsList,
    Contact
  }
}
</script>

<style>
/* Base */

.contacts {
  width: 100%;
}

.contacts-container {
  height: 100%;
  display: flex;
  flex-direction: column;
  overflow: auto;
}

/* Contacts */

.contact {
  border-bottom: 1px solid #d8dfe3;
  width: calc(100% - 20px);
  display: flex;
  align-items: center;
  text-decoration: none;
  color: #000;
}

.contact:hover {
  background: #f1f4f6;
}

.contact .preview-message {
  color: #818181;
  font-size: 12px;
  line-height: 12px;
}

.avatar {
  display: inline-block;
  height: 40px;
  width: 40px;
  border-radius: 50%;
  text-align: center;
  line-height: 38px;
  margin-right: 10px;
}
</style>
