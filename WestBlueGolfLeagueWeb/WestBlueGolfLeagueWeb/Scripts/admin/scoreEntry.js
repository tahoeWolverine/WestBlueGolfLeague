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
                    scoreEntryData: ['scoreEntrySvc', function (scoreEntry) {
                        return scoreEntry.getWeeks().then(function (data) {
                            return data.data;
                        });
                    }]
                }
            })
            .state('admin.scoreEntry.currentWeek', {
                url: '',
                controller: ['$stateParams', '$state', 'scoreEntryData', '$location', '$timeout', function ($stateParams, $state, scoreEntryData, $location, $timeout) {
                    // super hack
                    $timeout(function () {
                        $location.path('/scoreEntry/' + scoreEntryData.currentWeek.id).replace();
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
                    TeamMatchup: 'TeamMatchup',
                    resolvedTeamMatchup: ['TeamMatchup', '$stateParams', function (TeamMatchup, $stateParams) {
                        return new TeamMatchup($stateParams.weekId, $stateParams.matchupId).$promise;
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

    .factory('TeamMatchup', ['$http', function($http) {

        return function teamMatchup(weekId, matchupId) {

            var self = this;

            // Makes sure there are always 4 matches
            function extendMatches() {
                if (!self.teamMatchup.matches) { self.teamMatchup.matches = []; }

                for (var i = self.teamMatchup.matches.length; i < 4; i++) {
                    self.teamMatchup.matches.push({});
                }
            };

            this.$promise = $http({
                method: 'GET',
                url: '/api/scoreEntry/matchup/' + weekId + '/' + matchupId
            }).then(function (response) {
                _.extend(self, response.data);
                
                extendMatches();

                return self;
            });

            this.save = function () {

            };
        };
    }])

    .controller('MatchupEdit', ['$stateParams', 'resolvedTeamMatchup', 'scoreEntryData', function ($stateParams, resolvedTeamMatchup, scoreEntryData) {
        this.team1 = resolvedTeamMatchup.teamMatchup.team1;
        this.team2 = resolvedTeamMatchup.teamMatchup.team2;
		
        // TODO: return actual match data from endpoint.

        this.matches = resolvedTeamMatchup.teamMatchup.matches;

        this.team1PlayerList = scoreEntryData.teamIdToPlayer[this.team1.id];
        this.team2PlayerList = scoreEntryData.teamIdToPlayer[this.team2.id];
	}])
    .controller('Matchup', ['$stateParams', 'scoreEntryData', function ($stateParams, scoreEntryData) {
    	var selectedWeek = _.find(scoreEntryData.schedule.weeks, function (x) {
            return x.id == $stateParams.weekId;
        });

        this.weekId = $stateParams.weekId;
        this.matchups = selectedWeek.teamMatchups;
    }])
    .controller('CurrentWeek', ['$stateParams', 'scoreEntryData', function ($stateParams, scoreEntryData) {
    	var selectedWeek = _.find(scoreEntryData.schedule.weeks, function (x) {
            return x.id == $stateParams.weekId;
        });

        this.selectedWeek = selectedWeek;
        this.matchups = selectedWeek.teamMatchups;
    }])
    .controller('ScoreEntry', ['scoreEntryData', function (scoreEntryData) {
        this.weeks = scoreEntryData.schedule.weeks;
    }]);