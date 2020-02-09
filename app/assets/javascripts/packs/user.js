import './application';
import Vue from 'vue/dist/vue.esm';
import ProjectSearch from '../components/projects/ProjectSearch.vue';

new Vue({
  el: '#user',
  components: {
    ProjectSearch,
  },
});
