<template>
<div>
  <div class="mt-3 mb-3 d-flex justify-content-between">
    <h3 class="mb-3">Animal Control Report in Last 6 Monthes</h3>
  </div>
  <div>
    <h5 class="mb-3">Number of Dogs from Animal Control</h5>
    <b-table striped hover selectable no-select-on-click @row-clicked="this.viewSurrenderedDog"
      :items="ac_dog_count" :fields="dog_count_sur_fields">
    </b-table>
    <b-modal id="surrendered-modal" title="Dog Drilldown" size="xl" centered hide-footer>
      <AcDogDetail v-bind:month="selected_month" v-bind:dog_type="'surrendered'"></AcDogDetail>
    </b-modal>
  </div>
  <br>
  <div>
    <h5 class="mb-3">Number of Dogs from Animal Control Got Adopted (stayed in rescue over 60 days)</h5>
    <b-table striped hover selectable no-select-on-click @row-clicked="this.viewAdoptedDog"
      :items="ac_dog_adopted_gt_60_shelter" :fields="dog_count_adopted_fields">
    </b-table>
    <b-modal id="adopted-modal" title="Dog Drilldown" size="xl" centered hide-footer>
      <AcDogDetail v-bind:month="selected_month" v-bind:dog_type="'adopted'"></AcDogDetail>
    </b-modal>
  </div>
  <br>
  <div>
    <h5 class="mb-3">Total Dog Expense for Dog from Animal Control Got Adopted</h5>
    <b-table striped hover selectable no-select-on-click
      :items="ac_dog_adopted_expense" :fields="dog_expense_fields">
    </b-table>
  </div>
</div>
</template>

<script>
import moment from 'moment'
import AcDogDetail from './AcDogDetail.vue'

export default {
  name: 'AnimalControl',
  components:{
    AcDogDetail
  },
  data() {
    return {
      isLoading: false,
      ac_dog_count: null,
      selected_month: null,
      dog_count_sur_fields: [
        {
          key: 'surrender_month',
          label: 'Surrendered Month',
          sortable: true
        },
        {
          key: 'dog_count',
          label: 'Number of Dog',
          sortable: true
        }
      ],
      dog_count_adopted_fields: [
        {
          key: 'adopted_month',
          label: 'Adopted Month',
          sortable: true
        },
        {
          key: 'dog_count',
          label: 'Number of Dog',
          sortable: true
        }
      ],
      dog_expense_fields: [
        {
          key: 'adopted_month',
          label: 'Adopted Month',
          sortable: true
        },
        {
          key: 'dog_expense',
          label: 'Total Dog Expense',
          sortable: true,
          formatter: (value, row) => {
            return `$${Number.parseFloat(value).toFixed(2)}`;
          }
        }
      ]
    }
  },
  mounted() {
    this.getACReport();
  },
  methods: {
    getACReport() {
      let url = `${this.$store.state.domain}report/animal_control`;
      this.$http.get(url).then(res => {
        this.ac_dog_count = res.body.ac_dog_count;
        this.ac_dog_adopted_gt_60_shelter = res.body.ac_dog_adopted_gt_60_shelter
        this.ac_dog_adopted_expense = res.body.ac_dog_adopted_expense
      }, err => {
        this.error = err.data;
      }).finally(() => {
        this.isLoading = false;
      })
    },
    viewSurrenderedDog(row) {
      this.selected_month=row.surrender_month
      this.$bvModal.show('surrendered-modal')
    },
    viewAdoptedDog(row) {
      this.selected_month=row.adopted_month
      this.$bvModal.show('adopted-modal')
    }
  }
}
</script>