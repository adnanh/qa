

var ctrl_module = angular.module('qa.controllers');

ctrl_module.controller('FeedCtrl', ['$scope', 'i18n', 'Feed', 'AppAlert', 'ErrorProvider',
    function ($scope, i18n, FeedSrv, AppAlert, ErrorProvider) {
         $scope.questions = [];
         $scope.current_page = 1;
         $scope.items_per_page = 10;
         $scope.total_questions = 0;

         $scope.get_page = function (page) {
         FeedSrv.get_questions(page)
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
         $scope.get_page(page);
         };

         $scope.page_selected(1);
    }
]);