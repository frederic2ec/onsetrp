<template>
  <div class="bank padded-container">
    <form @submit.prevent="call" action="">
        <p style="margin-top: 0">{{ $root.translations.emergency[$route.params.service] }}</p>
        <label for="reason">{{ $root.translations.emergency.reason }}</label>
        <textarea autofocus name="reason" id="reason" rows="10" v-model="callReason"></textarea>
        <input class="emergency-button green-text" type="submit" name="" :value="$root.translations.emergency.submit">
    </form>
  </div>
</template>

<script>
export default {
    name: 'Call',
    data () {
        return {
            callReason: ''
        }
    },
    methods: {
        call: function (e) {
            e.preventDefault()
            if (window.ue) {
                window.ue.game.callevent("callouts:new", JSON.stringify([this.$route.params.service,  this.callReason]));
            } else {
                // eslint-disable-next-line
                console.log('-> window.ue.game.callevent("callouts:new", ' + JSON.stringify([this.$route.params.service,  this.callReason]) + ')')
            }
            this.$router.push('/emergency')
        }
    }
}
</script>

<style>
/* Base */

textarea {
    padding: 12px;
    margin: 12px 0 24px 0;
    border: 1px solid #d8dfe3;
    border-radius: 6px;
    width: 100%;
    box-sizing: border-box;
}
</style>
