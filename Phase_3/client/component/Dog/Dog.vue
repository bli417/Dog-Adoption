<template>
<div>
    <DogView v-if="action == 'view'" v-bind:dogInfo="dogInfo"></DogView>
    <DogForm v-if="action == 'edit'" v-bind:dogInfo="dogInfo"></DogForm>
</div>
</template>

<script>
import _ from 'lodash'
import DogView from './DogView.vue'
import DogForm from './DogForm.vue' 

var NullDogInfo = {
  "dogID": null,
  "name": null,
  "sex": null,
  "altered": null,
  "birth_date": null,
  "description": null,
  "is_animal_control_surrender": null,
  "surrender_date": null,
  "surrender_reason": null,
  "microchipID": null,
  "created_by": null,
  "breed": [],
  "expense": []
};

export default {
  name: 'Dog',
  data() {
    return {
      dogID: null,
      action: null,
      dogInfo: _.clone(NullDogInfo)
    }
  },
  components:{
    DogView, DogForm
  },
  watch: {
    '$route.params': {
      handler: function(val) {
        this.dogID = val.dogID
        if (val.dogID == null) {
          this.dogInfo = _.clone(NullDogInfo);
        } else {
          this.getDogInfo();
        }
        this.action = val.action || 'edit'
      },
      immediate: true
    }
  },
  methods: {
    getDogInfo() {
      let url = `${this.$store.state.domain}dogs/${this.dogID}`;
      this.$http.get(url).then(res => {
        this.dogInfo = res.body;
      }, err => {
        console.log(err);
      })
    }
  }
}
</script>