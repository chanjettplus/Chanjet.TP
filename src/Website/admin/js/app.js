'use strict';


// Declare app level module which depends on filters, and services
var app = angular.module('admin', ['ngRoute', 'admin.filters', 'admin.services', 'admin.directives', 'admin.views', 'admin.controllers']).
  config(['$routeProvider', function ($route, views) {
      $route.when('/site-list', { templateUrl: "partials/site-list.html", controller: "site-listCtrl" });
      $route.when('/account-create', { templateUrl: "partials/account-create.html", controller: "account-createCtrl" });
      $route.when('/account-hiddenset', { templateUrl: "partials/account-hiddenset.html", controller: "account-hiddensetCtrl" });
      $route.when('/account-list', { templateUrl: "partials/account-list.html", controller: "account-listCtrl" });
      $route.when('/backup-create', { templateUrl: "partials/backup-create.html", controller: "backup-createCtrl" });
      $route.when('/backup-list', { templateUrl: "partials/backup-list.html", controller: "backup-listCtrl" });
      $route.when('/default', { templateUrl: "partials/default.html", controller: "defaultCtrl" });
      $route.when('/job-list', { templateUrl: "partials/job-list.html", controller: "job-listCtrl" });
      $route.when('/server-setting', { templateUrl: "partials/server-setting.html", controller: "server-settingCtrl" });

      $route.otherwise({ redirectTo: '/default' });
  }]);
