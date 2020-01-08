<template>
  <DataTable
    :original-data="JSON.parse(originalData)"
    :row-class="'pointer'"
    @row-clicked="rowClicked"
  >
    <template v-slot:columns="slotProps">
      <b-table-column field="title" label="Title" sortable searchable>
        {{ slotProps.row.title }}
      </b-table-column>

      <b-table-column field="created_at" label="Date" sortable searchable>
        {{ slotProps.row.created_at }}
      </b-table-column>
    </template>
  </DataTable>
</template>

<script>
import DataTable from './DataTable.vue';
import Modal from './Modal.vue';

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
