<template>
  <div v-if="showSummary" id="search-summary">
    <span>
      <strong>{{ total }}</strong> results for
      <strong v-if="status">{{ status }}</strong> projects
      <template v-if="query">
        matching
        <strong>{{ query }}</strong>
      </template>
      <template v-if="category">
        related to
        <strong v-if="category">{{ category }}</strong>
      </template>
    </span>

    <a @click="clearFilter">
      <span class="icon mr-1">
        <span class="iconify is-24" data-icon="entypo:squared-cross" />
      </span>
      Clear filter
    </a>
  </div>
</template>

<script>
import { mapState, mapActions } from 'vuex';

export default {
  computed: {
    ...mapState('search', ['query', 'status', 'category', 'showSummary', 'total']),
  },
  methods: {
    ...mapActions('search', ['clearFilter']),
  },
};
</script>

<style scoped>

</style>
