<template>
<div>
  <div class="mt-3 mb-3 d-flex justify-content-between">
    <h3 class="mb-3">Monthly Adoption Report for last 12 monthes</h3>
  </div>
  <div>
    <b-table striped hover selectable no-select-on-click
      :items="monthly_adoption_data" :fields="monthly_adoption_fields">
    </b-table>
  </div>
</div>
</template>

<script>
export default {
  name: 'MonthlyAdoption',
  data() {
    return {
      isLoading: false,
      monthly_adoption_data: null,
      monthly_adoption_fields: [
        {
          key: 'month',
          label: 'Month',
          sortable: true
        },
        {
          key: 'breed',
          label: 'Breed',
          sortable: true
        },
        {
          key: 'sur_count',
          label: 'Surrendered',
          sortable: true
        },
        {
          key: 'ado_count',
          label: 'Adopted',
          sortable: true
        },
        {
          key: 'total_expense',
          label: 'Expense',
          sortable: true,
          formatter: (value, row) => {
            return `$${Number.parseFloat(value).toFixed(2)}`;
          }
        },
        {
          key: 'total_adoption_fee',
          label: 'Fee',
          sortable: true,
          formatter: (value, row) => {
            return `$${Number.parseFloat(value).toFixed(2)}`;
          }
        },
        {
          key: 'net_profit',
          label: 'Profit',
          sortable: true,
          formatter: (value, row) => {
            return `$${Number.parseFloat(value).toFixed(2)}`;
          }
        }
      ]
    }
  },
  mounted() {
    this.get_monthly_adoption();
  },
  methods: {
    get_monthly_adoption() {
      let url = `${this.$store.state.domain}report/monthly_adoption`;
      this.$http.get(url).then(res => {
        this.monthly_adoption_data = res.body;
      }, err => {
        this.error = err.data;
      }).finally(() => {
        this.isLoading = false;
      })
    }
  }
}
</script>