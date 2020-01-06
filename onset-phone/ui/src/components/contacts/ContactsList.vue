<template>
  <div class="contacts-container">
    <div class="contact my-number padded-container">{{ $root.translations.contacts.me }}{{ this.$root.currentUserPhone.replace('555', '555-') }}</div>
    <div><input ref="contactSearch" type="text" v-model="search" class="contact-search" :placeholder="$root.translations.contacts.search"></div>
    <router-link
      :to="`/contacts/${contact.phone}`"
      class="contact cursor-pointer padded-container"
      v-for="contact in filteredAndSortedContacts"
      v-bind:key="contact.phone"
    >
      <div>
        <span class="avatar" :style="contactStyle(contact.phone)">{{ contact.name[0] }}</span>
      </div>
      <div>
        <b v-search="search">{{ contact.name }}</b>
        <br>
        <span class="preview-message" v-search="search">{{ contact.phone.replace('555', '555-') }}</span>
      </div>
    </router-link>
  </div>
</template>

<script>
export default {
  name: 'contacts-list',
  data () {
    return {
      search: ''
    }
  },
  created () {
    this.search = ''

    this.$nextTick(function () {
      this.$refs.contactSearch.focus()
    })
  },
  methods: {
    contactStyle: function (phone) {
      return {
        'background-color': this.hexToRgba(phone.replace('555', ''), '.3'),
        'color': '#' + phone.replace('555', '')
      }
    },
    hexToRgba: function (hex, opacity) {
      var shorthandRegex = /^#?([a-f\d])([a-f\d])([a-f\d])$/i;
      hex = hex.replace(shorthandRegex, (m, r, g, b) => {
        return r + r + g + g + b + b;
      });

      var result = /^#?([a-f\d]{2})([a-f\d]{2})([a-f\d]{2})$/i.exec(hex);
      return result ? 'rgba(' + parseInt(result[1], 16) + ',' + parseInt(result[2], 16) + ',' + parseInt(result[3], 16) + ',' + opacity + ')' : '';
    }
  },
  directives: {
    search: {
      update: (el, binding) => {
        el.innerHTML = el.innerText.replace(new RegExp(binding.value, 'i'), '<u>' + el.innerText.match(new RegExp(binding.value, 'i')) + '</u>')
      }
    }
  },
  computed: {
    filteredAndSortedContacts: function () {
      let filteredContacts = this.$root.contacts

      filteredContacts.sort((a, b) => {
        return a.name.localeCompare(b.name)
      });

      return filteredContacts.filter((contact) => {
        return contact.name.toLocaleLowerCase().match(new RegExp(this.search, 'i')) || contact.phone.match(this.search)
      });
    }
  }
}
</script>

<style>
  .contact-search {
    width: calc(100% - 32px);
    padding: 10px;
    border: none;
    border-bottom: 1px solid #d8dfe3;
    background: #f8f8f8;
    font-size: 15px;
    outline: none;
    background: #fff;
  }

  .my-number:hover {
    background: #fff;
  }
</style>