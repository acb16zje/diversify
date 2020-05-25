<template>
  <section>
    <b-table
      :data="invitations"
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
          <a data-confirm="Are you sure?" @click="cancelInvite(id)">
            Cancel Invite
          </a>
        </b-table-column>
      </template>

      <template v-slot:empty>
        <div class="content has-text-grey has-text-centered">
          <p>No invitations</p>
        </div>
      </template>
    </b-table>

    <b-field>
      <b-input v-model="email" placeholder="Email" @keyup.native.enter="invite" />
      <p class="control">
        <b-button class="button is-primary" @click="invite">
          Invite
        </b-button>
      </p>
    </b-field>
  </section>
</template>

<script>
import Rails from '@rails/ujs';
import { dangerToast, successToast } from '../buefy/toast';

export default {
  data() {
    return {
      invitations: [],
      email: '',
      isLoading: false,
    };
  },
  created() {
    this.getInvitations();
  },
  methods: {
    getInvitations() {
      this.isLoading = true;
      Rails.ajax({
        url: `${window.location.pathname}/invitations`,
        type: 'GET',
        success: ({ invitations }) => {
          this.invitations = invitations;
        },
        complete: () => {
          this.isLoading = false;
        },
      });
    },
    invite() {
      Rails.ajax({
        url: `${window.location.pathname}/invitations`,
        type: 'POST',
        data: new URLSearchParams({
          email: this.email,
        }),
        success: ({ invitation }) => {
          successToast('Invitation sent');
          this.invitations.push({ ...invitation, user_email: this.email });
          this.email = '';
        },
        error: ({ message }) => {
          dangerToast(message);
        },
      });
    },
    cancelInvite(id) {
      Rails.ajax({
        url: `/invitations/${id}`,
        type: 'DELETE',
        success: () => {
          successToast('Invitation canceled');
          this.invitations = this.invitations.filter((x) => x.id !== id);
        },
        error: ({ message }) => {
          dangerToast(message);
        },
      });
    },
  },
};
</script>
