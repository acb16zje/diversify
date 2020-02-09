<template>
    <section>
      <b-field>
        <b-input placeholder="Project Title" v-model="search" type="search">
        </b-input>
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
              <option value="0">All</option>
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
            <b-select v-model="sort" @input="sortItems" expanded>
              <option value="name_asc">By Name Ascending</option>
              <option value="name_desc">By Name Descending</option>
              <option value="date_asc">By Date Ascending</option>
              <option value="date_desc">By Date Descending</option>
            </b-select>
          </b-field>
        </div>
      </div>
      <div class="columns">
        <div class="column is-three-quarters"></div>
        <div class="column is-one-quarter ">
          <b-field label="Items per page" position="is-right">
            <b-input type="number" v-model="perPage"></b-input>
          </b-field>
        </div>
      </div>
      <template v-if="paginatedItems.length === 0">
        <div class="content has-text-grey has-text-centered">
          <p>No Project :(</p>
        </div>
      </template>
      <article class="media" v-for="project in paginatedItems" :key="project.id">
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
            </span>
            <div class="project-description">
              <p>
                {{project.description}}
              </p>
            </div>
          </div>
        </div>
      </article>
      <hr>
      <b-pagination
          :total="total"
          :current.sync="current"
          :range-before=3
          :range-after=2
          :per-page="perPage"
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
    export default {
        created() {
          this.sortItems();
        },
        props: {
          originalData: {
            type: String,
            required: true,
          },
          originalCat: {
            type: String,
            required: true
          }
        },
        data() {
          return {
            search: '',
            status: '',
            category: "0",
            sort: 'name_asc',
            categories: JSON.parse(this.originalCat),
            items: JSON.parse(this.originalData),
            current: 1,
            perPage: 10
          }
        },
        computed: {
          total() {
            return this.filteredList.length
          },
          filteredList() {
            let tempData = this.items.filter(project => {
              return project.name.toLowerCase().includes(
                this.search.toLowerCase()
              )
            })
            tempData = tempData.filter(project => {
              return project.category_id === this.category ||
                this.category === "0"
            })
            return tempData.filter(project => {
              return project.status.includes(this.status)
            })
          },
          paginatedItems() {
            let page_number = this.current-1
            return this.filteredList.slice(
              page_number * this.perPage, (page_number + 1) * this.perPage);
          },
        },
        methods: {
          url(text) {
            let theUrl = 'http://via.placeholder.com/'+64+'x'+64;
            theUrl += '/ab28f4';
            theUrl += '/FFFFFF';
            if(text) theUrl += '?text='+encodeURIComponent(text);
            return theUrl;
          },
          sortItems() {
            switch(this.sort) {
              case 'name_asc':
                this.items = this.sortedNameAsc();
                break;
              case 'name_desc':
                this.items = this.sortedNameDesc();
                break;
              case 'date_asc':
                this.items = this.sortedDateAsc();
                break;
              case 'date_desc':
                this.items = this.sortedDateDesc();
                break;
              default:
                this.items = this.sortedNameAsc();
                break;
            }
          },
          sortedNameAsc(){
            return this.items.sort((a, b) =>
              ( a.name == b.name ) ? 0 : ( ( a.name > b.name ) ? 1 : -1 ) );
          },
          sortedNameDesc(){
            return this.items.sort((a, b) =>
            ( a.name == b.name ) ? 0 : ( ( a.name < b.name ) ? 1 : -1 ) );
          },
          sortedDateAsc(){
            return this.items.sort((a, b) =>
              new Date(b.created_at) - new Date(a.created_at));
          },
          sortedDateDesc(){
            return this.items.sort((a, b) =>
              new Date(a.created_at) - new Date(b.created_at));
          }
        }
    }
</script>