var ctrl_module = angular.module('qa.controllers');

ctrl_module.controller('QuestionPageCtrl', ['$scope', 'i18n', '$routeParams', 'Question', 'AppAlert', 'ErrorProvider',
    function ($scope, i18n, $routeParams, Question, AppAlert, ErrorProvider) {
        // include i18n reference to current scope
        $scope.i18n = i18n;

        // question used throughout this controller and its children : answers-view and (do)answer
        $scope.question = {};

        // get question_id from route params
        $scope.question.id = $routeParams.question_id;

        // function used to get question with ID specified from the webapi.
        // to see the JSON object returned, see rails partial question/_question.json.erb
        var load_question = function(question_id){
            Question.get(question_id)
                .success(
                    function(data){
                        if (data.success){
                            $scope.question = data.question;
                        }
                        else {
                            AppAlert.add("danger", data.message);
                        }
                    }
                )
                .error(
                    function(data, status){
                        AppAlert.add("danger", ErrorProvider.get_message(status,'Retreiveing question "'+question_id+'"'));
                    }
                );
        };

        $scope.closeAlert = function (alert) {
            AppAlert.closeAlert(alert);
        };


        // init the question
        load_question($scope.question.id);

    }
]);
