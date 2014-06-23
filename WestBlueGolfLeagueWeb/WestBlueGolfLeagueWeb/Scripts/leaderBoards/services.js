(function (module) {

    function leaderBoardFactory($http, $q) {

        var cachedBoards = null;

        return {
            getBoardDetails: function (key) {
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
