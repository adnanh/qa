var services_module = angular.module('qa.services');

services_module.service('ErrorProvider', [
    function(){
        this.errors = [
            {
                CODE: 401,
                MESSAGE: "You are unauthorized to perform the following action: %s. Please log in in order to perform this action."
            },
            {
                CODE: 404,
                MESSAGE: "Resource %s not found because it does not exist on the system."
            },
            {
                CODE: 500,
                MESSAGE: "Unexpected internal server error occurred."
            }
        ];

        this.get_message = function(code, action){
            var err = this.find_error(code);
            return err.MESSAGE.replace("%s",action);
        };

        this.find_error = function (code) {
            for (var i = 0; i< this.errors.length; i++) {
                if (this.errors[i].CODE == code){
                    return this.errors[i];
                }
            }
            return null;
        }
    }
]);