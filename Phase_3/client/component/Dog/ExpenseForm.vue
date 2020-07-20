<template>
<div>
  <b-alert :show="error!=null" variant="danger" dismissible @dismissed="error=null">
    {{error}}
  </b-alert>
  <b-form @submit="addExpense">
    <div class="d-flex justify-content-between">
      <b-form-group id="input-group-expenseDate" label="Date:" label-for="input-expenseDate">
        <b-form-input 
          id="input-expenseDate" 
          type="date"
          v-model="expenseInfo.expense_date"
          required
        />
      </b-form-group>

      <b-form-group id="input-group-vendor" label="Vendor:" label-for="input-vendor">
        <b-form-input
            id="input-vendor"
            v-model="expenseInfo.vendor"
            required
            placeholder="Enter vendor"
        />
      </b-form-group>

      <b-form-group id="input-group-amount" label="Amount:" label-for="input-amount">
        <b-input-group id="input-amount" size="sm" prepend="$">
          <b-form-input
            v-model="expenseInfo.amount"
            required
            placeholder="Enter amount">
          </b-form-input>
        </b-input-group>
      </b-form-group>
    </div>
    <div>
      <b-form-group id="input-group-description" label="Description:" label-for="input-description">
        <b-form-textarea 
            id="input-description"
            v-model="expenseInfo.description"
            rows="3"
        />
      </b-form-group>
    </div>
    <b-button type="submit" variant="primary" class="right">Submit</b-button>
  </b-form>
</div>
</template>

<script>
export default {
  name: 'ExpenseForm',
  props: ['dogID', 'getDogExpense'],
  data() {
    return {
      error: null,
      expenseInfo: {
        expense_date: null,
        vendor: null,
        amount: null,
        description: null
      }
    }
  },
  methods: {
    addExpense(evt) {
      evt.preventDefault();
      let url = `${this.$store.state.domain}dogs/${this.dogID}/expense`;
      this.$http.post(url, this.expenseInfo).then(res => {
        this.getDogExpense();
        this.$bvModal.hide('expense-modal');
      }, err => {
        this.error = err.bodyText;
        console.log(err);
      })
    }
  }
}
</script>

<style scoped>
.input-group input{height: 2.37rem;}
.right{position: relative; float:right;}
</style>