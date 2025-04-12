// @ts-ignore: Implicit any type for Vuex module
import { createStore } from 'vuex';

const store = createStore({
  state: {
    user: null,
    isAuthenticated: false,
    vista: '',
    sabor: '',
  },

  mutations: {
    setUser(state, user) {
      state.user = user;
      state.isAuthenticated = !!user;
    },
    setVista(state, vista) {
      state.vista = vista; // Mutación para actualizar 'vista'
    },
    setSabor(state, sabor) {
      state.sabor = sabor; // Mutación para actualizar 'sabor'
    },
    logout(state) {
      state.user = null;
      state.isAuthenticated = false;
      state.vista = '';
      state.sabor = '';
    },
  },

  actions: {
    login({ commit }, { user, vista, sabor }) {
      commit('setUser', user);
      commit('setVista', vista); // Actualizar 'vista' al iniciar sesión
      commit('setSabor', sabor); // Actualizar 'sabor' al iniciar sesión
    },
    logout({ commit }) {
      commit('logout');
    },
  },

  getters: {
    isAuthenticated: (state) => state.isAuthenticated,
    getUser: (state) => state.user,
    getVista: (state) => state.vista, // Getter para 'vista'
    getSabor: (state) => state.sabor, // Getter para 'sabor'
  },
});

export default store;
