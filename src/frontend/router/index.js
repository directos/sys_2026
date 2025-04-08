import { createRouter, createWebHistory } from 'vue-router';
import LoginForm from '@/components/LoginForm.vue';
import Home from '@/components/Home.vue';
import About from '@/components/About.vue';
import NotFound from '@/views/404.vue';

const routes = [
  { path: '/',      name: 'Login', component: LoginForm },
  { path: '/build', name: 'Login', component: LoginForm },
  { path: '/home', name: 'Home', component: Home },
  { path: '/about', name: 'About', component: About },
  { path: '/:pathMatch(.*)*', name: '404', component: NotFound },
];

const router = createRouter({
  history: createWebHistory(),
  routes,
});

export default router;
