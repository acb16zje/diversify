<template>
  <span class="iconify" :data-icon="iconifyIcon" data-width="24" data-height="24" />
</template>

<script>
export default {
  props: {
    icon: {
      type: Array,
      required: true,
    },
  },
  computed: {
    iconifyIcon() {
      return `${this.icon[0]}:${this.icon[1].slice(4)}`;
    },
  },
};
</script>
