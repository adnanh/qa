var services_module = angular.module('qa.services');


services_module.factory('GraphDataSrv', [
    '$http',
    function($http){
        return {
            get_registrations_per_day_since:
                function(start_date){
                    var ajax_config = {
                        'method': 'GET',
                        'url': 'statistics/registrations/daily.json',
                        params: {
                            start_date: start_date
                        }
                    };
                    return $http(ajax_config);
                },
            get_registration_distribution_since:
                function(start_date){
                    var ajax_config = {
                        'method': 'GET',
                        'url': 'statistics/registrations/distribution.json',
                        params: {
                            start_date: start_date
                        }
                    };
                    return $http(ajax_config);
                },
            get_answers_per_day_since:
                function(start_date){
                    var ajax_config = {
                        'method': 'GET',
                        'url': 'statistics/answers/daily.json',
                        params:{
                            start_date: start_date
                        }
                    };
                    return $http(ajax_config);
                },
            get_answered_distribution:
                function(){
                    var ajax_config = {
                        'method': 'GET',
                        'url': 'statistics/answers/distribution.json'
                    };
                    return $http(ajax_config);
                }
        }
    }
]);