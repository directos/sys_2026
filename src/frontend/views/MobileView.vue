<template>
  <div class="mobile-view">
    <h1>Mobile View</h1>
    <p>{{ mensaje }}</p>

    <!-- Usamos el componente Logout -->
    <Logout />
  </div>
</template>

<script>
import Logout from "@/components/Logout.vue"; // Asegúrate de que la ruta sea correcta

export default {
  name: "MobileView",
  components: {
    Logout, // Registramos el componente
  },
  data() {
    return {
      mensaje: "This is the mobile view component.",
    };
  },
};
</script>

<style scoped>
/* Add styles specific to the mobile view here */
</style>