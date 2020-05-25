<template>
  <b-table
    :data="data"
    :paginated="true"
    :hoverable="true"
    :per-page="10"
  >
    <template v-slot="{ row }">
      <b-table-column field="email" label="Email" sortable searchable>
        {{ row.email }}
      </b-table-column>

      <b-table-column field="created_at" label="Date Subscribed" sortable searchable>
        {{
          new Date(row.created_at).toLocaleString('en-GB', {
            day: 'numeric',
            month: 'long',
            year: 'numeric',
          })
        }}
      </b-table-column>

      <b-table-column label="Action" centered>
        <a data-confirm="Are you sure?" @click="unsubscribeUser(row)">
          Unsubscribe
        </a>
      </b-table-column>
    </template>

    <template v-slot:empty>
      <div class="content has-text-grey has-text-centered">
        <p>No data</p>
      </div>
    </template>
  </b-table>
</template>

<script>
import Rails from '@rails/ujs';
import { successToast } from '../../buefy/toast';

export default {
  props: {
    initialData: {
      type: String,
      required: true,
    },
  },
  data() {
    return {
      data: JSON.parse(this.initialData),
    };
  },
  methods: {
    unsubscribeUser(row) {
      Rails.ajax({
        url: '/newsletters/unsubscribe',
        type: 'POST',
        data: new URLSearchParams({
          'newsletter_unsubscription[reasons][]': 'admin',
          'newsletter_unsubscription[email]': row.email,
        }),
        success: () => {
          successToast('Email unsubscribed');
          this.data = this.data.filter((x) => x !== row);
        },
      });
    },
  },
};
</script>
