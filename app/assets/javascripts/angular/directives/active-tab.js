angular.module('qa.directives').directive('activeTab', ['$location', function ($location) {
    return {
        link: function postLink(scope, element, attrs) {
            scope.$on("$routeChangeSuccess", function (event, current, previous) {
                var pathLevel = attrs.activeTab || 1,
                    pathToCheck = $location.path().split('/')[pathLevel],
                    tabLink = attrs.href.split('/')[pathLevel];
                if (pathToCheck === tabLink) {
                    element.parent('li').addClass("active");
                }
                else {
                    element.parent('li').removeClass("active");
                }
            });
        }
    };
}
]);