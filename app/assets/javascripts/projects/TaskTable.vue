<template>
  <section>
    <b-select v-model="type">
      <option value="self">
        Tasks Assigned
      </option>
      <option value="unassigned">
        Unassigned Tasks
      </option>
      <option value="active">
        Active Tasks
      </option>
      <option value="completed">
        Completed Tasks
      </option>
    </b-select>
    <b-table
      :data="data"
      :paginated="true"
      :hoverable="true"
      :per-page="10"
      :mobile-cards="true"
      :loading="isLoading"
      detailed
      detail-key="id"
    >
      <template v-slot="{ row: { id, name, percentage } }">
        <b-table-column field="name" label="Name" sortable searchable>
          {{ name }}
        </b-table-column>
        <b-table-column field="owner" label="Owner" sortable searchable>
          <a :href="`/users/${userData[id][0].user_id}`">
            <div class="columns is-vcentered is-1 is-variable">
              <div class="column is-narrow">
                <p class="image is-32x32 user-avatar-container">
                  <img :src="images[userData[id][0].user_id]">
                </p>
              </div>
              <div class="column">
                {{ userData[id][0].user_name }}
              </div>
            </div>
          </a>
        </b-table-column>
        <b-table-column field="percentange" label="Percentage">
          <b-progress
            :type="percentage === 100 ? 'is-success' : 'is-primary'"
            :value="percentage"
            show-value format="percent"
          />
        </b-table-column>
        <b-table-column field="assignees" label="Assignees">
          <div class="columns is-0 is-variable is-multiline">
            <div v-for=" user in userData[id].slice(1,userData[id].length)" :key="user.user_id" class="column is-narrow">
              <b-tooltip :label="user.user_name" position="is-top" type="is-info">
                <a :href="`/users/${user.user_id}`">
                  <p class="image is-32x32 user-avatar-container">
                    <img :src="images[user.user_id]">
                  </p>
                </a>
              </b-tooltip>
            </div>
          </div>
        </b-table-column>
      </template>
      <template v-slot:empty>
        <div class="content has-text-grey has-text-centered">
          <p>No Tasks</p>
        </div>
      </template>
      <template slot="detail" slot-scope="{ row : { id, description } }">
        <div class ="columns">
          <div class="column">
            {{ description }}
          </div>
          <div class="column is-narrow">
            <a :href="'/projects/'+projectId+'/tasks/'+id+'/edit'" class="button is-warning">
              Edit Task
            </a>
            <b-button type="is-success">
              Complete
            </b-button>
          </div>
        </div>
      </template>
    </b-table>
  </section>
</template>

<script>
import Rails from '@rails/ujs';
import { dangerToast, successToast } from '../buefy/toast';

export default {
  props: {
    projectId: {
      type: String,
      required: true,
    },
  },
  data() {
    return {
      data: [],
      userData: [],
      images: [],
      isLoading: false,
      type: 'self',
    };
  },
  created() {
    this.getData();
  },
  methods: {
    getData() {
      this.isLoading = true;
      Rails.ajax({
        url: `/projects/${this.projectId}/tasks/data`,
        type: 'GET',
        data: new URLSearchParams({
          types: this.type,
        }),
        success: (data) => {
          this.data = data.data;
          this.userData = data.user_data;
          this.images = data.images;
          this.isLoading = false;
        },
      });
    },
    decline(row) {
      Rails.ajax({
        url: `/invites/${row.invite_id}`,
        type: 'DELETE',
        data: new URLSearchParams({
          user_id: row.id,
          project_id: this.projectId,
          types: 'application',
        }),
        success: () => {
          successToast('Application Declined');
          this.data = this.data.filter((x) => x !== row);
        },
        error: (data) => {
          if (Array.isArray(data.message)) {
            data.message.forEach((message) => dangerToast(message));
          } else {
            dangerToast(data.message || data.status);
          }
        },
      });
    },
    accept(row) {
      Rails.ajax({
        url: `/invites/accept`,
        type: 'POST',
        data: new URLSearchParams({
          user_id: row.id,
          project_id: this.projectId,
        }),
        success: () => {
          successToast('Application Accepted');
          this.data = this.data.filter((x) => x !== row);
        },
        error: (data) => {
          if (Array.isArray(data.message)) {
            data.message.forEach((message) => dangerToast(message));
          } else {
            dangerToast(data.message || data.status);
          }
        },
      });
    },
  },
};
</script>
