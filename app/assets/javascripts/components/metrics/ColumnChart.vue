<template>
  <column-chart :data="data" :title="title" />
</template>

<script>
export default {
  props: {
    data: {
      type: String,
      required: true,
    },
    title: {
      type: String,
      required: true,
    },
  },
};
</script>
