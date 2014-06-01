var ctrl_module = angular.module('qa.controllers');

ctrl_module.controller('ProfileViewCtrl', ['$scope', '$routeParams', '$location', 'i18n', 'AppAlert', 'ErrorProvider', 'User', 'Kudo',
    function ($scope, $routeParams, $location, i18n, AppAlert, ErrorProvider, User, Kudo) {
        // include i18n reference to current scope
        $scope.i18n = i18n;

        // get UID from route
        $scope.user_id = $routeParams.user_id;

        // toggle profile display
        $scope.user_set = false;

        // function to fetch user from ws
        var load_user = function(user_id){
            User.get_user(user_id)
                .success(
                    function(data){
                        if (data.success){
                            $scope.user = data.response.user;
                            $scope.user.karma_image = Kudo.get_karma_image($scope.user);
                            $scope.user_set = true;
                        }
                        else {
                            AppAlert.add('danger',data.message);
                            $scope.user_set = false;
                        }
                    }
                )
                .error(
                    function(data, status){
                        AppAlert.add("danger", ErrorProvider.get_message(status,'Viewing profile for user UID= '+user_id));
                        $scope.user_set = false;
                    }
                );
        };

        load_user($scope.user_id);
    }
]);
