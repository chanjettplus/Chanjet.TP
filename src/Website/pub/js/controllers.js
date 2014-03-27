"use strict";

angular.module('loginApp', [])

.controller('loginCtrl', ['$scope', '$window', '$http', function ($scope, $window, $http) {

    $scope.username = window.localStorage.getItem("login_username");
    $scope.password = "";


    $scope.doLogin = function () {

        window.localStorage.setItem("login_username", $scope.username);

        var url = '../Api/SM/DCUser/Query';
        var data = { Name: $scope.username, Password: $scope.password };
        var cfg = {
            headers: { 'Content-Type': 'application/x-www-form-urlencoded; charset=UTF-8' }
        };

        $http.post(url, data, cfg).success($scope.redirect);
    }

    $scope.redirect = function (result) {
        //For example: host='/s0101/checkcode.aspx?ticket='
        var host = result[0].host;
        if (host == 'err:noName') {
            alert('用户不存在！');
        } else if (host == 'err:badPassword') {
            alert('密码不正确！'); 
        } else {
            if ($window.event && $window.event.ctrlKey) {
                $window.open(host);
            }

            $http.get(host).success(function (result) {
                var arr = host.split('/');
                arr[arr.length - 1] = 'Default.aspx'; 
                $window.location = (arr.join('/'));
            });
        }
    }

}]);