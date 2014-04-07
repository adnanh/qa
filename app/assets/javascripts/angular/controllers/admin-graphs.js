/**
 * Created by XZone on 4/7/14.
 */

var ctrl_module = angular.module('qa.controllers');

ctrl_module.controller('AdminGraphsCtrl', ['$scope', 'i18n', 'GraphDataSrv',
    function ($scope, i18n, GraphDataSrv){

        $scope.today = function() {
            $scope.dt = new Date();
        };
        $scope.today();

        $scope.i18n = i18n;

        $scope.r_daily_type = 'line';

        $scope.r_daily_data = {
            series: ['Number'],
            data: [{x: 'wut', y: [5]}]
        };

        $scope.r_daily_config = {
            title : 'Daily chart',
            tooltips: true,
            labels : false,
            legend: {
                display: true,
                position: 'left'
            }
        };

        $scope.r_distr_type = 'pie';

        $scope.r_distr_data = {
            series: ['Number'],
            data: [{x: 'wut', y: [5]}]
        };

        $scope.r_distr_config = {
            title : 'Daily chart',
            tooltips: true,
            labels : false,
            legend: {
                display: true,
                position: 'left'
            }
        };

        $scope.response_to_graph_data = function(sname, response){
            var response_processed = [];
            for (var i=0; i<response.length;i++){
                response_processed.push(
                    {
                        x : response[i].day,
                        y:  [response[i].count]
                    }
                );
            }

            return {
                series: [sname],
                data: response_processed
            };
        };

        $scope.response_distr_to_data = function (response){
            return {
                series: ['lol'],
                data: [
                    {
                        x: 'Confirmed',
                        y: [response.confirmed]
                    },
                    {
                        x: 'Unconfirmed',
                        y: [response.total-response.confirmed]
                    }
                ]
            }
        };

        $scope.refresh_registrations_daily_graph = function () {
            GraphDataSrv.get_registrations_per_day_since(JSON.stringify($scope.dt).substr(1,10))
                .success(
                    function(data){
                        if (data.success){
                            $scope.r_daily_data = $scope.response_to_graph_data('Number',data.response);
                        }
                        else {
                            console.log('kaboom because: '+data.reason);
                        }
                    }
                )
                .error(
                    function(data, status){
                        console.log('kaboomed with: '+status);
                    }
                );
        };

        $scope.refresh_registrations_daily_graph();

        $scope.refresh_registrations_distribution_graph = function () {
            GraphDataSrv.get_registration_distribution_since(JSON.stringify($scope.dt).substr(1,10))
                .success(
                    function(data){
                        if (data.success){
                            $scope.r_distr_data =  $scope.response_distr_to_data(data.response);;
                        }
                        else {
                            console.log('kaboom because: '+data.reason);
                        }
                    }
                )
                .error(
                    function(data, status){
                        console.log('kaboomed with: '+status);
                    }
                );
        };

        $scope.do_refresh = function() {
            $scope.refresh_registrations_daily_graph();
            $scope.refresh_registrations_distribution_graph();
        };

        $scope.refresh_registrations_distribution_graph();

        $scope.open = function($event) {
            $event.preventDefault();
            $event.stopPropagation();

            $scope.opened = true;
        };
    }
])