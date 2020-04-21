import '../application';
import Vue from 'vue/dist/vue.esm';
import CategoryList from '../../admin/categories/CategoryList.vue';
import adminStore from '../../admin/store';

new Vue({
  el: '#admin',
  components: {
    CategoryList,
  },
  store: adminStore,
});
