<template>
  <b-table
    :data="data"
    :paginated="true"
    :hoverable="true"
    :row-class="() => rowClass"
    :per-page="10"
    :default-sort="defaultSort"
    @click="(row) => $emit('row-clicked', row)"
  >
    <template v-slot:default="props">
      <slot name="columns" :row="props.row" />
    </template>

    <template v-slot:empty>
      <div class="content has-text-grey has-text-centered">
        <p>No data</p>
      </div>
    </template>
  </b-table>
</template>

<script>
export default {
  props: {
    data: {
      type: Array,
      required: true,
    },
    rowClass: {
      type: String,
      required: false,
      default: null,
    },
    defaultSort: {
      type: Array,
      required: false,
      default: null,
    },
  },
};
</script>
