// begin controllers.
(function (module) {

    function Root($scope, leaderBoardStates) {

        // Everything below this line in this controller is stupid... resolves are stupid.

        // default to loading, cause we always have a resolve when first hit.
        $scope.isLoading = true;
        
        function handleStateTransitionBegin(event, toState, toParams, fromState, fromParams) {
            if (toState.resolve && toState.name === leaderBoardStates.LEADER_BOARDS) {
                $scope.isLoading = true;
            }
        };

        function handleStateTransitionEndOrError(event, toState, toParams, fromState, fromParams, error) {
            if (error) {
                // do something here for error.
            }

            if (toState.resolve) {
                $scope.isLoading = false;
            }
        };

        $scope.$on('$stateChangeStart', handleStateTransitionBegin);
        $scope.$on('$stateChangeSuccess', handleStateTransitionEndOrError);
        $scope.$on('$stateChangeError', handleStateTransitionEndOrError);
    };

    function LeaderBoardsController($scope, $stateParams, $state, leaderBoards) {

        $scope.boards = leaderBoards;

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

    module
        .controller('Root', ['$scope', 'leaderBoardStates', Root])
        .controller('Details', ['$state', '$stateParams', '$scope', 'leaderBoardService', 'leaderBoardDetails', DetailsController])
        .controller('DetailsLayout', ['$scope', '$stateParams', '$state', 'leaderBoards', 'leaderBoardStates', DetailsLayoutController])
        .controller('LeaderBoards', ['$scope', '$stateParams', '$state', 'leaderBoards', LeaderBoardsController]);

})(angular.module('leaderBoards'));