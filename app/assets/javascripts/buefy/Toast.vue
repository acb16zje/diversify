<template /> <!-- eslint-disable-line -->

<script>
import { dangerToast, successToast } from './toast';

export default {
  props: {
    type: {
      type: String,
      required: true,
    },
    message: {
      type: String,
      required: true,
    },
  },
  mounted() {
    if (this.type === 'success') {
      successToast(this.message);
    } else if (this.type === 'error') {
      dangerToast(this.message);
    }
  },
};
</script>
