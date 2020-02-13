<template>
  <div class="conversation-container">
    <div ref="conversationList" class="conversation-list padded-container">
      <div
        v-for="(conversationPart, index) in conversationParts"
        v-bind:key="index"
        v-bind:class="{ 'message-me': conversationPart.from_me, 'message-target': !conversationPart.from_me }">
        <div
          v-for="(message, messageIndex) in conversationPart.messages"
          v-bind:key="index + '-' + messageIndex">
          <div v-gps v-emoji class="message padded-container">
            {{ message.content }}
          </div>
        </div>
      </div>
    </div>
    <form v-if="conversation.name != '0'" @submit.prevent="sendMessage" class="conversation-form">
      <input
        ref="conversationInput"
        :placeholder="$root.translations.conversations.message_placeholder"
        class="conversation-input"
        type="text"
        v-model="text">
    </form>
  </div>
</template>

<script>
import emojiList from './emoji.json'
export default {
  name: 'conversation',
  data () {
    return {
      text: '',
    }
  },
  props: ['conversation'],
  mounted () {
    if (this.$refs.conversationInput) {
      this.$refs.conversationInput.focus()
    }

    this.$nextTick(function () {
      this.$refs.conversationList.scrollTop = this.$refs.conversationList.scrollHeight;
    })

    let gpsButtons = document.querySelectorAll('.gps-pos')

    for (let i = 0; i < gpsButtons.length; i++) {
      gpsButtons[i].addEventListener('click', (e) => {
        e.preventDefault();

        let latitude = e.currentTarget.dataset.latitude
        let longitude = e.currentTarget.dataset.longitude

        if (window.ue) {
          window.ue.game.callevent("MessageGPSClicked", JSON.stringify([latitude, longitude]));
        } else {
          // eslint-disable-next-line
          console.log('-> ue.game.callevent("MessageGPSClicked", ' + JSON.stringify([latitude, longitude]) + ')')
        }
      })
    }
  },
  computed: {
    conversationParts: function () {
      let parts = []
      let lastFromMe = null;

      if (this.conversation) {
        for (var i = 0; i < this.conversation.messages.length; i++) {
          let message = this.conversation.messages[i]

          if (lastFromMe === message.from_me) {
            parts[parts.length - 1].messages.push(message)
          } else {
            lastFromMe = message.from_me
            parts.push({ from_me: message.from_me, messages: [message] })
          }
        }
      } else {
        parts = []
      }

      return parts
    }
  },
  directives: {
    emoji: {
      inserted: function (el) {
        for (let emoji in emojiList) {
          if (el.innerHTML.trim() == emoji) {
            el.classList.add('message-emoji-only')
          }

          el.innerHTML = el.innerHTML.replace(new RegExp(emoji.replace(/[.*+?^${}()|[\]\\]/g, '\\$&'), 'gm'), '<span class="emoji">' + emojiList[emoji] + '</span>')
        }
      }
    },
    gps: {
      inserted: function (el, binding, vnode) {
        if (el.innerHTML.match(/\[\[pos-(\S+),\s?(\S+)\]\]/gi)) {
          el.innerHTML = el.innerHTML.replace(/\[\[pos-(\S+),\s?(\S+)\]\]/gi, function (_, b, c) {
            return `<span data-latitude="${b}" data-longitude="${c}" class="gps-pos cursor-pointer">${vnode.context.$root.translations.conversations.gps}</span>`
          })
        }
      }
    }
  },
  watch: {
    conversationParts: function () {
      this.$nextTick(function () {
        this.$refs.conversationList.scrollTop = this.$refs.conversationList.scrollHeight;
      })
    }
  },
  methods: {
    sendMessage () {
      if (this.text != '') {
        let newMessage = {
          from: this.$root.currentUserPhone,
          to: this.$route.params.phone_number,
          created_at: Math.floor(new Date().getTime() / 1000),
          content: this.text
        }

        this.$root.messages.push(newMessage)

        this.text = ''

        if (window.ue) {
          window.ue.game.callevent("MessageCreated", JSON.stringify([newMessage.to, newMessage.content]));
        } else {
          // eslint-disable-next-line
          console.log('-> ue.game.callevent("MessageCreated", ' + JSON.stringify([newMessage.to, newMessage.content]) + ')')
        }
      }
    }
  }
}
</script>

<style>
  .message .gps-pos {
    padding: 5px 0;
    border: 1px solid #d8dfe3;
    border-radius: 4px;
    white-space: nowrap;
    display: inline-block;
    width: 100%;
    text-align: center;
    margin-top: 6px;
  }
</style>
