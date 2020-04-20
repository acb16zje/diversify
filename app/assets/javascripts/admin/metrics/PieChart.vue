<template>
  <pie-chart :data="data" :title="title" />
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
  },
};
</script>
