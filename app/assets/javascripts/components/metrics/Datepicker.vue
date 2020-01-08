<template>
  <b-field>
    <b-datepicker
      v-model="dates"
      placeholder="Select date"
      :max-date="maxDate"
      range
      expanded
      @input="$emit('set-dates', dates)"
    />

    <p class="control">
      <b-button @click="clearDates">
        <span class="icon is-small">
          <span class="iconify" data-icon="emojione-v1:cross-mark" />
        </span>
      </b-button>
    </p>
  </b-field>
</template>

<script>
export default {
  data() {
    return {
      dates: [],
      maxDate: new Date(),
    };
  },
  methods: {
    clearDates() {
      this.dates = null;
      this.$emit('set-dates', this.dates);
    },
  },
};
</script>
