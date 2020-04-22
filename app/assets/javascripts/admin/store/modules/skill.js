export default {
  namespaced: true,
  state: {
    skills: [],
  },
  mutations: {
    updateSkills(state, value) {
      state.skills = value;
    },
    updateSkill(state, { index, name, categoryName }) {
      state.skills[index].name = name;
      state.skills[index].category_name = categoryName;
    },
  },
  actions: {
    addSkill({ state, commit }, skill) {
      commit('updateSkills', state.skills.concat(skill));
    },
    updateSkill({ state, commit }, { id, name, categoryName }) {
      const index = state.skills.findIndex((e) => e.id === id);

      if (index !== -1) {
        commit('updateSkill', { index, name, categoryName });
      }
    },
    removeSkill({ state, commit }, id) {
      commit('updateSkills', state.skills.filter((e) => e.id !== id));
    },
  },
};
