angular
    .module('userManagement', ['app', 'ui.router', 'ngResource'])
    .config(['$locationProvider', '$urlRouterProvider', '$stateProvider',
        function ($locationProvider, $urlRouterProvider, $stateProvider) {

            $stateProvider
            .state('index', {
                url: '/?error',
                templateUrl: '/Scripts/admin/tpl/userManagementIndex.tpl.html',
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
    .controller('Index', ['user', function (user) {

        var self = this;

        var u = user.getAllUsersWithRoles().then(function (result) {
            self.users = result.data.allUsers;
            self.roles = result.data.allRoles;
        });

        this.updateRole = function (userToUpdate) {
            user.updateUser(userToUpdate);
        };
    }]);