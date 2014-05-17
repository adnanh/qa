var services_module = angular.module('qa.services');

services_module.factory('Question', ['$http',
    function($http){
        return {
            // transform this: "tags":[{"text":"C"},{"text":"C#"}]
            // into this: "tags": "C;C#"
            transform_tags:
                function(tags) {
                    var newtags = "";
                    for (var i=0;i<tags.length-1;i++){
                        newtags+= tags[i].text+";";
                    }
                    newtags+= tags[tags.length-1].text;
                    return newtags;
                },

            put:
                function(question){
                    var ajax_config = {
                        'method': 'PUT',
                        'url': '/questions.json',
                        params: {
                            title: question.title,
                            content: question.content,
                            tags: this.transform_tags(question.tags)
                        }
                    };
                    return $http(ajax_config);
                },

            get:
                function(question_id){
                    var ajax_config = {
                        'method': 'GET',
                        'url': 'questions/' + question_id+ '.json'
                    };
                    return $http(ajax_config);
                }
        }
    }
]);