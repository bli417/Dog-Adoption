<template>
<div>
  <b-form @submit="onSubmit">
    <h3 class="mt-3 mb-3">New Application</h3> 

    <div class="d-flex justify-content-between">
        <b-form-group id="input-group-email" label="Apply Date:" label-for="input-email">
          <b-form-input 
            id="input-expenseDate" 
            type="date"
            v-model="application.apply_date"
            required
          />
        </b-form-group>

        <b-form-group id="input-group-email" label="Email:" label-for="input-email">
          <b-form-input
              id="input-email"
              v-model="application.email"
              type="email"
              required
              placeholder="Enter email"
          ></b-form-input>
          <!--TODO: optional feature, auto complete, combine Datalist support here-->
        </b-form-group>

        <b-form-group id="input-group-first_name" label="First Name:" label-for="input-first_name">
          <b-form-input
              id="input-first_name"
              v-model="application.first_name"
              required
              placeholder="First Name"
          ></b-form-input>
        </b-form-group>

        <b-form-group id="input-group-last_name" label="Last Name:" label-for="input-last_name">
          <b-form-input
              id="input-last_name"
              v-model="application.last_name"
              required
              placeholder="Last Name"
          ></b-form-input>
        </b-form-group>
    </div>

    <h5 class="mt-3 mb-1">Contact</h5>
    <div class="d-flex justify-content-between">
        <b-form-group id="input-group-cell_phone" label="Cell Phone:" label-for="input-cell_phone">
          <b-form-input
              id="input-cell_phone"
              v-model="application.cell_phone"
              required
              placeholder="Cell Phone"
          ></b-form-input>
        </b-form-group>

        <b-form-group id="input-group-street" label="Street:" label-for="input-street">
          <b-form-input
              id="input-street"
              v-model="application.street"
              placeholder="street"
          ></b-form-input>
        </b-form-group>

        <b-form-group id="input-group-city" label="City:" label-for="input-city">
          <b-form-input
              id="input-city"
              v-model="application.city"
              placeholder="City"
          ></b-form-input>
        </b-form-group>

        <b-form-group id="input-group-state" label="State:" label-for="input-state">
          <b-form-input
              id="input-state"
              v-model="application.state"
              placeholder="State"
          ></b-form-input>
        </b-form-group>

        <b-form-group id="input-group-zip_code" label="Zip Code:" label-for="input-zip_code">
          <b-form-input
              id="input-zip_code"
              v-model="application.zip_code"
              placeholder="zip code"
          ></b-form-input>
        </b-form-group>
    </div>

    <h5 class="mt-3 mb-1">Co-Application</h5>
    <div class="d-flex">
      <b-form-group id="input-group-coApp_first_name" label="First Name:" label-for="input-coApp_first_name">
        <b-form-input 
            id="input-coApp_first_name"
            v-model="application.coApp_first_name"
        ></b-form-input>
      </b-form-group>

      <b-form-group id="input-group-coApp_last_name" label="Last Name:" label-for="input-coApp_last_name">
        <b-form-input
            id="input-coApp_last_name"
            v-model="application.coApp_last_name"
        ></b-form-input>
      </b-form-group>
    </div>

    <div class="d-flex justify-content-end">
      <b-button type="submit" variant="primary">Submit</b-button>
    </div>  </b-form>
</div>
</template>

<script>
  import moment from 'moment'
  let NullApplication = {
    apply_date: moment().format('YYYY-MM-DD'),
    email: '',
    first_name: '',
    last_name: '',
    cell_phone: '',
    street: '',
    city: '',
    state: '',
    zip_code: '',
    coApp_first_name: '',
    coApp_last_name: ''
  }

  export default {
    name: 'ApplicationForm',
    data() {
    	return {
        application: _.clone(NullApplication)
      }
    },
    methods: {
      onSubmit(evt) {
        evt.preventDefault();
        
        let url = `${this.$store.state.domain}applications`;
        this.$http.post(url, this.application).then(res => {
          //this.$router.push(`/dashboard`);
          this.$bvToast.toast(`Application Number: ${res.body.insertId}.`, {
            title: 'New Application Created',
            autoHideDelay: 5000,
            appendToast: true
          });
          this.application = _.clone(NullApplication);
        }, err => {
          this.error = err.bodyText;
          console.log(err);
        })
      }
    }
  }
</script>

<style scoped>
.form-group{margin: 1rem 0.8rem;}
#input-description{width: 40rem;}
#input-surrenderReason{width: 56.5rem;}
</style>