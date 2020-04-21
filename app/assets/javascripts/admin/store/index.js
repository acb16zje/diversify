import Vuex from 'vuex';
import category from './modules/category';

const adminStore = new Vuex.Store({
  modules: {
    category,
  },
});

export default adminStore;
