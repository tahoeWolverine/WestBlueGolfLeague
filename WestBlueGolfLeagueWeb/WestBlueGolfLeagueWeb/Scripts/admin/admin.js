angular
    .module('admin', ['userManagement', 'ui.router', 'app'])
    .config(['$locationProvider', '$urlRouterProvider', '$stateProvider', function ($locationProvider, $urlRouterProvider, $stateProvider) {

        $stateProvider
            .state('admin', {
                url: '/',
                templateUrl: '/Scripts/admin/tpl/adminIndex.tpl.html',
                controller: 'AdminIndex as adminIndex'
            });

        $stateProvider
            .state('manageUsers', {
                url: '/manage',
                templateUrl: '/Scripts/admin/tpl/userManagementIndex.tpl.html',
                controller: 'ManageUserIndex as index'
            });

        $urlRouterProvider.otherwise('/');

        $locationProvider.html5Mode(true);
    }])
    .controller('AdminIndex', [function() {
       
    }])
    .controller('SetLeagueNote', ['$scope', 'leagueNote', function ($scope, leagueNote) {

        var self = this;

        this.toggleLeagueNoteDisplay = function (focus) {
            self.isHidden = !self.isHidden;

            if (focus) {
                $scope.focusMe();
            }
        };

        this.setNote = function (text) {
            leagueNote.setNote(text).then(function () {
                self.message = null;
                self.toggleLeagueNoteDisplay();
            }, function (error) {
                self.message = "There was an error setting the league note!";
            });
        };
    }]);