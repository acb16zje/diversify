<template>
  <b-dropdown
    id="notifications-dropdown"
    animation=""
    class="is-right mr-3"
    @active-change="getInitNotifications"
  >
    <template v-slot:trigger="{ active }">
      <button class="button rounded-full bg-gray-200 w-10 h-10">
        <b-icon icon="bell" class="text-sm" :class="{ 'has-text-link': active }" />
      </button>

      <span v-if="unreadCount" class="badge">{{ unreadCount }}</span>
    </template>

    <div class="flex justify-between items-center px-4 pt-2 pb-4">
      <h4 class="font-semibold title is-4 m-0">
        Notifications
      </h4>

      <a v-if="unreadCount" class="select-none" @click="readAllNotifications">
        Mark all as read
      </a>
    </div>

    <b-loading :is-full-page="false" :active.sync="isGettingNotifications" />

    <h4 v-if="notifications.length === 0" class="font-semibold text-center py-2">
      No notifications
    </h4>
    <template v-else>
      <a v-for="({ id, key, read, time_ago, notifiable, notifier}) in notifications"
         :key="id"
         class="dropdown-item"
         :class="[read ? 'read' : 'unread']"
         @click="readBeforeRedirect(id, read, notifier.link)"
      >
        <div v-html="notifiable.icon" /> <!-- eslint-disable-line vue/no-v-html -->

        <div class="notification-details">
          <template v-if="/^(invitation|application)/.test(key)">
            <AppealDescription :k="key" :notifiable="notifiable" :notifier="notifier" />
          </template>

          <span class="time-ago">{{ time_ago }}</span>
        </div>

        <NotificationOption :id="id" :read="read" />
      </a>

      <a v-if="hasMoreNotifications" class="more" @click="getMoreNotifications">
        See more notifications
      </a>
      <p v-else class="more">
        No more notifications
      </p>
    </template>
  </b-dropdown>
</template>

<script>
import Rails from '@rails/ujs';
import AppealDescription from './components/AppealDescription.vue';
import NotificationOption from './components/NotificationOption.vue';
import notificationStore from './store';

export default {
  components: {
    AppealDescription,
    NotificationOption,
  },
  props: {
    initUnreadCount: {
      type: Number,
      required: true,
    },
  },
  data() {
    return {
      page: 0,
      isGettingNotifications: true,
      hasMoreNotifications: true,
    };
  },
  computed: {
    unreadCount() {
      return notificationStore.state.unreadCount;
    },
    notifications() {
      return notificationStore.state.notifications;
    },
  },
  created() {
    notificationStore.commit('updateUnreadCount', this.initUnreadCount);
  },
  methods: {
    getInitNotifications(isActive) {
      if (!isActive || this.notifications.length > 0) {
        return;
      }

      this.getMoreNotifications();
    },
    getMoreNotifications() {
      if (!this.hasMoreNotifications) {
        return;
      }

      this.isGettingNotifications = true;

      Rails.ajax({
        url: '/notifications',
        type: 'GET',
        dataType: 'json',
        data: new URLSearchParams({ page: this.page += 1 }),
        success: (notifications) => {
          notificationStore.dispatch('addNotifications', notifications);
        },
        error: () => {
          this.hasMoreNotifications = false;
        },
        complete: () => {
          this.isGettingNotifications = false;
        },
      });
    },
    readBeforeRedirect(id, read, notifierLink) {
      if (read) {
        window.location.href = notifierLink;
      } else {
        Rails.ajax({
          url: `/notifications/${id}/read`,
          type: 'PATCH',
          complete: () => {
            window.location.href = notifierLink;
          },
        });
      }
    },
    readAllNotifications() {
      Rails.ajax({
        url: '/notifications/read_all',
        type: 'PATCH',
        success: () => {
          notificationStore.dispatch('readAllNotifications');
        },
      });
    },
  },
};
</script>
