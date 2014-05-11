var ctrl_module = angular.module('qa.controllers');

ctrl_module.controller('AnswersViewCtrl', ['$scope', 'i18n',
    function ($scope, i18n) {
        // include i18n reference to current scope
        $scope.i18n = i18n;


    }
]);
