'use strict';

/* Controllers */
 
angular.module('admin.controllers', ['admin.views']).

  controller('viewlistCtrl', ['$scope', 'views', function ($scope, views) {
      $scope.views = views;
  }])

  .controller('defaultCtrl', [function () {

  }])

  .controller('site-listCtrl', [function () {

  }])

  .controller('account-createCtrl', [function () {

  }])

  .controller('account-hiddensetCtrl', [function () {

  }])

  .controller('account-listCtrl', [function () {

  }])

  .controller('backup-createCtrl', [function () {

  }])

  .controller('backup-listCtrl', [function () {

  }])

  .controller('job-listCtrl', [function () {

  }])

  .controller('server-settingCtrl', [function () {

  }])


 ;