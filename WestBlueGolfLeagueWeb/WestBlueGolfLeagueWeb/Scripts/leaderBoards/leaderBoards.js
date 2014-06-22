
// leaderboards
angular.module('leaderBoards', ['app', 'ngAnimate', 'ui.router']);

// config.
(function (module) {

    var leaderBoardStates = {
        LEADER_BOARDS:      'landingPage',
        DETAILS_LAYOUT:     'detailsLayout',
        DETAILS:            'detailsLayout.details'
    };

    function leaderBoardsConfig($locationProvider, $urlRouterProvider, $stateProvider, boardStates) {
        
        $stateProvider
            .state(boardStates.LEADER_BOARDS, {
                url:    '/',
                templateUrl:    '/Scripts/leaderBoards/tpl/leaderBoardsLandingPage.tpl.html',
                controller:    'LeaderBoards',
                resolve: {
                    leaderBoards: ['resolveLeaderBoardService', function (lbs) {
                        return lbs.getBoards();
                    }],
                    resolveLeaderBoardService: 'leaderBoardService'
                }
            });

        $stateProvider
            .state(boardStates.DETAILS_LAYOUT, {
                abstract: true,
                url: '/leaderboarddata',
                templateUrl: '/Scripts/leaderBoards/tpl/boardDataLayout.tpl.html',
                controller: 'DetailsLayout',
                resolve: {
                    leaderBoards: ['resolveLeaderBoardService', function(lbs) {
                        return lbs.getBoards();
                    }],
                    resolveLeaderBoardService: 'leaderBoardService'
                }
            });

        $stateProvider
            .state(boardStates.DETAILS, {
                url: '/{boardGroup:team|player}/:id',
                templateUrl: '/Scripts/leaderBoards/tpl/boardData.tpl.html',
                controller: 'Details',
                resolve: {
                    leaderBoardDetails: ['resolveLeaderBoardService', '$stateParams', function (lbs, $stateParams) {
                        return lbs.getBoardDetails($stateParams.id);
                    }],
                    resolveLeaderBoardService: 'leaderBoardService'
                }
            });


        $urlRouterProvider.otherwise('/');

        $locationProvider.html5Mode(true);
    };

    module
        .constant('leaderBoardStates', leaderBoardStates)
        .config(['$locationProvider', '$urlRouterProvider', '$stateProvider', 'leaderBoardStates', leaderBoardsConfig]);

})(angular.module('leaderBoards'));

