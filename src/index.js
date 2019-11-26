/* globals alert */
const weexPluginJscmd = {
  show () {
    alert('Module weexPluginJscmd is created sucessfully ');
  }
};

const meta = {
  weexPluginJscmd: [{
    lowerCamelCaseName: 'show',
    args: []
  }]
};

function init (weex) {
  weex.registerModule('weexPluginJscmd', weexPluginJscmd, meta);
}

export default {
  init: init
};
