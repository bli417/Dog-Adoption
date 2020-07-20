<template>
<div>
  <div class="mt-3 mb-3 d-flex justify-content-between">
    <h3>Dog Detail for Dog ID: {{dogInfo.dogID}}</h3>
    <div  class="right">
      <b-button variant="primary" v-bind:href="`/#/dog/${dogInfo.dogID}/edit`">Edit</b-button>
      <b-button variant="primary" v-b-modal.approved-application-modal :disabled="!adoptable">Adopt</b-button>
      <b-modal id="approved-application-modal" title="Approved Applications" size="lg" centered hide-footer>
        <ApplicationSearch v-bind:dogID="dogInfo.dogID" v-bind:getDogExpense="getDogExpense" v-bind:fee="fee"/>
      </b-modal>
    </div>
  </div>
  <div class="d-flex justify-content-between">
    <div class="mb-3 mr-5">
      <label class="font-weight-bold">Name:</label>
      <span>{{dogInfo.name}}</span>
    </div>
    <div class="mb-3 mr-5">
      <label class="font-weight-bold">Sex:</label>
      <span>{{dogInfo.sex}}</span>
    </div>
    <div class="mb-3 mr-5">
      <label class="font-weight-bold">Altered:</label>
      <span>{{dogInfo.altered}}</span>
    </div>
    <div class="mb-3 mr-5">
      <label class="font-weight-bold">Birthdate:</label>
      <span>{{dogInfo.birth_date}}</span>
    </div>
    <div class="mb-3 mr-5">
      <label class="font-weight-bold">Microchip ID:</label>
      <span>{{dogInfo.microchipID || 'N/A'}}</span>
    </div>
  </div>
  <div>
    <div class="mb-3 mr-5">
      <label class="font-weight-bold">Breed:</label>
      <span>{{dog_breed}}</span>
    </div>
    <div class="mb-3 mr-5">
      <label class="font-weight-bold">Description:</label>
      <div>{{dogInfo.description || 'N/A'}}</div>
    </div>
  </div>

  <h3 class="mt-3 mb-3">Surrender</h3>
  <div class="d-flex">
    <div class="mb-3 mr-5">
      <label class="font-weight-bold">Surrender Date:</label>
      <span>{{dogInfo.surrender_date}}</span>
    </div>
    <div class="mb-3 mr-5">
      <label class="font-weight-bold">Animal Control:</label>
      <span>{{dogInfo.is_animal_control_surrender}}</span>
    </div>
  </div>
  <div class="d-flex">
    <div class="mb-3 mr-5">
      <label class="font-weight-bold">Surrender Reason:</label>
      <div>{{dogInfo.surrender_reason || 'N/A'}}</div>
    </div>
  </div>

  <div class="mt-3 mb-3 d-flex justify-content-between">
    <div class="d-flex">
      <h3>Expense </h3>
      <span id='totalExpense'>total: ${{totalExpense}}</span>
    </div>
    <b-button class="right" variant="primary" v-b-modal.expense-modal>
      Add Expense
    </b-button>
    <b-modal id="expense-modal" title="Expense" size="lg" centered hide-footer>
      <ExpenseForm v-bind:dogID="dogInfo.dogID" v-bind:getDogExpense="getDogExpense"></ExpenseForm>
    </b-modal>
  </div>
  <b-table striped hover :items="expenses" :fields="fields" />
</div>
</template>
<script>
import moment from 'moment'
import ExpenseForm from './ExpenseForm.vue'
import ApplicationSearch from '../Application/ApplicationSearch.vue'

export default {
  name: 'DogView',
  props: ['dogInfo'],
  components:{
    ExpenseForm, ApplicationSearch
  },
  data() {
  	return {
      expenses: null,
      fields: [
        {
          key: 'expense_date',
          label: 'Date',
          class: 'text-nowrap',
          sortable: true,
          formatter: (value, row) => {
            return moment(value).format('YYYY-MM-DD')
          }
        }, {
          key: 'vendor',
          sortable: true
        }, {
          key: 'amount',
          sortable: true,
          formatter: (value, row) => {
            return `$${value}`;
          }
        }, {
          key: 'description',
          sortable: true,
        }
      ]
    }
  },
  watch: {
    'dogInfo.dogID': {
      handler: function(val) {
        if (val != null) {
          this.getDogExpense();
        }
      },
      immediate: true
    }
  },
  computed: {
    dog_breed: function() {
      return this.dogInfo.breed.map((d) => d.name).join("/");
    },
    adoptable: function() {
      return this.dogInfo.altered && this.dogInfo.microchipID != null
    },
    totalExpense: function() {
      return _.sumBy(this.expenses, function(e) {return e.amount;});
    },
    fee: function() {
      return this.totalExpense * (this.dogInfo.is_animal_control_surrender ? 0.15 : 1.15);
    }
  },
  methods: {
    getDogExpense() {
      let url = `${this.$store.state.domain}dogs/${this.dogInfo.dogID}/expense`;
      this.$http.get(url).then(res => {
        this.expenses = res.body;
      }, err => {
        console.log(err);
      })
    }
  }
}

</script>

<style scoped>
.close{margin: 2.2rem;}
#totalExpense{font-size: 1rem; margin-top:0.5rem; margin-left: 4rem;}
</style>
