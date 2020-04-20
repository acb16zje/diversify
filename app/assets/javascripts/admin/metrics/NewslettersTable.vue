<template>
  <b-table
    :data="JSON.parse(data)"
    :paginated="true"
    :hoverable="true"
    :per-page="10"
    :row-class="() => 'cursor-pointer'"
    :default-sort="['created_at', 'desc']"
    @click="rowClicked"
  >
    <template v-slot="{ row }">
      <b-table-column field="title" label="Title" sortable searchable>
        {{ row.title }}
      </b-table-column>

      <b-table-column field="created_at" label="Date" sortable searchable>
        {{
          new Date(row.created_at).toLocaleString('en-GB', {
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
      <div class="content has-text-grey text-center">
        <p>No data</p>
      </div>
    </template>
  </b-table>
</template>

<script>
import NewsletterModal from './NewsletterModal.vue';

export default {
  props: {
    data: {
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
        component: NewsletterModal,
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
