var dir_module = angular.module('qa.directives');

dir_module.directive('myPosition', function() {
    return {
        restrict: 'A',
        controller: ['$scope','$document', function($scope,$document) {
            $scope.move= function(element) {
                $document.scrollTo(element,0,2000);
            }
        }],
        link: function(scope, iElement) {
            scope.move(iElement);
        }
    }
});