﻿'use strict';


// Declare app level module which depends on filters, and services
var app = angular.module('admin', ['ngRoute']).
  config(['$routeProvider', function ($route) {
      $route.when('/account_create', { templateUrl: "views/account_create.html", controller: "viewCtrlBase" });
      $route.when('/account_list', { templateUrl: "views/account_list.html", controller: "admin_account_listCtrl" });
      $route.when('/backup_list', { templateUrl: "views/backup_list.html", controller: "admin_backup_listCtrl" });
      $route.when('/backup_create', { templateUrl: "views/backup_create.html", controller: "viewCtrlBase" });
      $route.when('/account_hiddenset', { templateUrl: "views/account_hiddenset.html", controller: "viewCtrlBase" });
      $route.when('/aqd_list', { templateUrl: "views/aqd_list.html", controller: "viewCtrlBase" });
      $route.when('/site_list', { templateUrl: "views/site_list.html", controller: "viewCtrlBase" });
      $route.when('/job_list', { templateUrl: "views/job_list.html", controller: "viewCtrlBase" });
      $route.when('/server_setting', { templateUrl: "views/server_setting.html", controller: "viewCtrlBase" });
      $route.when('/server_recommend', { templateUrl: "views/server_recommend.html", controller: "viewCtrlBase" });
      $route.when('/account_clear', { templateUrl: "views/account_clear.html", controller: "viewCtrlBase" });
      $route.when('/account_reindex', { templateUrl: "views/account_reindex.html", controller: "viewCtrlBase" });
      $route.when('/account_profiler', { templateUrl: "views/account_profiler.html", controller: "viewCtrlBase" });

      //$route.otherwise({ redirectTo: '/account_list' });
  }])

//.controller('navMenu', function ($scope) {
//    $scope.currentMenu = '0.1';
//    $scope.menu = [
//        {
//            text: '账套管理', url: '#', open: true, submenu: [
//                { text: '新建账套', url: '#/account_create' },
//                { text: '账套维护', url: '#/account_list', active: true },
//                { text: '备份计划', url: '#/backup_list' },
//                { text: '安全盾维护', url: '#/aqd_list' }
//            ]
//        },
//        {
//            text: '运行管理', url: '#', open: true, submenu: [
//                 { text: '站点查看', url: '#/site_list' },
//                 { text: '任务管理', url: '#/job_list' }
//            ]
//        },
//        { text: '服务器配置', url: '#/server_setting' }
//    ];
//    $scope.menuclick = function (index) {

//    }
//})

.controller('viewCtrlBase', function ($scope) {

})
;
