<template>
  <section>
    <b-table
      :data="initialSkills"
      :paginated="true"
      :pagination-simple="true"
      :hoverable="true"
      :per-page="10"
      :mobile-cards="true"
    >
      <template v-slot="{ row: { name, category_name, created_at } }">
        <b-table-column field="name" label="Name" sortable searchable>
          {{ name }}
        </b-table-column>
        <b-table-column field="category_name" label="Category" sortable searchable>
          {{ category_name }}
        </b-table-column>
        <b-table-column label="Added At">
          {{ new Date(created_at).toLocaleDateString() }}
        </b-table-column>
      </template>
      <template v-slot:empty>
        <div class="content has-text-grey has-text-centered">
          <p>No Skills</p>
        </div>
      </template>
    </b-table>
  </section>
</template>

<script>
export default {
  props: {
    initialSkills: {
      type: Array,
      required: true,
    },
  },
};
</script>
