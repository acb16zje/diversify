<template>
  <div>
    <b-loading :is-full-page="false" :active.sync="isLoading" />

    <div class="action-holder">
      <div>
        <slot name="action" />
      </div>

      <b-tabs v-model="type" type="is-toggle" @change="getData">
        <b-tab-item label="Assigned" value="assigned" />
        <b-tab-item label="Unassigned" value="unassigned" />
        <b-tab-item label="Active" value="active" />
        <b-tab-item label="Completed" value="completed" />
      </b-tabs>
    </div>

    <b-table
      :data="data"
      :per-page="10"
      :paginated="true"
      :hoverable="true"
      :mobile-cards="true"
      detailed
      detail-key="id"
    >
      <template v-slot="{ row: { id, name, percentage, priority, owner_id, owner_name, assignees } }">
        <b-table-column field="name" label="Name" sortable searchable>
          {{ name }}
        </b-table-column>
        <b-table-column field="owner_name" label="Owner" sortable>
          <a :href="`/users/${owner_id}`" class="font-bold">
            {{ owner_name }}
          </a>
        </b-table-column>
        <b-table-column field="priority" label="Priority" :custom-sort="sortPriority" sortable>
          <span class="priority capitalize">
            <span :class="[priority, 'priority-colour']" />
            {{ priority }}
          </span>
        </b-table-column>
        <b-table-column label="Progress">
          <b-progress
            :type="percentage === 100 ? 'is-success' : 'is-info'"
            :value="percentage"
            show-value format="percent"
          />
        </b-table-column>
        <b-table-column label="Assignees">
          <div class="columns is-0 is-variable is-multiline">
            <div v-for="assignee in assignees" :key="assignee.id" class="column is-narrow">
              <b-tooltip :label="assignee.name" position="is-top" type="is-info">
                <a :href="`/users/${assignee.id}`">
                  <p class="image is-32x32 user-avatar-container">
                    <img :src="assignee.icon">
                  </p>
                </a>
              </b-tooltip>
            </div>
          </div>
          <a v-if="!assignees.length && !completed" class="button is-small is-success" data-confirm="Are you sure?" @click="assignSelf(id)">
            Assign Self
          </a>
        </b-table-column>
      </template>
      <template v-slot:empty>
        <div class="content has-text-grey has-text-centered">
          <p>No tasks</p>
        </div>
      </template>
      <template v-slot:detail="{ row: { id, description, percentage, skills, owner_id, assignees } }">
        <div class="columns">
          <div class="column is-8">
            <label class="label">Skills</label>
            <div v-if="skills !== null" class="tags are-medium">
              <span v-for="skill in skills" :key="skill" class="tag is-primary">
                {{ skill }}
              </span>
            </div>
            {{ description }}
          </div>
          <div class="column is-4">
            <div v-if="canEdit(owner_id) || inTask(assignees)" class="box">
              <a v-if="canEdit(owner_id)" :href="`/projects/${projectId}/tasks/${id}/edit`" class="button is-warning">
                Edit Task
              </a>
              <a v-if="canEdit(owner_id)" class="button is-danger" data-confirm="Are you sure?" @click="deleteTask(id)">
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
  </div>
</template>

<script>
import Rails from '@rails/ujs';
import { dangerToast, successToast } from '../buefy/toast';

export default {
  props: {
    projectId: {
      type: Number,
      required: true,
    },
    admin: {
      type: Boolean,
      required: true,
    },
    userId: {
      type: Number,
      required: true,
    },
    completed: {
      type: Boolean,
      required: true,
    },
  },
  data() {
    return {
      data: [],
      isLoading: false,
      type: 'assigned',
    };
  },
  created() {
    this.getData();
  },
  methods: {
    canEdit(ownerId) {
      return (this.userId === ownerId || this.admin) && !this.completed;
    },
    inTask(assignees) {
      return !this.completed && assignees.find(({ id }) => id === this.userId);
    },
    getData() {
      this.isLoading = true;
      Rails.ajax({
        url: `/projects/${this.projectId}/tasks/data`,
        type: 'GET',
        data: new URLSearchParams({ type: this.type }),
        success: ({ data }) => {
          this.data = data;
        },
        complete: () => {
          this.isLoading = false;
        },
      });
    },
    assignSelf(id) {
      Rails.ajax({
        url: `/projects/${this.projectId}/tasks/${id}/assign_self`,
        type: 'PATCH',
        success: () => {
          successToast('Assigned to Self');
          this.data = this.data.filter((x) => x.id !== id);
        },
        error: ({ message }) => {
          dangerToast(message);
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
        error: ({ message }) => {
          dangerToast(message);
        },
      });
    },
    sortPriority(a, b, isAsc) {
      if (a.priority === b.priority) {
        return 0;
      }
      if (a.priority === 'high' || (a.priority === 'medium' && b.priority === 'low')) {
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
