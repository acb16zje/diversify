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
    >
      <template v-slot="props">
        <b-table-column field="name" label="Name" sortable searchable>
          {{ props.row.name }}
        </b-table-column>
      </template>
      <template v-slot:empty>
        <div class="content has-text-grey has-text-centered">
          <p>No Tasks</p>
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
