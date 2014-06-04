
angular.module("player", ['ngRoute', 'app'])
    .config(['$locationProvider', '$routeProvider', function ($locationProvider, $routeProvider) {

        $locationProvider.html5Mode(true);

        $routeProvider
            .when('/', {
                template: 'home. go to <a href="test">test</a>'
            })
            .when('/test', {
                template: 'hello world test'
            })
            .when('/handicaps/:year?', {
                templateUrl: '/Scripts/player/tpl/playerHandicaps.tpl.html',
                controller: 'handicapsController'
            })
            .when('/results/:year?', {
                templateUrl: '/Scripts/player/tpl/playerResults.tpl.html',
                controller: 'resultsController'
            });
    }])
    .factory("routeState", function () {

        var state = {
            stateValue: -1
        };

        return state;
    })
    .controller("handicapsController", ['$routeParams', '$scope', 'routeState', function ($routeParams, $scope, routeState) {
        routeState.stateValue = 0;
        $scope.year = $routeParams.year;
    }])
    .controller('resultsController', ['$routeParams', '$scope', 'routeState', function ($routeParams, $scope, routeState) {
        routeState.stateValue = 1;
        $scope.year = $routeParams.year;
    }])
    .controller('navController', ['$scope', 'routeState', function ($scope, routeState) {

        $scope.currState = routeState;

    }]);