<template>
<div>
  <div>
    <h5 class="mb-3">Dog details for month {{this.month}}</h5>
    <b-table striped hover selectable no-select-on-click
      :items="dog_detail" :fields="dog_detail_fields">
    </b-table>
  </div>
</div>
</template>


<script>
import moment from 'moment'
export default {
  name: 'AcDogDetail',
  props: ['month', 'dog_type'],
  data() {
    return {
      isLoading: false,
      dog_detail: null,
      dog_detail_fields: null,
      surrendered_fields: [
        {
          key: 'dogID',
          label: 'Dog Id',
          sortable: true
        },
        {
          key: 'name',
          label: 'Name',
          sortable: true
        },
        {
          key: 'sex',
          label: 'Sex',
          sortable: true
        },
        {
          key: 'altered',
          label: 'Altered',
          sortable: true,
          formatter: (value, row) => {
            return value == 0 ? 'No' : 'Yes' 
          }
        },
        {
          key: 'microchipID',
          label: 'Microchip Id',
          sortable: true
        },
        {
          key: 'surrender_date',
          label: 'Surrendered Date',
          sortable: true,
          formatter: (value, row) => {
            return moment(value).format('YYYY-MM-DD')
          }
        },
        {
          key: 'breed',
          label: 'Breed',
          sortable: true
        }
      ],
      adopted_fields: [
        {
          key: 'dogID',
          label: 'Dog Id',
          sortable: true
        },
        {
          key: 'name',
          label: 'Name',
          sortable: true
        },
        {
          key: 'sex',
          label: 'Sex',
          sortable: true
        },
        {
          key: 'altered',
          label: 'Altered',
          sortable: true,
          formatter: (value, row) => {
            return value == 0 ? 'No' : 'Yes' 
          }
        },
        {
          key: 'microchipID',
          label: 'Microchip Id',
          sortable: true
        },
        {
          key: 'adopted_date',
          label: 'Adopted Date',
          sortable: true,
          formatter: (value, row) => {
            return moment(value).format('YYYY-MM-DD')
          }
        },
        {
          key: 'surrender_date',
          label: 'Surrendered Date',
          sortable: true,
          formatter: (value, row) => {
            return moment(value).format('YYYY-MM-DD')
          }
        },
        {
          key: 'breed',
          label: 'Breed',
          sortable: true
        },
        {
          key: 'days_in_rescue',
          label: 'Days in rescue',
          sortable: true
        }
      ]
    }
  },
  mounted() {
    this.getDogDetail(this.month, this.dog_type);
  },
  methods: {
    getDogDetail(month, dog_type) {
      if(dog_type == 'surrendered') {
        this.dog_detail_fields = this.surrendered_fields

        let url = `${this.$store.state.domain}report/animal_control/surrendered?month=${month}`;
        this.$http.get(url).then(res => {
          this.dog_detail = res.body;
        }, err => {
          console.log(err);
          this.error = err.data;
        }).finally(() => {
          this.isLoading = false;
        })

      } else if (dog_type == 'adopted') {
        this.dog_detail_fields = this.adopted_fields;

        let url = `${this.$store.state.domain}report/animal_control/adopted?month=${month}`;
        this.$http.get(url).then(res => {
          this.dog_detail = res.body;
        }, err => {
          console.log(err);
          this.error = err.data;
        }).finally(() => {
          this.isLoading = false;
        })
      }
    }
  }
}
</script>