// begin controllers.
(function (module) {

    function Root($scope, leaderBoardStates, $state, errorStates, $rootScope) {

        // Everything below this line in this controller is stupid... resolves are stupid.

        // default to loading, cause we always have a resolve when first hit.
        $scope.isLoading = true;
        
        function handleStateTransitionBegin(event, toState, toParams, fromState, fromParams) {
            if (toState.resolve && toState.name === leaderBoardStates.LEADER_BOARDS) {
                $scope.isLoading = true;
            }
        };

        function handleStateTransitionEndOrError(event, toState, toParams, fromState, fromParams, error) {

            var errorStateToGoTo = errorStates.GENERAL_ERROR;

            if (error) {
                if (toState.name === leaderBoardStates.DETAILS) {
                    if (error.status === 404) {
                        $state.go(leaderBoardStates.LEADER_BOARDS, { error: errorStates.UNKNOWN_LEADERBOARD });
                    }
                    else if (error.status === 500) {
                        errorStateToGoTo = errorStates.ERROR_LOADING_LEADERBOARD;
                    }
                }
            }

            if (toState.resolve) {
                $scope.isLoading = false;
            }
        };

        $scope.$on('$stateChangeStart', handleStateTransitionBegin);
        $scope.$on('$stateChangeSuccess', handleStateTransitionEndOrError);
        $scope.$on('$stateChangeError', handleStateTransitionEndOrError);
    };

    function LeaderBoardsController($scope, $stateParams, $state, leaderBoards, errorStates) {

        $scope.boards = leaderBoards;

        $scope.errorMessage = "";

        if ($stateParams.error) {
            if ($stateParams.error === errorStates.UNKNOWN_LEADERBOARD) {
                $scope.errorMessage = "Unknown leader board. Please select from one of the available.";
            }
            else if ($stateParams.error === errorStates.ERROR_LOADING_LEADERBOARD) {
                $scope.errorMessage = "There was an error loading your leader board, please select another.";
            }
            else {
                $scope.errorMessage = "There was an error loading leader board data :(";
            }
        }

        $scope.showTeamBoards = function () {
            return $scope.currBoard === 'team';
        };

        $scope.showPlayerBoards = function () {
            return $scope.currBoard !== 'team';
        };
    };

    function DetailsLayoutController($scope, $stateParams, $state, boards, boardStates) {

        $scope.boards = boards;

        // These funcs could be more generic.
        $scope.showTeamBoards = function () {
            return ((!$scope.currBoard && $scope.boardGroup === 'team') || $scope.currBoard === 'team');
        };

        $scope.showPlayerBoards = function () {
            return ((!$scope.currBoard && $scope.boardGroup !== 'team') || $scope.currBoard === 'player');
        };

        $scope.boardGroup = $state.params.boardGroup;
        $scope.currBoard = $state.params.boardGroup;

        // This controller won't get new-ed up until everything is resolved.
        // this means that this won't fire the first time coming to this (from another state that isn't a child)
        $scope.$on('$stateChangeStart', function (event, toState, toParams, fromState, fromParams) {
            if (toState.name === boardStates.DETAILS) {
                $scope.boardGroup = toParams.boardGroup;
                $scope.currBoard = toParams.boardGroup;
            }
        });
    };

    function DetailsController($state, $stateParams, $scope, leaderBoardService, leaderBoardDetails) {
        $scope.id = $stateParams.id;

        $scope.leaderBoardData = leaderBoardDetails.data;

        // uncomment to use spinners and not resolve.
        /*$scope.isLoading = true;
        leaderBoardService.getBoardDetails($stateParams.id).then(function (response) {
            $scope.isLoading = false;
            $scope.leaderBoardData = (response.data);
        });*/
    };

    function DetailsTitleController($scope, leaderBoardDetails) {
        $scope.leaderBoardTitle = leaderBoardDetails.data.leaderBoard.name;
    };

    module
        .controller('Root', ['$scope', 'leaderBoardStates', '$state', 'errorStates', '$rootScope', Root])
        .controller('Details', ['$state', '$stateParams', '$scope', 'leaderBoardService', 'leaderBoardDetails', DetailsController])
        .controller('DetailsTitle', ['$scope', 'leaderBoardDetails', DetailsTitleController])
        .controller('DetailsLayout', ['$scope', '$stateParams', '$state', 'leaderBoards', 'leaderBoardStates', DetailsLayoutController])
        .controller('LeaderBoards', ['$scope', '$stateParams', '$state', 'leaderBoards', 'errorStates', LeaderBoardsController]);

})(angular.module('leaderBoards'));