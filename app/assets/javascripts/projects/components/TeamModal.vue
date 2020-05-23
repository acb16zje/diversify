<template>
  <div class="modal-card">
    <header class="modal-card-head">
      <p class="modal-card-title">
        {{ team.name }}
      </p>
    </header>

    <section class="modal-card-body content">
      <b-loading :is-full-page="false" :active.sync="isLoading" />
      <div v-if="team.name !== 'Unassigned'">
        <p class="has-text-weight-bold">
          Skills:
          <span v-if="skills.length === 0">
            No Skills
          </span>
        </p>
        <div class="tags are-medium">
          <span v-for="skill in skills" :key="skill.id" class="tag is-primary">
            {{ skill.name }}
          </span>
        </div>
        <p>
          <strong>Members:</strong> {{ members.length }} / {{ team.team_size }}
        </p>
      </div>
      <div v-else>
        <p>
          <strong>Unallocated Members:</strong> {{ members.length }}
        </p>
      </div>
      <div class="columns is-multiline">
        <div v-for="member in members" :key="member.id" class="column is-one-third">
          <article class="media">
            <div class="media-left">
              <p class="image is-32x32 user-avatar-container">
                <img :src="images[member.id]">
              </p>
            </div>
            <div class="media-content">
              <div class="content">
                <a :href="`/users/${member.id}`" class="has-text-weight-bold">
                  {{ member.name }}
                </a>
              </div>
            </div>
          </article>
        </div>
      </div>
    </section>
  </div>
</template>

<script>
import Rails from '@rails/ujs';

export default {
  props: {
    id: {
      type: Number,
      required: true,
    },
    projectId: {
      type: Number,
      required: true,
    },
  },
  data() {
    return {
      team: { name: '', team_size: '' },
      skills: [],
      members: [],
      isLoading: true,
      images: {},
    };
  },
  created() {
    Rails.ajax({
      url: `/projects/${this.projectId}/teams/${this.id}`,
      type: 'GET',
      success: (data) => {
        this.isLoading = false;
        this.skills = data.skill;
        this.team = data.team;
        this.members = data.member;
        this.images = data.images;
      },
    });
  },
};
</script>
