<template>
  <div class="modal-card">
    <header class="modal-card-head">
      <p class="modal-card-title">
        Add skills
      </p>
    </header>

    <section class="modal-card-body h-half-screen ">
      <b-field label="Filter by category">
        <CategoryDropdown v-model="category" />
      </b-field>

      <b-field label="Search and add skills">
        <b-autocomplete
          v-model="skill"
          :data="filteredDataObj"
          :open-on-focus="true"
          field="name"
          placeholder="Search skills"
          icon="magnify"
          clearable
          rounded
          @focus="initFocus"
          @select="option => addToPending(option)"
        >
          <template v-slot:empty>
            No results found
          </template>
        </b-autocomplete>
      </b-field>

      <b-field v-if="pendingSkills.length > 0" label="Pending skills">
        <b-field grouped group-multiline>
          <div v-for="({ id, name }) in pendingSkills" :key="id" class="control">
            <b-tag
              type="is-primary"
              aria-close-label="Close tag"
              attached
              closable
              @close="removeFromPending(id)"
            >
              {{ name }}
            </b-tag>
          </div>
        </b-field>
      </b-field>
    </section>

    <footer class="modal-card-foot justify-end">
      <b-button
        type="is-success"
        :loading="isSaving"
        :disabled="isSaving || pendingSkills.length === 0"
        @click="saveSkills"
      >
        Save
      </b-button>
      <b-button
        :loading="isSaving"
        :disabled="isSaving"
        @click="$parent.close()"
      >
        Cancel
      </b-button>
    </footer>
  </div>
</template>

<script>
import Rails from '@rails/ujs';
import { mapActions, mapMutations, mapState } from 'vuex';
import { dangerToast, successToast } from '../../buefy/toast';
import CategoryDropdown from '../../categories/components/CategoryDropdown.vue';

export default {
  components: { CategoryDropdown },
  data() {
    return {
      skill: '',
      pendingSkills: [],
      isSaving: false,
    };
  },
  computed: {
    category: {
      get() {
        return this.$store.state.skill.category;
      },
      set(value) {
        this.updateCategory(value);
      },
    },
    filteredDataObj() {
      return this.skillList.filter((option) => option.name.toLowerCase().indexOf(this.skill.toLowerCase()) >= 0
        && !this.pendingSkills.find(({ name }) => name === option.name));
    },
    ...mapState('skill', ['skillList']),
  },
  methods: {
    initFocus() {
      if (this.skillList.length === 0) {
        this.getSkills();
      }
    },
    addToPending(skill) {
      if (skill && !this.pendingSkills.find((e) => e === skill)) {
        this.pendingSkills.push(skill);
      }
    },
    removeFromPending(id) {
      this.pendingSkills = this.pendingSkills.filter((e) => e.id !== id);
    },
    saveSkills() {
      this.isSaving = true;

      const data = new FormData();
      this.pendingSkills.forEach(({ id }) => {
        data.append('skill[skill_ids][]', id);
      });

      Rails.ajax({
        url: '/settings/skills',
        type: 'POST',
        data,
        success: () => {
          successToast('Skills added');
          this.addUserSkills(this.pendingSkills);
          this.$parent.close();
        },
        error: () => {
          dangerToast('Failed to add some skills. Please check your input.');
        },
        complete: () => {
          this.isSaving = false;
        },
      });
    },
    ...mapActions('skill', ['updateCategory', 'getSkills']),
    ...mapMutations('skill', ['addUserSkills']),
  },
};
</script>
