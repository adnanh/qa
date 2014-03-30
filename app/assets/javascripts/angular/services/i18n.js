var services_module = angular.module('qa.services');

services_module.service('i18n', ['$http', '$cookies',
    function($http,$cookies){
        this.t = {};
        this.locale = "";

        // WARNING - no fallbacks are provided b/c locales should always be able to load. If there's a problem with them, theres a problem with website so it doesnt matter either way.
        this.load_locale = function(new_locale){
            if (new_locale === this.locale) return;

            var lthis = this;
            var path = '/locales/'+new_locale+'.json';
            $http.get(path)
                .success(
                    function(data){
                        lthis.t = data;
                        lthis.locale = new_locale;
                        lthis.set_locale(new_locale);
                    }
                )
                .error(
                    function(data,status){
                        console.log('kaboom! data: '+data+' status: '+status);
                    }
                );
        };

        this.set_locale = function(new_locale){
           var ajax_confix = {
                'url': '/locale/set',
                'method': 'POST',
                data: {
                    'locale': new_locale
                }
            };

            // just set it and be over with it
            $http(ajax_confix);
        };

        // reads locale from browser settings - Accept-Language header is used b/c fukken javascript wont be able to read values accross all browsers
        this.get_locale = function(){
            var lthis = this;
            // call web service that'll read header for us -_-
            $http.get('/locale/read')
                .success(
                    function(data){
                        var l;
                        if (data.locale)
                            l = data.locale;
                        else
                            l = 'en';

                        lthis.load_locale(l);
                    }
                )
                .error(
                    function(data,status){
                        console.log('epic error occurred with status '+status);
                        lthis.load_locale('en');
                    }
                );
        }

        // init me
        this.get_locale();
    }
]);