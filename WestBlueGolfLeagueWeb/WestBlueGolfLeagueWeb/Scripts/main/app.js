angular
    .module("app", [])
    .directive('focusMe', ['$timeout', function ($timeout) {
        // This directive might not needed (see 'autofocus' attribute). Though might still be
        // needed for older browsers.
        return {
            link: function (scope, element, attrs) {
                var ele = element[0];

                scope.focusMe = function () {
                    ele.focus();
                };

                scope.focusMe();
            }
        };
    }])
    .directive('scrollToTop', ['$timeout', function ($timeout) {
        return {
            restrict: 'A',
            link: function (scope, element, attrs) {
                scope.scrollToTop = function () {
                    $timeout(function () {
                        $('body,html').scrollTop(0)
                    }, 0, false);
                };

                scope.scrollToTop();
            }
        };
    }])
    .controller("test", function () {
        this.foobar = "test";
    });