'use strict';

var qa_app = angular.module('qa', [
    'ngRoute',
    'qa.services',
    'qa.directives',
    'qa.controllers',
    'ui.bootstrap'
]);

qa_app.config( ['$routeProvider',
    function($routeProvider) {
        $routeProvider
            .when('/home', {templateUrl: 'partials/home.html'})
            .when('/ask', {templateUrl: 'partials/ask.html'})
            .when('/admin-panel', {templateUrl: 'partials/admin-panel.html'})
            .when('/', {redirectTo: '/home'})
            .when('/edit/:user_id',{templateUrl: 'partials/edit.html'});
    }
]);