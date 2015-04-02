angular
    .module('admin', ['userManagement', 'ui.router', 'app', 'ui.bootstrap.datepicker', 'schedule'])
    .config(['$locationProvider', '$urlRouterProvider', '$stateProvider', function ($locationProvider, $urlRouterProvider, $stateProvider) {

        $stateProvider
            .state('admin', {
                abstract: true,
                url: '/',
                templateUrl: '/Scripts/admin/tpl/adminWrapper.tpl.html',
                resolve: {
                    fetchedAdminInfo: ['adminInfo', function (adminInfo) {
                        return adminInfo.getAdminInfo();
                    }]
                }
            });

        $stateProvider
            .state('admin.index', {
                url: '',
                templateUrl: '/Scripts/admin/tpl/adminIndex.tpl.html',
                controller: 'AdminIndex as adminIndex'
            });

        $stateProvider
            .state('admin.manageUsers', {
                url: 'manage',
                templateUrl: '/Scripts/admin/tpl/userManagementIndex.tpl.html',
                controller: 'ManageUserIndex as index'
            });

        $stateProvider
            .state('admin.yearWizard', {
                abstract: true,
                url: 'yearWizard',
                templateUrl: '/Scripts/admin/tpl/yearWizard/yearWizard.tpl.html',
                controller: 'YearWizard as yearWizard'
            });

        $stateProvider
            .state('admin.schedule', {
                url: 'schedule',
                templateUrl: '/Scripts/admin/tpl/scheduleEditor.tpl.html',
                controller: 'ScheduleEditor as schedule'
            });

        $urlRouterProvider.otherwise('/');

        $locationProvider.html5Mode(true);
    }])


    .controller('AdminIndex', ['fetchedAdminInfo', function (fetchedAdminInfo) {
        this.fetchedAdminInfo = fetchedAdminInfo.data;
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
    }])

    // Future home of schedule editor
    .controller('ScheduleEditor', [function () {

    }]);