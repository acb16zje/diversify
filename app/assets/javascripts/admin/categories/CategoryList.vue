<template>
  <section class="section pt-0">
    <div class="container">
      <div class="flex items-center pb-4">
        <h4 class="title is-4 m-0">
          Categories
        </h4>

        <button class="button is-success ml-auto" @click="newCategory">
          New category
        </button>
      </div>

      <b-table :data="categories" :hoverable="true" default-sort="name">
        <template v-slot="{ row: { id, name } }">
          <b-table-column field="id" label="ID" sortable>
            {{ id }}
          </b-table-column>

          <b-table-column field="name" label="Name" sortable searchable>
            <a :href="`/admin/categories/${id}`">{{ name }}</a>
          </b-table-column>

          <b-table-column label="Action">
            <div class="buttons">
              <b-button type="is-link" outlined @click="editCategory(id, name)">
                Edit
              </b-button>
              <b-button type="is-danger" @click="deleteCategory(id, name)">
                Delete
              </b-button>
            </div>
          </b-table-column>
        </template>

        <template v-slot:empty>
          <div class="content has-text-grey text-center">
            <p>No categories</p>
          </div>
        </template>
      </b-table>
    </div>
  </section>
</template>

<script>
import { mapMutations, mapState } from 'vuex';
import CategoryNew from './components/CategoryNew.vue';
import CategoryEdit from './components/CategoryEdit.vue';
import CategoryDelete from './components/CategoryDelete.vue';

export default {
  props: {
    initCategories: {
      type: Array,
      required: true,
    },
  },
  data() {
    return {
      modalOptions: {
        parent: this,
        hasModalCard: true,
        trapFocus: true,
      },
    };
  },
  computed: {
    ...mapState('category', ['categories']),
  },
  created() {
    this.updateCategories(this.initCategories);
  },
  methods: {
    newCategory() {
      this.$buefy.modal.open({
        ...this.modalOptions,
        component: CategoryNew,
      });
    },
    editCategory(id, initName) {
      this.$buefy.modal.open({
        ...this.modalOptions,
        component: CategoryEdit,
        props: { id, initName },
      });
    },
    deleteCategory(id, name) {
      this.$buefy.modal.open({
        ...this.modalOptions,
        component: CategoryDelete,
        props: { id, name },
      });
    },
    ...mapMutations('category', ['updateCategories']),
  },
};
</script>
