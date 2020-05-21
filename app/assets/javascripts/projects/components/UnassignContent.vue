<template>
  <div>
    <p>
      <strong>Ongoing Tasks:</strong> {{ count }}
    </p>
    <p v-if="team.includes('Team')" class="compability-content">
      <strong>Recommendation:</strong> {{ team }}
    </p>
    <p v-else-if="team === ''">
      <strong>Recommendation:</strong> -
      <b-tooltip animated multilined label="No Recommendation can be made. This may be due to insufficient data or no compatible teams." position="is-top">
        <span class="iconify is-24" data-icon="twemoji:warning" />
      </b-tooltip>
    </p>
    <p v-else>
      <strong>Recommendation:</strong> -
      <b-tooltip animated multilined label="Recompute to get Team Recommendation" position="is-top">
        <span class="iconify is-24" data-icon="twemoji:warning" />
      </b-tooltip>
    </p>
  </div>
</template>

<script>

export default {
  props: {
    count: {
      type: Number,
      required: true,
    },
    team: {
      type: String,
      required: true,
    },
  },
};

</script>
