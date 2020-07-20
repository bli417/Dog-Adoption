module.exports = {
  val2NullableStr: (val) => {
    return val == null ? null : `'${val}'`;
  },
  val2List: (val) => {
    return "'" + val.split(",").join("','") + "'";
  }
}