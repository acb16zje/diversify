<template>
  <section class="section pt-0">
    <div class="container">
      <div class="flex items-center justify-between pb-4">
        <h4 class="title is-4 m-0">
          Skills
        </h4>

        <button class="button is-success" @click="newSkill">
          New skill
        </button>
      </div>


      <b-table
        :data="skills"
        :paginated="true"
        :pagination-simple="true"
        :per-page="10"
        :hoverable="true"
        default-sort="id"
      >
        <template v-slot="{ row: { id, name, category_name } }">
          <b-table-column field="id" label="ID" sortable>
            {{ id }}
          </b-table-column>

          <b-table-column field="name" label="Name" sortable searchable>
            {{ name }}
          </b-table-column>

          <b-table-column field="category_name" label="Category" sortable searchable>
            {{ category_name }}
          </b-table-column>

          <b-table-column label="Action">
            <div class="buttons">
              <b-button type="is-link" outlined @click="editSkill(id, name, category_name)">
                Edit
              </b-button>
              <b-button type="is-danger" @click="deleteSkill(id, name)">
                Delete
              </b-button>
            </div>
          </b-table-column>
        </template>

        <template v-slot:empty>
          <div class="content has-text-grey has-text-centered">
            <p>No skills</p>
          </div>
        </template>
      </b-table>
    </div>
  </section>
</template>

<script>
import { mapMutations, mapState } from 'vuex';
import SkillNew from './components/SkillNew.vue';
import SkillEdit from './components/SkillEdit.vue';
import SkillDelete from './components/SkillDelete.vue';

export default {
  props: {
    initSkills: {
      type: Array,
      required: true,
    },
    categories: {
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
    ...mapState('skill', ['skills']),
  },
  created() {
    this.updateCategories(this.categories);
    this.updateSkills(this.initSkills);
  },
  methods: {
    newSkill() {
      this.$buefy.modal.open({
        ...this.modalOptions,
        component: SkillNew,
      });
    },
    editSkill(id, initName, initCategoryName) {
      const initCategoryId = this.categories.find((e) => e.name === initCategoryName).id;

      this.$buefy.modal.open({
        ...this.modalOptions,
        component: SkillEdit,
        props: { id, initName, initCategoryId },
      });
    },
    deleteSkill(id, name) {
      this.$buefy.modal.open({
        ...this.modalOptions,
        component: SkillDelete,
        props: { id, name },
      });
    },
    ...mapMutations('category', ['updateCategories']),
    ...mapMutations('skill', ['updateSkills']),
  },
};
</script>
