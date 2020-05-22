<template>
  <div id="project-search">
    <b-field :grouped="true" :group-multiline="true" class="m-0">
      <div class="control">
        <b-input v-model="query" placeholder="Find a project..." class="w-64" />
      </div>

      <div class="control">
        <b-dropdown v-model="status" animation="" class="github is-right">
          <button slot="trigger" class="button">
            <i>Status:</i>
            <span class="capitalize">{{ status || 'All' }}</span>
            <b-icon icon="menu-down" />
          </button>

          <b-dropdown-item value="">
            All
          </b-dropdown-item>

          <b-dropdown-item value="open">
            Open
          </b-dropdown-item>

          <b-dropdown-item value="active">
            Active
          </b-dropdown-item>

          <b-dropdown-item value="completed">
            Completed
          </b-dropdown-item>
        </b-dropdown>
      </div>

      <div class="control">
        <CategoryDropdown v-model="category" class="is-right" />
      </div>

      <div class="control">
        <b-dropdown v-model="sort" animation="" class="github is-right">
          <button slot="trigger" class="button">
            <i>Sort:</i>
            <span>{{ sortLabel }}</span>
            <b-icon icon="menu-down" />
          </button>

          <b-dropdown-item value="created_desc" @click="sortLabel = 'Recently created'">
            Recently created
          </b-dropdown-item>

          <b-dropdown-item value="created_asc" @click="sortLabel = 'Oldest created'">
            Oldest created
          </b-dropdown-item>

          <b-dropdown-item value="name" @click="sortLabel = 'Name'">
            Name
          </b-dropdown-item>
        </b-dropdown>
      </div>
    </b-field>
  </div>
</template>

<script>
import { debounce } from 'lodash-es';
import { mapActions, mapMutations } from 'vuex';
import CategoryDropdown from '../../categories/components/CategoryDropdown.vue';

export default {
  components: { CategoryDropdown },
  data() {
    return {
      debouncedQuery: debounce(this.searchProjects, 300),
      sortLabel: 'Recently created',
    };
  },
  computed: {
    query: {
      get() {
        return this.$store.state.search.query;
      },
      set(value) {
        this.updateQuery(value);
      },
    },
    status: {
      get() {
        return this.$store.state.search.status;
      },
      set(value) {
        this.updateState({ param: 'status', value });
      },
    },
    category: {
      get() {
        return this.$store.state.search.category;
      },
      set(value) {
        this.updateState({ param: 'category', value });
      },
    },
    sort: {
      get() {
        return this.$store.state.search.sort;
      },
      set(value) {
        this.updateState({ param: 'sort', value });
      },
    },
  },
  watch: {
    query() {
      this.debouncedQuery();
    },
  },
  methods: {
    ...mapMutations('search', ['updateQuery', 'searchProjects']),
    ...mapActions('search', ['updateState']),
  },
};
</script>
