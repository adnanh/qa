

var ctrl_module = angular.module('qa.controllers');

ctrl_module.controller('FeedCtrl', ['$scope','$location', 'i18n', 'Feed', 'AppAlert', 'ErrorProvider', 'Question', '$cookies', '$rootScope',
    function ($scope,$location, i18n, FeedSrv, AppAlert, ErrorProvider, Question, $cookies, $rootScope) {
         $scope.questions = [];
         $scope.current_page = 1;
         $scope.items_per_page = 10;
         $scope.total_questions = 0;

         $scope.order_by = 'best-first';

        $rootScope.$on('doSearch', function(event, term){
            $scope.search_by = term;
            $scope.page_selected(1);
        });

         $scope.get_page = function (page,search_by,order_by) {
             FeedSrv.get_questions(page,search_by,order_by)
                 .success(
                     function (data) {
                         if (data.success) {
                         $scope.total_questions = data.response.total_questions;
                         $scope.questions = data.response.questions;
                         } else {

                     }
                 })
                 .error(
                     function (data, status) {
                     console.log(status);
                 });

         };

         $scope.page_selected = function (page) {
            $scope.get_page(page,$scope.search_by,$scope.order_by);
         };

         $scope.page_selected(1);

        $scope.go = function ( path ) {
            $location.path( path );
        };


        $scope.reorder = function (new_order) {
            $scope.order_by = new_order;
            $scope.page_selected(1);
        };

        $scope.dropdown = {
            isopen: false
        };

        // handle them events from submit, prolly should use a service but who cares..
        $scope.$root.$on('do_reload_plz',
            function(event, args){
                $scope.reorder('newest-first');
            }
        );

        $scope.can_vote = function(question)
        {
            var is_author = false;
            if (question.author !== undefined)
            {
                is_author = question.author.id == $cookies.user_id;
            }
            return $cookies.logged_in && !is_author;
        }

        $scope.up_vote = function(question) {
            Question.vote(question,true)
                .success(
                function(data){
                    if (data.success){
                        AppAlert.add("success", data.message);
                        if (data.new)
                            question.upvotes++;
                        else {
                            question.upvotes++;
                            question.downvotes--;
                        }
                    }
                    else {
                        AppAlert.add("danger", data.message);
                    }
                }
            )
                .error(
                function(data, status){
                    AppAlert.add("danger", ErrorProvider.get_message(status,'Vote unsuccesful "'+question.id+'"'));
                }
            );
        };

        $scope.down_vote = function(question) {
            Question.vote(question,false)
                .success(
                function(data){
                    if (data.success){
                        // deletion was successful, redirect to home
                        AppAlert.add("success", data.message);
                        //$location.path('home');
                        if (data.new)
                            question.downvotes++;
                        else {
                            question.upvotes--;
                            question.downvotes++;
                        }
                    }
                    else {
                        AppAlert.add("danger", data.message);
                    }
                }
            )
                .error(
                function(data, status){
                    AppAlert.add("danger", ErrorProvider.get_message(status,'Vote unsuccesful "'+question.id+'"'));
                }
            );
        };
    }
]);