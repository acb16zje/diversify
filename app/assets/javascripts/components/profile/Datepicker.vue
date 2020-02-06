<template>
  <b-field>
    <b-datepicker
      v-model="date"
      placeholder="Select date"
      :max-date="maxDate"
      @input="$emit('set-date', date)"
      :name="name"
    />

    <p class="control">
      <b-button @click="clearDate">
        <span class="icon is-small">
          <span class="iconify" data-icon="emojione-v1:cross-mark" />
        </span>
      </b-button>
    </p>
  </b-field>
</template>

<script>
export default {
  props: ['name', 'current'],
  data() {
    return {
      name: this.name,
      date: new Date(this.current),
      maxDate: new Date(),
    };
  },
  methods: {
    clearDate() {
      this.date = new Date(this.current);
      this.$emit('set-date', this.date);
    },
  },
};
</script>
