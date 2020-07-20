<template>
<div>
  <div class="mt-3 mb-3 d-flex justify-content-between">
    <h3 v-if="dogInfo.dogID">Dog ID: {{dogInfo.dogID}}</h3>
    <h3 v-else>New Dog</h3>
  </div>
  <b-alert :show="error!=null" variant="danger" dismissible @dismissed="error=null">
    {{error}}
  </b-alert>
  <b-form @submit="onSubmit">
    <div class="d-flex justify-content-between">
      <b-form-group id="input-group-name" label="Name:" label-for="input-name">
        <b-form-input
            id="input-name"
            v-model="editDogInfo.name"
            required
            placeholder="Enter name"
            :state="isNameValid"
        />
      </b-form-group>

      <b-form-group id="input-group-sex" label="Sex:" label-for="input-sex">
        <b-form-select
            id="input-sex"
            v-model="editDogInfo.sex"
            required
            :disabled="disableSex"
            :options="sexOptions"
        />
      </b-form-group>

      <b-form-group id="input-group-altered" label="Altered:" label-for="input-altered">
        <b-form-checkbox
            id="input-altered"
            v-model="editDogInfo.altered"
        />
      </b-form-group>

      <b-form-group id="input-group-birthday" label="Birthday:" label-for="input-birthday">
        <b-form-input
            id="input-birthday"
            v-model="editDogInfo.birth_date"
            required
            type="date"
        />
      </b-form-group>

      <b-form-group id="input-group-microchipID" label="Microchip ID:" label-for="input-microchipID">
        <b-form-input
            id="input-microchipID"
            v-model="editDogInfo.microchipID"
            placeholder="Enter Microchip ID"
        />
      </b-form-group>
    </div>

    <div class="d-flex justify-content-between">
      <b-form-group id="input-group-breed" label="Breed:" label-for="input-breed">
        <b-form-select 
            id="input-breed"
            v-model="editDogInfo.breedIDs"
            required
            multiple
            :state="isBreedsValid"
            :disabled="disableBreeds"
            :options="$store.state.breeds"
        />
      </b-form-group>

      <b-form-group id="input-group-description" label="Description:" label-for="input-description">
        <b-form-textarea 
            id="input-description"
            v-model="editDogInfo.description"
            required
            rows="3"
        />
      </b-form-group>
    </div>

    <h3 class="mt-3 mb-3">Surrender</h3>
    <div class="d-flex">
      <b-form-group id="input-group-surrenderDate" label="Surrender Date:" label-for="input-surrenderDate">
        <b-form-input
            id="input-surrenderDate"
            v-model="editDogInfo.surrender_date"
            type="date"
            required
        />
      </b-form-group>

      <b-form-group id="input-group-isAnimalControlSurrender" label="Is Animal Control Surrender:" label-for="input-isAnimalControlSurrender">
        <b-form-checkbox
            id="input-isAnimalControlSurrender"
            required
            v-model="editDogInfo.is_animal_control_surrender"
        />
      </b-form-group>
    </div>

    <div class="d-flex">
      <b-form-group id="input-group-surrenderReason" label="Surrender Reason:" label-for="input-surrenderReason">
        <b-form-textarea 
            id="input-surrenderReason"
            v-model="editDogInfo.surrender_reason"
            required
            rows="3"
        />
      </b-form-group>
    </div>

    <div class="d-flex justify-content-end">
      <b-button type="submit" variant="primary">Submit</b-button>
    </div>
  </b-form>
</div>
</template>

<script>
import _ from 'lodash'

var NullEditDogInfo = {
  "dogID": null,
  "name": null,
  "sex": null,
  "altered": false,
  "birth_date": null,
  "description": null,
  "is_animal_control_surrender": false,
  "surrender_date": null,
  "surrender_reason": null,
  "microchipID": null,
  "created_by": null,
  "breedIDs": []
};

export default {
  name: 'DogForm',
  props: ['dogInfo'],
  data() {
  	return {
      error: null,
      sexOptions: [{ text: 'Choose...', value: null }, "male", "female", "unknown"],
      breeds: null,
      isBreedsValid: null,
      isNameValid: null
    }
  },
  computed: {
    editDogInfo: function() {
      if (this.dogInfo.dogID == null) {
        return _.clone(NullEditDogInfo);
      } else {
        let dog = _.clone(this.dogInfo);
        dog.breedIDs = this.dogInfo.breed.map(b => { return b.breedID; });
        delete dog['breed'];
        delete dog['expense'];
        delete dog['created_by'];
        return dog;
      }
    },
    disableSex: function() {
      return this.dogInfo.dogID != null && this.dogInfo.sex != "unknown";
    },
    disableBreeds: function() {
      return this.dogInfo.dogID != null && 
        this.dogInfo.breed.length > 0 && 
        !(this.dogInfo.breed[0].breedID == 149 || this.dogInfo.breed[0].breedID == 185);
    }
  },
  methods: {
    validBreeds: function() {
      let unknown_or_mixed_selected = _.find(this.editDogInfo.breedIDs, (b)=>{return b == 149 || b == 185});
      this.isBreedsValid = !(unknown_or_mixed_selected && this.editDogInfo.breedIDs.length > 1);
      if (!this.isBreedsValid) {
        this.error = "Unknown or Mixed for breed cant not be saved with other values.";
      }
      return this.isBreedsValid;
    },
    validBulldogName: function() {
      let is_bulldog = _.find(this.editDogInfo.breedIDs, (b)=>{return  [54, 186, 187, 188].indexOf(b) >= 0});
      this.isNameValid = !(is_bulldog && this.editDogInfo.name && this.editDogInfo.name.toLocaleLowerCase() == "uga");
      if (!this.isNameValid) {
        this.error = "Bulldog can't have the name \"Uga\"."
      }
      return this.isNameValid;
    },
    onSubmit(evt) {
      evt.preventDefault();
      if (!this.validBreeds()) {return;}
      if (!this.validBulldogName()) {return;}
      this.nomalizeDogInfo()
      if (this.dogInfo.dogID) {
        this.update();
      } else {
        this.create();
      }
    },
    nomalizeDogInfo() {
      if (this.editDogInfo.microchipID == "") {
        this.editDogInfo.microchipID = null
      }
    },
    create() {
      let url = `${this.$store.state.domain}dogs`;
      this.$http.post(url, this.editDogInfo).then(res => {
        this.$router.push(`/dog/${res.body.dogID}/view`);
      }, err => {
        this.error = err.bodyText;
        console.log(err);
      })
    },
    update() {
      let url = `${this.$store.state.domain}dogs/${this.dogInfo.dogID}`;
      this.$http.put(url, this.editDogInfo).then(res => {
        this.$router.push(`/dog/${this.dogInfo.dogID}/view`);
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
#input-description{width: 38rem;}
#input-surrenderReason{width: 56.5rem;}
</style>