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
    </b-table>
  </section>
</template>

<script>
import Rails from '@rails/ujs';
import { successToast } from '../buefy/toast';

export default {
  props: {
    originalData: {
      type: String,
      required: true,
    },
  },
  data() {
    return {
      data: JSON.parse(this.originalData),
    };
  },
  methods: {
    cancelInvite(row) {
      console.log(row);
      Rails.ajax({
        url: `/applications/${row.id}`,
        type: 'DELETE',
        data: {
          types: 'Invite'
        },
        success: () => {
          successToast('Invite Canceled');
          this.data = this.data.filter((x) => x !== row);
        },
      });
    },
  },
};
</script>
