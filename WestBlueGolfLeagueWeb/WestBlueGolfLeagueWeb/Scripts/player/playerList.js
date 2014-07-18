

angular.module('playerList', ['ngAnimate', 'ui.router']);

(function (module) {


    module
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


})(angular.module('playerList'));

angular
    .module('playerList')
    .factory('playerListService', ['$window', '$q', '$timeout', function ($window, $q, $timeout) {

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
    }])

    .controller('list', ['$scope', 'playerListService', '$filter', function ($scope, playerListService, $filter) {

        $scope.wat = 'wattt';
        //$scope.playerData = [];

        playerListService.getPlayersForYear().then(function (result) {

            /*var sortedResult = $filter('orderBy')(result, 'name');

            var newArr = [],
                subArr = [];

            for (var i = 0; i < sortedResult.length; i++) {
                if (i % 3 == 0) {
                    subArr = [];
                    subArr.push(sortedResult[i]);
                    newArr.push(subArr);
                }
                else {
                    subArr.push(sortedResult[i]);
                }
            }

            //console.log(newArr);*/

            $scope.playerData = result;
        });
    }]);