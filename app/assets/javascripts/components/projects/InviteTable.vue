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
          <a data-confirm="Are you sure?" @click="cancelInvite(props.row)">
            Cancel Invite
          </a>
        </b-table-column>
      </template>
      <template v-slot:empty>
        <div class="content has-text-grey has-text-centered">
          <p>No Invites</p>
        </div>
      </template>
    </b-table>
    <b-field>
      <b-input v-model="email" placeholder="Email" @keyup.native.enter="invite"/>
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
  props: {
    projectId: {
      type: String,
      required: true,
    },
  },
  data() {
    return {
      data: [],
      email: '',
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
        type: 'GET',
        data: new URLSearchParams({
          types: 'invite',
        }),
        success: (data) => {
          this.isLoading = false;
          this.data = data.data;
        },
      });
    },
    cancelInvite(row) {
      Rails.ajax({
        url: `/invites/${row.invite_id}`,
        type: 'DELETE',
        data: new URLSearchParams({
          user_id: row.id,
          project_id: this.projectId,
          types: 'invite',
        }),
        success: () => {
          successToast('Invite Canceled');
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
    invite() {
      Rails.ajax({
        url: '/invites',
        type: 'POST',
        data: new URLSearchParams({
          user_id: this.email,
          project_id: this.projectId,
          types: 'invite',
        }),
        success: (data) => {
          successToast(data.message);
          this.data.push({ email: data.email, id: data.id, invite_id: data.invite_id });
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
