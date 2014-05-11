var ctrl_module = angular.module('qa.controllers');

ctrl_module.controller('QuestionViewCtrl', ['$scope', 'i18n', 'Question', 'AppAlert', 'ErrorProvider',
    function ($scope, i18n, Question, AppAlert, ErrorProvider) {
        // include i18n reference to current scope
        $scope.i18n = i18n;



        $scope.closeAlert = function (alert) {
            AppAlert.closeAlert(alert);
        };
    }
]);
