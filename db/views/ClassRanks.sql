CREATE OR REPLACE VIEW ClassRanks AS
SELECT CAST(CR.yr AS CHAR(4)) clsYear,
       CONCAT(SC.id, ' ', SC.short_name) schlName,
       CONCAT(SUBSTR(CONVERT(CL.id, CHAR), 5), ' ', CL.`name`)     clsName,
       CR.min_rank_I,
       CR.min_rank_II
  FROM classes        CL,
       class_rankings CR,
       schools        SC
 WHERE CR.class_id  = CL.id
   AND CR.yr        = CL.yr
   AND CL.school_id = SC.id
 ORDER BY CR.yr, CR.min_rank_II DESC;
