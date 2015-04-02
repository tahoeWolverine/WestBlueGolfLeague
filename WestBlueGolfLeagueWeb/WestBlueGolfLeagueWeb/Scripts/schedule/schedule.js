angular
    .module('schedule', [])
    .controller('Schedule', ['schedule', function (schedule) {

        var sched = new schedule(),
            self = this;

        sched.$promise.then(function (data) {
            self.sched = sched;
        });
    }])

    .directive('scheduleDisplay', function () {
        return {
            controller: 'Schedule',
            controllerAs: 'scheduleController',
            templateUrl: '/Scripts/schedule/tpl/schedule.tpl.html'
        };
    })

    .factory('schedule', ['$http', function ($http) {

        return function () {

            var self = this;

            this.$promise = $http({
                method: 'GET',
                url: '/api/schedule'
            }).then(function (response) {
                _.extend(self, response.data);
                return response.data;
            });

            this.save = function () {
                // TODO
            };
        };
    }]);