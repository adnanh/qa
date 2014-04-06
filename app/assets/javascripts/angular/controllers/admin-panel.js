// controller for admin panel

var ctrl_module = angular.module('qa.controllers');

ctrl_module.controller('AdminCtrl', ['$scope', 'Administration','$location','i18n','AppAlert',
    function ($scope, AdministrationSrv,$location,i18n,AppAlert) {
        $scope.i18n = i18n; // include i18n reference to current scope

        $scope.users = [];
        $scope.current_page = 1;
        $scope.items_per_page = 10;
        $scope.total_users = 0;

        $scope.get_page = function (page, search_by) {
            AdministrationSrv.get_users(page, search_by)
                .success(
                    function (data) {
                        if (data.success) {
                            $scope.total_users = data.response.total_users;
                            $scope.users = data.response.users;
                        } else {

                        }
                    })
                .error(
                function (data, status) {
                    console.log(status);
                });

        };

        $scope.page_selected = function (page) {
            $scope.get_page(page,$scope.search_by);
        };

        $scope.page_selected(1);

        $scope.ban = function(user){
            AdministrationSrv.ban(user).success(
                    function (data){
                        if(data.success){
                            AppAlert.add("success", data.message);
                            console.log('ban'+user.id);
                            user.banned = true;
                        }else{
                            AppAlert.add("danger", data.message);
                        }
                    })
                .error(
                function (data, status) {
                    AppAlert.add("danger", i18n.t.ERROR);
                    console.log(status);
                });
        };

        $scope.unban = function(user) {
            AdministrationSrv.unban(user).success(
                function (data){
                    if(data.success){
                        AppAlert.add("success", data.message);
                        console.log('unban'+ user.id);
                        user.banned = false;
                    }else{
                        AppAlert.add("danger", data.message);
                    }
                })
                .error(
                function (data, status) {
                    AppAlert.add("danger", i18n.t.ERROR);
                    console.log(status);
                });
        };

        $scope.promote = function(user){
            AdministrationSrv.promote(user).success(
                function(data){
                    if(data.success){
                        AppAlert.add("success", data.message);
                        user.privilege_id = 2;
                        user.privilege = 'Administrator';
                        console.log('promote'+ user.id);
                    }else{
                        AppAlert.add("danger", data.message);
                    }
                })
                .error(
                function(data, status){
                    AppAlert.add("danger", i18n.t.ERROR);
                    console.log(status);
                });
        };


        $scope.demote = function(user){
            AdministrationSrv.demote(user).success(
                function(data){
                    if(data.success){
                        AppAlert.add("success", "User demoted.");
                        user.privilege_id = 1;
                        user.privilege = 'Registered user';
                        console.log('demote'+ user.id);
                    }else{
                        AppAlert.add("danger", "User not demoted.");
                    }
                })
                .error(
                function(data, status){
                    AppAlert.add("danger", "User not demoted.");
                    console.log(status);
                });
        };

        $scope.go = function ( path ) {
            $location.path( path );
        };


    }
]);

ctrl_module.controller('EditCtrl', ['$scope', 'Administration','$routeParams',
    function ($scope, AdministrationSrv,$routeParams) {
        AdministrationSrv.get_user($routeParams.user_id).success(
            function(data){
                if(data.success)
                    $scope.user = data.user;
            })
            .error(
                function (data, status) {
                    console.log(status);
                });

    }
]);