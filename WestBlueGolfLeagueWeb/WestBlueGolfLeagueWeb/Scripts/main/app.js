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
    .module('main', ['app', 'ui.router', 'ngAnimate', 'leaderBoards', 'player', 'team'])
    .config(['$locationProvider', '$urlRouterProvider', '$stateProvider',
        function ($locationProvider, $urlRouterProvider, $stateProvider) {

            $stateProvider
                .state("root", {
                    url: '/',
                    templateUrl: '/Scripts/main/tpl/index.tpl.html',
                    resolve: {
                        homeApi: 'home',
                        homeData: ['homeApi', function (homeApi) {
                            return homeApi.getHomeData();
                        }]
                    },
                    controller: 'Main as main'
                });

            $locationProvider.html5Mode(true);
            // 'leaderBoards', 'player', 'team'

        }])

    .filter('playoffName', function () {
        return function (input) {
            if (input == 'championship') {
                return 'Championship';
            }
            else if (input == 'consolation') {
                return 'Consolation';
            }
            else if (input == 'lastplace') {
                return 'Lexis Nexis';
            }
            else if (input == 'thirdplace') {
                return 'Third Place';
            }

            return 'Unknown Playoff Type';
        };
    })

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

                    scope.selectedWeek = weeks[$index];
                    var width = $weekPager.width();

                    if (width >= wrapperWidth) {
                        $weekPageWrapper.css('left', 0);
                        return;
                    }

                    // Need to offset for the 6px margin here, along with half of the width of a page.
                    var offset = ($index * (56 + 6)) + (28) - (width / 2);
                    
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

	            scope.selectCurrentWeek = function() {
		            scope.selectWeek(scope.schedule.weeks.indexOf(scope.selectedWeek));
	            };

                // We need a watch in order to set the proper widths of everything.
                scope.$watchCollection('schedule', function (n, o) {
                    
                    if (n && n.weeks.length > 0) {
                        pageWidth = $weekPageWrapper.children().width() + 6;
                        wrapperWidth = $weekPageWrapper.children().length * pageWidth;

                        $weekPageWrapper.css('width', wrapperWidth);

	                    scope.selectCurrentWeek();

                        scope.initialized = true;
                    }
                });

	            $($window).on('resize.pager', function() {
		            scope.selectCurrentWeek();
	            });

	            scope.$on('$destroy', function() {
		            $($window).off('.pager');
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

    .factory('home', ['$http', '$q', function ($http, $q) {

        // so ugly, server should do this. Will cleanup.
        var transformData = function (data) {
            
            var playersLookup = _.indexBy(data.players, 'id');

            var hydratePlayerName = function(result) {
                result.playerName = playersLookup[result.playerId].name;
            };

            _.each(data.schedule.weeks, function (week) {
                _.each(week.teamMatchups, function (matchup) {
                    _.each(matchup.team1Results, hydratePlayerName);
                    _.each(matchup.team2Results, hydratePlayerName)
                });
            });

            return data;
        };

        return {
            getHomeData: function () {
                return $q(function (resolve, reject) {
                    $http({
                        method: 'GET',
                        url: '/api/homeApi/'
                    }).then(function (data) {
                        resolve(transformData(data.data));
                    })
                    .catch(function (err) {
                        reject(err);
                    });
                });
            },

            getSelectedWeek: function (weeks) {
                var now = moment(),
                    previousMatch;

                // find the next upcoming match
                var upcomingMatch = _.find(weeks, function (i) {
                    return now.isBefore(i.date);
                });

                if (!upcomingMatch) {
                    return _.last(weeks);
                }

                var upcomingMatchDate = moment(upcomingMatch.date).day(-4);

                if (now.isAfter(upcomingMatchDate)) {
                    return upcomingMatch;
                }

                previousMatch = _.findLast(weeks, function (i) {
                    return now.isAfter(i.date);
                });

                if (!previousMatch) {
                    return _.first(weeks);
                }

                return previousMatch;
            }
        };

    }])

    .controller('Main', ['homeData', 'home', function (homeData, home) {
        this.homeData = homeData;

        this.selectedWeek = home.getSelectedWeek(homeData.schedule.weeks);
    }]);