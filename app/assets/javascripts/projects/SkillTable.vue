<template>
  <section>
    <b-table
      :data="skills"
      :paginated="true"
      :hoverable="true"
      :per-page="10"
      :mobile-cards="true"
    >
      <template v-slot="{ row }">
        <b-table-column field="name" label="Name" sortable searchable>
          {{ row.name }}
        </b-table-column>
        <b-table-column field="category" label="Category" sortable searchable>
          {{ row.category_name }}
        </b-table-column>
        <b-table-column field="time" label="Added At">
          {{ dateConvert(row.created_at) }}
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
    initialData: {
      type: String,
      required: true,
    },
  },
  data() {
    return {
      skills: JSON.parse(this.initialData),
    };
  },
  methods: {
    dateConvert(str) {
      const d = new Date(str);
      return d.toLocaleDateString();
    },
  },
};

</script>
