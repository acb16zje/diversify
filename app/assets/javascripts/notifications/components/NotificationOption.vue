<template>
  <div class="dropdown dropdown-menu-animation is-right notification-options">
    <div ref="trigger" class="dropdown-trigger">
      <button class="button shadow-lg" @click.stop="toggle">
        <b-icon icon="dots-horizontal" class="text-sm" />
      </button>
    </div>

    <div ref="dropdownMenu" class="dropdown-menu" :class="{ 'hidden': !isActive }">
      <div class="dropdown-content">
        <a v-if="read" class="dropdown-item" @click.stop="markAsUnread">
          Mark as unread
        </a>
        <a v-else class="dropdown-item" @click.stop="markAsRead">
          Mark as read
        </a>

        <a class="dropdown-item" @click.stop="deleteNotification">
          Remove this notification
        </a>
      </div>
    </div>
  </div>
</template>

<script>
import Rails from '@rails/ujs';
import notificationStore from '../store/index';
import { dangerToast, successToast } from '../../buefy/toast';

export default {
  props: {
    id: {
      type: Number,
      required: true,
    },
    read: {
      type: Boolean,
      required: true,
    },
  },
  computed: {
    isActive() {
      return this.id === notificationStore.state.activeDropdownOption;
    },
  },
  created() {
    document.addEventListener('click', this.clickedOutside);
  },
  methods: {
    markAsRead() {
      Rails.ajax({
        url: `/notifications/${this.id}/read`,
        type: 'PATCH',
        success: () => {
          notificationStore.dispatch('readNotification', this.id);
          notificationStore.commit('updateActiveDropdownOption', 0);
        },
      });
    },
    markAsUnread() {
      Rails.ajax({
        url: `/notifications/${this.id}/unread`,
        type: 'PATCH',
        success: () => {
          notificationStore.dispatch('unreadNotification', this.id);
          notificationStore.commit('updateActiveDropdownOption', 0);
        },
      });
    },
    deleteNotification() {
      Rails.ajax({
        url: `/notifications/${this.id}`,
        type: 'DELETE',
        success: () => {
          notificationStore.dispatch('removeNotification', this.id);
          successToast('Notification deleted');
        },
        error: () => {
          dangerToast('Failed to delete the notification');
        },
      });
    },
    toggle() {
      const value = this.isActive ? 0 : this.id;
      notificationStore.commit('updateActiveDropdownOption', value);
    },
    clickedOutside(event) {
      if (!this.isInWhiteList(event.target)) {
        notificationStore.commit('updateActiveDropdownOption', 0);
      }
    },
    isInWhiteList(el) {
      if (el === this.$refs.dropdownMenu) return true;
      if (el === this.$refs.trigger) return true;
      // All children from dropdown
      if (this.$refs.dropdownMenu !== undefined) {
        const children = this.$refs.dropdownMenu.querySelectorAll('*');

        for (let i = 0, n = children.length; i < n; i += 1) {
          if (el === children[i]) {
            return true;
          }
        }
      }
      // All children from trigger
      if (this.$refs.trigger !== undefined) {
        const children = this.$refs.trigger.querySelectorAll('*');
        for (let i = 0, n = children.length; i < n; i += 1) {
          if (el === children[i]) {
            return true;
          }
        }
      }
      return false;
    },
  },
};
</script>
