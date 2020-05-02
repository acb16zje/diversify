<template>
  <section class="section">
    <div>
      <b-select v-model="type" @input="getData">
        <option value="assigned">
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
    </div>
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
      <template v-slot="{ row: { id, name, percentage, priority, owner_name, user_id } }">
        <b-table-column field="name" label="Name" sortable searchable>
          {{ name }}
        </b-table-column>
        <b-table-column field="owner" label="Owner" sortable>
          <a :href="`/users/${user_id}`" class="has-text-weight-bold">
            {{ owner_name }}
          </a>
        </b-table-column>
        <b-table-column field="priority" label="Priority" :custom-sort="sortPriority" sortable>
          <span class="priority">
            <span :class="[priority.toLowerCase(), 'priority-colour']" />
            {{ priority }}
          </span>
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
      <template slot="detail" slot-scope="{ row : { id, description, percentage, skill_names, user_id } }">
        <div class="columns">
          <div class="column is-8">
            <div v-if="skill_names != null" class="tags are-medium">
              <label class="label">Skills:  </label>
              <span v-for=" skill in skill_names.split(',')" :key="skill" class="tag is-primary">
                {{ skill }}
              </span>
            </div>
            {{ description }}
          </div>
          <div class="column is-4">
            <div v-if="canEdit(user_id) || inTask(id)" class="box">
              <a v-if="canEdit(user_id)" :href="'/projects/'+projectId+'/tasks/'+id+'/edit'" class="button is-warning">
                Edit Task
              </a>
              <a v-if="canEdit(user_id)" class="button is-danger" data-confirm="Are you sure?" @click="deleteTask(id)">
                Delete Task
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
    admin: {
      type: String,
      required: true,
    },
    userId: {
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
      type: 'assigned',
    };
  },
  created() {
    this.getData();
  },
  methods: {
    canEdit(ownerId) {
      return (parseInt(this.userId, 10) === ownerId || this.admin === 'true');
    },
    inTask(id) {
      return (id in this.userData
        && (this.userData[id].findIndex((u) => u.user_id === parseInt(this.userId, 10)) !== -1));
    },
    getData() {
      this.isLoading = true;
      Rails.ajax({
        url: `/projects/${this.projectId}/tasks/data`,
        type: 'GET',
        data: new URLSearchParams({
          type: this.type,
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
          successToast('Progress Updated');
          const dataPos = this.data.findIndex((u) => u.id === id);
          this.data[dataPos].percentage = e;
        },
      });
    },
    sortPriority(a, b, isAsc) {
      if (a.priority === b.priority) {
        return 0;
      }
      if (a.priority === 'High' || (a.priority === 'Medium' && b.priority === 'Low')) {
        return isAsc ? 1 : -1;
      }
      return isAsc ? -1 : 1;
    },
    deleteTask(id) {
      Rails.ajax({
        url: `/projects/${this.projectId}/tasks/${id}`,
        type: 'DELETE',
        success: () => {
          successToast('Task Deleted');
          this.data = this.data.filter((x) => x.id !== id);
        },
        error: ({ message }) => {
          dangerToast(message);
        },
      });
    },
  },
};
</script>
