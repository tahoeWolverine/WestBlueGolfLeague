angular.module('leaderBoards')
	.directive('sortIndicator', function() {
		return {
			templateUrl: '/Scripts/leaderBoards/tpl/sortIndicator.tpl.html',
			scope: true,
			restrict: 'E'

		};
	});