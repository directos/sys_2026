<template>
  <div id="app">
    <component :is="currentComponent" />
  </div>
</template>

<script>
import { computed } from 'vue';
import { useStore } from 'vuex';
import LoginForm from '@/components/LoginForm.vue';
import Sys from '@/views/Sys.vue';

export default {
  name: 'App',
  components: {
    LoginForm,
    Sys,
  },
  setup() {
    const store = useStore();
    const currentComponent = computed(() =>
      store.getters.isAuthenticated ? 'Sys' : 'LoginForm'
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
