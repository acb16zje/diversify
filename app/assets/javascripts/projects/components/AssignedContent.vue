<template>
  <nav class="level">
    <div class="level-item has-text-centered">
      <div>
        <p class="heading">
          Ongoing Tasks
        </p>
        <p class="title">
          {{ count }}
        </p>
      </div>
    </div>
    <div class="level-item has-text-centered">
      <div>
        <p class="heading">
          Compatibility
        </p>
        <p v-if="moved || score.includes('Team') || score === ''">
          -
          <b-tooltip animated multilined label="Recompute to get Compatibility Score" position="is-top">
            <span class="iconify is-24" data-icon="twemoji:warning" />
          </b-tooltip>
        </p>
        <p v-else :class="[{ 'has-text-danger': score <= 1 },{ 'has-text-success':score > 1},'title']">
          {{ score }}
        </p>
      </div>
    </div>
  </nav>
</template>

<script>

export default {
  props: {
    count: {
      type: Number,
      required: true,
    },
    score: {
      type: String,
      required: true,
    },
  },
  data() {
    return {
      moved: false,
    };
  },
  methods: {
    toggle(bool) {
      this.moved = bool;
    },
  },
};

</script>
