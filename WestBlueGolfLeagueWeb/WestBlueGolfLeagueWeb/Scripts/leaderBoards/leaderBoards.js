

// leaderboards
angular.module('leaderBoards', ['app', 'ngAnimate', 'ui.router']);

// begin controllers.
(function (module) {

    function LeaderBoardsController($scope, $stateParams, $state, leaderBoards) {

        $scope.boards = leaderBoards;

        $scope.showTeamBoards = function () {
            return $scope.currBoard === 'team';
        };

        $scope.showPlayerBoards = function () {
            return $scope.currBoard !== 'team';
        };
    };
         
    function DetailsLayoutController($scope, $stateParams, $state, boards, boardStates) {
              
        $scope.boards = boards;
              
        // These funcs could be more generic.
        $scope.showTeamBoards = function() {
            return ((!$scope.currBoard && $scope.boardGroup === 'team') || $scope.currBoard === 'team');
        };
              
        $scope.showPlayerBoards = function() {
            return ((!$scope.currBoard && $scope.boardGroup !== 'team') || $scope.currBoard === 'player');
        };
              
        $scope.boardGroup = $state.params.boardGroup;
        $scope.currBoard = $state.params.boardGroup;
              
        // This controller won't get new-ed up until everything is resolved.
        // this means that this won't fire the first time coming to this (from another state that isn't a child)
        $scope.$on('$stateChangeStart', function(event, toState, toParams, fromState, fromParams) {
            if (toState.name === boardStates.DETAILS) {
                $scope.boardGroup = toParams.boardGroup;
                $scope.currBoard = toParams.boardGroup;
            }
        });
    };

    function DetailsController($state, $stateParams, $scope, leaderBoardService) {
        $scope.id = $stateParams.id;

        leaderBoardService.getBoardDetails($stateParams.id).then(function (response) {
            $scope.leaderBoardData = (response.data);
        });
    };

    module
        .controller('Details', ['$state', '$stateParams', '$scope', 'leaderBoardService', DetailsController])
        .controller('DetailsLayout', ['$scope', '$stateParams', '$state', 'leaderBoards', 'leaderBoardStates', DetailsLayoutController])
        .controller('LeaderBoards', ['$scope', '$stateParams', '$state', 'leaderBoards', LeaderBoardsController]);

})(angular.module('leaderBoards'));


(function (module) {

    function leaderBoardFactory($http, $q) {

        var cachedBoards = null;

        return {
            getBoardDetails: function(key) {
                return $http({
                    method: 'GET',
                    url: '/api/v1/leaderboards/' + key
                });
            },
            getBoards: function () {

                var defer = $q.defer();

                if (cachedBoards !== null) {
                    defer.resolve(cachedBoards);
                    return defer.promise;
                }

                var httpPromise = $http({
                    method: 'GET',
                    url: '/api/v1/leaderboards'
                })
                .then(function (response) {

                    cachedBoards = {
                        player: [],
                        team: []
                    };

                    $.each(response.data.leaderBoards, function (index, value) {
                        if (value.isPlayerBoard) {
                            cachedBoards.player.push(value);
                        }
                        else {
                            cachedBoards.team.push(value);
                        }
                    });

                    defer.resolve(cachedBoards);
                },
                function () {
                    defer.reject();
                });

                return defer.promise;
            }
        }
    };

    module
        .factory('leaderBoardService', ['$http', '$q', leaderBoardFactory]);

})(angular.module('leaderBoards'));

// Begin states here.
(function (module) {

    var leaderBoardStates = {
        LEADER_BOARDS:             'leaderBoards',
        DETAILS_LAYOUT:     'detailsLayout',
        DETAILS:            'detailsLayout.details'
    };

    function leaderBoardsConfig($locationProvider, $urlRouterProvider, $stateProvider, boardStates) {
        
        $stateProvider
            .state(boardStates.LEADER_BOARDS, {
                url:    '/',
                templateUrl:    '/Scripts/leaderBoards/tpl/leaderBoardsNew.tpl.html',
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
                controller: 'Details'
            });


        $urlRouterProvider.otherwise('/');

        $locationProvider.html5Mode(true);
    };

    module
        .constant('leaderBoardStates', leaderBoardStates)
        .config(['$locationProvider', '$urlRouterProvider', '$stateProvider', 'leaderBoardStates', leaderBoardsConfig]);

})(angular.module('leaderBoards'));

