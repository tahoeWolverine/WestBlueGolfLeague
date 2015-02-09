﻿angular
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
                controller: 'AddUser as addUserCtrl',
                resolve: {
                    roles: function () {
                        return self.roles;
                    }
                }
            }).result.then(function (newUser) {
                self.users.push(newUser);
            });
        };
    }])
    .directive('username', ['$q', 'user', function ($q, user) {
        return {
            require: 'ngModel',
            link: function (scope, elem, attrs, ctrl) {
                ctrl.$asyncValidators.username = function (modelValue, viewValue) {
                    if (ctrl.$isEmpty(modelValue)) {
                        return $q.when();
                    }

                    return user.userNameAvailable(modelValue);
                }
            }
        };
    }])
    .controller('AddUser', ['$modalInstance', 'user', 'roles', function ($modalInstance, user, roles) {

        this.roles = roles;
        this.user = {};
        this.user.roleName = roles[0].name;

        this.addUser = function (userToAdd) {
            user.addUser(userToAdd).then(function (data) {
                if (data.status == 200) {
                    $modalInstance.close(data.data);
                }
            });
        };

        this.cancel = function () {
            $modalInstance.dismiss('cancel');
        };
    }]);