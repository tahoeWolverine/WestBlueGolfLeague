
// leaderboards
angular.module('leaderBoards', ['app', 'ngAnimate', 'ui.router']);

// config.
(function (module) {

    var leaderBoardStates = {
        LEADER_BOARDS_ROOT: 'leaderboards',
        LEADER_BOARDS:      'leaderboards.landingPage',
        DETAILS_LAYOUT:     'leaderboards.detailsLayout',
        DETAILS:            'leaderboards.detailsLayout.details'
    };

    var errorStates = {
        UNKNOWN_LEADERBOARD: 'unknown',
        GENERAL_ERROR: 'generalError',
        ERROR_LOADING_LEADERBOARD: 'errorLoadingLeaderBoard'
    };

    function leaderBoardsConfig($locationProvider, $urlRouterProvider, $stateProvider, boardStates) {
        
        $stateProvider
            .state('leaderboards', {
                abstract: true,
                url: '/LeaderBoards',
                templateUrl: '/Scripts/leaderBoards/tpl/leaderBoardWrapper.tpl.html',
            });

        $stateProvider
            .state(boardStates.LEADER_BOARDS, {
                url:    '/?error',
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
                views: {
                    'data': {
                        templateUrl: '/Scripts/leaderBoards/tpl/boardData.tpl.html',
                        controller: 'Details'
                    },
                    'title': {
                        template: '<h2>{{leaderBoardTitle}}</h2>',
                        controller: 'DetailsTitle'
                    }
                },
                resolve: {
                    leaderBoardDetails: ['resolveLeaderBoardService', '$stateParams', function (lbs, $stateParams) {
                        return lbs.getBoardDetails($stateParams.id);
                    }],
                    resolveLeaderBoardService: 'leaderBoardService'
                }
            });


        //$urlRouterProvider.otherwise('/');

        $locationProvider.html5Mode(true);
    };

    module
        .constant('leaderBoardStates', leaderBoardStates)
        .constant('errorStates', errorStates)
        .config(['$locationProvider', '$urlRouterProvider', '$stateProvider', 'leaderBoardStates', leaderBoardsConfig]);

})(angular.module('leaderBoards'));

