var services_module = angular.module('qa.services');

services_module.factory('User', [
    '$http',
    function($http){
        return {
            get_user:
                function(user_id){
                    var ajax_config = {
                        'method': 'GET',
                        'url': 'user/public/profile.json',
                        params:{
                            user_id:user_id
                        }
                    };
                    return $http(ajax_config);
                }
        }
    }
]);