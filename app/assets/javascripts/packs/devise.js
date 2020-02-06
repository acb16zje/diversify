import '../../stylesheets/devise.scss';
import './application';
import Vue from 'vue/dist/vue.esm';
import Toast from '../components/buefy/Toast.vue';
import { dangerToast } from '../components/buefy/toast';

new Vue({
  el: '#app',
  components: {
    Toast,
  },
  data: {
    showNavbar: false,
  },
  mounted() {
    document.addEventListener('DOMContentLoaded', () => {
      // 1. Display file name when select file
      let fileInputs = document.querySelectorAll('.file.has-name')
      for (let fileInput of fileInputs) {
        let input = fileInput.querySelector('.file-input')
        let name = fileInput.querySelector('.file-name')
        input.addEventListener('change', () => {
          let files = input.files
          if (files.length === 0) {
            name.innerText = 'No file selected'
          } else {
            name.innerText = files[0].name
          }
        })
      }

      // 2. Remove file name when form reset
      let forms = document.getElementsByTagName('form')
      for (let form of forms) {
        form.addEventListener('reset', () => {
          console.log('a')
          let names = form.querySelectorAll('.file-name')
          for (let name of names) {
            name.innerText = 'No file selected'
          }
        })
      }
    })
  },
  methods: {
    ajaxSuccess(event) {
      const form = event.target;
      form.outerHTML = `
        <p class="subtitle is-5 has-text-centered">${event.detail[0].message}</p>
      `;
    },
    ajaxError(event) {
      const messages = event.detail[0].errors;
      messages.forEach((message) => {
        dangerToast(message);
      });
    },
  },
});
