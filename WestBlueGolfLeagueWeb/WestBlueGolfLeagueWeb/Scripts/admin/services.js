angular
    .module('userManagement')
    .factory('user', ['$http', function ($http) {

        return {
            getAllUsersWithRoles: function () {
                return $http({
                    method: 'GET',
                    url: '/api/users/'
                });
            },
            updateUser: function (user) {
                return $http({
                    method: 'PUT',
                    url: '/api/users/' + user.id,
                    data: user
                });
            }
        };
    }]);