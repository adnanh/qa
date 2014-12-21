// controller for admin panel

var ctrl_module = angular.module('qa.controllers');

ctrl_module.controller('HeaderCtrl', ['$scope', 'i18n', 'PrivateMessages', '$timeout',
    function ($scope, i18n, PrivateMessages, $timeout) {
        // include i18n reference to current scope
        $scope.i18n = i18n;

        $scope.change_loc = function(new_loc){
            i18n.load_locale(new_loc);
        };

        $scope.refreshSpeedMillis = 15000; // poll every 15 seconds
        $scope.inboxUnreadCount = 0;

        (function refreshInboxUnreadCountPeriodically() {
            PrivateMessages.countUnreadMessages()
                .success(
                    function(data){
                        $scope.inboxUnreadCount = data.count;
                        $timeout(refreshInboxUnreadCountPeriodically, $scope.refreshSpeedMillis);
                    }
                )
                .error(
                    function(){
                        $scope.inboxUnreadCount = 0;
                        $timeout(refreshInboxUnreadCountPeriodically, $scope.refreshSpeedMillis);
                    }
                );
        })();
    }
]);