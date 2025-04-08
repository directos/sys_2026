import { createApp } from 'vue';
import App from './App.vue';
import store from './store';
import router from './router';
import './assets/styles/global.css';
import process from 'process'; // Para acceder a las variables de entorno 

const app = createApp(App);

// Leer las variables de entorno inyectadas por Webpack
const frontendUrl = process.env.FRONTEND_URL; // || 'http://localhost:3000';
const backendUrl = process.env.BACKEND_URL; // || 'http://localhost:5000';
console.log('Frontend URL:', frontendUrl);
console.log('Backend URL:', backendUrl);

// Usa la URL del backend en tu aplicación
const apiUrl = `${backendUrl}/api`;

app.use(store).use(router).mount('#app');