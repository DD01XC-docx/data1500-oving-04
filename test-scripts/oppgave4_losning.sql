-- ============================================================================
-- TEST-SKRIPT FOR OPPGAVESETT 1.4: Databasemodellering og implementering
-- ============================================================================
SELECT
    an.announcement_id,
    an.title,
    an.innlegg,
    an.dato
FROM announcement an
JOIN classroom c ON an.classroom_id = c.classroom_id
WHERE an.classroom_id = 'CLASS1'
  AND an.user_id = c.ansvarlig_larer_id
ORDER BY an.dato DESC
LIMIT 3;

WITH RECURSIVE diskusjonstrad AS (
    SELECT
        p.post_id,
        p.innlegg,
        p.parent_post_id,
        p.user_id,
        p.post_id AS root_id,
        0 AS depth
    FROM post p
    WHERE p.user_id = 'CCCCC'
      AND p.parent_post_id IS NULL

    UNION ALL

    SELECT
        c.post_id,
        c.innlegg,
        c.parent_post_id,
        c.user_id,
        d.root_id,
        d.depth + 1
    FROM post c
    JOIN diskusjonstrad d ON c.parent_post_id = d.post_id
)
SELECT *
FROM diskusjonstrad
ORDER BY root_id, depth, post_id;
ppe
SELECT
    u.user_id,
    u.username,
    u.name
FROM user_group ug
JOIN users u ON u.user_id = ug.user_id
WHERE ug.group_id = 'ADATA-C';

SELECT COUNT(*) AS antall_grupper
FROM groups;
