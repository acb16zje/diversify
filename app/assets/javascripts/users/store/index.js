import Vuex from 'vuex';
import search from '../../projects/store/modules/search';
import skill from './modules/skill';

const userStore = new Vuex.Store({
  modules: {
    search,
    skill,
  },
});

export default userStore;
