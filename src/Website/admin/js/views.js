'use strict';

/* Views */

angular.module('admin.views', []).
  value('views', [
    { title: '首页', routeUrl: 'default', templateUrl: "partials/default.html", controller: "defaultCtrl" },
    { title: '新建账套', routeUrl: 'account_create', templateUrl: "partials/account_create.html", controller: "account_createCtrl" },
    { title: '账套管理', routeUrl: 'account_list', templateUrl: "partials/account_list.html", controller: "account_listCtrl" },
    { title: '隐藏设置', routeUrl: 'account_hiddenset', templateUrl: "partials/account_hiddenset.html", controller: "account_hiddensetCtrl" },
    { title: '新建备份计划', routeUrl: 'backup_create', templateUrl: "partials/backup_create.html", controller: "backup_createCtrl" },
    { title: '备份计划管理', routeUrl: 'backup_list', templateUrl: "partials/backup_list.html", controller: "backup_listCtrl" },
    { title: '站点查看', routeUrl: 'site_list', templateUrl: "partials/site_list.html", controller: "site_listCtrl" },
    { title: '任务管理', routeUrl: 'job_list', templateUrl: "partials/job_list.html", controller: "job_listCtrl" },
    { title: '管理配置', routeUrl: 'server_setting', templateUrl: "partials/server_setting.html", controller: "server_settingCtrl" }
  ]);
