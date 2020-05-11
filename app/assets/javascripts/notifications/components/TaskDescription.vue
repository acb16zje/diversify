<template>
  <span v-if="k === 'task/assigned'">
    You have been assigned <strong>{{ notifier.name }}</strong>
    on <strong>{{ notifiable.name }}</strong>
  </span>
  <span v-else-if="k === 'task/removed'">
    You have been removed from Task <strong>{{ notifier.name }}</strong>
    on <strong>{{ notifiable.name }}</strong>
  </span>
  <span v-else-if="k === 'task/update'">
    Task <strong>{{ notifier.name }}</strong> on
    <strong>{{ notifiable.name }}</strong> has been updated
  </span>
   <span v-else-if="k === 'task/picked'">
    Task <strong>{{ notifier.name }}</strong> on
    <strong>{{ notifiable.name }}</strong> has picked up
  </span>
  <span v-else-if="k === 'task/completed'">
    Task <strong>{{ notifier.name }}</strong> on
    <strong>{{ notifiable.name }}</strong> has been completed
  </span>
</template>

<script>
export default {
  props: {
    k: {
      type: String,
      required: true,
      validator(value) {
        return /^(task)\/(assigned|removed|update|completed)$/.test(value);
      },
    },
    notifiable: {
      type: Object,
      required: true,
    },
    notifier: {
      type: Object,
      required: true,
    },
  },
};
</script>
