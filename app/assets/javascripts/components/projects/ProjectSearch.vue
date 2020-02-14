<template>
    <section>
      <b-field>
        <b-input placeholder="Project Title" expanded v-model="search" type="search">
        </b-input>
        <p class="control">
          <b-button class="button is-primary" @click="query(1)">
            <span class="iconify" data-icon="ant-design:search-outlined"/>
            Search
          </b-button>
        </p>
        <p class="control">
          <b-button class="button is-danger" @click="clear">
            <span class="iconify" data-icon="emojione-monotone:cross-mark"/>
            Clear
          </b-button>
        </p>
      </b-field>

      <div class="columns is-vcentered">
        <div class="column is-one-third-tablet">
          <b-field label="Status">
            <b-select v-model="status" expanded>
              <option value="">All</option>
              <option value="Ongoing">Ongoing</option>
              <option value="Completed">Completed</option>
            </b-select>
          </b-field>
        </div>
        <div class="column is-one-third-tablet">
          <b-field label="Category">
            <b-select v-model="category" expanded>
              <option value=''>All</option>
              <option
                  v-for="option in categories"
                  :value="option.id"
                  :key="option.id">
                  {{ option.name }}
              </option>
            </b-select>
          </b-field>
        </div>
        <div class="column is-one-third-tablet">
          <b-field label="Sort">
            <b-select v-model="sort" expanded>
              <option value="name_asc">By Name Ascending</option>
              <option value="name_desc">By Name Descending</option>
              <option value="date_asc">By Date Ascending</option>
              <option value="date_desc">By Date Descending</option>
            </b-select>
          </b-field>
        </div>
      </div>
      <div id="projects-list">
        <b-loading :is-full-page=false :active.sync="isLoading" :can-cancel="false"></b-loading>
        <template v-if="items.length === 0">
          <div class="content has-text-grey has-text-centered">
            <p>No Project :(</p>
          </div>
        </template>
        <div class="box" v-for="project in items" :key="project.id" @click="show(project.id)">
          <article class="media">
            <figure class="media-left">
              <figure class="image is-64x64">
                <img v-bind:src="project.avatar || url(project.name[0])">
              </figure>
            </figure>
            <div class="media-content">
              <div class="content">
                <h1 class="is-1 is-title">
                  {{project.name}}
                </h1>
                <span v-bind:class="{'tag is-success':project.status === 'Ongoing',
                  'tag is-danger':project.status === 'Completed'}">
                  Status: {{project.status}}
                  Visibility: {{project.visibility}}
                </span>
                <span class='tag is-primary'>
                  Category: {{categories[project.category_id-1]["name"]}}
                </span>
                <div class="project-description">
                  <p>
                    {{project.description}}
                  </p>
                </div>
              </div>
            </div>
          </article>
        </div>
      </div>
      <hr>
      <b-pagination
          @change="query"
          :total="total"
          :current.sync="current"
          :range-before=3
          :range-after=2
          :per-page=10
          order='is-centered'
          prevIcon= 'chevron-left'
          nextIcon= 'chevron-right'
          aria-next-label="Next page"
          aria-previous-label="Previous page"
          aria-page-label="Page"
          aria-current-label="Current page">
      </b-pagination>
  </section>
</template>

<script>
  import Rails from '@rails/ujs';
  export default {
    created() {
      this.query(this.current);
    },
    props: {
      originalCat: {
        type: String,
        required: true
      }
    },
    data() {
      return {
        search: '',
        status: '',
        category: '',
        sort: 'name_asc',
        categories: JSON.parse(this.originalCat),
        items: [],
        current: 1,
        total: 0,
        perPage: 10,
        isLoading: false
      }
    },
    computed: {
      paginatedItems() {
        return this.items
      },
    },
    methods: {
      clear() {
        this.search= '';
        this.status= '';
        this.category= '';
        this.sort= 'name_asc';
        this.query(1);
      },
      show(id) {
        window.location.href = "/projects/"+id;
      },
      query(page) {
        this.isLoading = true
        window.scrollTo({top:0, left:0, behavior: 'smooth' })
        Rails.ajax({
          url: '/projects/query',
          type: 'POST',
          data: new URLSearchParams({
            'page': page,
            'name': this.search,
            'category': this.category,
            'status': this.status,
            'sort': this.sort
          }),
          success: (data) => {
            this.current = data.pagy.page;
            this.total = data.pagy.count;
            this.items = data.data;
            this.isLoading = false;
          },
        });
      },
      url(text) {
        let theUrl = 'http://via.placeholder.com/'+64+'x'+64;
        theUrl += '/ab28f4';
        theUrl += '/FFFFFF';
        if(text) theUrl += '?text='+encodeURIComponent(text);
        return theUrl;
      },
    }
  }
</script>