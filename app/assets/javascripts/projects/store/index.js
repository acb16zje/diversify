import Vuex from 'vuex';
import search from './modules/search';

const projectStore = new Vuex.Store({
  modules: {
    search,
  },
});

export default projectStore;
