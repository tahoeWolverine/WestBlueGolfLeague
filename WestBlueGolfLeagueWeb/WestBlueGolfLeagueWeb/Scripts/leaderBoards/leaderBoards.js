
angular.module('leaderBoards', ['app', 'ngRoute'])
    .run(['$route', angular.noop]) // super hack to get ng-view to work in ng-include
    .config(['$routeProvider', '$locationProvider', function ($routeProvider, $locationProvider) {
        $routeProvider
            .when('/:boardType/:boardKey?', {
                controller: 'boardController',
                templateUrl: '/Scripts/leaderBoards/tpl/leaderBoardContent.tpl.html'
            })
            .otherwise({
                redirectTo: '/player'
            });

        $locationProvider.html5Mode(true);
    }])
    .controller('boardController', ['$routeParams', 'leaderBoardState', '$location', function ($routeParams, leaderBoardState, $location) {


        // TODO: Fix intial board which is selected when no specific one is chosen in URL.
        if ($routeParams.boardType !== 'players' && $routeParams.boardType !== 'teams') {
            $location
                .path('/players')
                .replace();
        }

        leaderBoardState.state.selectedBoard[$routeParams.boardType] = $routeParams.boardKey;
        leaderBoardState.state.selectedGroup = $routeParams.boardType;
    }])
    .factory('leaderBoardState', function () {

        var state = {
            selectedGroup: 'players',
            selectedBoard: {
                players: null,
                teams: null
            }
        };

        return {
            state: state
        }
    })
    .factory('leaderBoardService', function () {

        return {
            getBoardsForGroup: function (group) {
                if (group === 'teams') {
                    
                    return [{
                        name: 'Points',
                        key: 'points'
                    },
                    {
                        name: 'Handicaps',
                        key: 'handicaps'
                    },
                    {
                        name: 'Most Improved',
                        key: 'mostImproved'
                    }];
                }

                return [
                    {
                        name: 'Player Handicap',
                        key: 'playerHandicap'
                    },
                    {
                        name: 'Player Something',
                        key: 'handicaps'
                    },
                    {
                        name: 'Another Player Board',
                        key: 'mostImproved'
                    }
                ];
            }
        };
    })
    .controller('navController', ['$scope', 'leaderBoardState', 'leaderBoardService', function ($scope, leaderBoardState, leaderBoardService) {

        $scope.getBoard = function (key) {

        };

        // TODO: Fix intial board which is selected when no specific one is chosen in URL.

        //$scope.leaderboards = leaderBoardService.getBoardsForGroup(leaderBoardState.state.selectedGroup);

        $scope.$watch(function () { return leaderBoardState.state }, function (newVal, oldVal) {
            if (newVal) {
                $scope.leaderboards = leaderBoardService
                                        .getBoardsForGroup(newVal.selectedGroup);                                                                

                $scope.group = newVal.selectedGroup;
                $scope.currentlySelectedBoard = newVal.selectedBoard[newVal.selectedGroup];
            }
        }, true);

    }])
    .controller('boardGroupController', ['$scope', 'leaderBoardState', function ($scope, leaderBoardState) {

        $scope.state = leaderBoardState.state;

        $scope.setBoardGroup = function (group) {
            leaderBoardState.state.selectedGroup = group;
        };
    }]);