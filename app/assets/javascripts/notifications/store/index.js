import Vue from 'vue/dist/vue.esm';
import Vuex from 'vuex';

Vue.use(Vuex);

const notificationStore = new Vuex.Store({
  state: {
    unreadCount: 0,
    notifications: [],
    activeDropdownOption: 0,
  },
  mutations: {
    updateActiveDropdownOption(state, value) {
      state.activeDropdownOption = value;
    },
    updateUnreadCount(state, value) {
      state.unreadCount = value;
    },
    updateNotifications(state, value) {
      state.notifications = value;
    },
    readNotification(state, index) {
      state.notifications[index].read = true;
    },
    unreadNotification(state, index) {
      state.notifications[index].read = false;
    },
  },
  actions: {
    addNotifications({ state, commit }, value) {
      commit('updateNotifications', state.notifications.concat(value));
    },
    removeNotification({ state, commit }, id) {
      commit('updateNotifications', state.notifications.filter((e) => e.id !== id));
    },
    readNotification({ state, commit }, id) {
      const index = state.notifications.findIndex((e) => e.id === id);

      if (index !== -1) {
        commit('readNotification', index);
        commit('updateUnreadCount', state.unreadCount -= 1);
      }
    },
    readAllNotifications({ state, commit }) {
      for (let i = 0, n = state.notifications.length; i < n; i += 1) {
        commit('readNotification', i);
      }

      commit('updateUnreadCount', 0);
    },
    unreadNotification({ state, commit }, id) {
      const index = state.notifications.findIndex((e) => e.id === id);

      if (index !== -1) {
        commit('unreadNotification', index);
        commit('updateUnreadCount', state.unreadCount += 1);
      }
    },
  },
});

export default notificationStore;
