// controller for admin panel

var ctrl_module = angular.module('qa.controllers');

ctrl_module.controller('AdminCtrl', ['$scope', 'Administration',
    function ($scope, AdministrationSrv) {
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
                        if(data.success)
                            console.log('ban');
                            user.banned = true;
                    })
                .error(
                function (data, status) {
                    console.log(status);
                });
        };

        $scope.unban = function(user) {
            AdministrationSrv.unban(user).success(
                function (data){
                    if(data.success)
                        console.log('ban');
                        user.banned = false;
                })
                .error(
                function (data, status) {
                    console.log(status);
                });
        };

        $scope.promote = function(user){
            AdministrationSrv.promote(user).success(
                function(data){
                    if(data.success)
                        user.privilege_id = 2;
                        user.privilege = 'Administrator';
                        console.log('promote'+ user.id);
                })
                .error(
                function(data, status){
                    console.log(status);
                });
        };


        $scope.demote = function(user){
            AdministrationSrv.demote(user).success(
                function(data){
                    if(data.success)
                        user.privilege_id = 1;
                        user.privilege = 'Registered user';
                        console.log('demote'+ user.id);
                })
                .error(
                function(data, status){
                    console.log(status);
                });
        };
    }
]);