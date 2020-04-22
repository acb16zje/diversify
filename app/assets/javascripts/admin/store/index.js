import Vuex from 'vuex';
import category from './modules/category';
import skill from './modules/skill';

const adminStore = new Vuex.Store({
  modules: {
    category,
    skill,
  },
});

export default adminStore;
