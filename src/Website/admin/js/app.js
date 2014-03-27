'use strict';


// Declare app level module which depends on filters, and services
var app = angular.module('admin', ['ngRoute', 'admin.filters', 'admin.services', 'admin.directives', 'admin.views', 'admin.controllers']).
  config(['$routeProvider', function ($route, views) {
      $route.when('/site_list', { templateUrl: "partials/site_list.html", controller: "site_listCtrl" });
      $route.when('/account_create', { templateUrl: "partials/account_create.html", controller: "account_createCtrl" });
      $route.when('/account_hiddenset', { templateUrl: "partials/account_hiddenset.html", controller: "account_hiddensetCtrl" });
      $route.when('/account_list', { templateUrl: "partials/account_list.html", controller: "account_listCtrl" });
      $route.when('/backup_create', { templateUrl: "partials/backup_create.html", controller: "backup_createCtrl" });
      $route.when('/backup_list', { templateUrl: "partials/backup_list.html", controller: "backup_listCtrl" });
      $route.when('/default', { templateUrl: "partials/default.html", controller: "defaultCtrl" });
      $route.when('/job_list', { templateUrl: "partials/job_list.html", controller: "job_listCtrl" });
      $route.when('/server_setting', { templateUrl: "partials/server_setting.html", controller: "server_settingCtrl" });

      $route.otherwise({ redirectTo: '/default' });
  }]);
