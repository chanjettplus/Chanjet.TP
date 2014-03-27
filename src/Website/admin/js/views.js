'use strict';

/* Views */

angular.module('admin.views', []).
  value('views', [
    { templateUrl: "partials/site-list.html", controller: "site-listCtrl" },
    { templateUrl: "partials/account-create.html", controller: "account-createCtrl" },
    { templateUrl: "partials/account-hiddenset.html", controller: "account-hiddensetCtrl" },
    { templateUrl: "partials/account-list.html", controller: "account-listCtrl" },
    { templateUrl: "partials/backup-create.html", controller: "backup-createCtrl" },
    { templateUrl: "partials/backup-list.html", controller: "backup-listCtrl" },
    { templateUrl: "partials/default.html", controller: "defaultCtrl" },
    { templateUrl: "partials/job-list.html", controller: "job-listCtrl" },
    { templateUrl: "partials/server-setting.html", controller: "server-settingCtrl" } 
  ]);
