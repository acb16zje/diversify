<template>
  <div>
    <div class="flex items-center justify-between pb-4">
      <h4 class="title is-4 m-0">
        Your skills
      </h4>

      <button class="button is-success" @click="addSkill">
        Add skills
      </button>
    </div>

    <p v-if="userSkills.length === 0" class="settings-message text-center">
      There are no skills added in your profile
    </p>
    <div v-else v-for="(skills, category, index) in categoryGroupedSkills" :key="index" class="content">
      <h5>{{ category }}</h5>

      <ul class="ml-0">
        <li v-for="({ id, name }) in skills" :key="id" class="flex justify-between">
          <p>{{ name }}</p>
          <b-button size="is-small" class="skill-delete" @click="deleteSkill(id, name)">
            Delete
          </b-button>
        </li>
      </ul>
    </div>
  </div>
</template>

<script>
import { mapValues, groupBy } from 'lodash-es';
import { mapMutations, mapState } from 'vuex';
import SkillAdd from './SkillAdd.vue';
import SkillDelete from './SkillDelete.vue';

export default {
  props: {
    initSkills: {
      type: Array,
      required: true,
    },
  },
  computed: {
    categoryGroupedSkills() {
      return mapValues(groupBy(this.userSkills, 'category_name'));
    },
    ...mapState('skill', ['userSkills']),
  },
  created() {
    this.updateUserSkills(this.initSkills);
  },
  methods: {
    addSkill() {
      this.$buefy.modal.open({
        parent: this,
        hasModalCard: true,
        trapFocus: true,
        component: SkillAdd,
      });
    },
    deleteSkill(id, name) {
      this.$buefy.modal.open({
        parent: this,
        hasModalCard: true,
        trapFocus: true,
        component: SkillDelete,
        props: { id, name },
      });
    },
    ...mapMutations('skill', ['updateUserSkills']),
  },
};
</script>
