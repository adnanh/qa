// controller for asking questions

var ctrl_module = angular.module('qa.controllers');


ctrl_module.controller('AskCtrl', ['$scope', 'i18n',
    function ($scope, i18n) {
        // include i18n reference to current scope
        $scope.i18n = i18n;

        $scope.question = {};

        $scope.title_invalid = function(ask_form) {
            return ask_form.title.$invalid && !ask_form.title.$pristine;
        };
    }
]);