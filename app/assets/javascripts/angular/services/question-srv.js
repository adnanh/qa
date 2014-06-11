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
                },

            delete:
                function(question){
                    var ajax_config = {
                        'method': 'DELETE',
                        'url': 'questions/'+question.id+'.json'
                    };
                    return $http(ajax_config);
                },

            post:
                function(question){
                    if (!question.edited_title)
                        question.edited_title = "";
                    if (!question.edited_content)
                        question.edited_content = "";

                    var ajax_config = {
                        'method': 'POST',
                        'url': 'questions/'+question.id+'.json',
                        'data': {
                            'title': question.edited_title,
                            'content': question.edited_content
                        }
                    };
                    return $http(ajax_config);
                },
            vote:
                function(item,val){
                    var ajax_config = {
                    'method': 'POST',
                    'url': 'question/vote.json',
                     params: {
                            item_id: item.id,
                            value: val,
                            user_created:item.author.id
                        }
                    };
                    return $http(ajax_config);
                },
            get_similar_to:
                function(question_id){
                    var ajax_config = {
                        'method': 'GET',
                        'url': 'search/questions/similar/'+question_id+'.json'
                    };
                    return $http(ajax_config);
                },
            close:
                function(question){
                    var ajax_config = {
                        'method': 'POST',
                        'url': 'questions/'+question.id+'/close.json',
                        params:{
                            explanation: question.status_description
                        }
                    };
                    return $http(ajax_config);
                },
            open:
                function(question){
                    var ajax_config = {
                        'method': 'POST',
                        'url': 'questions/'+question.id+'/open.json'
                    };
                    return $http(ajax_config);
                },
            report:
                function(item_id){
                    var ajax_config = {
                        'method': 'GET',
                        'url': 'report.json',
                        params: {
                            question_id: item_id
                        }
                    };
                    return $http(ajax_config);
                }
        }
    }
]);