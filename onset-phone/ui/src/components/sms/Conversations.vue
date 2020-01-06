<template>
  <div class="conversations-container">
    <router-link
      :to="`/sms/${conversation[0]}`"
      class="conversation cursor-pointer padded-container"
      v-for="conversation in sortedConversations"
      v-bind:key="conversation[0]"
    >
      <div>
        <span class="avatar" v-if="conversation[1].name == conversation[0]" :style="conversationStyle(conversation[0])">?</span>
        <span class="avatar" v-else :style="conversationStyle(conversation[0])">{{ conversation[1].name[0] }}</span>
      </div>
      <div>
        <b>{{ conversation[1].name.replace('555', '555-') }}</b>
        <br>
        <span class="preview-message">{{ conversation[1].messages[conversation[1].messages.length - 1].content }}</span>
      </div>
    </router-link>
  </div>
</template>

<script>
export default {
  name: 'conversations',
  props: ['conversations'],
  computed: {
    sortedConversations: function() {
      let sortable = [];

      for (let phoneNumber in this.conversations) {
        sortable.push([phoneNumber, this.conversations[phoneNumber]]);
      }

      return sortable.sort(function(a, b) {
        return parseInt(b[1].last_message_at) - parseInt(a[1].last_message_at);
      });
    }
  },
  methods: {
    goToConversation: function (phoneNumber) {
      this.$parent.currentConversationWith = phoneNumber
      this.$root.goTo('sms', 'conversation', this.conversations[phoneNumber].name.replace('555', '555-'))
    },
    conversationStyle: function (phoneNumber) {
      return {
        'background-color': this.hexToRgba(phoneNumber.replace('555', ''), '.3'),
        'color': '#' + phoneNumber.replace('555', '')
      }
    },
    hexToRgba: function (hex, opacity) {
      var shorthandRegex = /^#?([a-f\d])([a-f\d])([a-f\d])$/i;
      hex = hex.replace(shorthandRegex, function(m, r, g, b) {
        return r + r + g + g + b + b;
      });

      var result = /^#?([a-f\d]{2})([a-f\d]{2})([a-f\d]{2})$/i.exec(hex);
      return result ? 'rgba(' + parseInt(result[1], 16) + ',' + parseInt(result[2], 16) + ',' + parseInt(result[3], 16) + ',' + opacity + ')' : '';
    }
  }
}
</script>
