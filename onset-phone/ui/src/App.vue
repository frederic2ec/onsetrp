<template>
  <div class="smartphone">
    <!-- Header with Title and Back -->
    <div v-if="$route.name != 'Homescreen'" class="header">
      <span class="cursor-pointer" @click="$router.back()">
        <svg xmlns="http://www.w3.org/2000/svg" width="14" height="20px" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" class="feather feather-arrow-left" style="display: inherit;margin-right: 10px;"><line x1="19" y1="12" x2="5" y2="12"></line><polyline points="12 19 5 12 12 5"></polyline></svg>
      </span>
      {{ typeof $route.meta.title == 'function' ? $route.meta.title($route) : $route.meta.title }}
      <router-link v-if="$route.meta.rightButton" :to="$route.meta.rightButton.href($route)">
        {{ $route.meta.rightButton.text }}
      </router-link>
    </div>

    <div v-bind:class="{ 'full-body': $route.name == 'Homescreen' }" class="body">
      <!-- Apps -->
      <router-view v-if="$root.loaded"></router-view>
      <div v-else class="lds-dual-ring"></div>
    </div>
    <router-link to="/" class="home-button"></router-link >
  </div>
</template>

<script>
export default {
  name: 'app',
}
</script>

<style>
@import url('https://fonts.googleapis.com/css?family=Open+Sans&display=swap');

* {
  font-size: 15px;
  font-family: 'Open Sans', sans-serif;
  -webkit-animation: fadein .2s; /* Safari, Chrome and Opera > 12.1 */
     -moz-animation: fadein .2s; /* Firefox < 16 */
      -ms-animation: fadein .2s; /* Internet Explorer */
       -o-animation: fadein .2s; /* Opera < 12.1 */
          animation: fadein .2s;
}

.header {
  display: flex;
  border-bottom: 1px solid #d8dfe3;
  background: #f1f4f6;
  padding: 10px;
}

.header a {
  width: 18px;
  height: 18px;
  text-align: center;
  border: 1px solid #818181;
  font-size: 14px;
  border-radius: 50%;
  margin-left: auto;
  color: #000000;
  text-decoration: none;
  line-height: 18px;
}

.body {
  display: flex;
  background: #fff;
  flex-grow: 1;
  /* 41px = header height */
  max-height: calc(100% - 41px);
}

.body.full-body {
  max-height: 100%;
  background-color: #ffffff;
  background-image: url("data:image/svg+xml,%3Csvg width='180' height='180' viewBox='0 0 180 180' xmlns='http://www.w3.org/2000/svg'%3E%3Cpath d='M81.28 88H68.413l19.298 19.298L81.28 88zm2.107 0h13.226L90 107.838 83.387 88zm15.334 0h12.866l-19.298 19.298L98.72 88zm-32.927-2.207L73.586 78h32.827l.5.5 7.294 7.293L115.414 87l-24.707 24.707-.707.707L64.586 87l1.207-1.207zm2.62.207L74 80.414 79.586 86H68.414zm16 0L90 80.414 95.586 86H84.414zm16 0L106 80.414 111.586 86h-11.172zm-8-6h11.173L98 85.586 92.414 80zM82 85.586L87.586 80H76.414L82 85.586zM17.414 0L.707 16.707 0 17.414V0h17.414zM4.28 0L0 12.838V0h4.28zm10.306 0L2.288 12.298 6.388 0h8.198zM180 17.414L162.586 0H180v17.414zM165.414 0l12.298 12.298L173.612 0h-8.198zM180 12.838L175.72 0H180v12.838zM0 163h16.413l.5.5 7.294 7.293L25.414 172l-8 8H0v-17zm0 10h6.613l-2.334 7H0v-7zm14.586 7l7-7H8.72l-2.333 7h8.2zM0 165.414L5.586 171H0v-5.586zM10.414 171L16 165.414 21.586 171H10.414zm-8-6h11.172L8 170.586 2.414 165zM180 163h-16.413l-7.794 7.793-1.207 1.207 8 8H180v-17zm-14.586 17l-7-7h12.865l2.333 7h-8.2zM180 173h-6.613l2.334 7H180v-7zm-21.586-2l5.586-5.586 5.586 5.586h-11.172zM180 165.414L174.414 171H180v-5.586zm-8 5.172l5.586-5.586h-11.172l5.586 5.586zM152.933 25.653l1.414 1.414-33.94 33.942-1.416-1.416 33.943-33.94zm1.414 127.28l-1.414 1.414-33.942-33.94 1.416-1.416 33.94 33.943zm-127.28 1.414l-1.414-1.414 33.94-33.942 1.416 1.416-33.943 33.94zm-1.414-127.28l1.414-1.414 33.942 33.94-1.416 1.416-33.94-33.943zM0 85c2.21 0 4 1.79 4 4s-1.79 4-4 4v-8zm180 0c-2.21 0-4 1.79-4 4s1.79 4 4 4v-8zM94 0c0 2.21-1.79 4-4 4s-4-1.79-4-4h8zm0 180c0-2.21-1.79-4-4-4s-4 1.79-4 4h8z' fill='%23e67e22' fill-opacity='0.18' fill-rule='evenodd'/%3E%3C/svg%3E");
}

/* Utils */

.padded-container {
  padding: 10px;
}

.cursor-pointer {
  cursor: pointer;
}

/* PHONE DESIGN */

.smartphone {
  position: absolute;
  bottom: 20px;
  left: 20px;
  width: 280px;
  height: 498px;
  margin: auto;
  border: 16px black solid;
  border-top-width: 60px;
  border-bottom-width: 60px;
  border-radius: 36px;
  display: flex;
  flex-direction: column;
  background: #ffffff;
}

/* The horizontal line on the top of the device */
.smartphone:before {
  content: '';
  display: block;
  width: 60px;
  height: 5px;
  position: absolute;
  top: -30px;
  left: 50%;
  transform: translate(-50%, -50%);
  background: #333;
  border-radius: 10px;
}

/* The circle on the bottom of the device */
.smartphone .home-button {
  content: '';
  display: block;
  width: 35px;
  height: 35px;
  position: absolute;
  left: 50%;
  bottom: -65px;
  transform: translate(-50%, -50%);
  background: #333;
  border-radius: 50%;
}

/* The screen (or content) of the device */
.smartphone .phone {
  width: 280px;
  height: 498px;
  background: white;
}

/* LOADER */

.lds-dual-ring {
  display: inline-block;
  width: 80px;
  height: 80px;
  margin-left: calc(50% - 44px);
  margin-top: 50%;
}

.lds-dual-ring:after {
  content: " ";
  display: block;
  width: 64px;
  height: 64px;
  margin: 8px;
  border-radius: 50%;
  border: 6px solid #3578e5;
  border-color: #3578e5 transparent #3578e5 transparent;
  animation: lds-dual-ring 1.2s linear infinite;
}

@keyframes lds-dual-ring {
  0% {
    transform: rotate(0deg);
  }
  100% {
    transform: rotate(360deg);
  }
}

@keyframes fadein {
    from { opacity: 0; }
    to   { opacity: 1; }
}

/* Firefox < 16 */
@-moz-keyframes fadein {
    from { opacity: 0; }
    to   { opacity: 1; }
}

/* Safari, Chrome and Opera > 12.1 */
@-webkit-keyframes fadein {
    from { opacity: 0; }
    to   { opacity: 1; }
}

/* Internet Explorer */
@-ms-keyframes fadein {
    from { opacity: 0; }
    to   { opacity: 1; }
}

/* Opera < 12.1 */
@-o-keyframes fadein {
    from { opacity: 0; }
    to   { opacity: 1; }
}
</style>
