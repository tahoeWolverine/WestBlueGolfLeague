angular
    .module('manageUsers', ['app', 'ui.router'])
    .config(['$locationProvider', '$urlRouterProvider', '$stateProvider',
        function ($locationProvider, $urlRouterProvider, $stateProvider) {

            $stateProvider
            .state('index', {
                url: '/?error',
                templateUrl: '/Scripts/admin/tpl/manageUsersIndex.tpl.html',
                controller: 'Index as index',
                //resolve: {
                //    leaderBoards: ['resolveLeaderBoardService', function (lbs) {
                //        return lbs.getBoards();
                //    }],
                //    resolveLeaderBoardService: 'leaderBoardService'
                //}
            });

            $locationProvider.html5Mode(true);
        }])
    .controller('Index', function () {
        this.test = 'eafwef';
    });