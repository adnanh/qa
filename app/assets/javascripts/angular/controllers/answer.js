var ctrl_module = angular.module('qa.controllers');

ctrl_module.controller('AnswerCtrl', ['$scope', '$cookies', 'i18n', 'Answer', 'AppAlert', 'ErrorProvider',
    function ($scope, $cookies, i18n, Answer, AppAlert, ErrorProvider) {
        // include i18n reference to current scope
        $scope.i18n = i18n;
        // answer to be posted
        $scope.answer = {
            content: ""
        };
        $scope.poster = {
            open: false
        };

        $scope.user_logged_in = function(){
            if ($cookies.logged_in)
                return $cookies.logged_in;
            else
                return false;
        }

        $scope.canAnswer = function(){
            return $scope.user_logged_in() && $scope.question.open
        };

        // reload answers with current settings
        $scope.do_reload = function(answer_submit_form){
            $scope.$root.$broadcast('do_reload_plz',{});
            $scope.reset_form(answer_submit_form);
            $scope.poster.open = false;
        };

        $scope.submit = function(answer_submit_form) {
            Answer.put($scope.question.id,$scope.answer.content)
                .success(
                function(data){
                    if (data.success){
                        AppAlert.add('success', 'Your answer has been successfully posted.');
                        $scope.do_reload(answer_submit_form);
                    }
                    else {
                        AppAlert.add('danger', data.message);
                    }
                }
            )
                .error(
                function (data, status){
                    AppAlert.add("danger", ErrorProvider.get_message(status,'Posting answer to question "'+$scope.question.id+'"'));
                }
            );
        };

        $scope.reset_form = function(answer_submit_form) {
            $scope.answer = {
                content: ""
            };
            answer_submit_form.content.$pristine = true;
        };
    }
]);
