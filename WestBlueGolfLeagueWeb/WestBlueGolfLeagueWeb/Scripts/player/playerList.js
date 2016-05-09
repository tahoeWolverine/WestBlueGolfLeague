

angular.module('playerList', ['app', 'ui.router']);

(function (module) {

    module
        // TODO: might not need this... remove this if not needed.
        .filter('chunkPlayers', function () {
            return function (playerList) {
                var newArr = [],
                    subArr = [];

                for (var i = 0; i < playerList.length; i++) {
                    if (i % 3 == 0) {
                        subArr = [];
                        subArr.push(playerList[i]);
                        newArr.push(subArr);
                    }
                    else {
                        subArr.push(playerList[i]);
                    }
                }

                return newArr;
            };
        });


    var PlayerListService = function ($http) {

        return {
            getPlayersForYear: function () {

                return $http({
                    method: 'GET',
                    url: '/api/v1/players'
                }).then(function(result) { return result.data.playersForYear; });
            }
        };
    };


    var ListController = function ($scope, playerListService, $filter) {
        var self = this;

        self.nameSearchText = '';

        self.doFocus = function () {
            $scope.focusMe();
        };

        playerListService.getPlayersForYear().then(function (result) {
            self.playerData = result;
        });

        $scope.$watch(function () { return self.nameSearchText; }, function (newVal, oldVal) {
            $scope.scrollToTop();
        });
    };

    module
        .controller('PlayerList', ['$scope', 'playerListService', '$filter', ListController])
        .factory('playerListService', ['$http', PlayerListService]);

})(angular.module('playerList'));

    