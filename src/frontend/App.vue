<template>
  <div id="app">
    <component :is="currentComponent" />
  </div>
</template>

<script>
import { computed } from 'vue';
import { useStore } from 'vuex';
import LoginForm from './components/LoginForm.vue';
import Home from './components/Home.vue';

export default {
  name: 'App',
  components: {
    LoginForm,
    Home,
  },
  setup() {
    const store = useStore();
    const currentComponent = computed(() =>
      store.getters.isAuthenticated ? 'Home' : 'LoginForm'
    );

    return {
      currentComponent,
    };
  },
};
</script>

<style>
/* Add global styles here if needed */
</style>
