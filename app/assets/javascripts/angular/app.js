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
    'ngTagsInput',
    'ngFacebook'
]);

qa_app.config( ['$routeProvider', '$facebookProvider',
    function($routeProvider, $facebookProvider) {
        $routeProvider
            .when('/home', {templateUrl: 'partials/home.html'})
            .when('/ask', {templateUrl: 'partials/ask.html'})
            .when('/admin-panel', {templateUrl: 'partials/admin-panel.html'})
            .when('/q/:question_id', {templateUrl: 'partials/question-view.html'})
            .when('/profile/:user_id', {templateUrl: 'partials/profile-view.html'})
            .when('/edit/:user_id',{templateUrl: 'partials/edit.html'})
            .when('/pm/:message_id/:recipient_id', {templateUrl: 'partials/private-messages.html'})
            .when('/pm/:message_id', {templateUrl: 'partials/private-messages.html'})
            .when('/', {redirectTo: '/home'})
            .when('/pm', {redirectTo: '/pm/inbox'});

        $facebookProvider.setAppId('705202082852225');
    }
]);

qa_app.run(function() {
    // Load the facebook SDK asynchronously
    (function(){
        // If we've already installed the SDK, we're done
        if (document.getElementById('facebook-jssdk')) {return;}

        // Get the first script element, which we'll use to find the parent node
        var firstScriptElement = document.getElementsByTagName('script')[0];

        // Create a new script element and set its id
        var facebookJS = document.createElement('script');
        facebookJS.id = 'facebook-jssdk';

        // Set the new script's source to the source of the Facebook JS SDK
        facebookJS.src = '//connect.facebook.net/en_US/all.js';

        // Insert the Facebook JS SDK into the DOM
        firstScriptElement.parentNode.insertBefore(facebookJS, firstScriptElement);
    }());
})


