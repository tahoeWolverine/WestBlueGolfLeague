

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


    
    