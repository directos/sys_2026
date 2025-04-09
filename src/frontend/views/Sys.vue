<template>
  <div>
    <component :is="currentView" />
  </div>
</template>

<script>
import { defineAsyncComponent } from "vue";

let vista = "desktop"; // Cambia esto a "mobile" o "desktop" según sea necesario
if (window.innerWidth < 768) {
  vista = "mobile";
}

console.log("Screen:", window.innerWidth); // Para depuración
console.log("Vista:", vista); // Para depuración

export default {
  name: "Sys",
  components: {
    // Lazy load de las vistas:
    DesktopView: defineAsyncComponent(() => import("@/views/DesktopView.vue")),
    MobileView:  defineAsyncComponent(() => import("@/views/MobileView.vue")),
  },
  data() {
    return {
      currentView: vista === "desktop" ? "DesktopView" : "MobileView",
    };
  },
};
</script>

<style>
  /* Estilos globales para el componente Sys */
</style>
