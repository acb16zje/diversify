<template>
  <div v-if="teamCount > 0">
    <div v-for="team in teams" :id="team.id" :key="team.id" class="container">
      <p class="is-size-3">
        {{ team.name }}
      </p>
      <div v-if="data[team.id].length===0" class="content has-text-grey has-text-centered">
        <p>No Members</p>
      </div>
      <draggable class="columns is-multiline" :list="data[team.id]" group="people">
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


  },
};
</script>
