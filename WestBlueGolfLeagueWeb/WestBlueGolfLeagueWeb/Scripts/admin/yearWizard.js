angular
    .module('admin')

    .config(['$stateProvider', function ($stateProvider) {

        $stateProvider
            .state('admin.yearWizard.yearInit', {
                url: '',
                templateUrl: '/Scripts/admin/tpl/yearWizard/yearInit.tpl.html',
                controller: 'YearInit as yearInit',
                resolve: {
                    resolvedYearWizardInfo: ['adminInfo', function(adminInfo) {
                        return adminInfo.getYearWizardData();
                    }]
                }
            });
    }])
    .controller('YearInit', ['fetchedAdminInfo', 'resolvedYearWizardInfo', 'adminInfo',
        function (fetchedAdminInfo, resolvedYearWizardInfo, adminInfo) {

        this.adminInfo = fetchedAdminInfo.data;
        this.yearInfo = resolvedYearWizardInfo.data;

        this.isOpen = false;
        this.disabled = false;

        this.getMinDate = function () {
            return moment().month('April').date(1).format('YYYY-MM-DD');
        };

        this.getMaxDate = function () {
            return moment().month('October').date(31).format('YYYY-MM-DD');
        };

        this.open = function ($event) {
            $event.preventDefault();
            $event.stopPropagation();

            this.isOpen = !this.isOpen;
        };

        this.selectTeam = function (team) {
            team.isSelected = !team.isSelected;
        };

        this.processRules = function () {
            return !(_.any(this.yearInfo.teams, 'isSelected') && !this.disabled);
        };

        this.saveYear = function () {
            adminInfo.saveYear({});

            this.disabled = true;
        };
    }])
    .controller('YearWizard', ['fetchedAdminInfo', 'yearWizardSteps', function (fetchedAdminInfo, yearWizardSteps) {

        this.fetchedAdminInfo = fetchedAdminInfo.data;

    }])
    .factory('yearWizardStorage', function () {

        var data = {

        };

        return {

        };
    })
    .factory('yearWizardSteps', ['yearWizardStorage', function (yearWizardStorage) {

        var stepNames = {
            DATE_SELECT: 'dateSelect',
            TEAM_SELECT: 'teamSelect',
            CONFIRMATION: 'confirmation'
        };

        var stepConfig = { };
        stepConfig[stepNames.DATE_SELECT] = {
            next: stepNames.TEAM_SELECT
        };

        stepConfig[stepNames.TEAM_SELECT] = {
            view: '/Scripts/admin/tpl/yearWizard/teamSelect.tpl.html',
            next: stepNames.CONFIRMATION
        };

        stepConfig[stepNames.CONFIRMATION] = {
            next: null
        };

        var currentStepName = stepNames.DATE_SELECT;

        return {
            getCurrentStep: function () {
                return { stepName: currentStepName, config: stepConfig[currentStepName] };
            },
            commitStep: function (stepName, data) {

            }
        };
    }])
    