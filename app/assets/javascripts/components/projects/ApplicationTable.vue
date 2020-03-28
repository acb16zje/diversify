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
          <a :href="'/users/'+ props.row.id">
            {{ props.row.name }}
          </a>
        </b-table-column>
        <b-table-column label="Action" centered>
          <a data-confirm="Are you sure?" class="button is-success" @click="accept(props.row)">
            Accept
          </a>
          <a data-confirm="Are you sure?" class="button is-danger" @click="decline(props.row)">
            Decline
          </a>
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
    decline(row) {
      Rails.ajax({
        url: `/applications/${row.id}`,
        type: 'DELETE',
        data: new URLSearchParams({
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
        url: `/applications/accept`,
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
