// controller for admin panel

var ctrl_module = angular.module('qa.controllers');

ctrl_module.controller('HeaderCtrl', ['$scope', 'i18n', 'PrivateMessages', '$timeout', '$location', '$rootScope', 'Syncer', '$cookies',
    function ($scope, i18n, PrivateMessages, $timeout, $location, $rootScope, Syncer, $cookies) {
        // include i18n reference to current scope
        $scope.i18n = i18n;

        $scope.change_loc = function(new_loc){
            i18n.load_locale(new_loc);
        };

        $scope.refreshSpeedMillis = 6000; // poll every 6 seconds
        $scope.inboxUnreadCount = 0;

        (function refreshInboxUnreadCountPeriodically() {
            if (!($cookies.privilege_id > 0)) return;
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

        $scope.do_search = function(){
            $location.path('/home');
            $rootScope.$emit('doSearch', $scope.search_term);
            Syncer.set_search_term($scope.search_term);
        };

        $scope.clear_search = function(){
            $location.path('/home');
            $scope.search_term = "";
            $rootScope.$emit('doSearch', $scope.search_term);
            Syncer.set_search_term($scope.search_term);
        };

        $scope.can_search = function() {
            return $location.path().length !== 0;
        };
    }
]);