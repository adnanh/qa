// controller for asking questions

var ctrl_module = angular.module('qa.controllers');


ctrl_module.controller('AskCtrl', ['$scope', 'i18n', 'Question', 'AppAlert', 'ErrorProvider',
    function ($scope, i18n, QuestionSrv, AppAlert, ErrorProvider) {
        // include i18n reference to current scope
        $scope.i18n = i18n;

        $scope.question = {};

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