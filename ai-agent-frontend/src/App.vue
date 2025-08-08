<template>
  <div id="app">
    <router-view />
  </div>
</template>

<script>
export default {
  name: 'App'
}
</script>

<style>
@import './styles/common.css';

#app {
  min-height: 100vh;
}
</style>
