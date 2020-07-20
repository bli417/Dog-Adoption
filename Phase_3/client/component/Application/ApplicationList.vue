<template>
<div>
  <div class="mt-3 mb-3 d-flex" v-if="state=='pending approval'">
    <h3 class="mb-3">Applications: {{state}}</h3>
  </div>
    <div class="col-sm-4">
     <b-form-group v-if="state=='approved'" id="input-group-adoptedDate" 
        label="Adopted Date:" 
        label-rows-sm
        label-for="input-adoptedDate">
        <b-form-input
            id="input-adoptedDate"
            v-model="adopted_date"
            required
            type="date"
        />
      </b-form-group>
       </div>
  <div>
    <b-list-group>
      <b-list-group-item v-for="app in filteredApplications" :key="app.application_number"> 
        <div class="d-flex justify-content-between">
          <div>
            <div class="d-flex justify-content-left">
              <div class="mb-1 mr-4">
                <label class="font-weight-bold">NO.: </label>
                <span>{{app.application_number}}</span>
              </div>
              <div class="mb-1 mr-4">
                <label class="font-weight-bold">Email: </label>
                <span>{{app.adopter_email}}</span>
              </div>
              <div class="mb-1 mr-4">
                <label class="font-weight-bold">Cell Phone: </label>
                <span>{{app.cell_phone}}</span>
              </div>
            </div> 
            <div class="d-flex justify-content-left"> 
              <div class="mb-1 mr-4">
                <label class="font-weight-bold">Applicant: </label>
                <span>{{app.first_name}} {{app.last_name}}</span>
              </div>
              <div class="mb-1 mr-4" v-if="app.coApp_first_name != null">
                <label class="font-weight-bold">Co-Applicant: </label>
                <span>{{app.coApp_first_name}} {{app.coApp_last_name}}</span>
              </div>
            </div>
            <div>
              <div class="mb-1 mr-4">
                <label class="font-weight-bold">Address: </label>
                <span>{{app.street}}, {{app.city}}, {{app.state}} {{app.zip_code}}</span>
              </div>
            </div>
            <div>
              <div class="mb-1 mr-4">
                <label class="font-weight-bold">Apply Date: </label>
                <span>{{DateFormat(app.apply_date)}}</span>
              </div>
            </div>
          </div>
          <div class="d-flex align-items-center">
            <b-button v-if="state=='pending approval'" variant="success" class="mr-1"
              @click="reviewApplication(app.application_number, 'approved')">
              Approve
            </b-button>
            <b-button v-if="state=='pending approval'" variant="danger" class="mr-1"
              @click="reviewApplication(app.application_number, 'rejected')">
              Reject
            </b-button>
            <b-button v-if="state=='approved'" variant="success" class="mr-1"
              @click="associateDog(app.application_number, dogID, this.adopted_date)">
              Associate
            </b-button>
          </div>
        </div>
      </b-list-group-item>
    </b-list-group>
  </div>
</div>
</template>

<script>
import moment from 'moment'

export default {
  name: 'ApplicationList',
  props: ['state', 'searchText' , 'dogID'],
  data() {
    return {
      applications: [],
      adopted_date: moment().format("YYYY-MM-DD"),
    }
  },
  mounted() {
    this.getApplications();
  },
  computed: {
    filteredApplications: function() {
      var searchText = this.searchText ? this.searchText.toLowerCase() : "";
      return this.applications.filter((app) => {
        return app.last_name.toLowerCase().indexOf(searchText) >= 0 || 
          (app.coApp_last_name && app.coApp_last_name.toLowerCase().indexOf(searchText) >= 0)
      })
    }
  },
  methods: {
    getApplications() {
      let url = `${this.$store.state.domain}applications?state=${this.state}`;
      this.$http.get(url).then(res => {
        this.applications = res.body;
      }, err => {
        this.error = err.data;
      })
    },
    reviewApplication(appNO, state) {
      let url = `${this.$store.state.domain}applications/${appNO}`;
      this.$http.put(url, {state: state}).then(res => {
        this.getApplications()
      }, err => {
        this.error = err.data;
      })
    },
    associateDog(appNO, dogID, adopted_date) {
      let url = `${this.$store.state.domain}applications/${appNO}/associate/${dogID}`;
      this.$http.put(url, {adopted_date: this.adopted_date}).then(res => {
        this.$router.push('/dashboard');
        return
      }, err => {
        this.error = err.data;
      })
    },
    DateFormat: function(date) {
      if(date){
          return moment(date).format('YYYY-MM-DD');
      }
    },
  }
}
</script>