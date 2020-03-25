import './application';
import Vue from 'vue/dist/vue.esm';
import ProjectSearch from '../components/projects/ProjectSearch.vue';
// import ApplicationTable from '../components/projects/ApplicationTable.vue';
import InviteTable from '../components/projects/InviteTable.vue';
import { successToast } from '../components/buefy/toast';

new Vue({
  el: '#user',
  components: {
    ProjectSearch,
    // ApplicationTable,
    InviteTable,
  },
  data: {
    avatarFilename: 'No file attached',
    avatarDataUrl: null,
  },
  methods: {
    profileUpdateSuccess({ detail: [response] }) {
      successToast(response.message);

      if (this.avatarDataUrl) {
        document.getElementById('avatar').src = this.avatarDataUrl;
      }
    },
    avatarChanged(event) {
      const file = event.target.files[0];
      const reader = new FileReader();

      reader.addEventListener('load', () => {
        this.avatarDataUrl = reader.result;
      }, false);

      if (file) {
        this.avatarFilename = event.target.files[0].name;
        reader.readAsDataURL(file);
      }
    },
  },
});
