import Rails from '@rails/ujs';

export default {
  namespaced: true,
  state: {
    userSkills: [],
    category: '',
    skillList: [],
  },
  mutations: {
    updateUserSkills(state, value) {
      state.userSkills = value;
    },
    addUserSkills(state, skills) {
      state.userSkills = state.userSkills.concat(skills);
    },
    removeUserSkill(state, id) {
      state.userSkills = state.userSkills.filter((e) => e.id !== id);
    },
  },
  actions: {
    updateCategory({ state, dispatch }, value) {
      state.category = value;
      dispatch('getSkills');
    },
    getSkills({ state }) {
      Rails.ajax({
        url: `/skills?category=${state.category}`,
        type: 'GET',
        success: ({ skills }) => {
          state.skillList = JSON.parse(skills)
            .filter(({ id }) => !state.userSkills.find((skill) => skill.id === id));
        },
      });
    },
  },
};
