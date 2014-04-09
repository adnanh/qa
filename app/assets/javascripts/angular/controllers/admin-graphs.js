/**
 * Created by XZone on 4/7/14.
 */

var ctrl_module = angular.module('qa.controllers');

ctrl_module.controller('AdminGraphsCtrl', ['$scope', 'i18n', 'GraphDataSrv',
    function ($scope, i18n, GraphDataSrv){
        $scope.subtract_days = function(date, number_of_days){
            return new Date(
                date.getFullYear(),
                date.getMonth(),
                date.getDate() - number_of_days,
                date.getHours(),
                date.getMinutes(),
                date.getSeconds(),
                date.getMilliseconds()
            );
        };

        $scope.today = function() {
            var today = new Date();
            $scope.dt = $scope.subtract_days(today,7);
        };
        $scope.today();

        $scope.week_ago = $scope.subtract_days(new Date(),7);

        $scope.i18n = i18n;

        // registrations daily graph
        $scope.r_daily_type = 'line';
        $scope.r_daily_data = {
            series: ['whatever'],
            data: [{x: 'wut', y: [5]}]
        };
        $scope.r_daily_config = {
            //title : i18n.t.R_DAILY_CHART,
            tooltips: true,
            labels : false,
            legend : {
                display: true,
                position:'right'
            }
        };

        // registrations distr graph
        $scope.r_distr_type = 'pie';
        $scope.r_distr_data = {
            series: ['whatever'],
            data: [{x: 'wut', y: [5]}]
        };
        $scope.r_distr_config = {
            //title : i18n.t.R_DISTR_CHART,
            tooltips: true,
            labels : false,
            legend: {
                display: true,
                position: 'right'
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
                        x: i18n.t.CONFIRMED,
                        y: [response.confirmed]
                    },
                    {
                        x: i18n.t.UNCONFIRMED,
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
                            if (data.response.length > 0)
                                $scope.r_daily_data = $scope.response_to_graph_data(i18n.t.NUMBER_OF_REGISTRATIONS,data.response);
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