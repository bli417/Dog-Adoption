<template>
<div>
  <b-navbar toggleable="lg" type="dark" variant="info">
    <b-navbar-brand href="/#/dashboard">Mo's Mutt House</b-navbar-brand>
    <b-navbar-nav class="ml-auto">
      <b-nav-item-dropdown right>
        <template v-slot:button-content>
          <em>{{$store.state.user.name}}</em>
        </template>
        <b-dropdown-item href="#" @click="logout">
          Login Out
        </b-dropdown-item>
      </b-nav-item-dropdown>
    </b-navbar-nav>
  </b-navbar>
</div>
</template>

<script>
export default {
  name: 'Navbar',
  data() {
  	return {
      isLogouting: false
    }
  },
  methods: {
    logout() {
      this.isLogouting = true;
      this.delCookie('token');
      this.$store.commit('resetUser');

      //should make request to server to invalidate the token
      setTimeout(()=>{
        this.$router.push('/login');
        this.isLogouting = false;
      }, 200)
    }
  }
}
</script>

<style scoped>
</style>