<template>
  <section>
    <b-table
      :data="data"
      :paginated="true"
      :hoverable="true"
      :per-page="10"
      :mobile-cards="true"
      :loading="isLoading"
    >
      <template v-slot="props">
        <b-table-column field="email" label="Email" sortable searchable>
          <a :href="'/users/'+ props.row.id">
            {{ props.row.email }}
          </a>
        </b-table-column>
        <b-table-column label="Action" centered>
          <div class="buttons has-addons is-centered">
            <button data-confirm="Are you sure?" class="button is-success" @click="accept(props.row)">
              Accept
            </button>
            <button data-confirm="Are you sure?" class="button is-danger" @click="decline(props.row)">
              Decline
            </button>
          </div>
        </b-table-column>
      </template>
      <template v-slot:empty>
        <div class="content has-text-grey has-text-centered">
          <p>No Applications</p>
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
    };
  },
  created() {
    this.getData();
  },
  methods: {
    getData() {
      this.isLoading = true;
      Rails.ajax({
        url: `/projects/${this.projectId}/data`,
        type: 'POST',
        data: new URLSearchParams({
          types: 'Application',
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
          types: 'Application',
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
