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

ctrl_module.filter('moment', function () {
    return function (input, momentFn /*, param1, param2, etc... */) {
        var args = Array.prototype.slice.call(arguments, 2),
            momentObj = moment(input);
        return momentObj[momentFn].apply(momentObj, args);
    };
});