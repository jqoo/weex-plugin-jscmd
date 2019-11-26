import Vue from 'vue';

import weex from 'weex-vue-render';

import WeexPluginJscmd from '../src/index';

weex.init(Vue);

weex.install(WeexPluginJscmd)

const App = require('./index.vue');
App.el = '#root';
new Vue(App);
