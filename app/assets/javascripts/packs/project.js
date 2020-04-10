import './application';
import Vue from 'vue/dist/vue.esm';
import Rails from '@rails/ujs';
import ProjectList from '../components/projects/ProjectList.vue';
import ApplicationTable from '../components/projects/ApplicationTable.vue';
import InviteTable from '../components/projects/InviteTable.vue';
import { successToast, dangerToast } from '../components/buefy/toast';

import projectStore from '../components/projects/store';

new Vue({
  el: '#project',
  components: {
    ProjectList,
    ApplicationTable,
    InviteTable,
  },
  store: projectStore,
  data: {
    avatarFilename: 'No file attached',
    avatarDataUrl: null,
    id: -1,
    selected: 0,
    taskCount: -1,
    applicationCount: -1,
    teamCount: -1,
  },
  watch: {
    selected(value) {
      if (value === 1) {
        this.getCount('task');
      } else if (value === 2) {
        this.getCount('team');
      } else if (value === 3) {
        this.getCount('application');
      }
    },
  },
  methods: {
    getId(id) {
      this.id = id;
    },
    getCount(countType) {
      Rails.ajax({
        url: `/projects/${this.id}/count`,
        type: 'POST',
        data: new URLSearchParams({
          type: countType,
        }),
        success: (data) => {
          switch (countType) {
            case 'task':
              this.taskCount = data.count;
              break;
            case 'team':
              this.teamCount = data.count;
              break;
            case 'application':
              this.applicationCount = data.count;
              break;
            default:
              dangerToast('Invalid Type');
          }
        },
      });
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
