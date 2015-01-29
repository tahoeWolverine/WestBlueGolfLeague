angular
    .module('userManagement', ['app', 'ui.router', 'ngResource', 'ui.bootstrap'])
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
    .controller('Index', ['user', '$modal', function (user, $modal) {

        var self = this;

        var u = user.getAllUsersWithRoles().then(function (result) {
            self.users = result.data.allUsers;
            self.roles = result.data.allRoles;
        });

        this.updateRole = function (userToUpdate) {
            user.updateUser(userToUpdate);
        };

        this.addUser = function () {
            var addUserModal = $modal.open({
                templateUrl: '/Scripts/admin/tpl/addUser.tpl.html',
                controller: 'AddUser as addUserCtrl'
            });
        };
    }])
    .controller('AddUser', ['$modalInstance', function ($modalInstance) {

        this.addUser = function () {

        };

        this.cancel = function () {
            $modalInstance.dismiss('cancel');
        };

    }]);