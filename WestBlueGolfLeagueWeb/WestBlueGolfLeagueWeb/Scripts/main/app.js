﻿angular
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

                scope.disableNext = false;
                scope.disablePrev = false;

                var $weekPageWrapper = ele.find('.week-page-wrapper');
                var $weekPager = ele.find('.week-page-window');
                var pageWidth = 0,
                    wrapperWidth = 0;

                var setDisableFlags = function (index, weeks) {
                    if (index == weeks.length - 1) {
                        scope.disableNext = true;
                    }
                    else {
                        scope.disableNext = false;
                    }

                    if (index == 0) {
                        scope.disablePrev = true;
                    }
                    else {
                        scope.disablePrev = false;
                    }
                }

                scope.selectWeek = function ($index) {

                    var weeks = scope.schedule.weeks;

                    scope.selectedWeek =weeks[$index];
                    var width = $weekPager.width();

                    if (width >= wrapperWidth) {
                        $weekPageWrapper.css('left', 0);
                        return;
                    }

                    var offset = ($index * 50) + 25 - (width / 2);
                    
                    $weekPageWrapper.css('left', -offset);

                    setDisableFlags($index, weeks);
                }

                scope.selectNextWeek = function () {
                    var currIndex = scope.schedule.weeks.indexOf(scope.selectedWeek);

                    if (!(currIndex + 1 > scope.schedule.weeks.length - 1)) {
                        scope.selectWeek(currIndex + 1);
                    }
                };

                scope.selectPrevWeek = function () {
                    var currIndex = scope.schedule.weeks.indexOf(scope.selectedWeek);

                    if (currIndex > 0) {
                        scope.selectWeek(currIndex - 1);
                    }
                };

                scope.$watchCollection('schedule', function (n, o) {
                    
                    if (n && n.weeks.length > 0) {
                        pageWidth = $weekPageWrapper.children().width();
                        wrapperWidth = $weekPageWrapper.children().length * pageWidth;

                        $weekPageWrapper.css('width', wrapperWidth);
                    }
                });

                // TODO: set up watch to watch for initial week selection

                // TODO: handle window resizing (need to correct offset of pager after window resize.

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