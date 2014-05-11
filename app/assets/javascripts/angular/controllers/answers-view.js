var ctrl_module = angular.module('qa.controllers');

ctrl_module.controller('AnswersViewCtrl', ['$scope', 'i18n', 'Answer', 'AppAlert', 'ErrorProvider',
    function ($scope, i18n, Answer, AppAlert, ErrorProvider) {
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
                    } else {
                        AppAlert.add("danger", data.message);
                    }
                })
                .error(
                function (data, status) {
                    AppAlert.add("danger", ErrorProvider.get_message(status,'Fetching answers for question "'+$scope.question.id+'"'));
                });

        };

        $scope.page_selected = function (page) {
            $scope.get_page(page, $scope.question.id, $scope.order_by);
        };

        $scope.page_selected(1);

    }
]);
