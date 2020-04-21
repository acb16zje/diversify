export default {
  namespaced: true,
  state: {
    categories: [],
  },
  mutations: {
    updateCategories(state, value) {
      state.categories = value;
    },
    updateCategoryName(state, { index, name }) {
      state.categories[index].name = name;
    },
  },
  actions: {
    addCategory({ state, commit }, category) {
      commit('updateCategories', state.categories.concat(category));
    },
    updateCategory({ state, commit }, { id, name }) {
      const index = state.categories.findIndex((e) => e.id === id);

      if (index !== -1) {
        commit('updateCategoryName', { index, name });
      }
    },
    removeCategory({ state, commit }, id) {
      commit('updateCategories', state.categories.filter((e) => e.id !== id));
    },
  },
};
