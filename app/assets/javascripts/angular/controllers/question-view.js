var ctrl_module = angular.module('qa.controllers');

ctrl_module.controller('QuestionViewCtrl', ['$scope', '$cookies', 'i18n', 'Question', 'AppAlert', 'ErrorProvider',
    function ($scope, $cookies, i18n, Question, AppAlert, ErrorProvider) {
        // include i18n reference to current scope
        $scope.i18n = i18n;

        $scope.can_attempt_edit = function() {
            if (!$cookies.logged_in || !$cookies.user_id || !$cookies.privilege_id || !$scope.question.author)
                return false;
            else {
                var is_author = $scope.question.author.id == $cookies.user_id;
                var is_admin = $cookies.privilege_id == 2; // USER 1 ADMIN 2
                return is_author || is_admin;
            }

        };

        $scope.can_attempt_delete = function() {
            if (!$cookies.logged_in || !$cookies.privilege_id)
                return false;
            else {
                var is_admin = $cookies.privilege_id == 2;
                return is_admin;
            }
        };

        $scope.closeAlert = function (alert) {
            AppAlert.closeAlert(alert);
        };

        $scope.do_edit = function() {
            alert("nope");
        };

        $scope.do_delete = function() {
            alert("nope");
        };
    }
]);
