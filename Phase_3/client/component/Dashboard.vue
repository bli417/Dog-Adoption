<template>
<div>
  <div class="mt-3 mb-3 d-flex justify-content-between">
    <h3 class="mb-3">Dogs ({{this.dogs.length}}/15)</h3>
    <div class="right">
      <b-button variant="primary" v-bind:href="`/#/application/new`">
        Add Application
      </b-button>
      <b-button v-if="$store.state.user.is_admin" variant="primary" 
        v-bind:href="`/#/application/pending`">
        Review Applications
      </b-button>
      <b-button :disabled="disableNewDog" variant="primary" 
        v-bind:href="`/#/dog/new`" class="ml-3">
        Add Dog
      </b-button>
    </div>
  </div>
  <br>
  <div>
    <b-table striped hover selectable no-select-on-click @row-clicked="this.viewDog"
      :items="dogs" :fields="fields">
    </b-table>
  </div>

  <div v-if="$store.state.user.is_admin" class="mt-5 mb-3">
    <h3 class="mb-3">Reports</h3>
    <b-list-group class="w-25">
      <b-list-group-item><b-link v-bind:href="`/#/report/animal_control`">Animal Control Report</b-link></b-list-group-item>
      <b-list-group-item><b-link v-bind:href="`/#/report/monthly_adoption`">Monthly Adoption Report</b-link></b-list-group-item>
      <b-list-group-item><b-link v-bind:href="`/#/report/expense_analysis`">Expense Analysis Report</b-link></b-list-group-item>
      <b-list-group-item><b-link v-bind:href="`/#/report/volunteer_lookup`">Volunteer Lookup</b-link></b-list-group-item>
    </b-list-group>
  </div>
</div>
</template>
<script>
import moment from 'moment'

export default {
  name: 'Dashboard',
  data() {
    return {
      isLoading: false,
      dogs: [],
      fields: [
        {
          key: 'dogID',
          label: 'ID',
          sortable: true
        },
        {
          key: 'name',
          label: 'Name',
          sortable: true
        }, {
          key: 'sex',
          label: 'sex',
          sortable: true
        }, {
          key: 'age',
          label: 'Age(month)',
          sortable: true
        }, {
          key: 'altered',
          label: 'Altered',
          sortable: true,
          formatter: (value, row) => {
            return value == 0 ? 'No' : 'Yes' 
          }
        }, {
          key: 'surrender_date',
          label: 'Surrender',
          sortable: true,
          formatter: (value, row) => {
            return moment(value).format('YYYY-MM-DD')
          }
        }, {
          key: 'microchipID',
          label: 'microchipID',
          sortable: true
        }, {
          key: 'adoptable',
          label: 'Adoptable',
          sortable: true,
          formatter: (value, row) => {
            return value == 0 ? 'No' : 'Yes' 
          }
        }
      ]
    }
  },
  watch: {
    "$route": {
      handler: function(val) {
        if (val.path == '/dashboard') {
          this.getDogs();
        }
      }
    }
  },
  mounted() {
    this.getDogs();
  },
  computed: {
    disableNewDog: function() {
      return this.dogs == null || this.dogs.length >= 15;
    } 
  },
  methods: {
    getDogs() {
      let url = `${this.$store.state.domain}dogs`;
      this.$http.get(url).then(res => {
        //TODO, default sort this per spec
        this.dogs = res.body;
      }, err => {
        this.error = err.data;
      }).finally(() => {
        this.isLoading = false;
      })
    },
    viewDog(dog) {
      this.$router.push(`/dog/${dog.dogID}/view`);
    }
  }
}
</script>