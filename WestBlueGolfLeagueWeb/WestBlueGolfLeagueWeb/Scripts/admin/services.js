angular
    .module('userManagement')
    .factory('user', ['$http', '$q', function ($http, $q) {

        return {
            getAllUsersWithRoles: function () {
                return $http({
                    method: 'GET',
                    url: '/api/user/'
                });
            },
            updateUser: function (user) {
                return $http({
                    method: 'PUT',
                    url: '/api/user/' + user.id,
                    data: user
                });
            },
            deleteUser: function(userToDelete) {
                return $http({
                    method: 'DELETE',
                    url: '/api/user/' + userToDelete.id,
                });
            },
            addUser: function (user) {
                return $http({
                    method: 'POST',
                    url: '/api/user',
                    data: user
                });
            },
            userNameAvailable: function (username) {

                return $http({
                    method: 'GET',
                    url: '/api/user/name/' + encodeURIComponent(btoa(username)) + '/'
                });
            }
        };
    }]);