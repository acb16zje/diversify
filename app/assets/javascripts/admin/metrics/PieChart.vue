<template>
  <pie-chart v-if="size === ''" :data="data" :title="title" :donut="isDonut" />
  <pie-chart v-else :data="data" :title="title" :donut="isDonut" :height="size" :width="size" />
</template>

<script>
export default {
  props: {
    data: {
      type: [String, Object, Array],
      required: true,
    },
    title: {
      type: String,
      required: true,
    },
    isDonut: {
      type: Boolean,
      default: false,
      required: false,
    },
    size: {
      type: String,
      default: '',
      required: false,
    },
  },
};
</script>
