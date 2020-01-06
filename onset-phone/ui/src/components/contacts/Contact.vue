<template>
  <div>
    <div class="error padded-container" v-if="error">{{ error }}</div>
    <form @submit.prevent="saveContact" class="contacts padded-container">
      <label for="contact_name">{{ $root.translations.contacts.name }}</label>
      <input class="input" id="contact_name" ref="contactName" v-model="contactName" :placeholder="$root.translations.contacts.name_placeholder" type="text" name="">

      <label for="contact_phone">{{ $root.translations.contacts.phone }}</label>
      <input :readonly="!contact.isNew" class="input" id="contact_phone" ref="contactPhone" autofocus v-model="contactPhone" :placeholder="$root.translations.contacts.phone_placeholder" type="text" name="">

      <input class="input contact-button green-text" type="submit" name="" :value="$root.translations.contacts[contact.isNew ? 'new' : 'save']">
    </form>
    <div v-if="!contact.isNew" class="padded-container">
      <div v-if="removing" class="padded-container">
        <span>
          {{ $root.translations.contacts.are_you_sure }}&nbsp;&nbsp;
        </span>
        <span @click="removeContact()" class="green-text">
          {{ $root.translations.contacts.yes }}
        </span>
        <span>
          &nbsp;&nbsp;-&nbsp;&nbsp;
        </span>
        <span @click="removing = false" class="red-text">
          {{ $root.translations.contacts.no }}
        </span>
      </div>
      <div v-else @click="removing = true" class="input contact-button red-text">
        {{ $root.translations.contacts.delete }}
      </div>
    </div>
    <div v-if="!contact.isNew" class="padded-container">
      <router-link
        class="input contact-button"
        :to="'/sms/' + contact.phone"
      >
        {{ $root.translations.contacts.message }}
      </router-link>
    </div>
  </div>
</template>

<script>
export default {
  name: 'contact',
  data () {
    return {
      error: null,
      contactName: '',
      contactPhone: '',
      removing: false
    }
  },
  props: {
    contact: {
      default: function () {
        return {
          name: '',
          phone: '',
          isNew: true
        }
      }
    }
  },
  created () {
    this.contactPhone = this.contact.phone
    this.contactName = this.contact.name

    if (this.contactPhone == '' && this.$route.params.phone_number != 'new') {
      this.contactPhone = this.$route.params.phone_number
    }

    this.$nextTick(function () {
      this.$refs.contactName.focus()
    })
  },
  methods: {
    saveContact: function () {
      this.error = null
      // Empty contact name
      if (this.contactName == '') {
        this.error = this.$root.translations.contacts.errors.no_name
        this.$refs.contactName.focus()
      } else {
        // Malformated contact phone number
        if (this.contactPhone && this.contactPhone.match(/555-?(\d{6})$/)) {
          this.contactPhone = this.contactPhone.replace('555-', '555')

          if (this.contact.isNew) {
            // Already existing contact with this phone number
            let existing = this.$root.contacts.find((contact) => { return contact.phone == this.contactPhone })
            if (existing) {
              this.error = this.$root.translations.contacts.errors.existing + existing.name
              this.$refs.contactPhone.focus()
            } else {
              // Create contact
              this.$root.contacts.unshift({
                name: this.contactName,
                phone: this.contactPhone
              })

              if (window.ue) {
                window.ue.game.callevent("ContactCreated", JSON.stringify([this.contactName,  this.contactPhone]));
              } else {
                // eslint-disable-next-line
                console.log('-> window.ue.game.callevent("ContactCreated", ' + JSON.stringify([this.contactName,  this.contactPhone]) + ')')
              }

              this.$router.push('/contacts')
            }
          } else {
            // Update contact
            this.contact.phone = this.contactPhone
            this.contact.name = this.contactName

            if (window.ue) {
              window.ue.game.callevent("ContactUpdated", JSON.stringify([this.contactName,  this.contactPhone]));
            } else {
              // eslint-disable-next-line
              console.log('-> window.ue.game.callevent("ContactCreated", ' + JSON.stringify([this.contactName,  this.contactPhone]) + ')')
            }

            this.$router.push('/contacts')
          }

        } else {
          this.error = this.$root.translations.contacts.errors.no_phone
          this.$refs.contactPhone.focus()
        }
      }
    }
  }
}
</script>

<style>
  .contacts .input {
    width: calc(100% - 42px);
    border: 1px solid #d8dfe3;
    background: #f1f4f6;
    padding: 10px;
    margin: 10px 0;
    border-radius: 6px;
    outline: none;
  }

  .contacts .input.contact-button {
    width: calc(100% - 20px);
    color: #000000;
    text-decoration: none;
    display: inline-block;
    text-align: center;
    cursor: pointer;
  }

  .error {
    color: red;
  }

  input[readonly] {
    cursor: no-drop;
  }

  .red-text {
    color: #c0392b!important;
  }

  .green-text {
    color: #27ae60!important;
  }
</style>
