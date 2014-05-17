var ctrl_module = angular.module('qa.controllers');

ctrl_module.controller('QuestionViewCtrl', ['$scope', '$cookies', '$location', 'i18n', 'Question', 'AppAlert', 'ErrorProvider',
    function ($scope, $cookies, $location, i18n, Question, AppAlert, ErrorProvider) {
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

        $scope.do_edit = function() {
            $scope.question.edit_mode = !$scope.question.edit_mode;
        };

        $scope.submit_edit = function() {
            Question.post($scope.question)
                .success(
                    function(data){
                        if (data.success){
                            // just apply changes locally, no need for going to ws
                            AppAlert.add("success",data.message);
                            $scope.question.content = $scope.question.edited_content;
                            $scope.question.title = $scope.question.edited_title;
                        }
                        else {
                            AppAlert.add("danger", data.message);
                        }
                    }
                )
                .error(
                    function(data, status){
                        AppAlert.add("danger", ErrorProvider.get_message(status,'Editing question "' + $scope.question.id));
                    }
                );
        };

        $scope.cancel_edit = function() {
            $scope.question.edit_mode = false;
            $scope.question.edited_content = $scope.question.content;
            $scope.question.edited_title = $scope.question.title;
        };

        $scope.do_delete = function() {
            Question.delete($scope.question)
                .success(
                    function(data){
                        if (data.success){
                            // deletion was successful, redirect to home
                            AppAlert.add("success", data.message);
                            $location.path('home');
                        }
                        else {
                            AppAlert.add("danger", data.message);
                        }
                    }
                )
                .error(
                    function(data, status){
                        AppAlert.add("danger", ErrorProvider.get_message(status,'Deleting question "'+$scope.question.id+'"'));
                    }
                );
        };
    }
]);
