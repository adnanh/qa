var ctrl_module = angular.module('qa.controllers');

ctrl_module.controller('QuestionPageCtrl', ['$scope','$cookies', 'i18n', '$routeParams', 'Question', 'AppAlert', 'ErrorProvider', 'Kudo',
    function ($scope,$cookies, i18n, $routeParams, Question, AppAlert, ErrorProvider, Kudo) {
        // include i18n reference to current scope
        $scope.i18n = i18n;

        // question used throughout this controller and its children : answers-view and (do)answer
        $scope.question = {};

        // get question_id from route params
        $scope.question.id = $routeParams.question_id;

        $scope.question_set = false;

        // questions similar to the current one
        $scope.similar_questions = [];

        $scope.question_closed = false;

       $scope.isOpen = function(){
         return $scope.question.open
       };

       $scope.canClose = function(){
         return $scope.question.open && $cookies.privilege_id == 2
       };

        $scope.canOpen = function(){
          return !$scope.question.open && $cookies.privilege_id == 2
        };

        $scope.isAdmin = function(){
            return $cookies.privilege_id == 2; // USER 1 ADMIN 2
        };

        // function used to get question with ID specified from the webapi.
        // to see the JSON object returned, see rails partial question/_question.json.erb
        var load_question = function(question_id){
            Question.get(question_id)
                .success(
                    function(data){
                        if (data.success){
                            $scope.question = data.question;
                            // get tags from concatenated string..
                            $scope.question.tags_list = $scope.question.tags.split(";");
                            $scope.question_set = true;

                            // editing stuff
                            $scope.question.edit_mode = false;
                            $scope.question.edited_content = $scope.question.content;
                            $scope.question.edited_title = $scope.question.title;

                            // karma stuff
                            var karma_image = Kudo.get_karma_image(data.question.author);
                            $scope.question.author.karma_image = karma_image;

                            if (data.question.editor !== undefined)
                            {
                                var editor_karma_image = Kudo.get_karma_image(data.question.editor);
                                $scope.question.editor.karma_image = editor_karma_image;
                            }

                        }
                        else {
                            AppAlert.add("danger", data.message);
                            $scope.question_set = false;
                        }
                    }
                )
                .error(
                    function(data, status){
                        AppAlert.add("danger", ErrorProvider.get_message(status,'Retreiveing question "'+question_id+'"'));
                        $scope.question_set = false;
                    }
                );
        };

        $scope.close_question = function() {
            Question.close($scope.question)
                .success(
                function(data){
                    if (data.success){
                        // just apply changes locally, no need for going to ws
                        AppAlert.add("success",data.message);
                        $scope.question.open = false;
                    }
                    else {
                        AppAlert.add("danger", data.message);
                    }
                }
            )
                .error(
                function(data, status){
                    AppAlert.add("danger", ErrorProvider.get_message(status,'Close question "' + $scope.question.id));
                }
            );
        };

        $scope.open_question = function() {
            Question.open($scope.question)
                .success(
                function(data){
                    if (data.success){
                        // just apply changes locally, no need for going to ws
                        AppAlert.add("success",data.message);
                        $scope.question.open = true;
                    }
                    else {
                        AppAlert.add("danger", data.message);
                    }
                }
            )
                .error(
                function(data, status){
                    AppAlert.add("danger", ErrorProvider.get_message(status,'Close question "' + $scope.question.id));
                }
            );
        };

        // init the question
        load_question($scope.question.id);

        var load_similar_questions = function(question_id){
            Question.get_similar_to(question_id)
                .success(
                    function (data){
                        if (data.success){
                            $scope.similar_questions = data.response.questions;
                        }
                        else {
                            AppAlert.add('danger',data.message);
                        }
                    }
                )
                .error(
                    function (data, status){
                        AppAlert.add("danger", ErrorProvider.get_message(status,'Retreiveing questions similar to current question.'));
                    }
                );
        };

        load_similar_questions($scope.question.id);
    }
]);
