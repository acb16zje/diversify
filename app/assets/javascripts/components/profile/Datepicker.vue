<template>
  <b-field>
    <b-datepicker
      v-model="date"
      :date-formatter="(date) => date.toLocaleDateString('en-GB')"
      :max-date="new Date()"
      :name="name"
      placeholder="Select date"
    />

    <p class="control">
      <b-button @click="date = new Date(current)">
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
      date: new Date(this.current),
    };
  },
};
</script>
