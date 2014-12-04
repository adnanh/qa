var ctrl_module = angular.module('qa.controllers');

ctrl_module.controller('AnswersViewCtrl', ['$scope', '$cookies', 'i18n', 'Answer', 'AppAlert', 'ErrorProvider', 'Kudo', '$location',
    function ($scope, $cookies, i18n, Answer, AppAlert, ErrorProvider, Kudo, $location) {
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

        $scope.canPick = function (answer){
            return $scope.isAuthor() && answer.accepted == 0;
        };


        $scope.canUnpick = function (answer){
            return $scope.isAuthor() && answer.accepted == 1;
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
                            var karma_image = Kudo.get_karma_image(data.answers[i].author);
                            $scope.answers[i].author.karma_image = karma_image;

                            if (data.answers[i].editor !== undefined)
                            {
                                editor_karma_image = Kudo.get_karma_image(data.answers[i].editor);
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

        $scope.isAccepted = function(answer)
        {
            return answer.accepted==1;
        }

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

        $scope.to_permalink = function (answer_id){
            $location.path('q/'+$scope.question.id+"/a/"+answer_id);
            return false;
        };

        $scope.pick = function(answer){
            Answer.pick($scope.question.id,answer.id)
                .success(
                function(data){
                    if (data.success){
                        AppAlert.add("success", data.message);
                        answer.accepted = 1;
                    }
                    else {
                        AppAlert.add("danger", data.message);
                    }
                }
            )
            .error(
                    function(data, status){
                        AppAlert.add("danger", ErrorProvider.get_message(status,'Pick unsuccesful "'+answer.id+'"'));
                    }
            );
        };

        $scope.unpick = function(answer){
            Answer.unpick($scope.question.id,answer.id)
                .success(
                function(data){
                    if (data.success){
                        AppAlert.add("success", data.message);
                        answer.accepted = 0;
                    }
                    else {
                        AppAlert.add("danger", data.message);
                    }
                }
            )
                .error(
                function(data, status){
                    AppAlert.add("danger", ErrorProvider.get_message(status,'Unpick unsuccesful "'+answer.id+'"'));
                }
            );
        };
        $scope.report = function(question_id, answer_id) {
            Answer.report(question_id, answer_id)
                .success(
                function(data) {
                    if (data.success) {
                        AppAlert.add('success', 'Answer has been successfully reported.');
                    }
                    else
                    {
                        AppAlert.add('danger', data.message);
                    }
                }
            );
        };

    }
]);
