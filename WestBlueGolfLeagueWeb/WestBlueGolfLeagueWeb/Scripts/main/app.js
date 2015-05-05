angular
	.module("app", [])
	.directive('focusMe', ['$timeout', function ($timeout) {
		// This directive might not needed (see 'autofocus' attribute). Though might still be
		// needed for older browsers.
		return {
			link: function (scope, element, attrs) {
				var ele = element[0];

				scope.focusMe = function () {
				    $timeout(function () {
				        ele.focus();
				    }, 0, false);
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
	.directive('equal', function() {
	
		return {
			require: 'ngModel',
			priority: 100,
			link: function (scope, elem, attrs, ctrl) {
				ctrl.$validators.equal = function (modelValue, viewValue) {

					if (viewValue === attrs.equal) {
						return true;
					}

					return false;
				};

				attrs.$observe('equal', function (val) {
					ctrl.$validate();
				});
			}
		};
	})
	.controller("test", function () {
		this.foobar = "test";
	});


angular
    .module('main', ['app', 'ui.router', 'ngAnimate', 'leaderBoards'])
    .config(['$locationProvider', '$urlRouterProvider', '$stateProvider',
        function ($locationProvider, $urlRouterProvider, $stateProvider) {

            $stateProvider
                .state("root", {
                    url: '/testtest',
                    templateUrl: '/Scripts/main/tpl/index.tpl.html',
                    controller: function () { },
                });

            $locationProvider.html5Mode(true);
            // 'leaderBoards', 'player', 'team'

        }]);