<template>
  <div class="login-container">
    <div class="login-wrap">
      <main>
        <div class="login-title mb-2">
          <div>
            <img src="../assets/img/login_logo.png" alt="logo" width="80px" height="80px" />
          </div>
        </div>

        <!-- Login form -->
        <form class="login-form" @submit.prevent="handleSubmit">
          <div class="wrap-input rs1">
            <i class="bx bx-user"></i>
            <input v-model="user" class="login-input" type="text" name="user" placeholder="User" autocomplete="off"
              required />
          </div>
          <div class="wrap-input rs2">
            <i class="bx bx-lock-alt"></i>
            <input v-model="password" class="login-input" type="password" name="pass" placeholder="Password"
              autocomplete="new-password" required />
          </div>
          <div class="login-container-form-btn">
            <button type="submit" class="login-form-btn">Login</button>
          </div>
        </form>

        <!-- Texto inferior -->
        <div class="text-center small">
          <div class="text-danger mb-1" style="min-height: 18px;">{{ errorMessage }}</div>
          <span class="text-white-50"><span>&copy;</span>{{ currentYear }}</span>
          <a href="#" class="text-white-50 ml-1" @click.prevent="clear">Clear</a>
          <a href="https://statuspage.freshping.io/46357-SysFunerariaElEden" target="_blank" rel="noreferrer"
            class="text-white-50 ml-1">
            Estatus
          </a>
        </div>
      </main>
    </div>
  </div>
</template>

<script>
import { ref } from "vue";

export default {
  name: "LoginForm",
  setup() {
    const user = ref("");
    const password = ref("");
    const errorMessage = ref("");
    const currentYear = new Date().getFullYear();

    const handleSubmit = () => {
      if (!user.value || !password.value) {
        errorMessage.value = "Por favor, completa todos los campos.";
        return;
      }
      // Aquí puedes manejar el envío del formulario
      console.log("Usuario:", user.value);
      console.log("Contraseña:", password.value);
    };

    const clear = () => {
      user.value = "";
      password.value = "";
      errorMessage.value = "";
    };

    return {
      user,
      password,
      errorMessage,
      currentYear,
      handleSubmit,
      clear,
    };
  },
};
</script>

<style scoped>
* {
  font-family: 'Open Sans', sans-serif;
  margin: 0;
  padding: 0;
  box-sizing: border-box;
}

/* Simulando Bootstrap */

.mb-2 {
  margin-bottom: 0.5rem !important;
}

.mb-3 {
  margin-bottom: 1rem !important;
}

.mt-2 {
  margin-top: 0.5rem !important;
}

.mt-1 {
  margin-top: 0.25rem !important;
}

.ml-1 {
  margin-left: 0.25rem !important;
}

.ml-2 {
  margin-left: 0.5rem !important;
}

.small {
  font-size: 0.75rem !important;
}

.text-danger {
  color: #dc3545 !important;
}

.text-center {
  text-align: center !important;
}

.text-white-50 {
  color: rgba(255, 255, 255, 0.5) !important;
}

.d-none {
  display: none !important;
}

/* Cuando estamos en modo standalone */

@media all and (display-mode: standalone) {
  #btn-instalar {
    display: none !important;
    /* Ocultamos el btn instalar: */
  }
}

/* Otros */

.login-container {
  width: 100%;
  min-height: 100vh;
  display: -webkit-box;
  display: -webkit-flex;
  display: -moz-box;
  display: -ms-flexbox;
  display: flex;
  flex-wrap: wrap;
  justify-content: center;
  align-items: center;
  padding: 15px;
}

.login-wrap {
  width: 420px;
}

.login-title {
  font-size: 30px;
  letter-spacing: 2px;
  line-height: 1.2;
  width: 100%;
  display: block;
  color: #fefefe;
  text-transform: uppercase;
  text-align: center;
}

.login-form {
  width: 100%;
  background-color: transparent;
  display: -webkit-box;
  display: -webkit-flex;
  display: -moz-box;
  display: -ms-flexbox;
  display: flex;
  flex-wrap: wrap;
  font-size: 15px;
}

.wrap-input {
  display: -webkit-box;
  display: -webkit-flex;
  display: -moz-box;
  display: -ms-flexbox;
  display: flex;
  flex-wrap: wrap;
  align-items: flex-end;
  width: 50%;
  height: 70px;
  position: relative;
  border: 1px solid #e0e0e0;
  border-bottom: none;
  background-color: #fff;
}

.wrap-input.rs1 {
  border-top-left-radius: 12px;
  border-right: none;
}

.wrap-input.rs2 {
  border-top-right-radius: 12px;
}

.validate-input {
  position: relative;
}

input.login-input {
  height: 90%;
  -webkit-transition: all 0.4s;
  -o-transition: all 0.4s;
  -moz-transition: all 0.4s;
  transition: all 0.4s;
}

.login-input {
  box-shadow: 0 0 0 1000px #fff inset;
  font-size: 15px;
  color: #555;
  line-height: 1.2;
  display: block;
  width: 100%;
  background: 0 0;
  padding: 0 40px;
}

input {
  outline: none;
  border: none;
}

.label-input {
  font-size: 15px;
  font-weight: bold;
  letter-spacing: 1px;
  color: #555;
  line-height: 1.2;
  display: block;
  position: absolute;
  pointer-events: none;
  width: 100%;
  padding-left: 30px;
  left: 0;
  top: 28px;
  -webkit-transition: all 0.4s;
  -o-transition: all 0.4s;
  -moz-transition: all 0.4s;
  transition: all 0.4s;
}

.has-val {
  height: 55px !important;
  box-shadow: 0 0 0 1000px #fff inset;
}

.has-val+.label-input {
  top: 10px;
  font-size: 13px;
  color: #111;
}

.login-container-form-btn {
  width: 100%;
  display: -webkit-box;
  display: -webkit-flex;
  display: -moz-box;
  display: -ms-flexbox;
  display: flex;
  flex-wrap: wrap;
  justify-content: center;
}

.login-form-btn {
  cursor: pointer;
  font-size: 15px;
  font-weight: bold;
  letter-spacing: 1px;
  color: #fff;
  line-height: 1.2;
  /*text-transform: uppercase;*/
  display: -webkit-box;
  display: -webkit-flex;
  display: -moz-box;
  display: -ms-flexbox;
  display: flex;
  justify-content: center;
  align-items: center;
  padding: 0 20px;
  width: 100%;
  height: 70px;
  border-bottom-left-radius: 12px;
  border-bottom-right-radius: 12px;
  overflow: hidden;
  /*background: #111;*/
  /*border: 1px solid rgb(255 255 255 / 40%);*/
  box-shadow: 1px 1px 10px 1px rgba(255, 255, 255, 0.1);
  background: rgba(33, 33, 33, 0.9);
  -webkit-transition: all 0.4s;
  -o-transition: all 0.4s;
  -moz-transition: all 0.4s;
  transition: all 0.4s;
  position: relative;
  z-index: 1;
}

.login-form-btn::before {
  content: "";
  display: block;
  position: absolute;
  z-index: -1;
  width: 100%;
  height: 100%;
  opacity: 0;

  background: #2575fc;
  background: -webkit-linear-gradient(right, #6a11cb, #2575fc);
  background: -o-linear-gradient(right, #6a11cb, #2575fc);
  background: -moz-linear-gradient(right, #6a11cb, #2575fc);
  background: linear-gradient(to left, #6a11cb, #2575fc);
  background-image: linear-gradient(to right, #6a11cb, #2575fc);

  -webkit-transition: all 0.4s;
  -o-transition: all 0.4s;
  -moz-transition: all 0.4s;
  transition: all 0.4s;
}

.login-form-btn:hover {
  background-color: transparent;
  box-shadow: 1px 3px 7px 1px rgba(255, 255, 255, 0.2);
}

.login-form-btn:hover:before {
  opacity: 1;
}

button {
  outline: none !important;
  border: none;
  background: transparent;
}

a {
  text-decoration: none;
  letter-spacing: 0.5px;
  line-height: 1.7;
  color: #666;
  margin: 0;
  transition: all 0.4s;
  -webkit-transition: all 0.4s;
  -o-transition: all 0.4s;
  -moz-transition: all 0.4s;
}

a:focus {
  outline: none !important;
}

a:hover {
  color: #fff !important;
}

@media (max-width: 576px) {
  .wrap-input {
    width: 100%;
  }

  .wrap-input.rs1 {
    border-top-right-radius: 12px;
    border-right: 1px solid #e0e0e0;
  }

  .wrap-input.rs2 {
    border-top-right-radius: 0px;
  }
}

.bx {
  position: fixed;
  padding: 24px 14px;
  color: #6783aa;
}
</style>