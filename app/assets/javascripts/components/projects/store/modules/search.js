import Rails from '@rails/ujs';

const defaultRequestState = () => ({
  query: '',
  status: '',
  category: '',
  sort: 'created_desc',
});

export default {
  namespaced: true,
  state: {
    ...defaultRequestState(),
    page: 1,
    personal: false,
    isSearching: false,
    showSummary: false,
    projectsHTML: '',
    total: 0,
  },
  mutations: {
    updateQuery(state, value) {
      state.query = value;
    },
    updateProjectsHTML(state, value) {
      state.projectsHTML = value;
    },
    updateTotal(state, value) {
      state.total = value;
    },
    clearFilter(state) {
      Object.assign(state, defaultRequestState());
    },
    searchProjects(state) {
      state.isSearching = true;
      state.showSummary = false;

      Rails.ajax({
        url: `${window.location.pathname}${state.personal ? '?personal=true' : ''}`,
        type: 'GET',
        data: new URLSearchParams({
          page: state.page,
          query: state.query,
          status: state.status,
          category: state.category,
          sort: state.sort,
        }),
        dataType: 'json',
        success: ({ html, total }) => {
          state.projectsHTML = html;
          state.total = total;
        },
        complete: () => {
          state.isSearching = false;
          state.showSummary = !(state.query === '' && state.status === '' && state.category === '');
        },
      });
    },
  },
  actions: {
    async updateState({ state, commit }, { param, value }) {
      state[param] = value;
      await commit('searchProjects');
    },
    async clearFilter({ commit }) {
      await commit('clearFilter');
      await commit('searchProjects');
    },
  },
};
