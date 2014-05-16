'use strict';

var qa_app = angular.module('qa', [
    'ngRoute',
    'ngCookies',
    'qa.services',
    'qa.directives',
    'qa.controllers',
    'ui.bootstrap',
    'angularCharts',
    'textAngular',
    'ngTagsInput'
]);

qa_app.config( ['$routeProvider',
    function($routeProvider) {
        $routeProvider
            .when('/home', {templateUrl: 'partials/home.html'})
            .when('/ask', {templateUrl: 'partials/ask.html'})
            .when('/admin-panel', {templateUrl: 'partials/admin-panel.html'})
            .when('/q/:question_id', {templateUrl: 'partials/question-view.html'})
            .when('/edit/:user_id',{templateUrl: 'partials/edit.html'})
            .when('/pm/:message_id', {templateUrl: 'partials/private-messages.html'})
            .when('/', {redirectTo: '/home'})
            .when('/pm', {redirectTo: '/pm/inbox'});
    }
]);