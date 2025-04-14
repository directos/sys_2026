import { mount } from '@vue/test-utils';
import LoginForm from '@/components/LoginForm.vue';
import { createStore } from 'vuex';

describe('LoginForm.vue', () => {
  let store;

  beforeEach(() => {
    // Mock del store de Vuex
    store = createStore({
      state: {
        isAuthenticated: false,
      },
      actions: {
        login: jest.fn(),
      },
      getters: {
        isAuthenticated: (state) => state.isAuthenticated,
      },
    });
  });

  it('renders the login form', () => {
    const wrapper = mount(LoginForm, {
      global: {
        plugins: [store],
      },
    });

    expect(wrapper.find('form').exists()).toBe(true);
    expect(wrapper.find('input[name="user"]').exists()).toBe(true);
    expect(wrapper.find('input[name="pass"]').exists()).toBe(true);
    expect(wrapper.find('button[type="submit"]').exists()).toBe(true);
  });

  it('shows an error message when login fails', async () => {
    const wrapper = mount(LoginForm, {
      global: {
        plugins: [store],
      },
    });

    // Simular un error en el login
    await wrapper.setData({ errorMessage: 'Credenciales incorrectas' });

    expect(wrapper.find('.text-danger').text()).toBe('Credenciales incorrectas');
  });

  it('dispatches the login action on form submit', async () => {
    const wrapper = mount(LoginForm, {
      global: {
        plugins: [store],
      },
    });

    const usuarioInput = wrapper.find('input[name="user"]');
    const passwordInput = wrapper.find('input[name="pass"]');

    await usuarioInput.setValue('testuser');
    await passwordInput.setValue('password123');

    await wrapper.find('form').trigger('submit.prevent');

    expect(store._actions.login).toHaveBeenCalled();
  });
});