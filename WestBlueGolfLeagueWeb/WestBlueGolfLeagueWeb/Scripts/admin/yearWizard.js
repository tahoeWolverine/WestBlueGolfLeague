angular
    .module('admin')

    .config(['$stateProvider', function ($stateProvider) {

        $stateProvider
            .state('admin.yearWizard.yearInit', {
                url: '',
                templateUrl: '/Scripts/admin/tpl/yearWizard/yearInit.tpl.html',
                controller: 'YearInit as yearInit',
                resolve: {
                    resolvedYearWizardInfo: ['yearManagement', function (yearManagement) {
                        return yearManagement.getYearWizardData();
                    }]
                }
            });
    }])
    .controller('YearInit', ['fetchedAdminInfo', 'resolvedYearWizardInfo', 'yearManagement', '$state',
        function (fetchedAdminInfo, resolvedYearWizardInfo, yearManagement, $state) {

            var self = this;
            this.adminInfo = fetchedAdminInfo.data;
            this.yearInfo = resolvedYearWizardInfo.data;

            this.disabled = false;
            this.startDate = null;
            this.selectedDates = [];

            this.minDate = moment().month('April').date(1).format('YYYY-MM-DD');
            this.maxDate = moment().month('October').date(31).format('YYYY-MM-DD');

            this.selectTeam = function (team) {
                team.isSelected = !team.isSelected;
            };

            this.validState = function () {
                return (/*_.filter(this.yearInfo.teams, 'isSelected').length % 2 == 0 &&*/ !this.disabled && (this.selectedDates && this.selectedDates.length));
            };

            this.createTeam = function () {
                if (!self.teamToCreate) { return; }

                self.yearInfo.teams.push({ name: self.teamToCreate, isSelected: true });
                self.teamToCreate = '';
            };

            this.saveYear = function () {

                var submitData = {
                    teamIds: _.pluck(_.select(this.yearInfo.teams, 'isSelected'), 'id'),
                    selectedDates: _.map(this.selectedDates, function (date) { return moment(date).format() }),
                    roster: this.yearRoster,
                    teamsToCreate: _.pluck(_.filter(this.yearInfo.teams, function(team) { return !team.id && team.isSelected }), 'name'), // grab non-persisted teams
                };

                yearManagement.saveYear(submitData)
                    .then(function () {
                        $state.go('admin.schedule');
                    })
                    .catch(function () {
                        alert('error saving year');
                    });
                
                this.disabled = true;
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
    