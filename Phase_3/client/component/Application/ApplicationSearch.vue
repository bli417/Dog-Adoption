<template>
<div>
  <div class="d-flex justify-content-between">
    <div class="mb-3 col-sm-4">
        <b-form-input v-model="searchText" debounce="500" placeholder="Search" type="search" />
    </div>
    <span>Adoption Fee: ${{fee.toFixed(2)}}</span>
  </div>
  <ApplicationList v-bind:state="'approved'" v-bind:searchText="searchText" v-bind:dogID="dogID"/>
</div>
</template>

<script>
import ApplicationList from './ApplicationList.vue'

export default {
  name: 'ApplicationSearch',
  props: ['dogID', 'fee'],
  data() {
    return {
      searchText: null
    }
  },
  components:{
    ApplicationList
  }
}
</script>