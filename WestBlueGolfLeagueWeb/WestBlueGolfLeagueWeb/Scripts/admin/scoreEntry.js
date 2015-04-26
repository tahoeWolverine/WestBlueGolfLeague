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
                    weekEntry: ['$q', '$state', function ($q, $state) {
                        return $q.when(42);
                    }]
                }
            })
            .state('admin.scoreEntry.currentWeek', {
                url: '',
                controller: ['$stateParams', '$state', 'weekEntry', '$location', '$timeout', function ($stateParams, $state, weekEntry, $location, $timeout) {
                    // super hack
                    $timeout(function () {
                        //debugger;
                        $location.path('/scoreEntry/' + weekEntry).replace();
                    }, 0, true);
                    //$state.go('admin.scoreEntry.week', { weekId: weekEntry }, { location: 'replace' });
                }]
            })
            .state('admin.scoreEntry.week', {
                url: '/:weekId',
                templateUrl: '/Scripts/admin/tpl/scoreEntry/week.tpl.html',
                controller: 'WeekEntry as weekEntry'
            });
    }])
    .run(['$rootScope', '$state', function ($rootScope, $state) {
        $rootScope.$on('$stateChangeSuccess', function (e, toState, toParams, fromState, fromParams) {
            console.log(toState.name);
            //debugger;
        });
    }])
    .controller('WeekEntry', ['$stateParams', function($stateParams) {
        this.weekId = $stateParams.weekId;
    }])
    .controller('ScoreEntry', [function () {

    }]);