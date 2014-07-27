angular
    .module("app", ["ngRoute"])
    .directive('focusMe', function () {
        return {
            link: function (scope, element, attrs) {

                var ele = element[0];

                scope.focusMe = function () {
                    if (ele.focus) {
                        ele.focus();
                    }
                };

                scope.focusMe();
            }
        };
    })
    .directive('scrollToTop', ['$timeout', function ($timeout) {
        return {
            link: function (scope, element, attrs) {
                scope.scrollToTop = function () {
                    $timeout(function () {
                        $('body,html').scrollTop(0)
                    }, 0, false);
                };
            }
        };
    }])
    .controller("test", function () {
        this.foobar = "test";
    });