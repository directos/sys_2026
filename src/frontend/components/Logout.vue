<template>
  <br />
  <a href="#" @click.prevent="handleLogout">Logout</a>
</template>

<script>
import { useStore } from "vuex";

export default {
  name: "Logout",
  setup() {
    const store = useStore();

    const handleLogout = () => {
      store.dispatch("logout"); // Ejecuta la acción de logout en Vuex
    };

    return {
      handleLogout,
    };
  },
};
</script>

<style scoped>
a {
  color: #007bff;
  text-decoration: none;
  cursor: pointer;
}

a:hover {
  text-decoration: underline;
}
</style>