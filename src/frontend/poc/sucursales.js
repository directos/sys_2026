const { createApp } = Vue;
const apiUrl = 'http://localhost/sys/src/backend'; // URL de la API

createApp({
  data() {
    return {
      sucursales: [], // Aquí se almacenarán las sucursales
      sucursalId: '', // ID de la sucursal a buscar
      sucursal: null  // Detalles de la sucursal encontrada
    };
  },
  methods: {
    async fetchSucursales() {
      try {
        const response = await axios.get(`${apiUrl}/sucursales`);
        this.sucursales = response.data;
      } catch (err) {
        console.error('Error al obtener las sucursales:', err);
      }
    },
    async fetchSucursalById() {
      try {
        if (!this.sucursalId.trim()) {
          alert('Por favor, ingrese un ID válido.');
          this.sucursal = null; // Reinicia el valor si no se proporciona un ID
          return;
        }
        const response = await axios.get(`${apiUrl}/sucursales/${this.sucursalId}`);
        this.sucursal = response.data;
      } catch (err) {
        console.error('Error al buscar la sucursal:', err);
        this.sucursal = null; // Reinicia el valor si no se encuentra
        alert('Sucursal no encontrada o error en la búsqueda.');
      }
    }
  }
}).mount('#app');
