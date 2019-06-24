/* 7klas utility functions */

var $7klas = {}

/**
 * Round to given number of places
 * @param number Number to round
 * @param places Places to round to
 * @returns Number rounded
 */
$7klas.round = function (number, places) {
  return Math.round(number * Math.pow(10, places)) / Math.pow(10, places);
}

/**
 * Convert mark to scores (see ???)
 * @param mark Mark in six-point marking system
 * @returns Scores
 */
$7klas.mark_to_score = function (mark) {
  var score = 0;

  if ( isNaN(mark) ) {
    throw "Mark is NOT a number!";
  }

  switch(Math.round(mark)) {
      case 6: score = 50; break;
      case 5: score = 39; break;
      case 4: score = 26; break;
      case 3: score = 15; break;
      default: score = 0;
  }

  return score;
}

/**
 * Convert scores to mark (see ???)
 * @param score Scores from exam
 * @returns Mark in six-point marking system
 */
$7klas.score_to_mark = function (score) {
  var mark = 0.0;

  if ( isNaN(score) ) {
    throw "Score is NOT a number!";
  }

  if ( score < 0 || score > 100 ) {
    throw "Score should be betweeen 0 and 100!";
  }

  if (score <= 15) {
    mark = 2.0;
  }
  else {
    mark = $7klas.round((score + 68)/28, 3);
  }

  return mark;
}
