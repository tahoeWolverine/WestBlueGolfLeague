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
    .controller('YearInit', ['fetchedAdminInfo', 'resolvedYearWizardInfo', 'adminInfo', '$state',
        function (fetchedAdminInfo, resolvedYearWizardInfo, adminInfo, $state) {

        this.adminInfo = fetchedAdminInfo.data;
        this.yearInfo = resolvedYearWizardInfo.data;

        this.isOpen = false;
        this.disabled = false;

        this.minDate = moment().month('April').date(1).format('YYYY-MM-DD');
        this.maxDate = moment().month('October').date(31).format('YYYY-MM-DD');

        this.open = function ($event) {
            $event.preventDefault();
            $event.stopPropagation();

            this.isOpen = !this.isOpen;
        };

        this.selectTeam = function (team) {
            team.isSelected = !team.isSelected;
        };

        this.validState = function () {
            return (_.any(this.yearInfo.teams, 'isSelected') && !this.disabled && this.numberOfWeeks > 0 && this.startDate);
        };

        this.saveYear = function () {

            var submitData = {
                teamIds: _.pluck(_.select(this.yearInfo.teams, 'isSelected'), 'id'),
                numberOfWeeks: this.numberOfWeeks,
                weekDate: moment(this.startDate).format()
            };

            adminInfo.saveYear(submitData)
                .then(function () {
                    $state.go('admin.schedule');
                })
                .catch(function () {
                    alert('error saving year');
                });

            // removing for now
            //this.disabled = true;
        };
    }])
    .controller('YearWizard', ['fetchedAdminInfo', 'yearWizardSteps', function (fetchedAdminInfo, yearWizardSteps) {

        this.fetchedAdminInfo = fetchedAdminInfo.data;

    }])


    // Don't think these will be used at all :(
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
    