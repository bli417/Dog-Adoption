<template>
<div>
  <div class="mt-3 mb-3 d-flex justify-content-between">
    <h3 class="mb-3">Volunteer Lookup</h3>
  </div>
  <div>
      <b-form-input
          id="input-search-text"
          v-model="search_text"
          debounce="500"
          placeholder="Search volunteer by first or last name"
          class="mb-3 col-sm-4"
      />
  </div>
  <div>
    <b-table striped hover selectable no-select-on-click
      :items="volunteer_lookup_data" :fields="volunteer_lookup_fields">
    </b-table>
  </div>
</div>
</template>

<script>
export default {
  name: 'VolunteerLookup',
  data() {
    return {
      isLoading: false,
      search_text: null,
      volunteer_lookup_data: null,
      volunteer_lookup_fields: [
        {
          key: 'last_name',
          label: 'Last Name',
          sortable: true
        },
        {
          key: 'first_name',
          label: 'First Name',
          sortable: true
        },
        {
          key: 'email',
          label: 'Email',
          sortable: true
        },
        {
          key: 'cell_phone',
          label: 'Cell Phone',
          sortable: true
        }
      ]
    }
  },
  watch: {
    'search_text': {
      handler: function(val) {
        this.get_volunteer_lookup()
      }
    }
  },
  methods: {
    get_volunteer_lookup() {
      let url = ''
      if (this.search_text == null || this.search_text == "") {
        url = `${this.$store.state.domain}report/volunteer_lookup`
      } else {
        url = `${this.$store.state.domain}report/volunteer_lookup?search_text=${this.search_text}`;
      }
      
      this.$http.get(url).then(res => {
        this.volunteer_lookup_data = res.body;
      }, err => {
        this.error = err.data;
      }).finally(() => {
        this.isLoading = false;
      })
    }
  }
}
</script>