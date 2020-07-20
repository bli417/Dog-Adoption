<template>
<div>
    <ApplicationList v-if="action=='pending'" v-bind:state="'pending approval'" />
    <ApplicationForm v-if="action=='new'" v-bind:applicationInfo="applicationInfo" />
</div>
</template>

<script>
import _ from 'lodash'
import ApplicationList from './ApplicationList.vue'
import ApplicationForm from './ApplicationForm.vue'

export default {
  name: 'Application',
  data() {
    return {
      action: null,
      state: null
    }
  },
  components:{
    ApplicationList, ApplicationForm
  },
  watch: {
    '$route.params': {
      handler: function(val) {
        this.action = val.action || 'new'
        if (this.action == 'list') {
          this.state = 'pending'
        }
      },
      immediate: true
    }
  }
}
</script>