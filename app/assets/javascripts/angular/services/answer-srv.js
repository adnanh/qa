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
                },
            post:
                function(question_id, answer){
                    var ajax_config = {
                        'method': 'POST',
                        'url': '/question/' + question_id + '/answers/'+answer.id+'.json',
                        params: {
                            question_id: question_id,
                            answer_id: answer.id,
                            content: answer.edited_content
                        }
                    };
                    return $http(ajax_config);
                },
            delete:
                function(question_id, answer){
                    var ajax_config = {
                        'method': 'DELETE',
                        'url': '/question/' + question_id + '/answers/'+answer.id+'.json'
                    };
                    return $http(ajax_config);
                }
        }
    }
]);