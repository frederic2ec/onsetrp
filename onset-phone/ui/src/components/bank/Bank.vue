<template>
  <div class="bank padded-container">
    <div class="balance">
      <span class="desc">{{ $root.translations.bank.balance }}</span>
      <br>
      <span v-bind:class="{ negative: $root.money < 0 }" class="money">${{ $root.money.toLocaleString('en-US') }}</span>
    </div>
    <div class="menu-btn menu-btn-first">
      <svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="#3498db" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" class="feather feather-trending-up"><polyline points="23 6 13.5 15.5 8.5 10.5 1 18"></polyline><polyline points="17 6 23 6 23 12"></polyline></svg>
      <p class="first-p">{{ $root.translations.bank.history }}</p>
      <p>{{ $root.translations.bank.comingsoon }}</p>
    </div>
    <div class="menu-btn">
      <svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="#9b59b6" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" class="feather feather-shopping-cart"><circle cx="9" cy="21" r="1"></circle><circle cx="20" cy="21" r="1"></circle><path d="M1 1h4l2.68 13.39a2 2 0 0 0 2 1.61h9.72a2 2 0 0 0 2-1.61L23 6H6"></path></svg>
      <p class="first-p">{{ $root.translations.bank.loan }}</p>
      <p>{{ $root.translations.bank.comingsoon }}</p>
    </div>
    <div class="menu-btn menu-btn-first">
      <svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="#1abc9c" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" class="feather feather-users"><path d="M17 21v-2a4 4 0 0 0-4-4H5a4 4 0 0 0-4 4v2"></path><circle cx="9" cy="7" r="4"></circle><path d="M23 21v-2a4 4 0 0 0-3-3.87"></path><path d="M16 3.13a4 4 0 0 1 0 7.75"></path></svg>
      <p class="first-p">{{ $root.translations.bank.sendmoney }}</p>
      <p>{{ $root.translations.bank.comingsoon }}</p>
    </div>
    <div class="menu-btn">
      <svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="#e67e22" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" class="feather feather-file-text"><path d="M14 2H6a2 2 0 0 0-2 2v16a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V8z"></path><polyline points="14 2 14 8 20 8"></polyline><line x1="16" y1="13" x2="8" y2="13"></line><line x1="16" y1="17" x2="8" y2="17"></line><polyline points="10 9 9 9 8 9"></polyline></svg>
      <p class="first-p">{{ $root.translations.bank.bills }}</p>
      <p>{{ $root.translations.bank.comingsoon }}</p>
    </div>
  </div>
</template>

<script>
export default {
  name: 'Bank'
}
</script>

<style>
/* Base */

.bank {
  width: 100%;
}

.balance {
  padding: 17.5px 22.5px;
  box-shadow: 0 10px 50px rgba(179, 179, 179, 0.25);
  margin-bottom: 20px;
}

.balance .money {
  font-size: 22.5px;
  letter-spacing: 2px;
  font-weight: bold;
  color: #2ecc71;
}

.balance .money.negative {
  color: #e74c3c;
}

.balance .desc {
  font-size: 15px;
  color: #ACACAC;
}

.menu-btn-first {
  margin-right: 20px;
}

.menu-btn {
  width: 100px;
  padding: 22.5px 10px 10px 10px;
  -webkit-box-shadow: 0 10px 50px rgba(179, 179, 179, 0.25);
  box-shadow: 0 10px 50px rgba(179, 179, 179, 0.25);
  float: left;
  margin-bottom: 20px;
}

.menu-btn p {
  font-size: 12.5px;
  color: #ACACAC;
  position: relative;
}

.menu-btn p.first-p {
  margin-top: 0;
}
</style>
