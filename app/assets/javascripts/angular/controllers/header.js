// controller for admin panel

var ctrl_module = angular.module('qa.controllers');

ctrl_module.controller('HeaderCtrl', ['$scope', 'i18n',
    function ($scope, i18n) {
        // include i18n reference to current scope
        $scope.i18n = i18n;

        $scope.change_loc = function(new_loc){
            i18n.load_locale(new_loc);
        };
    }
]);