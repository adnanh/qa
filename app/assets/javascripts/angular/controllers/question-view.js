var ctrl_module = angular.module('qa.controllers');

ctrl_module.controller('QuestionViewCtrl', ['$scope', 'i18n', '$routeParams',
    function ($scope, i18n, $routeParams) {
        // include i18n reference to current scope
        $scope.i18n = i18n;

        // get question_id from route params
        $scope.question_id = $routeParams.question_id;

    }
]);
