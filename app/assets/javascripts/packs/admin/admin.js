import '../application';
import Vue from 'vue/dist/vue.esm';
import CategoryList from '../../admin/categories/CategoryList.vue';
import SkillList from '../../admin/skills/SkillList.vue';
import adminStore from '../../admin/store';

new Vue({
  el: '#admin',
  components: {
    CategoryList,
    SkillList,
  },
  store: adminStore,
});
