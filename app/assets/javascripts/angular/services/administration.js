var services_module = angular.module('qa.services');

services_module.factory('Administration', [
    '$http',
    function($http){
        return {
            get_users:
                function(page, search_by){
                    var ajax_config = {
                        'method': 'GET',
                        'url': '/users.json',
                        params: {
                            page: page,
                            search_by: (search_by==null)?'':search_by
                        }
                    };
                    return $http(ajax_config);
                },
            ban:
                function(user){
                    var ajax_config = {
                        'method': 'GET',
                        'url': 'users/ban.json',
                        params: {
                            user_id: user.id
                        }
                    };
                    return $http(ajax_config);
                },
            unban:
                function(user){
                    var ajax_config = {
                        'method': 'GET',
                        'url': 'users/unban.json',
                        params: {
                            user_id: user.id
                        }
                    };
                    return $http(ajax_config);
                },
            promote:
                function(user){
                    var ajax_config = {
                        'method': 'GET',
                        'url': 'users/promote.json',
                        params:{
                            user_id: user.id
                        }
                    };
                    return $http(ajax_config);
                },
            demote:
                function(user){
                    var ajax_config = {
                        'method': 'GET',
                        'url': 'users/demote.json',
                        params:{
                            user_id: user.id
                        }
                    };
                    return $http(ajax_config);
                },
            get_user:
                function(param_id){
                    var ajax_config = {
                            'method': 'GET',
                            'url': 'users/profile.json',
                            params:{
                                user_id:param_id
                            }
                    };
                    return $http(ajax_config);
                }
        }
    }
]);

services_module.factory('AppAlert', [
    '$rootScope', function($rootScope) {
        var alertService;
        $rootScope.alerts = [];
        return alertService = {
            add: function(type, msg) {
                return $rootScope.alerts.push({
                    type: type,
                    msg: msg,
                    close: function() {
                        return alertService.closeAlert(this);
                    }
                });
            },
            closeAlert: function(alert) {
                return this.closeAlertIdx($rootScope.alerts.indexOf(alert));
            },
            closeAlertIdx: function(index) {
                return $rootScope.alerts.splice(index, 1);
            },
            clear: function(){
                $rootScope.alerts = [];
            }
        };
    }
])