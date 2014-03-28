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
                }
        }
    }
]);