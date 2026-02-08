-- ============================================================================
-- TEST-SKRIPT FOR OPPGAVESETT 1.4: Databasemodellering og implementering
-- ============================================================================

-- Kjør med: docker-compose exec postgres psql -h -U admin -d data1500_db -f test-scripts/oppgave4_losning.sql

-- En test SQL-spørring mot metadata i PostgreSQL
select nspname as schema_name from pg_catalog.pg_namespace;
