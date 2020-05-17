<template>
  <div class="timeline-item">
    <div v-if="e.key === 'user/create'" class="timeline-marker is-image is-32x32 is-success">
      <span class="iconify is-30" data-icon="bi:flag" />
    </div>
    <div v-else class="timeline-marker" />
    <div class="timeline-content">
      <p v-if="'created_at' in e" class="heading">
        {{ formatDate(e.created_at) }}
      </p>
      <span v-if="e.key === 'user/create'">
        User Joined Diversify
      </span>
      <span v-else-if="e.key === 'project/create'">
        Created Project {{ e.name }}
      </span>
      <span v-else-if="e.key === 'project/complete'">
        Completed Project {{ e.name }}
      </span>
      <!-- <span v-if="p === 'task/completed'">
        You have been assigned Task <strong>{{ notifier.name }}</strong>
        on <strong>{{ notifiable.name }}</strong>
      </span>
      <span v-else-if="p === 'project/join'">
        Joined
      </span> -->
    </div>
  </div>
</template>

<script>
const months = ['January', 'February', 'March', 'April', 'May', 'June', 'July', 'August', 'September', 'October', 'November', 'December'];
export default {
  props: {
    e: {
      type: Object,
      required: true,
      // validator(value) {
      //   return /^(task)\/(assigned|removed|update|completed)$/.test(value);
      // },
    },
  },
  methods: {
    formatDate(str) {
      const d = new Date(str);
      let result = d.getDate().toString(10);
      result = result.concat(' ', months[d.getMonth()]);
      return result;
    },
  },
};
</script>
