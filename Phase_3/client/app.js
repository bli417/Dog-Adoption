import Vue from 'vue'
import Vuex from 'vuex'
import VueRouter from 'vue-router'
import VueResource from 'vue-resource'
import BootstrapVue from 'bootstrap-vue'

import App from './component/App.vue'
import Login from './component/Login.vue'
import Dashboard from './component/Dashboard.vue'
import Dog from './component/Dog/Dog.vue'
import Application from './component/Application/Application.vue'

import AnimalControl from './component/Report/AnimalControl.vue'
import MonthlyAdoption from './component/Report/MonthlyAdoption.vue'
import ExpenseAnalysis from './component/Report/ExpenseAnalysis.vue'
import VolunteerLookup from './component/Report/VolunteerLookup.vue'

Vue.use(Vuex)
Vue.use(VueRouter)
Vue.use(VueResource)
Vue.use(BootstrapVue)

const router = new VueRouter({
  routes: [{
    path: '/login',
    component: Login
  }, {
    path: '/dashboard',
    component: Dashboard
  }, {
    path: '/dog/new',
    component: Dog
  }, {
    path: '/dog/:dogID/:action',
    component: Dog
  }, {
    path: '/application/:action',
    component: Application
  },{
    path: '/report/animal_control',
    component: AnimalControl
  },{
    path: '/report/monthly_adoption',
    component: MonthlyAdoption
  },{
    path: '/report/volunteer_lookup',
    component: VolunteerLookup
  },{
    path: '/report/expense_analysis',
    component: ExpenseAnalysis
  }]
})

//Vuex
const store = new Vuex.Store({
  state: {
    domain: 'http://localhost:3000/api/v1/', //backend api domain
    token: null,
    user: {
      email: null,
      name: null,
      is_admin: null
    },
    breeds: null
  },
  mutations: {
    updateToken(state, token) {
      state.token = token;
    },
    updateBreeds(state, breeds) {
      state.breeds = breeds
    },
    updateUserInfo(state, newUserInfo) {
      state.user = newUserInfo;
    },
    resetUser(state) {
      state.token = null;
      state.user = {
        email: null,
        name: null,
        is_admin: null
      };
    }
  }
})

Vue.prototype.setCookie = (c_name, value, expiredays) => {
  var exdate = new Date();
  exdate.setDate(exdate.getDate() + expiredays);
  document.cookie = c_name + "=" + escape(value) + ((expiredays == null) ? "" : ";expires=" + exdate.toGMTString());
}

function getCookie(name) {
  var arr, reg = new RegExp("(^| )" + name + "=([^;]*)(;|$)");
  if (arr = document.cookie.match(reg))
    return (arr[2]);
  else
    return null;
}
Vue.prototype.getCookie = getCookie;

Vue.prototype.delCookie = (name) => {
  var exp = new Date();
  exp.setTime(exp.getTime() - 1);
  var cval = getCookie(name);
  if (cval != null)
    document.cookie = name + "=" + cval + ";expires=" + exp.toGMTString();
}

Vue.http.interceptors.push((request, next) => {
  request.headers.set('x-access-token', store.state.token)
  next()
})

var app = new Vue({
  data: {},
  el: '#app',
  render: h => h(App),
  router,
  store,
  watch: {
    "$route": 'checkLogin'
  },
  created() {
    this.checkLogin();
  },
  methods: {
    checkLogin() {
      var token = this.getCookie('token');
      if (token == null) {
        this.$router.push('/login');
      } else {
        this.$store.commit('updateToken', token);
        if (this.$store.state.breeds == null) {
          this.getDogBreeds();
        }
      }
    },
    getDogBreeds() {
      let url = `${this.$store.state.domain}dogs/breeds`;
      this.$http.get(url).then(res => {
        let breeds = res.body.map(b => {
          return {value: b.breedID, text: b.name}
        });
        this.$store.commit('updateBreeds', breeds);
      }, err => {
        console.log(err);
      })
    },
  }
})