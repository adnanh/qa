var services_module = angular.module('qa.services');

services_module.factory('Kudo', [
    function(){
        return {
            get_karma_image:
                function(user){
                    var karma_image = null;
                    if (user.karma >= 2000)
                    {
                        karma_image = '/assets/blue_gold_medal_small.png';
                    }
                    else if (user.karma >= 1500)
                    {
                        karma_image = '/assets/green_gold_medal_small.png';
                    }
                    else if (user.karma >= 1000)
                    {
                        karma_image = '/assets/red_gold_medal_small.png';
                    }
                    else if (user.karma >= 750)
                    {
                        karma_image = '/assets/blue_silver_medal_small.png';
                    }
                    else if (user.karma >= 400)
                    {
                        karma_image = '/assets/green_silver_medal_small.png';
                    }
                    else if (user.karma >= 250)
                    {
                        karma_image = '/assets/red_silver_medal_small.png';
                    }
                    else if (user.karma >= 150)
                    {
                        karma_image = '/assets/blue_bronze_medal_small.png';
                    }
                    else if (user.karma >= 100)
                    {
                        karma_image = '/assets/green_bronze_medal_small.png';
                    }
                    else if (user.karma > 0)
                    {
                        karma_image = '/assets/red_bronze_medal_small.png';
                    }
                    return karma_image;
                }
        }
    }
]);