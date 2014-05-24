
angular.module('leaderBoards', ['app'])
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

        //$scope.leaderboards = leaderBoardService.getBoardsForGroup(leaderBoardState.state.selectedGroup);

        $scope.$watch(function () { return leaderBoardState.state.selectedGroup }, function (newVal, oldVal) {
            if (newVal) {
                $scope.leaderboards = leaderBoardService.getBoardsForGroup(newVal);
            }
        });

    }])
    .controller('boardGroupController', ['$scope', 'leaderBoardState', function ($scope, leaderBoardState) {

        $scope.state = leaderBoardState.state;

        $scope.setBoardGroup = function (group) {
            leaderBoardState.state.selectedGroup = group;
        };
    }]);