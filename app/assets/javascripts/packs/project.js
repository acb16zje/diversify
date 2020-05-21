import './application';
import Vue from 'vue/dist/vue.esm';
import Rails from '@rails/ujs';
import ProjectList from '../projects/ProjectList.vue';
import ApplicationTable from '../projects/ApplicationTable.vue';
import InvitationTable from '../projects/InvitationTable.vue';
import TeamsManage from '../projects/TeamsManage.vue';
import TeamModal from '../projects/components/TeamModal.vue';
import TaskTable from '../projects/TaskTable.vue';
import { dangerToast } from '../buefy/toast';
import projectStore from '../projects/store';

new Vue({
  el: '#project',
  components: {
    ProjectList,
    ApplicationTable,
    InvitationTable,
    TeamsManage,
    TaskTable,
  },
  store: projectStore,
  data: {
    avatarFilename: 'No file attached',
    avatarDataUrl: null,
    selected: 0,
    taskCount: -1,
    applicationCount: -1,
    isModalActive: -1,
  },
  computed: {
    id() {
      return window.location.pathname.split('/')[2];
    },
  },
  watch: {
    selected(value) {
      if (value === 1) {
        this.getCount('task');
      } else if (value === 2) {
        this.getCount('application');
      }
    },
  },
  methods: {
    getCount(countType) {
      Rails.ajax({
        url: `/projects/${this.id}/count`,
        type: 'GET',
        data: new URLSearchParams({ type: countType }),
        success: ({ count }) => {
          switch (countType) {
            case 'task':
              this.taskCount = count;
              break;
            case 'application':
              this.applicationCount = count;
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
    teamModal(id, projectId) {
      this.$buefy.modal.open({
        component: TeamModal,
        hasModalCard: true,
        trapFocus: true,
        scroll: 'keep',
        props: {
          id,
          projectId,
        },
      });
    },
  },
});
