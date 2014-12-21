var services_module = angular.module('qa.services');

services_module.factory('PrivateMessages', ['$http',
    function($http){
        return {
            countUnreadMessages: function(){
                var ajax_config = {
                    method: 'GET',
                    url: '/messages/unread.json'
                };

                return $http(ajax_config);
            },

            inbox: function() {
                var ajax_config = {
                    'method': 'GET',
                    'url': '/messages/inbox.json'
                };

                return $http(ajax_config);
            },
            outbox: function() {
                var ajax_config = {
                    'method': 'GET',
                    'url': '/messages/outbox.json'
                };

                return $http(ajax_config);
            },
            send:
                function(message){
                    var ajax_config = {
                        'method': 'POST',
                        'url': '/messages.json',
                        params: {
                            title: message.title,
                            content: message.content,
                            receiver_id: message.recipient.id
                        }
                    };
                    return $http(ajax_config);
                },
            get:
                function(message_id){
                    var ajax_config = {
                        'method': 'GET',
                        'url': '/messages/' + message_id+ '.json'
                    };
                    return $http(ajax_config);
                },
            delete:
                function(message_id){
                    var ajax_config = {
                        'method': 'DELETE',
                        'url': '/messages/'+message_id+'.json'
                    };
                    return $http(ajax_config);
                },
            suggestUsers:
                function(filter_string){
                    var ajax_config = {
                        'method': 'POST',
                        'url': '/users/suggest.json',
                        params: {
                            filter_string: filter_string
                        }
                    };
                    return $http(ajax_config);
                },
            getUserById:
                function(id){
                    var ajax_config = {
                        'method': 'GET',
                        'url': 'user/public/profile.json',
                        params: {
                            user_id: id
                        }
                    };
                    return $http(ajax_config);
                }
        }
    }
]);