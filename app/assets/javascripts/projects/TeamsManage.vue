<template>
  <div>
    <b-loading :is-full-page="false" :active.sync="isLoading" />
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
      <b-button class="button is-link" @click="toggleCollapse">
        <span v-if="currentToggleState">Collapse All</span>
        <span v-else>Expand All</span>
      </b-button>
      <b-field>
        <p class="control">
          <b-button class="button is-primary">
            Suggest
            <span class="icon">
              <span class="iconify" data-icon="ic:outline-autorenew" />
            </span>
          </b-button>
        </p>
        <b-select placeholder="Team Preset">
          <option value="efficient">
            Efficient
          </option>
          <option value="cohesion">
            Cohesion
          </option>
          <option value="balance">
            Balance
          </option>
        </b-select>
      </b-field>
    </div>
    <div v-if="changed" class="container">
      <p class="has-text-grey">
        Recompute the compability for current changes.
      </p>
      <b-button class="button is-danger">
        Recompute Compability
      </b-button>
    </div>
    <div v-for="team in teams" :key="team.id" class="container">
      <div class="columns">
        <div class="column">
          <p>{{ team.name }}</p>
        </div>
        <div v-if="team.name !== 'Unassigned'" class="column is-narrow">
          <span :class="[data[team.id].length === team.team_size ? 'has-background-warning font-medium' : 'has-text-primary', 'tag is-medium']">
            <p>
              Members: {{ data[team.id].length }} / {{ team.team_size }}
            </p>
          </span>
        </div>
        <div v-if="team.name !== 'Unassigned'" class="column is-narrow">
          <div class="buttons has-addons">
            <a :href="'/projects/'+projectId+'/teams/'+team.id+'/edit'" class="button is-warning">
              Edit Team
            </a>
            <b-button class="button is-danger" @click="deleteTeam(team.id)">
              Delete Team
            </b-button>
          </div>
        </div>
      </div>
      <div v-if="data[team.id].length===0" class="content has-text-grey has-text-centered">
        <p>No Members</p>
      </div>
      <draggable :id="team.id" :list="data[team.id]" group="people" class="columns is-multiline" :move="checkMove" :scroll-sensitivity="250" :force-fallback="true" @change="log">
        <div
          v-for="element in data[team.id]"
          :key="element.email"
          class="column is-one-third"
        >
          <b-collapse ref="collapse" class="card user-card" animation="slide" :aria-id="element.email">
            <div
              slot="trigger"
              class="card-header"
              role="button"
              :aria-controls="element.email"
            >
              <p class="card-header-title">
                {{ element.name }} ({{ element.email }})
                <span v-if="element.id === projectOwner" class="tag is-info font-normal">
                  Owner
                </span>
              </p>
              <a class="card-header-icon">
                <b-icon icon="menu-down" />
              </a>
            </div>
            <div class="card-content">
              <unassign-content v-if="team.name === 'Unassigned'" :count="element.count" :team="compability[element.id]" />
              <assigned-content v-else-if="team.id !== element.team_id" :count="element.count" :score="''" />
              <assigned-content v-else :count="element.count" :score="compability[element.id]" />
            </div>
            <footer v-if="element.id !== projectOwner" class="card-footer">
              <a href="#" class="card-footer-item" @click="removeUser(team.id, element.id)">Remove from Project</a>
            </footer>
          </b-collapse>
        </div>
      </draggable>
    </div>
    <div v-if="teamCount === 1">
      No Teams
    </div>
  </div>
</template>

<script>
import draggable from 'vuedraggable';
import Rails from '@rails/ujs';
import { dangerToast, successToast } from '../buefy/toast';
import AssignedContent from './components/AssignedContent.vue';
import UnassignContent from './components/UnassignContent.vue';

export default {
  components: {
    draggable,
    AssignedContent,
    UnassignContent,
  },
  props: {
    projectId: {
      type: Number,
      required: true,
    },
    projectOwner: {
      type: Number,
      required: true,
    },
  },
  data() {
    return {
      currentToggleState: true,
      changed: false,
      compability: {},
      data: {},
      teams: {},
      isLoading: false,
      teamCount: 1,
    };
  },
  created() {
    this.query();
    this.teamCount = Object.keys(this.teams).length;
  },
  methods: {
    reset() {
      this.query();
    },
    checkMove(evt) {
      const targetId = +evt.to.id;
      const selectedTeam = this.teams.find((o) => o.id === targetId);

      return this.data[targetId].length !== selectedTeam.team_size;
    },
    log(evt) {
      if (Object.prototype.hasOwnProperty.call(evt, 'added')) {
        this.changed = true;
        successToast(`${evt.added.element.name} Moved`);
      }
    },
    send() {
      this.isLoading = true;
      Rails.ajax({
        url: `/projects/${this.projectId}/teams/manage`,
        type: 'POST',
        data: new URLSearchParams({
          data: JSON.stringify(this.data),
        }),
        success: () => {
          this.isLoading = false;
          successToast('Saved!');
        },
        error: ({ message }) => {
          this.isLoading = false;
          dangerToast(message);
        },
      });
    },
    query() {
      this.isLoading = true;
      Rails.ajax({
        url: `/projects/${this.projectId}/teams/manage_data`,
        type: 'GET',
        success: ({ compability, data, teams }) => {
          console.log(data);
          this.isLoading = false;
          const newData = data;
          this.teams = teams;
          this.compability = compability;
          this.teams.forEach((team) => {
            if (!(team.id in data)) {
              newData[team.id] = [];
            }
          });
          this.data = newData;
          this.changed = false;
        },
      });
    },
    deleteTeam(id) {
      Rails.ajax({
        url: `/projects/${this.projectId}/teams/${id}`,
        type: 'DELETE',
        success: () => {
          successToast('Team Deleted');
          const unassignedTeam = this.teams.find((o) => o.name === 'Unassigned');
          this.data[unassignedTeam.id] = this.data[unassignedTeam.id].concat(this.data[id]);
          this.teams = this.teams.filter((x) => x.id !== id);
          delete this.data[id];
        },
      });
    },
    removeUser(id, userId) {
      Rails.ajax({
        url: `/projects/${this.projectId}/teams/${id}/remove_user`,
        type: 'DELETE',
        data: new URLSearchParams({
          user_id: userId,
        }),
        success: () => {
          successToast('User Removed');
          this.data[id] = this.data[id].filter((x) => x.id !== userId);
        },
      });
    },
    toggleCollapse() {
      const list = this.$refs.collapse;
      for (let i = 0; i < list.length; i += 1) {
        if (list[i].isOpen === this.currentToggleState) {
          list[i].toggle();
        }
      }
      this.currentToggleState = !this.currentToggleState;
    },
  },
};
</script>
