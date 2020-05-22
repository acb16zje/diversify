import './application';
import Vue from 'vue/dist/vue.esm';
import Chartkick from 'vue-chartkick';
import Chart from 'chart.js';
import ProjectList from '../projects/ProjectList.vue';
import { successToast } from '../buefy/toast';
import Skill from '../users/settings/Skill.vue';
import SkillTable from '../users/SkillTable.vue';
import Timeline from '../users/Timeline.vue';
import PieChart from '../admin/metrics/PieChart.vue';
import userStore from '../users/store';

Chartkick.options = {
  messages: {
    empty: 'No data',
  },
};

Vue.use(Chartkick.use(Chart));

new Vue({
  el: '#user',
  components: {
    ProjectList,
    SkillTable,
    Skill,
    PieChart,
    Timeline,
  },
  store: userStore,
  data: {
    avatarFilename: 'No file attached',
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
        document.getElementById('avatar').src = reader.result;
      }, false);

      if (file) {
        this.avatarFilename = event.target.files[0].name;
        reader.readAsDataURL(file);
      }
    },
  },
});
