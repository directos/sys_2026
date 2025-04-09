<template>
  <div class="desktop-view">
    <h1>Desktop View</h1>
    <p>{{ mensaje }}</p>
    
    <!-- Usamos el componente Logout -->
    <Logout />
  </div>
</template>

<script>
import Logout from "@/components/Logout.vue"; // Asegúrate de que la ruta sea correcta

export default {
  name: "DesktopView",
  components: {
    Logout, // Registramos el componente
  },
  data() {
    return {
      mensaje: "This is the desktop view component.",
    };
  },
};
</script>

<style scoped>
/* Add styles specific to the desktop view here */
</style>