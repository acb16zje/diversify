<template>
  <section>
    <b-table
      :data="data"
      :paginated="true"
      :hoverable="true"
      :per-page="10"
    >
      <template v-slot="props">
        <b-table-column field="user" label="Username" sortable searchable>
          {{ props.row.name }}
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
      <b-input v-model="username" placeholder="Username" />
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
    originalData: {
      type: String,
      required: true,
    },
    projectId: {
      type: String,
      required: true,
    },
  },
  data() {
    return {
      data: JSON.parse(this.originalData),
      username: '',
    };
  },
  methods: {
    cancelInvite(row) {
      Rails.ajax({
        url: `/applications/${row.id}`,
        type: 'DELETE',
        data: new URLSearchParams({
          types: 'Invite',
        }),
        success: () => {
          successToast('Invite Canceled');
          this.data = this.data.filter((x) => x !== row);
        },
      });
    },
    invite() {
      Rails.ajax({
        url: '/applications',
        type: 'POST',
        data: new URLSearchParams({
          user_id: this.username,
          project_id: this.projectId,
          types: 'Invite',
        }),
        success: (data) => {
          successToast(data.message);
          this.data.push({ name: data.name, id: data.id });
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
