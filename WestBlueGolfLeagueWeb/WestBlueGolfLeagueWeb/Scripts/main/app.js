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
    .module('main', ['app', 'ui.router', 'ngAnimate', 'leaderBoards', 'schedule'])
    .config(['$locationProvider', '$urlRouterProvider', '$stateProvider',
        function ($locationProvider, $urlRouterProvider, $stateProvider) {

            $stateProvider
                .state("root", {
                    url: '/',
                    templateUrl: '/Scripts/main/tpl/index.tpl.html',
                    resolve: {
                        Schedule: 'schedule',
                        scheduleObj: function (Schedule) {
                            return new Schedule().$promise;
                        }
                    },
                    controller: 'Main as main'
                });

            $locationProvider.html5Mode(true);
            // 'leaderBoards', 'player', 'team'

        }])

    .directive('pager', ['$window', function ($window) {
        return {
            templateUrl: '/Scripts/main/tpl/schedulePager.tpl.html',
            scope: {
                schedule: '=*',
                selectedWeek: '='
            },
            restrict: 'A',
            link: function (scope, ele) {

                var $weekPageWrapper = ele.find('.week-page-wrapper');
                var $weekPager = ele.find('.week-pager');
                var pageWidth = 0,
                    wrapperWidth = 0;

                scope.selectWeek = function (week, $event) {
                    scope.selectedWeek = week;
                    var width = $weekPager.width();

                    if (width >= wrapperWidth) {
                        $weekPageWrapper.css('left', 0);
                        return;
                    }

                    var index = $($event.target).parent().children().index($event.target);                   

                    var offset = (index * 50) + 25 - (width / 2);
                    
                    $weekPageWrapper.css('left', -offset);
                }

                scope.$watchCollection('schedule', function (n, o) {
                    
                    if (n && n.weeks.length > 0) {
                        pageWidth = $weekPageWrapper.children().width();
                        wrapperWidth = $weekPageWrapper.children().length * pageWidth;

                        $weekPageWrapper.css('width', wrapperWidth);
                    }
                });

            }
        }
    }])

    .directive('weekDisplay', [function () {
        return {
            templateUrl: '/Scripts/main/tpl/weekDisplay.tpl.html',
            scope: {
                week: '='
            },
            restrict: 'A'
        }
    }])

    .controller('Main', ['scheduleObj', function (schedule) {
        this.schedule = schedule;
        this.selectedWeek = null;
    }]);