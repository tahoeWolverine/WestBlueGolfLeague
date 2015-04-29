angular
    .module('admin')
    .config(['$stateProvider', function ($stateProvider) {
        $stateProvider
            .state('admin.scoreEntry', {
                abstract: true,
                url: 'scoreEntry',
                templateUrl: '/Scripts/admin/tpl/scoreEntry/scoreEntryContainer.tpl.html',
                controller: 'ScoreEntry as scoreEntry',
                resolve: {
                    scoreEntrySvc: 'scoreEntry',
                    scheduleData: ['scoreEntrySvc', function (scoreEntry) {
                        return scoreEntry.getWeeks().then(function (data) {
                            return data.data;
                        });
                    }]
                }
            })
            .state('admin.scoreEntry.currentWeek', {
                url: '',
                controller: ['$stateParams', '$state', 'scheduleData', '$location', '$timeout', function ($stateParams, $state, scheduleData, $location, $timeout) {
                    // super hack
                    $timeout(function () {
                        $location.path('/scoreEntry/' + scheduleData.weeks[0].id).replace();
                    }, 0, true);
                    //$state.go('admin.scoreEntry.week', { weekId: weekEntry }, { location: 'replace' });
                }]
            })
            .state('admin.scoreEntry.week', {
                url: '/:weekId',
                templateUrl: '/Scripts/admin/tpl/scoreEntry/week.tpl.html',
                controller: 'CurrentWeek as currentWeek'
            })
            // Probably don't need this state anymore
            .state('admin.scoreEntry.week.matchup', {
                abstract: true,
                controller: 'Matchup as matchupCtrl',
                templateUrl: '/Scripts/admin/tpl/scoreEntry/matchupContainer.tpl.html',
               
            })
            .state('admin.scoreEntry.week.matchup.edit', {
                url: '/:matchupId',
                templateUrl: '/Scripts/admin/tpl/scoreEntry/matchupEdit.tpl.html',
                controller: 'MatchupEdit as matchupEdit',
                resolve: {
                    matchupData: ['scoreEntrySvc', '$stateParams', function (scoreEntry, $stateParams) {
                        return scoreEntry.getMatchup($stateParams.weekId, $stateParams.matchupId).then(function (data) {
                            return data.data;
                        });
                    }]
                }
            })
    }])
    .run(['$rootScope', '$state', function ($rootScope, $state) {
        $rootScope.$on('$stateChangeSuccess', function (e, toState, toParams, fromState, fromParams) {
            console.log(toState.name);
        });
    }])
    .factory('scoreEntry', ['$http', function ($http) {
        return {
            getWeeks: function () {
                return $http({
                    method: 'GET',
                    url: '/api/scoreEntry'
                });
            },
            getMatchup: function (weekId, matchupId) {
                return $http({
                    method: 'GET',
                    url: '/api/scoreEntry/matchup/' + weekId + '/' + matchupId
                });
            }
        }
    }])
    .controller('MatchupEdit', ['$stateParams', 'matchupData', function ($stateParams, matchupData) {
        this.team1 = matchupData.teamMatchup.team1;
        this.team2 = matchupData.teamMatchup.team2;
    }])
    .controller('Matchup', ['$stateParams', 'scheduleData', function ($stateParams, scheduleData) {
        var selectedWeek = _.find(scheduleData.weeks, function (x) {
            return x.id == $stateParams.weekId;
        });

        this.weekId = $stateParams.weekId;
        this.matchups = selectedWeek.teamMatchups;
    }])
    .controller('CurrentWeek', ['$stateParams', 'scheduleData', function ($stateParams, scheduleData) {
        var selectedWeek = _.find(scheduleData.weeks, function (x) {
            return x.id == $stateParams.weekId;
        });

        this.selectedWeek = selectedWeek;
        this.matchups = selectedWeek.teamMatchups;
    }])
    .controller('ScoreEntry', ['scheduleData', function (scheduleData) {
        this.weeks = scheduleData.weeks;
    }]);