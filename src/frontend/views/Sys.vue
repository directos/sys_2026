<template>
  <div>
    <component :is="currentView" />
  </div>
</template>

<script>
import { defineAsyncComponent } from "vue";
import store from "@/store";

export default {
  name: "Sys",
  components: {
    // Lazy load de las vistas:
    DesktopView: defineAsyncComponent(() => import("@/views/DesktopView.vue")),
    MobileView:  defineAsyncComponent(() => import("@/views/MobileView.vue")),
    LiteView:    defineAsyncComponent(() => import("@/views/LiteView.vue")),
  },
  data() {
    return {
      currentView: this.getCurrentView(),
    };
  },
  methods: {
    getCurrentView() {
      const vista = store.getters.getVista; // Leer el valor de 'vista' desde el store
      if (vista === "desktop") {
        return window.innerWidth < 768 ? "LiteView" : "DesktopView";
      } else {
        return "MobileView";
      }
    },
  },
};
</script>

<style>
  /* Estilos globales para el componente Sys */
</style>
