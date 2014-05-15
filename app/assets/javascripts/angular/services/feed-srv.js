var services_module = angular.module('qa.services');

services_module.factory('Feed', ['$http',
    function($http){
        return {
            get_questions:
                function(page){
                    var ajax_config = {
                        'method': 'GET',
                        'url': '/questions.json',
                        params: {
                            page: page
                        }
                    };
                    return $http(ajax_config);
                }
        }
    }
]);