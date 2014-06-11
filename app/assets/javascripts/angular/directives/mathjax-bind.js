var dir_module = angular.module('qa.directives');

dir_module.directive('mathjaxBind', function() {
    return {
        restrict: "A",
        controller: ["$scope", "$element", "$attrs", function($scope, $element, $attrs) {
            $scope.$watch($attrs.mathjaxBind, function(value) {
                //$element.text(value == undefined ? "" : value);
                $element.html(value==undefined ? "": value);
                MathJax.Hub.Queue(["Typeset", MathJax.Hub, $element[0]]);

            });
        }]
    };
});