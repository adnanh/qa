var services_module = angular.module('qa.services');

services_module.service('i18n', ['$http',
    function($http){
        this.translations = {};
        this.locale = "";

        this.load_locale = function(new_locale){
            if (new_locale === this.locale) return;

            var lthis = this;
            var path = '/locales/'+new_locale+'.json';
            $http.get(path)
                .success(
                    function(data){
                        lthis.translations = data;
                        lthis.locale = new_locale;
                    }
                )
                .error(
                    function(data,status){
                        console.log('kaboom! data: '+data+' status: '+status);
                    }
                );
        };

        // init me
        this.load_locale('en');
    }
]);