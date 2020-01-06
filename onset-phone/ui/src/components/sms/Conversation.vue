<template>
  <div class="conversation-container">
    <div ref="conversationList" class="conversation-list padded-container">
      <div
        v-for="(conversationPart, index) in conversationParts"
        v-bind:key="index"
        v-bind:class="{ 'message-me': conversationPart.from_me, 'message-target': !conversationPart.from_me }"
      >
        <div
          v-for="(message, messageIndex) in conversationPart.messages"
          v-bind:key="index + '-' + messageIndex"
        >
          <div v-emoji class="message padded-container">
            {{ message.content }}
          </div>
        </div>
      </div>
    </div>
    <form @submit.prevent="sendMessage" class="conversation-form">
      <input ref="conversationInput" :placeholder="$root.translations.conversations.message_placeholder" class="conversation-input" type="text" v-model="text">
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
    this.$refs.conversationInput.focus()

    this.$nextTick(function () {
      this.$refs.conversationList.scrollTop = this.$refs.conversationList.scrollHeight;
    })
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
          console.log('-> window.ue.game.callevent("MessageCreated", ' + JSON.stringify([newMessage.to, newMessage.content]) + ')')
        }
      }
    }
  }
}
</script>
