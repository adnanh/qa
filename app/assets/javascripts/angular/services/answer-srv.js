var services_module = angular.module('qa.services');

services_module.factory('Answer', ['$http',
    function($http){
        return {
            put:
                function(question_id, answer_content){
                    var ajax_config = {
                        'method': 'PUT',
                        'url': '/question/'+question_id+'/answers.json',
                        params: {
                            content: answer_content
                        }
                    };
                    return $http(ajax_config);
                },

            get_all:
                function(question_id, page, order_by){
                    var ajax_config = {
                        'method': 'GET',
                        'url': 'question/' + question_id+ '/answers.json',
                        params: {
                            page: page,
                            order_by: order_by
                        }
                    };
                    return $http(ajax_config);
                }
        }
    }
]);