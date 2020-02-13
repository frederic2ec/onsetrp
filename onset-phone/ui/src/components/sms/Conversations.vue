<template>
  <div class="conversations-container">
    <router-link
      :to="`/sms/${conversation[0]}`"
      class="conversation cursor-pointer padded-container"
      v-for="conversation in sortedConversations"
      v-bind:key="conversation[0]">
      <div>
        <span class="avatar" v-if="conversation[1].name == conversation[0]" :style="conversationStyle(conversation[0])">?</span>
        <span class="avatar" v-else :style="conversationStyle(conversation[0])">{{ conversation[1].name[0] }}</span>
      </div>
      <div>
        <b v-if="conversation[1].name != '0'">{{ conversation[1].name.replace('555', '555-') }}</b>
        <b v-else>{{ $root.translations.conversations.anonymous }}</b>
        <br>
        <span v-gps class="preview-message">{{ conversation[1].messages[conversation[1].messages.length - 1].content }}</span>
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
  },
  directives: {
    gps: {
      inserted: function (el) {
        if (el.innerHTML.match(/\[\[pos-(\S+),\s?(\S+)\]\]/gi)) {
          el.innerHTML = el.innerHTML.replace(/\[\[pos-(\S+),\s?(\S+)\]\]/gi, function () {
            return `<span class="gps-pos">GPS</span>`
          })
        }
      }
    }
  }
}
</script>

<style>
  .preview-message {
    white-space: nowrap;
    overflow: hidden;
    text-overflow: ellipsis;
    width: 210px;
    display: inline-block;
  }

  .preview-message .gps-pos {
    font-size: 12px!important;
    padding: 0px 2px;
    border: 1px solid #d8dfe3;
    border-radius: 4px;
    white-space: nowrap;
  }
</style>
