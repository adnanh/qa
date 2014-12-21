

var ctrl_module = angular.module('qa.controllers');

ctrl_module.controller('FeedCtrl', ['$scope','$location', 'i18n', 'Feed', 'AppAlert', 'ErrorProvider',
    function ($scope,$location, i18n, FeedSrv, AppAlert, ErrorProvider) {
         $scope.questions = [];
         $scope.current_page = 1;
         $scope.items_per_page = 10;
         $scope.total_questions = 0;

        $scope.order_by = 'best-first';

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
    }
]);