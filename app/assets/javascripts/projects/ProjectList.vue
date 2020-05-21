<template>
  <div>
    <div class="component-holder" :class="{ 'justify-end': !hasTabs }">
      <b-tabs v-if="hasTabs" v-model="tabIndex" :animated="false" class="m-0">
        <b-tab-item label="Personal" />
        <b-tab-item label="Joined" />
      </b-tabs>

      <Search />
    </div>

    <SearchSummary />

    <template>
      <b-loading :is-full-page="false" :active.sync="isSearching" />
      <div v-html="projectsHTML" /> <!-- eslint-disable-line vue/no-v-html -->
    </template>

    <b-pagination
      :total="total"
      :current.sync="currentPage"
      :per-page="10"
      :range-before="2"
      :range-after="2"
      order="is-centered"
    />
  </div>
</template>

<script>
import { mapActions, mapMutations, mapState } from 'vuex';
import Search from './components/Search.vue';
import SearchSummary from './components/SearchSummary.vue';

export default {
  components: {
    Search,
    SearchSummary,
  },
  props: {
    initProjectsHtml: {
      type: String,
      default: '',
      required: false,
    },
    initTotal: {
      type: Number,
      default: 0,
      required: false,
    },
    hasTabs: {
      type: Boolean,
      default: true,
      required: false,
    },
    isJoined: {
      type: Boolean,
      default: false,
      required: false,
    },
  },
  data() {
    return {
      tabIndex: 0,
    };
  },
  computed: {
    currentPage: {
      get() {
        return this.$store.state.search.page;
      },
      set(value) {
        this.updateState({ param: 'page', value });
      },
    },
    ...mapState('search', ['isSearching', 'projectsHTML', 'total']),
  },
  watch: {
    tabIndex(newVal) {
      this.updateState({ param: 'joined', value: newVal === 1 });
    },
  },
  created() {
    this.updateProjectsHTML(this.initProjectsHtml);
    this.updateTotal(this.initTotal);

    // User profile tabs
    if (this.initProjectsHtml === '') {
      this.updateState({ param: 'joined', value: this.isJoined });
    }
  },
  methods: {
    ...mapMutations('search', ['updateProjectsHTML', 'updateTotal']),
    ...mapActions('search', ['updateState']),
  },
};
</script>
