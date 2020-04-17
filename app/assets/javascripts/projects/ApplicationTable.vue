<template>
  <section>
    <b-table
      :data="applications"
      :paginated="true"
      :hoverable="true"
      :per-page="10"
      :mobile-cards="true"
      :loading="isLoading"
    >
      <template v-slot="{ row: { id, user_id, user_email } }">
        <b-table-column field="email" label="Email" sortable searchable>
          <a :href="`/users/${user_id}`">{{ user_email }}</a>
        </b-table-column>

        <b-table-column label="Action" centered>
          <div class="buttons has-addons is-centered">
            <button data-confirm="Are you sure?" class="button is-success" @click="accept(id)">
              Accept
            </button>
            <button data-confirm="Are you sure?" class="button is-danger" @click="decline(id)">
              Decline
            </button>
          </div>
        </b-table-column>
      </template>

      <template v-slot:empty>
        <div class="content has-text-grey has-text-centered">
          <p>No applications</p>
        </div>
      </template>
    </b-table>
  </section>
</template>

<script>
import Rails from '@rails/ujs';
import { dangerToast, successToast } from '../buefy/toast';

export default {
  data() {
    return {
      applications: [],
      isLoading: false,
    };
  },
  created() {
    this.getApplications();
  },
  methods: {
    getApplications() {
      this.isLoading = true;
      Rails.ajax({
        url: `${window.location.pathname}/applications`,
        type: 'GET',
        success: ({ applications }) => {
          this.applications = applications;
        },
        complete: () => {
          this.isLoading = false;
        },
      });
    },
    accept(id) {
      Rails.ajax({
        url: `/applications/${id}/accept`,
        type: 'POST',
        success: () => {
          successToast('Application accepted');
          this.applications = this.applications.filter((x) => x.id !== id);
        },
        error: ({ message }) => {
          dangerToast(message);
        },
      });
    },
    decline(id) {
      Rails.ajax({
        url: `/applications/${id}`,
        type: 'DELETE',
        success: () => {
          successToast('Application deleted');
          this.applications = this.applications.filter((x) => x.id !== id);
        },
        error: ({ message }) => {
          dangerToast(message);
        },
      });
    },
  },
};
</script>
