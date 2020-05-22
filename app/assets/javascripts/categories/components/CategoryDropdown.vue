<template>
  <b-dropdown
    v-model="selected"
    animation=""
    id="category"
    class="github"
    @change="$emit('input', $event)"
    @active-change="getCategories"
  >
    <b-loading :is-full-page="false" :active.sync="isGettingCategories" />
    <button slot="trigger" class="button">
      <i>Category:</i>
      <span>{{ selected || 'All' }}</span>
      <b-icon icon="menu-down" />
    </button>

    <b-dropdown-item value="">
      All
    </b-dropdown-item>

    <b-dropdown-item
      v-for="(category, index) in categories"
      :key="index"
      :value="category"
    >
      {{ category }}
    </b-dropdown-item>
  </b-dropdown>
</template>

<script>
import Rails from '@rails/ujs';

export default {
  props: {
    value: {
      type: String,
      default: '',
      required: false,
    },
  },
  data() {
    return {
      selected: this.value,
      categories: [],
      isGettingCategories: false,
    };
  },
  watch: {
    value(value) {
      this.selected = value;
    },
  },
  methods: {
    getCategories() {
      if (this.categories.length) {
        return;
      }

      this.isGettingCategories = true;

      Rails.ajax({
        url: '/categories',
        type: 'GET',
        dataType: 'json',
        success: ({ categories }) => {
          this.categories = categories;
          this.isGettingCategories = false;
        },
        complete: () => {
          this.isGettingCategories = false;
        },
      });
    },
  },
};
</script>
