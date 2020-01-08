<template>
  <DataTable :data="JSON.parse(originalData)">
    <template v-slot:columns="slotProps">
      <b-table-column field="email" label="Email" sortable searchable>
        {{ slotProps.row.email }}
      </b-table-column>

      <b-table-column field="created_at" label="Date Subscribed" sortable searchable>
        {{ slotProps.row.created_at }}
      </b-table-column>

      <b-table-column label="Action" centered>
        <a data-confirm="Are you sure?" data-remote data-method="post"
           :href="'/newsletters/unsubscribe?newsletter_unsubscription[reasons][]=admin&newsletter_unsubscription[email]=' + slotProps.row.email"
           @ajax:success="unsubscribeSuccess(slotProps.row)"
        >
          Unsubscribe
        </a>
      </b-table-column>
    </template>
  </DataTable>
</template>

<script>
import { successToast } from '../buefy/toast';
import DataTable from './DataTable.vue';

export default {
  components: {
    DataTable,
  },
  props: {
    originalData: {
      type: String,
      required: true,
    },
  },
  methods: {
    unsubscribeSuccess(row) {
      successToast('Email unsubscribed');
      this.data = this.data.filter((x) => x !== row);
    },
  },
};
</script>
