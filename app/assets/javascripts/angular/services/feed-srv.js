var services_module = angular.module('qa.services');

services_module.factory('Feed', ['$http',
    function($http){
        return {
            get_questions:
                function(page,search_by,order_by){
                    var ajax_config = {
                        'method': 'GET',
                        'url': 'search/questions.json',
                        params: {
                            page: page,
                            search_by: (search_by==null)?'':search_by,
                            order_by: order_by
                        }
                    };
                    return $http(ajax_config);
                }
        }
    }
]);