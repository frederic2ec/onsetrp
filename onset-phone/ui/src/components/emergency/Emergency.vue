<template>
  <div class="bank padded-container">
    <p style="margin-top: 0">{{ $root.translations.emergency.subtitle }}</p>
    <router-link
      class="emergency-button"
      :to="'/emergency/police'"
    >
      {{ $root.translations.emergency.police }}
    </router-link>
    
    <router-link
      class="emergency-button"
      :to="'/emergency/medic'"
    >
      {{ $root.translations.emergency.medic }}
    </router-link>
  </div>
</template>

<script>
export default {
  name: 'Emergency'
}
</script>

<style>
/* Base */

.emergency-button {
  text-decoration: none;
  color: #333;
  display: block;
  padding: 12px;
  margin: 12px 0 24px 0;
  border: 1px solid #d8dfe3;
  background: #fff;
  border-radius: 6px;
  text-align: center;
  cursor: pointer;
  width: 100%;
  box-sizing: border-box;
}
</style>
