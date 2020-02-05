<template>
  <b-table
    :data="JSON.parse(originalData)"
    :paginated="true"
    :hoverable="true"
    :per-page="10"
    :row-class="() => 'pointer'"
    :default-sort="['created_at', 'desc']"
    @click="rowClicked"
  >
    <template v-slot="props">
      <b-table-column field="title" label="Title" sortable searchable>
        {{ props.row.title }}
      </b-table-column>

      <b-table-column field="created_at" label="Date" sortable searchable>
        {{
          new Date(props.row.created_at).toLocaleString('en-GB', {
            day: 'numeric',
            month: 'long',
            year: 'numeric',
            hour: 'numeric',
            minute: '2-digit',
            hour12: true,
          })
        }}
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
import Modal from './Modal.vue';

export default {
  props: {
    originalData: {
      type: String,
      required: true,
    },
  },
  methods: {
    formatDate(dateString) {
      return new Date(dateString).toLocaleString('en-GB', {
        day: 'numeric',
        month: 'long',
        year: 'numeric',
        hour: 'numeric',
        minute: '2-digit',
        hour12: true,
      });
    },
    rowClicked(row) {
      this.$buefy.modal.open({
        parent: this,
        component: Modal,
        hasModalCard: true,
        trapFocus: true,
        scroll: 'keep',
        props: {
          row,
        },
      });
    },
  },
};
</script>
