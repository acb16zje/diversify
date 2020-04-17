<template>
  <span v-if="k === 'invitation/send'">
    You are invited to join <strong>{{ notifiable.name }}</strong>
  </span>
  <span v-else-if="k === 'invitation/accept'">
    <strong>{{ notifiable.name }}</strong> accepted your invitation to join
    <strong>{{ notifier.name }}</strong>
  </span>
  <span v-else-if="k === 'invitation/decline'">
    <strong>{{ notifiable.name }}</strong> declined your invitation to join
    <strong>{{ notifier.name }}</strong>
  </span>
  <span v-else-if="k === 'application/send'">
    <strong>{{ notifiable.name }}</strong> asked to join
    <strong>{{ notifier.name }}</strong>
  </span>
  <span v-else-if="k === 'application/accept'">
    Your request to join <strong>{{ notifiable.name }}</strong> has been approved
  </span>
  <span v-else-if="k === 'application/decline'">
    Your request to join <strong>{{ notifiable.name }}</strong> has been declined
  </span>
</template>

<script>
export default {
  props: {
    k: {
      type: String,
      required: true,
      validator(value) {
        return /^(invitation|application)\/(send|accept|decline)$/.test(value);
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
