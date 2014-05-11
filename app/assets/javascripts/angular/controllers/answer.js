var ctrl_module = angular.module('qa.controllers');

ctrl_module.controller('AnswerCtrl', ['$scope', '$cookies', 'i18n', 'Answer', 'AppAlert', 'ErrorProvider',
    function ($scope, $cookies, i18n, Answer, AppAlert, ErrorProvider) {
        // include i18n reference to current scope
        $scope.i18n = i18n;
        // answer to be posted
        $scope.answer = {
            content: ""
        }

        $scope.user_logged_in = function(){
            if ($cookies.logged_in)
                return $cookies.logged_in;
            else
                return false;
        }

        // reload answers with current settings
        $scope.do_reload = function(){

        };



        $scope.submit = function() {
            Answer.put($scope.question.id,$scope.answer.content)
                .success(
                function(data){
                    if (data.success){
                        AppAlert.add('success', 'Your answer has been successfully posted.');
                        $scope.do_reload();
                    }
                    else {
                        AppAlert.add('danger', data.reason);
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
