

(function (player) {

    function PlayerConfig($locationProvider, $urlRouterProvider, $stateProvider) {

        $stateProvider
            .state('playerList', {
                url: '/',
                templateUrl: '/Scripts/player/tpl/playerList.tpl.html',
                controller: 'PlayerList as pList'
            });

        $stateProvider
            .state('playerDetails', {
                url: '/:id',
                templateUrl: '/Scripts/player/tpl/playerDetails.tpl.html',
                controller: 'PlayerDetails as playerDetails',
                resolve: {
                    profileData: ['resolvedPlayerProfileService', '$stateParams', function (profileService, $stateParams) {
                        return profileService.getPlayerData($stateParams.id);
                    }],
                    resolvedPlayerProfileService: 'PlayerProfileService'
                }
            });

        $locationProvider.html5Mode(true);
    };

    function PlayerDetails(profileData) {
        this.profileData = profileData.data;
    };

    function PlayerProfileService($http) {
        return {
            getPlayerData: function (id) {
                return $http({
                    method: 'GET',
                    url: '/api/v1/playerProfile/' + id
                });
            }
        };
    };

    player
        .config(['$locationProvider', '$urlRouterProvider', '$stateProvider', PlayerConfig])
        .controller('PlayerDetails', ['profileData', PlayerDetails])
        .factory('PlayerProfileService', ['$http', PlayerProfileService]);

})(angular.module('player', ['app', 'ngAnimate', 'ui.router', 'playerList']));

  