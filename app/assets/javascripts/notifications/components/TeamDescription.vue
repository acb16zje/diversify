<template>
  <p>
    You have been assigned to <strong>{{ notifier.name }}</strong> in <strong>{{ notifiable.name }}</strong>
  </p>
</template>

<script>
export default {
  props: {
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
