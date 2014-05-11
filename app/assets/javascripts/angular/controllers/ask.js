// controller for asking questions

var ctrl_module = angular.module('qa.controllers');


ctrl_module.controller('AskCtrl', ['$scope', 'i18n', 'Question', 'AppAlert', 'ErrorProvider',
    function ($scope, i18n, QuestionSrv, AppAlert, ErrorProvider) {
        // include i18n reference to current scope
        $scope.i18n = i18n;

        $scope.question = {};

       /* $scope.questions = [];
        $scope.current_page = 1;
        $scope.items_per_page = 10;
        $scope.total_questions = 0;

        $scope.get_page = function (page) {
            QuestionSrv.get_questions(page)
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

        $scope.page_selected(1);*/

        $scope.title_invalid = function(ask_form) {
            return ask_form.title.$invalid && !ask_form.title.$pristine;
        };

        $scope.reset_form = function(ask_form) {
            $scope.question = {
                title: "",
                content: "",
                tags: []
            };
            ask_form.title.$pristine = true;
        };

        $scope.closeAlert = function (alert) {
            AppAlert.closeAlert(alert);
        };

        $scope.submit = function(){
            QuestionSrv.put($scope.question)
                .success(
                    function(data){
                        if (data.success){
                            AppAlert.add("success", data.message);
                        }
                        else {
                            AppAlert.add("danger", data.message);
                        }
                    }
                )
                .error(
                    function(data, status){
                        AppAlert.add("danger", ErrorProvider.get_message(status,'Posting a new question'));
                    }
                )
        }

    }
]);