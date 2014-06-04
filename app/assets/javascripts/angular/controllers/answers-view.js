var ctrl_module = angular.module('qa.controllers');

ctrl_module.controller('AnswersViewCtrl', ['$scope', '$cookies', 'i18n', 'Answer', 'AppAlert', 'ErrorProvider',
    function ($scope, $cookies, i18n, Answer, AppAlert, ErrorProvider) {
        // include i18n reference to current scope
        $scope.i18n = i18n;

        // answers to display
        $scope.answers = [];
        // on new, current page is set to 1st
        $scope.current_page = 1;
        // limit 10 items per page
        $scope.items_per_page = 10;
        // on new, we dont know how many answers for current question are there
        $scope.total_answers = 0;
        // dropdown open
        $scope.dropdown = {
            isopen: false
        };
        // allowed values: newest-first, oldest-first, best-first
        $scope.order_by = 'newest-first';

        $scope.reorder = function (new_order) {
            $scope.order_by = new_order;
            $scope.page_selected(1);
        };

        $scope.get_page = function (page, question_id, order_by) {
            Answer.get_all(question_id, page, order_by)
                .success(
                function (data) {
                    if (data.success) {
                        $scope.total_answers = data.total_answers;
                        $scope.answers = data.answers;
                        for (var i=0; i<$scope.answers.length; i++){
                            $scope.answers[i].edit_mode = false;
                            $scope.answers[i].edited_content = $scope.answers[i].content;

                            // karma stuff
                            karma_image = null;

                            if (data.answers[i].author.karma >= 2000)
                            {
                                karma_image = '/assets/blue_gold_medal_small.png';
                            }
                            else if (data.answers[i].author.karma >= 1500)
                            {
                                karma_image = '/assets/green_gold_medal_small.png';
                            }
                            else if (data.answers[i].author.karma >= 1000)
                            {
                                karma_image = '/assets/red_gold_medal_small.png';
                            }
                            else if (data.answers[i].author.karma >= 750)
                            {
                                karma_image = '/assets/blue_silver_medal_small.png';
                            }
                            else if (data.answers[i].author.karma >= 400)
                            {
                                karma_image = '/assets/green_silver_medal_small.png';
                            }
                            else if (data.answers[i].author.karma >= 250)
                            {
                                karma_image = '/assets/red_silver_medal_small.png';
                            }
                            else if (data.answers[i].author.karma >= 150)
                            {
                                karma_image = '/assets/blue_bronze_medal_small.png';
                            }
                            else if (data.answers[i].author.karma >= 100)
                            {
                                karma_image = '/assets/green_bronze_medal_small.png';
                            }
                            else if (data.answers[i].author.karma >= 50)
                            {
                                karma_image = '/assets/red_bronze_medal_small.png';
                            }

                            $scope.answers[i].author.karma_image = karma_image;

                            if (data.answers[i].editor !== undefined)
                            {
                                editor_karma_image = null;

                                if (data.answers[i].editor.karma >= 2000)
                                {
                                    editor_karma_image = '/assets/blue_gold_medal_small.png';
                                }
                                else if (data.answers[i].editor.karma >= 1500)
                                {
                                    editor_karma_image = '/assets/green_gold_medal_small.png';
                                }
                                else if (data.answers[i].editor.karma >= 1000)
                                {
                                    editor_karma_image = '/assets/red_gold_medal_small.png';
                                }
                                else if (data.answers[i].editor.karma >= 750)
                                {
                                    editor_karma_image = '/assets/blue_silver_medal_small.png';
                                }
                                else if (data.answers[i].editor.karma >= 400)
                                {
                                    editor_karma_image = '/assets/green_silver_medal_small.png';
                                }
                                else if (data.answers[i].editor.karma >= 250)
                                {
                                    editor_karma_image = '/assets/red_silver_medal_small.png';
                                }
                                else if (data.answers[i].editor.karma >= 150)
                                {
                                    editor_karma_image = '/assets/blue_bronze_medal_small.png';
                                }
                                else if (data.answers[i].editor.karma >= 100)
                                {
                                    editor_karma_image = '/assets/green_bronze_medal_small.png';
                                }
                                else if (data.answers[i].editor.karma >= 50)
                                {
                                    editor_karma_image = '/assets/red_bronze_medal_small.png';
                                }

                                $scope.answers[i].editor.karma_image = editor_karma_image;
                            }
                        }
                    } else {
                        AppAlert.add("danger", data.message);
                    }
                })
                .error(
                function (data, status) {
                    AppAlert.add("danger", ErrorProvider.get_message(status,'Fetching answers for question "'+$scope.question.id+'"'));
                });

        };

        $scope.can_vote = function()
        {
            return $cookies.logged_in
        }

        $scope.page_selected = function (page) {
            $scope.get_page(page, $scope.question.id, $scope.order_by);
        };

        $scope.page_selected(1);

        // checks whether current user can edit selected answer
        $scope.can_attempt_edit = function(answer) {
            if (!$cookies.logged_in || !$cookies.user_id || !$cookies.privilege_id || !$scope.question.author)
                return false;
            else {
                var is_author = $scope.question.author.id == $cookies.user_id;
                var is_admin = $cookies.privilege_id == 2; // USER 1 ADMIN 2
                return (is_author || is_admin) && $scope.question.open ;
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

        $scope.do_edit = function(answer) {
            // close all other edits
            for (var i=0; i<$scope.answers.length; i++){
                if ($scope.answers[i].id == answer.id && $scope.answers[i].edit_mode){
                    $scope.cancel_edit($scope.answers[i]);
                    return;
                }
                $scope.cancel_edit($scope.answers[i]);
            }
            answer.edit_mode = true;
        };

        $scope.cancel_edit = function(answer) {
            answer.edit_mode = false;
            answer.edited_content = answer.content;
        };

        $scope.submit_edit = function(answer){
            Answer.post($scope.question.id, answer)
                .success(
                    function(data){
                        if (data.success){
                            // just apply changes locally, no need for going to ws
                            AppAlert.add("success",data.message);
                            answer.content = answer.edited_content;
                        }
                        else {
                            AppAlert.add("danger", data.message);
                        }
                    }
                )
                .error(
                    function(data, status){
                        AppAlert.add("danger", ErrorProvider.get_message(status,'Editing answer "' + answer.id +'" for question "'+$scope.question.id+'"'));
                    }
                );
        };

        $scope.do_delete = function(answer) {
            Answer.delete($scope.question.id, answer)
                .success(
                    function(data){
                        if (data.success){
                            AppAlert.add("success" ,data.message);
                            $scope.page_selected(1);
                        } else {
                            AppAlert.add("danger", data.message);
                        }
                    }
                )
                .error(
                    function(data,status){
                        AppAlert.add("danger", ErrorProvider.get_message(status,'Deleting answer "' + answer.id +'" for question "'+$scope.question.id+'"'));
                    }
                )
        };



        // handle them events from submit, prolly should use a service but who cares..
        $scope.$root.$on('do_reload_plz',
               function(event, args){
                    $scope.reorder('newest-first');
               }
        );

        $scope.up_vote = function(answer){
            Answer.vote(answer,true)
                .success(
                function(data){
                    if (data.success){
                        // deletion was successful, redirect to home
                        AppAlert.add("success", data.message);
                        answer.upvotes++;
                        //$location.path('home');
                    }
                    else {
                        AppAlert.add("danger", data.message);
                    }
                }
            )
                .error(
                function(data, status){
                    AppAlert.add("danger", ErrorProvider.get_message(status,'Vote unsuccesful "'+answer.id+'"'));
                }
            );
        };

        $scope.down_vote = function(answer){
            Answer.vote(answer,false)
                .success(
                function(data){
                    if (data.success){
                        // deletion was successful, redirect to home
                        AppAlert.add("success", data.message);
                        //$location.path('home');
                        answer.downvotes++;
                    }
                    else {
                        AppAlert.add("danger", data.message);
                    }
                }
            )
                .error(
                function(data, status){
                    AppAlert.add("danger", ErrorProvider.get_message(status,'Vote unsuccesful "'+answer.id+'"'));
                }
            );
        };

    }
]);
