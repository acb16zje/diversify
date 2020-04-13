<template>
  <div v-if="teamCount > 0">
    <div class="buttons">
      <b-button class="button is-success" @click="send">
        Save
        <span class="icon">
          <span class="iconify" data-icon="cil:save" />
        </span>
      </b-button>
      <b-button class="button is-info" @click="reset">
        Reset
        <span class="icon">
          <span class="iconify" data-icon="bx:bx-reset" />
        </span>
      </b-button>
    </div>
    <div v-for="team in teams" :id="team.id" :key="team.id" class="container">
      <p class="is-size-3">
        {{ team.name }}
      </p>
      <div v-if="data[team.id].length===0" class="content has-text-grey has-text-centered">
        <p>No Members</p>
      </div>
      <draggable class="columns is-multiline" :list="data[team.id]" group="people" @change="log">
        <div
          v-for="element in data[team.id]"
          :key="element.id"
          class="column is-one-third"
        >
          <div class="card user-card">
            <header class="card-header">
              <p class="card-header-title">
                {{ element.name }} ({{ element.email }})
              </p>
            </header>
            <div class="card-content">
              <nav class="level">
                <div class="level-item has-text-centered">
                  <div>
                    <p class="heading">
                      Tasks
                    </p>
                    <p class="title">
                      -
                    </p>
                  </div>
                </div>
                <div class="level-item has-text-centered">
                  <div>
                    <p class="heading">
                      Compability
                    </p>
                    <p class="title">
                      -
                    </p>
                  </div>
                </div>
              </nav>
            </div>
            <footer class="card-footer">
              <a href="#" class="card-footer-item">Remove from Project</a>
            </footer>
          </div>
        </div>
      </draggable>
    </div>
    <div v-if="teamCount === 0">
      No Teams
    </div>
  </div>
</template>
<script>
import draggable from 'vuedraggable';
import Rails from '@rails/ujs';
import { successToast } from '../buefy/toast';

export default {
  components: {
    draggable,
  },
  props: {
    projectId: {
      type: String,
      required: true,
    },
    originalData: {
      type: String,
      required: true,
    },
    originalTeams: {
      type: String,
      required: true,
    },
  },
  data() {
    return {
      data: JSON.parse(this.originalData),
      teams: JSON.parse(this.originalTeams),
      isLoading: false,
      teamCount: 0,
    };
  },
  created() {
    this.teamCount = Object.keys(this.teams).length;
  },
  methods: {
    reset() {
      this.data = JSON.parse(this.originalData);
    },
    log(evt) {
      if (Object.prototype.hasOwnProperty.call(evt, 'added')) {
        successToast(`${evt.added.element.name} Moved`);
      }
    },
    send() {
      console.log('send');
      Rails.ajax({
        url: '/teams/save_manage',
        type: 'POST',
        data: new URLSearchParams({
          data: JSON.stringify(this.data),
          project_id: this.projectId,
        }),
        success: () => {
          successToast('Saved!');
        },
      });
    },
  },
};
</script>
