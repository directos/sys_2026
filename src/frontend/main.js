import { createApp } from 'vue';
import process from 'process'; // Para acceder a las variables de entorno 
import store from '@/store';
import router from '@/router';
import '@/assets/styles/global.css';
import App from '@/App.vue';

const app = createApp(App);

// Leer las variables de entorno inyectadas por Webpack
const frontendUrl = process.env.FRONTEND_URL; // || 'http://localhost:3000';
const backendUrl = process.env.BACKEND_URL; // || 'http://localhost:5000';
console.log('Frontend URL:', frontendUrl);
console.log('Backend URL:', backendUrl);

app.use(store).use(router).mount('#app');