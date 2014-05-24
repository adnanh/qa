var ctrl_module = angular.module('qa.controllers');

ctrl_module.controller('AppCtrl', ['$scope', 'AppAlert',
    function ($scope, AppAlert) {
        $scope.closeAlert = function (alert) {
            AppAlert.closeAlert(alert);
        };

        $scope.inform_of = function(notice){
            AppAlert.add("info", notice);
        };

        $scope.alert_of = function(alert){
            AppAlert.add("danger", alert);
        }
    }
]);