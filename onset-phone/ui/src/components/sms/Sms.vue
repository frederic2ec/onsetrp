<template>
  <div class="sms">
    <conversations v-if="$route.name == 'Conversations'" :conversations="conversations"></conversations>
    <conversation v-if="$route.name == 'Conversation'" :conversation="conversations[$route.params.phone_number]"></conversation>
  </div>
</template>

<script>
import Conversations from './Conversations'
import Conversation from './Conversation'
export default {
  name: 'sms',
  components: {
    Conversations,
    Conversation
  },
  data () {
    return {
      currentConversationWith: null
    }
  },
  props: ['messages'],
  computed: {
    conversations: function () {
      let conversations = {}

      for (var i = 0; i < this.$root.messages.length; i++) {
        let message = this.$root.messages[i]
        let conversationWith = null
        let senderIsMe = message.from == this.$root.currentUserPhone

        conversationWith = senderIsMe ? message.to : message.from

        let contact = this.$root.contacts.filter(contact => contact.phone == conversationWith)[0]

        if (!conversations[conversationWith]) {
          conversations[conversationWith] = {
            phone: conversationWith,
            name: contact ? contact.name : conversationWith,
            messages: []
          }
        }

        conversations[conversationWith].last_message_at = message.created_at
        conversations[conversationWith].messages.push({ id: i, from_me: senderIsMe, content: message.content })
      }

      return conversations
    }
  }
}
</script>

<style>
/* Base */

.sms {
  width: 100%;
}

.conversation-container {
  height: 100%;
  display: flex;
  flex-direction: column;
}

/* Conversations */

.conversation {
  border-bottom: 1px solid #d8dfe3;
  width: calc(100% - 20px);
  display: flex;
  align-items: center;
  text-decoration: none;
  color: #000;
}

.conversation:hover {
  background: #f1f4f6;
}

.conversation .preview-message {
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

/* Conversation */

.conversation-list {
  flex-grow: 1;
  overflow: auto;
}

.message {
  margin: 1px 10px 0px 10px;
  background-color: #f1f0f0;
  width: auto;
  display: inline-block;
  max-width: 70%;
  text-align: left;
}

.message.message-emoji-only {
  padding: 4px 0;
  background-color: transparent!important;
}

.message-emoji-only span {
  height: 40px;
}

.message-emoji-only span svg {
  height: 40px;
  width: 40px;
}

.message-me {
  text-align: right;
}

.message-me .message {
  border-radius: 6px 0 0 6px;
  background-color: #3578e5;
  color: #fff;
}

.message-me div:first-child .message {
  margin-top: 10px;
  border-radius: 6px 6px 0 6px!important;
}

.message-me div:last-child .message {
  border-radius: 6px 0px 6px 6px;
}

.message-target {
  text-align: left;
}

.message-target .message {
  border-radius: 0 6px 6px 0;
}

.message-target div:first-child .message {
  margin-top: 10px;
  border-radius: 6px 6px 6px 0!important;
}

.message-target div:last-child .message {
  border-radius: 0 6px 6px 6px;
}

.emoji {
  height: 20px;
  vertical-align: middle;
  display: inline-block;
}

.conversation-form {
}

.conversation-form input {
  width: calc(100% - 32px);
  padding: 16px;
  border: none;
  border-top: 1px solid #d8dfe3;
  background: #f8f8f8;
  /* border-radius: 6px; */
  font-size: 15px;
  outline: none;
  background: #fff;
}
</style>
