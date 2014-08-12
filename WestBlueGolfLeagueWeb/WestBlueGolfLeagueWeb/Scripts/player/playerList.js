

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


    var PlayerListService = function ($window, $q, $timeout) {

        var playerYearData = $window.playerYearData;

        return {
            getPlayersForYear: function () {

                // This is kind of goofy but I want to keep an async contract in case
                // we return this data from http or something else which is async in the future.
                var defer = $q.defer();

                defer.resolve(playerYearData);

                return defer.promise;
            }
        };
    };


    var ListController = function ($scope, playerListService, $filter) {

        playerListService.getPlayersForYear().then(function (result) {
            $scope.playerData = result;
        });

        $scope.$watch('nameSearchText', function (newVal, oldVal) {
            $scope.scrollToTop();
        });
    };

    module
        .controller('PlayerList', ['$scope', 'playerListService', '$filter', ListController])
        .factory('playerListService', ['$window', '$q', '$timeout', PlayerListService]);

})(angular.module('playerList'));

    