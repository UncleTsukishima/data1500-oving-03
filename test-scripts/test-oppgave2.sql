-- ============================================================================
-- TEST-SKRIPT FOR OPPGAVE 2: SQL-spørringer og databaseskjema
-- ============================================================================

-- Kjør med: psql -h localhost -U admin -d data1500_db -f test-oppgave2.sql

-- Test 1: Verifiser at alle tabeller eksisterer
SELECT 'Test 1: Tabeller eksisterer' as test;
SELECT table_name FROM information_schema.tables 
WHERE table_schema = 'public' 
ORDER BY table_name;

-- Test 2: Verifiser fremmednøkler
SELECT 'Test 2: Fremmednøkler' as test;
SELECT 
    tc.table_name, 
    kcu.column_name, 
    ccu.table_name AS foreign_table_name,
    ccu.column_name AS foreign_column_name
FROM information_schema.table_constraints AS tc
JOIN information_schema.key_column_usage AS kcu
    ON tc.constraint_name = kcu.constraint_name
JOIN information_schema.constraint_column_usage AS ccu
    ON ccu.constraint_name = tc.constraint_name
WHERE tc.constraint_type = 'FOREIGN KEY'
ORDER BY tc.table_name;

-- Test 3: Verifiser indekser
SELECT 'Test 3: Indekser' as test;
SELECT 
    schemaname,
    tablename,
    indexname
FROM pg_indexes
WHERE schemaname = 'public'
ORDER BY tablename, indexname;

-- Test 4: Verifiser at SELECT fungerer
SELECT 'Test 4: SELECT fra alle tabeller' as test;
SELECT COUNT(*) as programmer_count FROM programmer;
SELECT COUNT(*) as emner_count FROM emner;
SELECT COUNT(*) as studenter_count FROM studenter;
SELECT COUNT(*) as emneregistreringer_count FROM emneregistreringer;

-- Test 5: Verifiser JOIN
SELECT 'Test 5: JOIN fungerer' as test;
SELECT 
    s.fornavn, 
    s.etternavn, 
    p.program_navn
FROM studenter s
LEFT JOIN programmer p ON s.program_id = p.program_id
LIMIT 5;

-- Test 6: Verifiser aggregatfunksjoner
SELECT 'Test 6: Aggregatfunksjoner fungerer' as test;
SELECT 
    p.program_navn,
    COUNT(s.student_id) as antall_studenter
FROM programmer p
LEFT JOIN studenter s ON p.program_id = s.program_id
GROUP BY p.program_id, p.program_navn;

-- Test 7: Verifiser at views eksisterer
SELECT 'Test 7: Views eksisterer' as test;
SELECT table_name FROM information_schema.views 
WHERE table_schema = 'public'
ORDER BY table_name;

-- Test 8: Verifiser student_view
SELECT 'Test 8: student_view fungerer' as test;
SELECT COUNT(*) as rows FROM student_view;

-- Test 9: Verifiser foreleser_view
SELECT 'Test 9: foreleser_view fungerer' as test;
SELECT COUNT(*) as rows FROM foreleser_view;

-- Test 10: Verifiser at data er konsistent
SELECT 'Test 10: Data-konsistens' as test;
SELECT 
    'Alle studenter har gyldig program' as check_name,
    COUNT(*) as invalid_count
FROM studenter 
WHERE program_id NOT IN (SELECT program_id FROM programmer)
UNION ALL
SELECT 
    'Alle emneregistreringer har gyldig student',
    COUNT(*)
FROM emneregistreringer 
WHERE student_id NOT IN (SELECT student_id FROM studenter)
UNION ALL
SELECT 
    'Alle emneregistreringer har gyldig emne',
    COUNT(*)
FROM emneregistreringer 
WHERE emne_id NOT IN (SELECT emne_id FROM emner);

-- Test 11: Verifiser at constraints fungerer
SELECT 'Test 11: Constraints fungerer' as test;
SELECT constraint_name, constraint_type 
FROM information_schema.table_constraints 
WHERE table_schema = 'public'
ORDER BY table_name, constraint_name;

SELECT 'Alle tester fullført!' as result;

--Oppgave 1
SELECT s.fornavn, s.etternavn, COUNT(er.registrering_id) AS antall_emner
FROM studenter s
LEFT JOIN emneregistreringer er ON s.student_id = er.student_id
GROUP BY s.student_id, s.fornavn, s.etternavn
HAVING COUNT(er.registrering_id) = 0
ORDER BY s.student_id DESC;

--Oppgave2
SELECT
    e.emne_id,
    e.emne_kode,
    e.emne_navn
FROM emner e
LEFT JOIN emneregistreringer er ON e.emne_id = er.emne_id
WHERE er.emne_id IS NULL;

--Opppgave3
SELECT
    e.emne_navn,
    MIN(er.karakter) AS hoyest_karakter
FROM emneregistreringer er
     JOIN emner e ON er.emne_id = e.emne_id
WHERE er.karakter IS NOT NULL
GROUP BY e.emne_id, e.emne_navn;

--Oppgave4
SELECT
    s.fornavn,
    s.etternavn,
    p.program_navn,
    e.emne_navn
FROM studenter s
LEFT JOIN programmer p
    ON s.program_id = p.program_id
LEFT JOIN emneregistreringer er
    ON s.student_id = er.student_id
LEFT JOIN emner e
    ON er.emne_id = e.emne_id
ORDER BY s.fornavn, s.etternavn;

--Oppgave5
SELECT
    s.student_id,
    s.fornavn,
    s.etternavn
FROM studenter s
JOIN emneregistreringer er
    ON s.student_id = er.student_id
WHERE er.emne_id IN (1, 2)
GROUP BY s.student_id, s.fornavn, s.etternavn
HAVING COUNT(DISTINCT er.emne_id) = 2;



