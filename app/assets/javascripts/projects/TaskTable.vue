<template>
  <section>
    <b-select v-model="type">
      <option value="self">
        Tasks Assigned
      </option>
      <option value="unassigned">
        Unassigned Tasks
      </option>
      <option value="active">
        Active Tasks
      </option>
      <option value="completed">
        Completed Tasks
      </option>
    </b-select>
    <b-table
      :data="data"
      :paginated="true"
      :hoverable="true"
      :per-page="10"
      :mobile-cards="true"
      :loading="isLoading"
      detailed
      detail-key="id"
    >
      <template v-slot="{ row: { id, name, percentage, owner_name, owner_id } }">
        <b-table-column field="name" label="Name" sortable searchable>
          {{ name }}
        </b-table-column>
        <b-table-column field="owner" label="Owner" sortable searchable>
          <a :href="`/users/${owner_id}`" class="has-text-weight-bold">
            {{ owner_name }}
          </a>
        </b-table-column>
        <b-table-column field="percentange" label="Progress">
          <b-progress
            :type="percentage === 100 ? 'is-success' : 'is-info'"
            :value="percentage"
            show-value format="percent"
          />
        </b-table-column>
        <b-table-column field="assignees" label="Assignees">
          <div class="columns is-0 is-variable is-multiline">
            <div v-for=" user in userData[id]" :key="user.user_id" class="column is-narrow">
              <b-tooltip :label="user.user_name" position="is-top" type="is-info">
                <a :href="`/users/${user.user_id}`">
                  <p class="image is-32x32 user-avatar-container">
                    <img :src="images[user.user_id]">
                  </p>
                </a>
              </b-tooltip>
            </div>
          </div>
        </b-table-column>
      </template>
      <template v-slot:empty>
        <div class="content has-text-grey has-text-centered">
          <p>No Tasks</p>
        </div>
      </template>
      <template slot="detail" slot-scope="{ row : { id, description, percentage} }">
        <div class="columns">
          <div class="column is-8">
            {{ description }}
          </div>
          <div class="column is-4">
            <div class="box">
              <a :href="'/projects/'+projectId+'/tasks/'+id+'/edit'" class="button is-warning">
                Edit Task
              </a>
              <b-field label="Set Progress">
                <b-slider :value="percentage" :min="0" :max="100" :step="10" ticks @change="updateProgress($event, id)" />
              </b-field>
            </div>
          </div>
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
    projectId: {
      type: String,
      required: true,
    },
  },
  data() {
    return {
      data: [],
      userData: [],
      images: [],
      isLoading: false,
      type: 'self',
    };
  },
  created() {
    this.getData();
  },
  methods: {
    getData() {
      this.isLoading = true;
      Rails.ajax({
        url: `/projects/${this.projectId}/tasks/data`,
        type: 'GET',
        data: new URLSearchParams({
          types: this.type,
        }),
        success: (data) => {
          this.data = data.data;
          this.userData = data.user_data;
          this.images = data.images;
          this.isLoading = false;
        },
      });
    },
    updateProgress(e, id) {
      Rails.ajax({
        url: `/projects/${this.projectId}/tasks/${id}/set_percentage`,
        type: 'PATCH',
        data: new URLSearchParams({
          'task[percentage]': e,
        }),
        success: () => {
          this.data[id - 1].percentage = e;
        },
      });
    },
  },
};
</script>
