<template>
<div>
  <div class="mt-3 mb-3 d-flex justify-content-between">
    <h3 class="mb-3">Expense Analysis Report</h3>
  </div>
  <div>
    <b-table striped hover selectable no-select-on-click
      :items="expense_analysis_data" :fields="expense_analysis_fields">
    </b-table>
  </div>
</div>
</template>

<script>
export default {
  name: 'ExpenseAnalysis',
  data() {
    return {
      isLoading: false,
      search_text: null,
      expense_analysis_data: null,
      expense_analysis_fields: [
        {
          key: 'vendor',
          label: 'Vendor Name',
          sortable: true
        },
        {
          key: 'total_expense',
          label: 'Total Expense',
          sortable: true,
          formatter: (value, row) => {
            return `$${Number.parseFloat(value).toFixed(2)}`;
          }
        }
      ]
    }
  },
  mounted() {
    this.get_expense_analysis();
  },
  methods: {
    get_expense_analysis() {
      let url = `${this.$store.state.domain}report/expense_analysis`;
      
      this.$http.get(url).then(res => {
        this.expense_analysis_data = res.body;
      }, err => {
        this.error = err.data;
      }).finally(() => {
        this.isLoading = false;
      })
    }
  }
}
</script>