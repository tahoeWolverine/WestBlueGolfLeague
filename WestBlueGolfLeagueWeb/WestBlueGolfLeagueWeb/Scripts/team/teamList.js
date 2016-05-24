

angular.module('teamList', ['app', 'ui.router']);

(function (module) {

    module
        // TODO: might not need this... remove this if not needed.
        .filter('chunkTeam', function () {
            return function (teamList) {
                var newArr = [],
                    subArr = [];

                for (var i = 0; i < teamList.length; i++) {
                    if (i % 3 == 0) {
                        subArr = [];
                        subArr.push(teamList[i]);
                        newArr.push(subArr);
                    }
                    else {
                        subArr.push(teamList[i]);
                    }
                }

                return newArr;
            };
        });


    var TeamListService = function ($http) {

        return {
            getTeamsForYear: function () {
                return $http({
                    method: 'GET',
                    url: '/api/v1/teams'
                }).then(function (result) { return result.data.teamsForYear; });
            }
        };
    };


    var ListController = function ($scope, teamListService, $filter) {
        var self = this;

        self.nameSearchText = '';

        self.doFocus = function () {
            $scope.focusMe();
        };

        teamListService.getTeamsForYear().then(function (result) {
            self.teamData = result;
        });

        $scope.$watch(function () { return self.nameSearchText; }, function (newVal, oldVal) {
            $scope.scrollToTop();
        });
    };

    module
        .controller('TeamList', ['$scope', 'teamListService', '$filter', ListController])
        .factory('teamListService', ['$http', TeamListService]);

})(angular.module('teamList'));

    