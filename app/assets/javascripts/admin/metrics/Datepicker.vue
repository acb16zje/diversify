<template>
  <b-field>
    <b-datepicker
      v-model="dates"
      :max-date="new Date()"
      :mobile-native="false"
      placeholder="Select date"
      range
      expanded
      @input="$emit('set-dates', dates)"
    />

    <p class="control">
      <button class="button" @click="clearDates">
        <span class="icon is-small">
          <span class="iconify" data-icon="emojione-v1:cross-mark" />
        </span>
      </button>
    </p>
  </b-field>
</template>

<script>
export default {
  data() {
    return {
      dates: [],
    };
  },
  methods: {
    clearDates() {
      this.dates = [];
      this.$emit('set-dates', this.dates);
    },
  },
};
</script>
