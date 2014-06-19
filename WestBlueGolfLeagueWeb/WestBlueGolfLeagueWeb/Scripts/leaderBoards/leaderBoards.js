

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

    // TODO: remove this and inject the real one.
    function FakeDetailsFetcher($timeout, $q, $stateParams) {
        
        return {
            getDetails: function() {
                var d = $q.defer();
                
                $timeout(function() {
                    d.resolve({ value: 42 });
                }, 590);
    
                return d.promise;
            }
        };
    }

    function DetailsController($state, $stateParams, $scope, detailsFetcher) {
        $scope.id = $stateParams.id;

        $scope.deets = detailsFetcher.getDetails();
    };


    module
        .factory('detailsFetcher', ['$timeout', '$q', '$stateParams', FakeDetailsFetcher])
        .controller('Details', ['$state', '$stateParams', '$scope', 'detailsFetcher', DetailsController])
        .controller('DetailsLayout', ['$scope', '$stateParams', '$state', 'leaderBoards', 'leaderBoardStates', DetailsLayoutController])
        .controller('LeaderBoards', ['$scope', '$stateParams', '$state', 'leaderBoards', LeaderBoardsController]);

})(angular.module('leaderBoards'));


// Begin states here.
(function (module) {

    var leaderBoardStates = {
        LEADER_BOARDS:             'leaderBoards',
        DETAILS_LAYOUT:     'detailsLayout',
        DETAILS:            'detailsLayout.details'
    };

    function leaderBoardsConfig($locationProvider, $urlRouterProvider, $stateProvider, boardStates) {

        // TODO: remove this and inject the real implementation.
        function FakeBoardDataResolve($timeout, $q, $stateParams) {
            var boards = {
                player: [],
                team: []
            };

            for (var i = 0; i < 12; i++) {
                boards.player.push({
                    name: "player board " + i,
                    id: i
                });
                boards.team.push({
                    name: "team board " + i,
                    id: i
                });
            }

            var d = $q.defer();
            $timeout(function() {
                d.resolve(boards);
            }, 290);

            return d.promise;
        }

        FakeBoardDataResolve.$inject = ['$timeout', '$q', '$stateParams'];

        $stateProvider
            .state(boardStates.LEADER_BOARDS, {
                url:    '/',
                templateUrl:    '/Scripts/leaderBoards/tpl/leaderBoardsNew.tpl.html',
                controller:    'LeaderBoards',
                resolve: {
                    leaderBoards: FakeBoardDataResolve
                }
            });

        $stateProvider
            .state(boardStates.DETAILS_LAYOUT, {
                abstract: true,
                url: '/leaderboarddata',
                templateUrl: '/Scripts/leaderBoards/tpl/boardDataLayout.tpl.html',
                controller: 'DetailsLayout',
                resolve: {
                    leaderBoards: FakeBoardDataResolve
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









/*
(function (module) {

    //
    // run
    //
    module.run(['$route', angular.noop]) // super hack to get ng-view to work in ng-include

    //
    // config
    //
    function LeaderBoardConfig($routeProvider, $locationProvider) {
        $routeProvider
            .when('/:boardType/:boardKey?', {
                controller: 'boardController',
                templateUrl: '/Scripts/leaderBoards/tpl/leaderBoardContent.tpl.html'
            })
            .otherwise({
                redirectTo: '/player'
            });

        $locationProvider.html5Mode(true);
    }
    LeaderBoardConfig.$inject = ['$routeProvider', '$locationProvider'];

    module.config(LeaderBoardConfig);

    //
    // services
    //
    function LeaderBoardState() {

        var state = {
            selectedGroup: null,
            selectedBoard: {
                players: null,
                teams: null
            }
        };

        return {
            state: state
        }
    }


    function LeaderBoardService($http, $q) {

        var cachedBoards = {
            teams: null,
            players: null
        };

        return {
            getBoardsForGroup: function (group) {

                var defer = $q.defer();

                if (cachedBoards[group] !== null) {
                    defer.resolve(cachedBoards[group]);
                    return defer.promise;
                }

                var httpPromise = $http({
                    method: 'GET',
                    url: '/api/v1/leaderboards'
                })
                .then(function (response) {
                    cachedBoards.teams = [];
                    cachedBoards.players = [];

                    $.each(response.data.leaderBoards, function (index, value) {
                        if (value.isPlayerBoard) {
                            cachedBoards.players.push(value);
                        }
                        else {
                            cachedBoards.teams.push(value);
                        }
                    });

                    defer.resolve(cachedBoards[group]);
                },
                function () {
                    defer.reject()
                });

                return defer.promise;
            }
        };
    }
    LeaderBoardService.$inject = ['$http', '$q'];

    module
        .factory('leaderBoardService', LeaderBoardService)
        .factory('leaderBoardState', LeaderBoardState);
    

    //
    // controllers
    //
    function BoardController($routeParams, leaderBoardState, $location) {
        // TODO: Fix intial board which is selected when no specific one is chosen in URL.
        if ($routeParams.boardType !== 'players' && $routeParams.boardType !== 'teams') {
            $location
                .path('/players')
                .replace();
        }

        leaderBoardState.state.selectedBoard[$routeParams.boardType] = $routeParams.boardKey;
        leaderBoardState.state.selectedGroup = $routeParams.boardType;
    }
    BoardController.$inject = ['$routeParams', 'leaderBoardState', '$location'];


    function NavController($scope, leaderBoardState, leaderBoardService) {

        $scope.getBoard = function (key) {

        };
               
        $scope.currentlySelectedBoard = leaderBoardState.state.selectedBoard;

        $scope.$watch(function () { return leaderBoardState.state.selectedGroup }, function (newVal, oldVal) {
            if (newVal) {
                                                
                leaderBoardService.getBoardsForGroup(newVal).then(function (data) {

                    if (!data || data.length == 0) {
                        debugger;
                    }

                    $scope.leaderBoards = data;

                    if (!leaderBoardState.state.selectedBoard[leaderBoardState.state.selectedGroup]) {
                        leaderBoardState.state.selectedBoard[leaderBoardState.state.selectedGroup] = data[0].key;
                    }
                });

                $scope.group = newVal;
            }
        }, true);
    }
    NavController.$inject = ['$scope', 'leaderBoardState', 'leaderBoardService'];


    function BoardGroupController($scope, leaderBoardState) {

        $scope.state = leaderBoardState.state;

        $scope.setBoardGroup = function (group) {
            leaderBoardState.state.selectedGroup = group;
        };
    }
    BoardGroupController.$inject = ['$scope', 'leaderBoardState'];

    module
        .controller("boardController", BoardController)
        .controller('navController', NavController)
        .controller('boardGroupController', BoardGroupController);

})(angular.module('leaderBoards', ['app', 'ngRoute']));


    
  */  