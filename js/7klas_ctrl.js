/* 7klas Application Controller */

angular.module('7klas_app', []).controller('7klas_ctrl', function($scope, $http) {
  $scope.stName = '';
  $scope.stNEABEL = '';
  $scope.stNEABEL_mul = 1;
  $scope.stNEAMAT_mul = 3;
  $scope.stNEAMAT = '';
  $scope.stSubj1 = '';
  $scope.stSubj2 = '';
  $scope.stRank = '';
  $scope.stRankBy = 'both';

  $scope.cls_rnks = '';
  /* For running locally
    $scope.cls_rnks = [
    {schlName:'Училище 1', clsName:"Клас А", min_rank_I:456, min_rank_II:432 },
    {schlName:'Училище 2', clsName:"Клас Б", min_rank_I:321, min_rank_II:123 }
  ];

  var $num = 0;
  angular.forEach($scope.cls_rnks, function(item) {
    item.number = ++$num;
  });*/

  $http.get("get_ranks.php").then(function (response) {
      /* Number rows here, because in MySQL 5.7 Window functions (e.g.
       * ROW_NUMBER) is not available.
       */
      var $num = 0;
      $scope.cls_rnks = response.data;
      angular.forEach($scope.cls_rnks, function(item) {
        item.number = ++$num;
        item.src = 'db';
      });
  });

  $scope.edit = true;
  $scope.error = false;
  $scope.incomplete = false;
  $scope.hideform = true;

  $scope.addStudent = function() {
    $scope.hideform = false;

    $scope.edit = true;

    $scope.incomplete = true;
    if ($scope.edit             &&
        $scope.stName.length    &&
        $scope.stNEABEL.length  &&
        $scope.stNEAMAT.length  &&
        $scope.stSubj1 !== null &&
        $scope.stSubj2 !== null
       )
    {
      $scope.incomplete = false;
    }
  };

  $scope.calcRank = function(bel, bmul, mat, mmul, subj1, subj2) {
    var rank = (bmul * bel) + (mmul * mat) +
               $7klas.mark_to_score(subj1) + $7klas.mark_to_score(subj2);
    return rank;
  };

  $scope.showRank = function() {
    var scBEL, scMAT;
    if ( $scope.stNEABEL == '' || isNaN($scope.stNEABEL) ) {
      scBEL = 0;
    }
    else {
      scBEL = parseFloat($scope.stNEABEL);
    }

    if ( $scope.stNEAMAT == '' || isNaN($scope.stNEAMAT) ) {
      scMAT = 0;
    }
    else {
      scMAT = parseFloat($scope.stNEAMAT);
    }

    $scope.stRank = $scope.calcRank(scBEL, $scope.stNEABEL_mul,
                                    scMAT, $scope.stNEAMAT_mul,
                                    $scope.stSubj1, $scope.stSubj2);
  }

  $scope.rankStudent = function() {
    $scope.hideform = true;

    var student_ranked = false;
    var rank_by = 0;
    var new_arr = [];
    var new_item = {};

    /* Initialize with student's data */
    new_item.schlName = $scope.stName;
    new_item.clsName  = 'n/a';
    if ( $scope.stRankBy == 'first' ) {
      new_item.min_rank_I = $scope.stRank;
      new_item.min_rank_II = 0.0;
    }
    else if ( $scope.stRankBy == 'second' ) {
      new_item.min_rank_I = 0.0
      new_item.min_rank_II = $scope.stRank;
    }
    else { /* both */
      new_item.min_rank_I  = $scope.stRank;
      new_item.min_rank_II = $scope.stRank;
    }

    var num = 0;
    angular.forEach($scope.cls_rnks, function(item) {
      if ( $scope.stRankBy == 'first' || $scope.stRankBy == 'both' ) {
        rank_by = parseFloat(item.min_rank_I);
      }
      else {
        rank_by = parseFloat(item.min_rank_II);
      }

      if ( $scope.stRank >= rank_by && !student_ranked ) {
        student_ranked = true;
        new_item.number = '--';
        new_item.clsName = item.clsName;
        new_item.source = 'user';
        new_arr.push(new_item);
        item.number = ++num;
        new_arr.push(item);
      }
      else if ( item.source == 'user' ) { /* just push user items */
        new_arr.push(item);
      }
      else {
        item.number = ++num;
        new_arr.push(item);
      }
    });

    /* Loop again to rank by second ranks */
    if ( $scope.stRankBy == 'both' )
    {
      $scope.cls_rnks = new_arr;

      var new_item2 = {};
      new_item2.schlName = $scope.stName;
      new_item2.clsName  = 'n/a';
      new_item2.min_rank_I = $scope.stRank;
      new_item2.min_rank_II = $scope.stRank;

      new_arr = [];
      student_ranked = false;
      num = 0;

      angular.forEach($scope.cls_rnks, function(item) {
        if ( $scope.stRank >= parseFloat(item.min_rank_II)
             && !student_ranked
             && item.source != 'user' /* avoid previous ranking */ )
        {
          student_ranked = true;
          new_item2.number = '--';
          new_item2.clsName = item.clsName;
          new_item2.source = 'user';
          new_arr.push(new_item2);
          item.number = ++num;
          new_arr.push(item);
        }
        else if ( item.source == 'user' ) {  /* just push user items */
          new_arr.push(item);
        }
        else {
          item.number = ++num;
          new_arr.push(item);
        }
      });
    }

    /* Add at the very end if not ranked higher */
    if ( !student_ranked ) {
      new_item.number = ++num;
      new_arr.push(new_item);
    }

    $scope.cls_rnks = new_arr;
  };

  $scope.cancel = function() {
    $scope.hideform = true;
  };

  /* Verify user input */
  $scope.verify = function() {
    $scope.error = false;
    /* Name should have value */
    if ( $scope.stName == "" ) {
      $scope.error = true;
    }

    /* Score should be between 0 and 100 */
    if ( parseFloat($scope.stNEABEL) < 0.0 || parseFloat($scope.stNEABEL) > 100.0 ) {
      $scope.error = true;
    }

    /* Score should be between 0 and 100 */
    if ( parseFloat($scope.stNEAMAT) < 0.0 || parseFloat($scope.stNEAMAT) > 100.0 ) {
      $scope.error = true;
    }

    /* Mark is between 3 and 6 */
    if ( $scope.stSubj1 < 3 || $scope.stSubj1 > 6 ) {
      $scope.error = true;
    }

    /* Mark i between 3 and 6 */
    if ( $scope.stSubj2 < 3 || $scope.stSubj2 > 6 ) {
      $scope.error = true;
    }

    $scope.incomplete = false;
    if ( $scope.edit             &&
        (!$scope.stName.length   ||
         !$scope.stNEABEL.length ||
         !$scope.stNEAMAT.length ||
         $scope.stSubj1 == null  ||
         $scope.stSubj2 == null
        )
       )
    {
      $scope.incomplete = true;
    }
  };

  $scope.mul_change_bel = function () {
    $scope.stNEAMAT_mul = 4 - $scope.stNEABEL_mul;
    $scope.showRank();
  }

  $scope.mul_change_mat = function () {
    $scope.stNEABEL_mul = 4 - $scope.stNEAMAT_mul;
    $scope.showRank();
  }

  $scope.getItemStyle = function(itm) {
    if ( itm.source == 'user' ) {
      return "red";
    }
    else {
      return "inherit";
    }
  }

  $scope.$watch('stName'  ,function() {$scope.verify();});
  $scope.$watch('stNEABEL',function() {$scope.verify(); $scope.showRank();});
  $scope.$watch('stNEAMAT',function() {$scope.verify(); $scope.showRank();});
  $scope.$watch('stSubj1' ,function() {$scope.verify(); $scope.showRank();});
  $scope.$watch('stSubj2' ,function() {$scope.verify(); $scope.showRank();});

});
