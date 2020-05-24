<template>
  <div>
    <b-loading :is-full-page="false" :active.sync="isLoading" />
    <div class="sticky box">
      <p class="has-text-grey">
        Computing Compatibility might take up to 1 minute depending on project size.
      </p>
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
            <b-button class="button is-primary" @click="suggest">
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
      <div v-if="changed.length !== 1" class="container">
        <p class="has-text-weight-medium">
          <span class="iconify is-24" data-icon="twemoji:warning" />
          Recompute the compatibility for current changes.
        </p>
        <b-button class="button is-danger" @click="compute">
          Recompute Compatibility
        </b-button>
      </div>
    </div>

    <div v-for="team in teams" :key="team.id" class="container">
      <b-collapse ref="collapse" animation="slide" :aria-id="team.id.toString()">
        <div
          slot="trigger"
          role="button"
          class="content"
          :aria-controls="team.id.toString()"
        >
          <div class="columns">
            <div class="column">
              <p class="title is-3">
                <b-icon icon="menu-down" />
                {{ team.name }}
              </p>
            </div>
            <div v-if="team.name !== 'Unassigned'" class="column is-narrow">
              <span :class="[data[team.id].length === team.team_size ? 'has-background-warning has-text-weight-medium' : 'has-text-primary', 'tag is-medium']">
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
        </div>
        <div v-if="data[team.id].length===0" class="content has-text-grey has-text-centered">
          <p>No Members</p>
        </div>
        <draggable :id="team.id" :list="data[team.id]" group="people" class="columns is-mobile is-multiline" :move="checkMove" :scroll-sensitivity="250" :force-fallback="true" @change="log">
          <div
            v-for="element in data[team.id]"
            :key="element.email"
            class="column is-one-third-tablet is-one-quarter-desktop"
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
                </p>
                <a class="card-header-icon">
                  <b-tooltip v-if="element.id === parseInt(projectOwner, 10)" animated label="Owner" position="is-top">
                    <b-icon icon="account" size="is-medium" type="is-info" />
                  </b-tooltip>
                  <b-icon icon="menu-down" />
                </a>
              </div>
              <div class="card-content">
                <unassign-content v-if="team.name === 'Unassigned'" :ref="element.id" :count="element.count" :recommendation="compatibility[element.id]" />
                <assigned-content v-else :ref="element.id" :count="element.count" :score="compatibility[element.id]" />
              </div>
              <footer v-if="element.id != parseInt(projectOwner, 10)" class="card-footer">
                <a href="#" class="card-footer-item" @click="removeUser(team.id, element.id)">Remove from Project</a>
              </footer>
            </b-collapse>
          </div>
        </draggable>
      </b-collapse>
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
    unassignedId: {
      type: String,
      required: true,
    },
  },
  data() {
    return {
      currentToggleState: true,
      changed: [this.unassignedId],
      compatibility: {},
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
      Object.keys(this.compatibility).forEach((key) => {
        const list = this.$refs[key];
        for (let i = 0; i < list.length; i += 1) {
          list[i].toggle(false);
        }
      });
    },
    checkMove(evt) {
      const targetId = +evt.to.id;
      const selectedTeam = this.teams.find((o) => o.id === targetId);
      if (this.data[targetId].length === selectedTeam.team_size) {
        return false;
      }
      if (!this.changed.includes(evt.from.id)) { this.changed.push(evt.from.id); }
      if (!this.changed.includes(evt.to.id)) { this.changed.push(evt.to.id); }
      return true;
    },
    log(evt) {
      if (Object.prototype.hasOwnProperty.call(evt, 'added')) {
        const list = this.$refs[evt.added.element.id];
        for (let i = 0; i < list.length; i += 1) {
          list[i].toggle(true);
        }
        successToast(`${evt.added.element.name} Moved`);
      }
    },
    send() {
      this.isLoading = true;
      Rails.ajax({
        url: `/projects/${this.projectId}/manage/`,
        type: 'POST',
        data: new URLSearchParams({
          data: JSON.stringify(this.data),
        }),
        success: ({ data }) => {
          this.data = data;
          this.isLoading = false;
          console.log(data);
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
        url: `/projects/${this.projectId}/manage/manage_data`,
        type: 'GET',
        success: ({ compatibility, data, teams }) => {
          console.log(compatibility);
          this.isLoading = false;
          const newData = data;
          this.teams = teams;
          this.compatibility = compatibility;
          this.teams.forEach((team) => {
            if (!(team.id in data)) {
              newData[team.id] = [];
            }
          });
          this.data = newData;
          this.changed = [this.unassignedId];
        },
      });
    },
    compute() {
      this.isLoading = true;
      let changedData = {};
      if (this.changed.length === 1) {
        changedData = this.data;
      } else {
        Object.keys(this.data).forEach((key) => {
          if (this.changed.includes(key)) {
            changedData[key] = this.data[key];
          }
        });
      }
      Rails.ajax({
        url: `/projects/${this.projectId}/manage/recompute_data`,
        type: 'POST',
        data: new URLSearchParams({
          data: JSON.stringify(changedData),
        }),
        success: ({ compatibility }) => {
          Object.keys(compatibility).forEach((key) => {
            this.compatibility[key] = compatibility[key];
            const list = this.$refs[key];
            for (let i = 0; i < list.length; i += 1) {
              list[i].toggle(false);
            }
          });
          this.isLoading = false;
          this.changed = [this.unassignedId];
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
        url: `/projects/${this.projectId}/manage/remove_user`,
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
    suggest() {
      this.isLoading = true;
      Rails.ajax({
        url: `/projects/${this.projectId}/manage/suggest`,
        type: 'GET',
        success: ({ data }) => {
          console.log(data);
          this.data = data;
          this.changed = [this.unassignedId];
          this.compute();
        },
      });
    },
  },
};
</script>
