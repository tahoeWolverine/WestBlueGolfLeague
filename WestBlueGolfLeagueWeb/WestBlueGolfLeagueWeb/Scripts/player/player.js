

(function (player) {

    function PlayerConfig($locationProvider, $urlRouterProvider, $stateProvider) {

        $stateProvider
            .state('playerList', {
                url: '/',
                templateUrl: '/Scripts/player/tpl/playerListWrapper.tpl.html',
            });

        $stateProvider
            .state('playerDetails', {
                abstract: true,
                templateUrl: '/Scripts/player/tpl/playerDetailsLayout.tpl.html',
                controller: 'PlayerDetailsLayout'
            });

        $stateProvider
            .state('playerDetails.playerProfile', {
                url: '/:id',
                views: {
                    /*playerList: {
                        templateUrl: '/Scripts/player/tpl/playerList.tpl.html',
                        controller: 'PlayerList as pList'
                    },*/
                    playerDetails: {
                        templateUrl: '/Scripts/player/tpl/playerDetails.tpl.html',
                        controller: 'PlayerDetails as playerDetails'
                    },
                    'header.main@': {
                        template: '<a class="navbar-brand" ui-sref="playerList()" href="javascript:void();"><i class="fa fa-chevron-left"></i> Players</a>'
                    }
                },
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

    function PlayerDetailsLayout() {

    };

    function PlayerListDirective() {
        return {
            templateUrl: '/Scripts/player/tpl/playerList.tpl.html',
            controller: 'PlayerList',
            controllerAs: 'pList',
            restrict: 'A',
            link: function () {

            }
        };
    };

    player
        .config(['$locationProvider', '$urlRouterProvider', '$stateProvider', PlayerConfig])
        .controller('PlayerDetails', ['profileData', PlayerDetails])
        .controller('PlayerDetailsLayout', PlayerDetailsLayout)
        .factory('PlayerProfileService', ['$http', PlayerProfileService])
        .directive('playerList', PlayerListDirective);

})(angular.module('player', ['app', 'ngAnimate', 'ui.router', 'playerList']));

  