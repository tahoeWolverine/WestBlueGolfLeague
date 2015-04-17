angular
    .module('schedule', [])
    .controller('Schedule', ['schedule', function (schedule) {

        var sched = new schedule(),
            self = this;

        sched.$promise.then(function (data) {
        	self.sched = sched;
	        self.aggData = sched.getAggregateData();
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

	        this.getAggregateData = function() {
		        if (!self.weeks) {
			        return null;
		        }

		        var lookup = {};

		        self.weeks.forEach(function (item) {
			        item.teamMatchups.forEach(function(teamMatchup) {
						if (!lookup[teamMatchup.team1.name]) {
							lookup[teamMatchup.team1.name] = {};
						}

						if (!lookup[teamMatchup.team2.name]) {
							lookup[teamMatchup.team2.name] = {};
						}

				        var temp = lookup[teamMatchup.team1.name][teamMatchup.matchOrder];
				        lookup[teamMatchup.team1.name][teamMatchup.matchOrder] = !temp ? 1 : temp + 1;

				        temp = lookup[teamMatchup.team2.name][teamMatchup.matchOrder];
				        lookup[teamMatchup.team2.name][teamMatchup.matchOrder] = !temp ? 1 : temp + 1;
			        });
		        });

		        return lookup;
	        };
        };
    }]);