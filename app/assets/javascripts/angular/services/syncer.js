var services_module = angular.module('qa.services');

services_module.service('Syncer', [
    function(){
        this.search_term = null;

        this.set_search_term = function(search_term){
            this.search_term = search_term;
        }

        this.get_search_term = function() {
            return this.search_term;
        }
    }
]);