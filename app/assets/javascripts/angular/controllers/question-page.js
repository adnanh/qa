var ctrl_module = angular.module('qa.controllers');

ctrl_module.controller('QuestionPageCtrl', ['$scope', 'i18n', '$routeParams', 'Question', 'AppAlert', 'ErrorProvider',
    function ($scope, i18n, $routeParams, Question, AppAlert, ErrorProvider) {
        // include i18n reference to current scope
        $scope.i18n = i18n;

        // question used throughout this controller and its children : answers-view and (do)answer
        $scope.question = {};

        // get question_id from route params
        $scope.question.id = $routeParams.question_id;

        $scope.question_set = false;

        // questions similar to the current one
        $scope.similar_questions = [];

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
                            karma_image = null;

                            if (data.question.author.karma >= 2000)
                            {
                                karma_image = '/assets/blue_gold_medal_small.png';
                            }
                            else if (data.question.author.karma >= 1500)
                            {
                                karma_image = '/assets/green_gold_medal_small.png';
                            }
                            else if (data.question.author.karma >= 1000)
                            {
                                karma_image = '/assets/red_gold_medal_small.png';
                            }
                            else if (data.question.author.karma >= 750)
                            {
                                karma_image = '/assets/blue_silver_medal_small.png';
                            }
                            else if (data.question.author.karma >= 400)
                            {
                                karma_image = '/assets/green_silver_medal_small.png';
                            }
                            else if (data.question.author.karma >= 250)
                            {
                                karma_image = '/assets/red_silver_medal_small.png';
                            }
                            else if (data.question.author.karma >= 150)
                            {
                                karma_image = '/assets/blue_bronze_medal_small.png';
                            }
                            else if (data.question.author.karma >= 100)
                            {
                                karma_image = '/assets/green_bronze_medal_small.png';
                            }
                            else if (data.question.author.karma >= 50)
                            {
                                karma_image = '/assets/red_bronze_medal_small.png';
                            }

                            $scope.question.author.karma_image = karma_image;

                            if (data.question.editor !== undefined)
                            {
                                editor_karma_image = null;

                                if (data.question.editor.karma >= 2000)
                                {
                                    editor_karma_image = '/assets/blue_gold_medal_small.png';
                                }
                                else if (data.question.editor.karma >= 1500)
                                {
                                    editor_karma_image = '/assets/green_gold_medal_small.png';
                                }
                                else if (data.question.editor.karma >= 1000)
                                {
                                    editor_karma_image = '/assets/red_gold_medal_small.png';
                                }
                                else if (data.question.editor.karma >= 750)
                                {
                                    editor_karma_image = '/assets/blue_silver_medal_small.png';
                                }
                                else if (data.question.editor.karma >= 400)
                                {
                                    editor_karma_image = '/assets/green_silver_medal_small.png';
                                }
                                else if (data.question.editor.karma >= 250)
                                {
                                    editor_karma_image = '/assets/red_silver_medal_small.png';
                                }
                                else if (data.question.editor.karma >= 150)
                                {
                                    editor_karma_image = '/assets/blue_bronze_medal_small.png';
                                }
                                else if (data.question.editor.karma >= 100)
                                {
                                    editor_karma_image = '/assets/green_bronze_medal_small.png';
                                }
                                else if (data.question.editor.karma >= 50)
                                {
                                    editor_karma_image = '/assets/red_bronze_medal_small.png';
                                }

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
