
angular
    .module('playerList', ['ngAnimate', 'ui.router'])
    .factory('playerListService', ['$window', '$q', '$timeout', function ($window, $q, $timeout) {

        var playerYearData = $window.playerYearData;

        return {
            getPlayersForYear: function () {

                // This is kind of goofy but I want to keep an async contract in case
                // we return this data from http or something else which is async in the future.
                var defer = $q.defer();

                $timeout(function () {
                    defer.resolve(playerYearData);
                }, 0);

                return defer.promise;
            }
        };
    }])
    .controller('list', ['$scope', 'playerListService', function ($scope, playerListService) {

        $scope.wat = 'wattt';
        //$scope.playerData = [];

        playerListService.getPlayersForYear().then(function (result) {
            $scope.playerData = result;
        });
    }]);