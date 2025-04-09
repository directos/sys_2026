<template>
  <div>
    <h1>Sys</h1>
    <p>You are authenticated!</p>
    <p>{{ currentUser }}</p>
    <p><button @click="logout" class="logout-btn">Logout</button></p>
  </div>
</template>

<script>
import { useStore } from "vuex";
import { computed } from "vue";

export default {
  name: "Sys",
  setup() {
    const store = useStore();

    // Obtén el usuario actual desde Vuex:
    const currentUser = computed(() => store.getters.getUser);

    const logout = () => {
      store.dispatch("logout"); // Actualiza el estado de autenticación en Vuex
    };

    return {
      currentUser,
      logout,
    };
  },
};
</script>

<style>
.logout-btn {
  padding: 10px 20px;
  background-color: #ff4d4d;
  color: white;
  border: none;
  border-radius: 5px;
  cursor: pointer;
}

.logout-btn:hover {
  background-color: #ff1a1a;
}
</style>
