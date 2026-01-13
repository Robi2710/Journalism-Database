-- tabele independente
CREATE TABLE CATEGORIE (
    cod_categorie NUMBER(5) NOT NULL,
    nume VARCHAR2(50) NOT NULL,
    descriere VARCHAR2(255),
    CONSTRAINT pk_categorie PRIMARY KEY (cod_categorie)
);

CREATE TABLE ABONAMENTE (
    cod_abonament NUMBER(5) NOT NULL,
    tip_abonament VARCHAR2(50) NOT NULL,
    pret NUMBER(6,2) NOT NULL,
    CONSTRAINT pk_abonamente PRIMARY KEY (cod_abonament)
);

CREATE TABLE TAG (
    cod_tag NUMBER(5) NOT NULL,
    nume VARCHAR2(50) NOT NULL,
    popularitate NUMBER(5) DEFAULT 0,
    CONSTRAINT pk_tag PRIMARY KEY (cod_tag)
);

CREATE TABLE EVENIMENT (
    cod_eveniment NUMBER(5) NOT NULL,
    locatie VARCHAR2(100),
    data_eveniment DATE,
    CONSTRAINT pk_eveniment PRIMARY KEY (cod_eveniment)
);

CREATE TABLE SURSE (
    cod_sursa NUMBER(5) NOT NULL,
    provenienta VARCHAR2(100) NOT NULL,
    link_sursa VARCHAR2(255) NOT NULL,
    CONSTRAINT pk_surse PRIMARY KEY (cod_sursa)
);

CREATE TABLE UTILIZATORI (
    cod_utilizator NUMBER(5) NOT NULL,
    cod_abonament NUMBER(5),
    nume VARCHAR2(50) NOT NULL,
    prenume VARCHAR2(50) NOT NULL,
    email VARCHAR2(100) UNIQUE,
    CONSTRAINT pk_utilizatori PRIMARY KEY (cod_utilizator),
    CONSTRAINT fk_utilizatori_abonament FOREIGN KEY (cod_abonament)
                      REFERENCES ABONAMENTE (cod_abonament)
);
-- subtabele
CREATE TABLE AUTORI (
    cod_utilizator NUMBER(5) NOT NULL,
    rating_mediu NUMBER(3,2) DEFAULT 0,
    CONSTRAINT pk_autori PRIMARY KEY (cod_utilizator),
    CONSTRAINT fk_autori_users FOREIGN KEY (cod_utilizator)
        REFERENCES UTILIZATORI (cod_utilizator) ON DELETE CASCADE
);

CREATE TABLE EDITORI (
    cod_utilizator NUMBER(5) NOT NULL,
    CONSTRAINT pk_editori PRIMARY KEY (cod_utilizator),
    CONSTRAINT fk_editori_users FOREIGN KEY (cod_utilizator)
        REFERENCES UTILIZATORI (cod_utilizator) ON DELETE CASCADE
);
CREATE TABLE CITITORI (
    cod_utilizator NUMBER(5) NOT NULL,
    data_ultima_logare DATE DEFAULT SYSDATE,
    CONSTRAINT pk_cititori PRIMARY KEY (cod_utilizator),
    CONSTRAINT fk_cititori_users FOREIGN KEY (cod_utilizator)
        REFERENCES UTILIZATORI (cod_utilizator) ON DELETE CASCADE
);
-- tabele dependente

CREATE TABLE ARTICOLE (
    cod_articol NUMBER(5) NOT NULL,
    cod_categorie NUMBER(5) NOT NULL,
    titlu VARCHAR(150) NOT NULL,
    continut CLOB,
    data_aparitie DATE DEFAULT SYSDATE,
    limba VARCHAR2(20),
    CONSTRAINT pk_articole PRIMARY KEY (cod_articol),
    CONSTRAINT fk_articole_cat FOREIGN KEY (cod_categorie)
                      REFERENCES CATEGORIE (cod_categorie)

);

CREATE TABLE COMENTARII (
    cod_comentariu NUMBER(10) NOT NULL,
    cod_utilizator NUMBER(5) NOT NULL, -- autorul comentariului
    cod_articol NUMBER(5) NOT NULL,
    text_comentariu VARCHAR2(500),
    CONSTRAINT pk_comentarii PRIMARY KEY (cod_comentariu),
    CONSTRAINT fk_comm_util FOREIGN KEY (cod_utilizator) REFERENCES UTILIZATORI (cod_utilizator),
    CONSTRAINT fk_comm_art FOREIGN KEY (cod_articol) REFERENCES ARTICOLE (cod_articol)

);

CREATE TABLE FEEDBACK (
    cod_feedback NUMBER(10) NOT NULL,
    cod_articol NUMBER(5) NOT NULL,
    cod_utilizator NUMBER(5) NOT NULL,
    tip_feedback VARCHAR2(20) CHECK (tip_feedback IN ('Like', 'Dislike', 'Rating')),
    nota NUMBER(1) CHECK (nota BETWEEN 1 AND 5),
    CONSTRAINT pk_feedback PRIMARY KEY (cod_feedback),
    CONSTRAINT fk_feed_art FOREIGN KEY (cod_articol) REFERENCES ARTICOLE (cod_articol),
    CONSTRAINT fk_feed_util FOREIGN KEY (cod_utilizator) REFERENCES UTILIZATORI (cod_utilizator)
);

CREATE TABLE RAPORTARI (
    cod_raport NUMBER(5) NOT NULL,
    cod_comentariu NUMBER(10) NOT NULL,
    cod_utilizator NUMBER(5),
    motiv VARCHAR2(100),
    data_raport DATE DEFAULT SYSDATE,
    CONSTRAINT pk_raportari PRIMARY KEY (cod_raport),
    CONSTRAINT fk_rap_comm FOREIGN KEY (cod_comentariu) REFERENCES COMENTARII (cod_comentariu),
    CONSTRAINT fk_rap_util FOREIGN KEY (cod_utilizator) REFERENCES UTILIZATORI (cod_utilizator)
);

-- tabele asociative

CREATE TABLE SCRIE (
    cod_utilizator NUMBER(5) NOT NULL,
    cod_articol NUMBER(5) NOT NULL,
    data_scrierii DATE DEFAULT SYSDATE,
    CONSTRAINT pk_scrie PRIMARY KEY (cod_utilizator, cod_articol),
    CONSTRAINT fk_scrie_util FOREIGN KEY (cod_utilizator) REFERENCES AUTORI (cod_utilizator) ON DELETE CASCADE,
    CONSTRAINT fk_scrie_art FOREIGN KEY (cod_articol) REFERENCES ARTICOLE (cod_articol) ON DELETE CASCADE
);

CREATE TABLE ARTICOL_ARE_TAG (
    cod_articol NUMBER(5) NOT NULL,
    cod_tag NUMBER(5) NOT NULL,
    CONSTRAINT pk_art_are_tag PRIMARY KEY (cod_articol, cod_tag),
    CONSTRAINT fk_art_are_tag_art FOREIGN KEY (cod_articol) REFERENCES ARTICOLE (cod_articol),
    CONSTRAINT fk_art_are_tag_tag FOREIGN KEY (cod_tag) REFERENCES TAG (cod_tag)
);

CREATE TABLE INCLUDE (
    cod_articol NUMBER(5) NOT NULL,
    cod_sursa NUMBER(5) NOT NULL,
    CONSTRAINT pk_include PRIMARY KEY (cod_articol, cod_sursa),
    CONSTRAINT fk_include_art FOREIGN KEY (cod_articol) REFERENCES ARTICOLE (cod_articol),
    CONSTRAINT fk_include_sursa FOREIGN KEY (cod_sursa) REFERENCES SURSE (cod_sursa)
);

CREATE TABLE ASOCIAT_LA (
    cod_articol NUMBER(5) NOT NULL,
    cod_eveniment NUMBER(5) NOT NULL,
    CONSTRAINT pk_asociat PRIMARY KEY (cod_articol, cod_eveniment),
    CONSTRAINT fk_aso_art FOREIGN KEY (cod_articol) REFERENCES ARTICOLE (cod_articol),
    CONSTRAINT fk_aso_ev FOREIGN KEY (cod_eveniment) REFERENCES EVENIMENT (cod_eveniment)
);

CREATE TABLE ISTORIC_CITIRE (
    cod_utilizator NUMBER(5) NOT NULL,
    cod_articol NUMBER(5) NOT NULL,
    data_citire DATE DEFAULT SYSDATE,
    CONSTRAINT pk_ist_cit PRIMARY KEY (cod_utilizator, cod_articol),
    CONSTRAINT fk_ist_cit_util FOREIGN KEY (cod_utilizator) REFERENCES CITITORI (cod_utilizator) ON DELETE CASCADE ,
    CONSTRAINT fk_ist_cit_art FOREIGN KEY (cod_articol) REFERENCES ARTICOLE (cod_articol) ON DELETE CASCADE
);

--inserturi

--tabele independente

INSERT INTO CATEGORIE (cod_categorie, nume, descriere) VALUES (1, 'Tehnologie', 'Gadgeturi, AI si Software');
INSERT INTO CATEGORIE (cod_categorie, nume, descriere) VALUES (2, 'Stiinta', 'Descoperiri in fizica, astronomie, biologie si alte subiecte');
INSERT INTO CATEGORIE (cod_categorie, nume, descriere) VALUES (3, 'Sanatate', 'Nutritie, medicina si lifestyle');
INSERT INTO CATEGORIE (cod_categorie, nume, descriere) VALUES (4, 'Politic', 'Analize si noutati politice interne si externe');
INSERT INTO CATEGORIE (cod_categorie, nume, descriere) VALUES (5, 'Sport', 'Fotbal, tenis, basket si Jocurile Olimpice');

INSERT INTO ABONAMENTE (cod_abonament, tip_abonament, pret) VALUES (10, 'Free', 0);
INSERT INTO ABONAMENTE (cod_abonament, tip_abonament, pret) VALUES (20, 'Silver', 15.99);
INSERT INTO ABONAMENTE (cod_abonament, tip_abonament, pret) VALUES (30, 'Gold', 29.99);
INSERT INTO ABONAMENTE (cod_abonament, tip_abonament, pret) VALUES (40, 'Student', 9.99);
INSERT INTO ABONAMENTE (cod_abonament, tip_abonament, pret) VALUES (50, 'Corporate', 99.99);

INSERT INTO TAG (cod_tag, nume, popularitate) VALUES (100, 'Inteligenta Artificiala', 950);
INSERT INTO TAG (cod_tag, nume, popularitate) VALUES (101, 'Spatiul Cosmic', 400);
INSERT INTO TAG (cod_tag, nume, popularitate) VALUES (102, 'Alegeri', 1200);
INSERT INTO TAG (cod_tag, nume, popularitate) VALUES (103, 'Dieta Keto', 300);
INSERT INTO TAG (cod_tag, nume, popularitate) VALUES (104, 'Champions League', 800);

INSERT INTO EVENIMENT (cod_eveniment, locatie, data_eveniment) VALUES (500, 'CES Las Vegas', TO_DATE('10-01-2025', 'DD-MM-YYYY'));
INSERT INTO EVENIMENT (cod_eveniment, locatie, data_eveniment) VALUES (501, 'Summit Climatic Paris', TO_DATE('15-03-2025', 'DD-MM-YYYY'));
INSERT INTO EVENIMENT (cod_eveniment, locatie, data_eveniment) VALUES (502, 'Finala UCL Munchen', TO_DATE('30-05-2025', 'DD-MM-YYYY'));
INSERT INTO EVENIMENT (cod_eveniment, locatie, data_eveniment) VALUES (503, 'Turul 2 Prezidentiale', TO_DATE('18-05-2025', 'DD-MM-YYYY'));
INSERT INTO EVENIMENT (cod_eveniment, locatie, data_eveniment) VALUES (504, 'Lansare iPhone', TO_DATE('12-09-2025', 'DD-MM-YYYY'));

INSERT INTO SURSE (cod_sursa, provenienta, link_sursa) VALUES (1000, 'Reuters', 'https://reuters.com');
INSERT INTO SURSE (cod_sursa, provenienta, link_sursa) VALUES (1001, 'NASA Official', 'https://nasa.gov');
INSERT INTO SURSE (cod_sursa, provenienta, link_sursa) VALUES (1002, 'Ministerul Sanatatii', 'https://ms.ro');
INSERT INTO SURSE (cod_sursa, provenienta, link_sursa) VALUES (1003, 'BBC Sport', 'https://bbc.com/sport');
INSERT INTO SURSE (cod_sursa, provenienta, link_sursa) VALUES (1004, 'TechCrunch', 'https://techcrunch.com');

INSERT INTO UTILIZATORI VALUES (1, 30, 'Popescu', 'Ion', 'ion@news.ro');
INSERT INTO EDITORI (cod_utilizator) VALUES (1);
INSERT INTO UTILIZATORI VALUES (7, 30, 'Stanescu', 'Mircea', 'mircea@news.ro');
INSERT INTO EDITORI (cod_utilizator) VALUES (7);
INSERT INTO UTILIZATORI VALUES (8, 30, 'Diaconu', 'Alina', 'alina@news.ro');
INSERT INTO EDITORI (cod_utilizator) VALUES (8);
INSERT INTO UTILIZATORI VALUES (9, 50, 'Barbu', 'Costel', 'costel@news.ro');
INSERT INTO EDITORI (cod_utilizator) VALUES (9);
INSERT INTO UTILIZATORI VALUES (10, 30, 'Nistor', 'Diana', 'diana@news.ro');
INSERT INTO EDITORI (cod_utilizator) VALUES (10);

INSERT INTO UTILIZATORI VALUES (2, 20, 'Ionescu', 'Maria', 'maria@news.ro');
INSERT INTO AUTORI (cod_utilizator, rating_mediu) VALUES (2, 4.8);
INSERT INTO UTILIZATORI VALUES (3, 50, 'Vasilescu', 'Dan', 'dan@news.ro');
INSERT INTO AUTORI (cod_utilizator, rating_mediu) VALUES (3, 4.2);
INSERT INTO UTILIZATORI VALUES (11, 20, 'Oprea', 'Victor', 'victor@news.ro');
INSERT INTO AUTORI (cod_utilizator, rating_mediu) VALUES (11, 4.5);
INSERT INTO UTILIZATORI VALUES (12, 20, 'Lupu', 'Camelia', 'camelia@news.ro');
INSERT INTO AUTORI (cod_utilizator, rating_mediu) VALUES (12, 4.9);
INSERT INTO UTILIZATORI VALUES (6, 30, 'Radu', 'Elena', 'elena@news.ro');
INSERT INTO AUTORI (cod_utilizator, rating_mediu) VALUES (6,  4.9);

INSERT INTO UTILIZATORI VALUES (4, 10, 'Dumitru', 'Ana', 'ana@gmail.com');
INSERT INTO CITITORI (cod_utilizator, data_ultima_logare) VALUES (4, SYSDATE - 2);
INSERT INTO UTILIZATORI VALUES (5, 40, 'Georgescu', 'Vlad', 'vlad@student.ro');
INSERT INTO CITITORI (cod_utilizator, data_ultima_logare) VALUES (5, SYSDATE - 4);
INSERT INTO UTILIZATORI VALUES (13, 10, 'Manta', 'George', 'george@yahoo.com');
INSERT INTO CITITORI (cod_utilizator, data_ultima_logare) VALUES (13, SYSDATE-1);
INSERT INTO UTILIZATORI VALUES (14, 10, 'Toma', 'Sorina', 'sorina@gmail.com');
INSERT INTO CITITORI (cod_utilizator, data_ultima_logare) VALUES (14, SYSDATE-5);
INSERT INTO UTILIZATORI VALUES (15, 40, 'Pavel', 'Ionut', 'ionut@student.ro');
INSERT INTO CITITORI (cod_utilizator, data_ultima_logare) VALUES (15, SYSDATE - 7);

INSERT INTO ARTICOLE VALUES (10, 1, 'Revolutia AI in 2025', 'Text despre AI...', SYSDATE-10, 'Romana');
INSERT INTO ARTICOLE VALUES (11, 2, 'Noi imagini de pe Marte', 'Roverul a trimis...', SYSDATE-8, 'Engleza');
INSERT INTO ARTICOLE VALUES (12, 3, 'Beneficiile somnului', 'Studiu recent...', SYSDATE-5, 'Romana');
INSERT INTO ARTICOLE VALUES (13, 4, 'Rezultate Sondaje', 'Analiza politica...', SYSDATE-3, 'Romana');
INSERT INTO ARTICOLE VALUES (14, 5, 'Cine castiga finala?', 'Predicții fotbal...', SYSDATE-1, 'Spaniola');
INSERT INTO ARTICOLE VALUES (15, 1, 'Lansare Procesor Nou', 'Specificatii tehnice...', SYSDATE, 'Engleza');

-- tabele dependente

INSERT INTO COMENTARII VALUES (100, 4, 10, 'Foarte interesant articol!');
INSERT INTO COMENTARII VALUES (101, 5, 10, 'Nu sunt de acord cu ultimul paragraf.');
INSERT INTO COMENTARII VALUES (102, 4, 14, 'Cine credeti ca bate?');
INSERT INTO COMENTARII VALUES (103, 5, 11, 'Imagini superbe.');
INSERT INTO COMENTARII VALUES (104, 2, 13, 'Analiza corecta.');

INSERT INTO FEEDBACK VALUES (1, 10, 4, 'Like', 5);
INSERT INTO FEEDBACK VALUES (2, 10, 5, 'Like', 4);
INSERT INTO FEEDBACK VALUES (3, 11, 4, 'Rating', 5);
INSERT INTO FEEDBACK VALUES (4, 14, 5, 'Dislike', 1);
INSERT INTO FEEDBACK VALUES (5, 15, 4, 'Like', 5);

INSERT INTO RAPORTARI VALUES (1, 101, 2, 'Limbaj agresiv', SYSDATE);
INSERT INTO RAPORTARI VALUES (2, 102, 3, 'Spam', SYSDATE);
INSERT INTO RAPORTARI VALUES (3, 100, 1, 'Publicitate', SYSDATE);
INSERT INTO RAPORTARI VALUES (4, 104, 5, 'Fake news', SYSDATE);
INSERT INTO RAPORTARI VALUES (5, 101, 1, 'Off-topic', SYSDATE);

-- tabele asociative
INSERT INTO SCRIE VALUES (2, 10, SYSDATE-10);
INSERT INTO SCRIE VALUES (3, 11, SYSDATE-8);
INSERT INTO SCRIE VALUES (6, 12, SYSDATE-5);
INSERT INTO SCRIE VALUES (11, 13, SYSDATE-3);
INSERT INTO SCRIE VALUES (3, 14, SYSDATE-1);
INSERT INTO SCRIE VALUES (2, 15, SYSDATE);
INSERT INTO SCRIE VALUES (6, 10, SYSDATE-10);
INSERT INTO SCRIE VALUES (12, 11, SYSDATE-8);
INSERT INTO SCRIE VALUES (3, 15, SYSDATE);
INSERT INTO SCRIE VALUES (2, 12, SYSDATE-5);

INSERT INTO ARTICOL_ARE_TAG VALUES (10, 100);
INSERT INTO ARTICOL_ARE_TAG VALUES (10, 104);
INSERT INTO ARTICOL_ARE_TAG VALUES (15, 100);
INSERT INTO ARTICOL_ARE_TAG VALUES (11, 101);
INSERT INTO ARTICOL_ARE_TAG VALUES (13, 102);
INSERT INTO ARTICOL_ARE_TAG VALUES (12, 103);
INSERT INTO ARTICOL_ARE_TAG VALUES (14, 104);
INSERT INTO ARTICOL_ARE_TAG VALUES (11, 100);
INSERT INTO ARTICOL_ARE_TAG VALUES (15, 104);
INSERT INTO ARTICOL_ARE_TAG VALUES (13, 100);
INSERT INTO ARTICOL_ARE_TAG VALUES (10, 101);

INSERT INTO INCLUDE VALUES (10, 1004);
INSERT INTO INCLUDE VALUES (10, 1000);
INSERT INTO INCLUDE VALUES (11, 1001);
INSERT INTO INCLUDE VALUES (12, 1002);
INSERT INTO INCLUDE VALUES (13, 1000);
INSERT INTO INCLUDE VALUES (14, 1003);
INSERT INTO INCLUDE VALUES (15, 1004);
INSERT INTO INCLUDE VALUES (15, 1000);
INSERT INTO INCLUDE VALUES (11, 1000);
INSERT INTO INCLUDE VALUES (13, 1003);


INSERT INTO ASOCIAT_LA VALUES (10, 500);
INSERT INTO ASOCIAT_LA VALUES (15, 500);
INSERT INTO ASOCIAT_LA VALUES (11, 501);
INSERT INTO ASOCIAT_LA VALUES (12, 503);
INSERT INTO ASOCIAT_LA VALUES (14, 502);
INSERT INTO ASOCIAT_LA VALUES (15, 504);
INSERT INTO ASOCIAT_LA VALUES (10, 504);
INSERT INTO ASOCIAT_LA VALUES (13, 501);
INSERT INTO ASOCIAT_LA VALUES (14, 500);
INSERT INTO ASOCIAT_LA VALUES (12, 501);

INSERT INTO FEEDBACK (cod_feedback, cod_articol, cod_utilizator, tip_feedback, nota)
VALUES (999, 13, 2, 'Dislike', 1);

INSERT INTO ISTORIC_CITIRE VALUES (4, 10, SYSDATE - 2);
INSERT INTO ISTORIC_CITIRE VALUES (4, 12, SYSDATE - 1);
INSERT INTO ISTORIC_CITIRE VALUES (5, 11, SYSDATE - 4);
INSERT INTO ISTORIC_CITIRE VALUES (5, 15, SYSDATE - 3);
INSERT INTO ISTORIC_CITIRE VALUES (13, 10, SYSDATE - 0.5);
INSERT INTO ISTORIC_CITIRE VALUES (13, 13, SYSDATE - 0.2);
INSERT INTO ISTORIC_CITIRE VALUES (14, 14, SYSDATE - 5);
INSERT INTO ISTORIC_CITIRE VALUES (14, 11, SYSDATE - 5);
INSERT INTO ISTORIC_CITIRE VALUES (15, 12, SYSDATE - 7);
INSERT INTO ISTORIC_CITIRE VALUES (15, 15, SYSDATE - 6);
COMMIT;

-- CERINTA 6

-- analiza_activitate_autor:
-- 1: varray (dim fixa) - lista de categorii prioritate pt un autor
-- 2: nested table (dinamic) - lista de titluri a autorului
-- 3: associative array - in functie de numarul de surse, se va acorda un calificativ articolelor (titlu_articol: calificativ)
CREATE OR REPLACE PROCEDURE analiza_activitate_autor(p_id_autor in NUMBER) IS

    TYPE t_categorii_target IS VARRAY(3) OF VARCHAR(50);
    v_categorii t_categorii_target := t_categorii_target('Tehnologie', 'Stiinta', 'Politic');

    TYPE t_lista_titluri IS TABLE OF VARCHAR2(150);
    v_articole_autor t_lista_titluri := t_lista_titluri();

    TYPE t_map_status IS TABLE OF VARCHAR2(50) INDEX BY VARCHAR2(150);
    v_status_articol t_map_status;

    v_nr_surse NUMBER;
    v_titlu_curent VARCHAR2(150);
    v_idx VARCHAR2(150);
    v_nume_autor VARCHAR2(100);
    v_check_autor NUMBER;
BEGIN
    SELECT COUNT(*) INTO v_check_autor FROM autori WHERE cod_utilizator = p_id_autor;

    IF v_check_autor = 0 THEN
        DBMS_OUTPUT.PUT_LINE('Nu exista autorul selectat.');
        RETURN;
    end if;

    SELECT nume || ' ' || prenume INTO v_nume_autor
    FROM UTILIZATORI WHERE cod_utilizator = p_id_autor;

    DBMS_OUTPUT.PUT_LINE('Raport analiza pentru: ' || v_nume_autor);
    DBMS_OUTPUT.PUT_LINE('1. Categorii Prioritare');
    FOR i in 1..v_categorii.COUNT LOOP
        DBMS_OUTPUT.PUT_LINE('Target #' || i || ': ' || v_categorii(i));
        end loop;

    SELECT a.titlu
    BULK COLLECT INTO v_articole_autor
    FROM ARTICOLE a
    JOIN SCRIE s on a.cod_articol = s.cod_articol
    WHERE s.cod_utilizator = p_id_autor;

    DBMS_OUTPUT.PUT_LINE('2. Articole Scrise');
    IF v_articole_autor.COUNT = 0 THEN
        DBMS_OUTPUT.PUT_LINE('Autorul nu a scris niciun articol.');
    ELSE
        FOR i in v_articole_autor.FIRST .. v_articole_autor.LAST LOOP
            v_titlu_curent := v_articole_autor(i);
            DBMS_OUTPUT.PUT_LINE('   Articol #' || i || ': ' || v_titlu_curent);
            SELECT COUNT(*) INTO v_nr_surse
            FROM "INCLUDE" i
            JOIN ARTICOLE a on i.cod_articol = a.cod_articol
            WHERE a.titlu = v_titlu_curent;

            IF v_nr_surse >= 2 THEN
                v_status_articol(v_titlu_curent) := 'Bine documentat' || v_nr_surse || 'surse';
                ELSE
                v_status_articol(v_titlu_curent) := 'Slab documentat';

            end if;
            end loop;
        DBMS_OUTPUT.PUT_LINE('3. Evaluare Credibilitate');
        v_idx := v_status_articol.FIRST;
        WHILE v_idx IS NOT NULL LOOP
            DBMS_OUTPUT.PUT_LINE('Titlu: '|| v_idx || '->Status: ' || v_status_articol(v_idx) );
            v_idx := v_status_articol.NEXT(v_idx);
            end loop;
    end if;

    EXCEPTION
    WHEN NO_DATA_FOUND THEN DBMS_OUTPUT.PUT_LINE('Nu exista articole scrise de autorul selectat.');
    WHEN OTHERS THEN DBMS_OUTPUT.PUT_LINE('Eroare: ' || SQLERRM);
end;
/
BEGIN
    DBMS_OUTPUT.ENABLE();
    analiza_activitate_autor(2);
    analiza_activitate_autor(4);
end;

select nume, prenume, a.cod_utilizator from utilizatori u
join CITITORI a on u.cod_utilizator = a.cod_utilizator;

-- CERINTA 7
-- raport_categorii_articole
-- cursor clasic: toate categoriile
-- cursor parametrizat: articolele care apartin unei categorii
CREATE OR REPLACE PROCEDURE raport_categorii_articole IS
    CURSOR c_categorii IS
        SELECT cod_categorie, nume
        FROM CATEGORIE
        ORDER BY NUME;
    CURSOR c_articole_cat (p_id_cat NUMBER) is
        SELECT titlu, data_aparitie, limba
        FROM articole
        WHERE cod_categorie = p_id_cat
        ORDER BY data_aparitie DESC;
    v_cod_cat CATEGORIE.cod_categorie%TYPE;
    v_nume_cat CATEGORIE.nume%TYPE;
    v_titlu ARTICOLE.titlu%TYPE;
    v_data ARTICOLE.data_aparitie%TYPE;
    v_limba ARTICOLE.limba%TYPE;
BEGIN
    OPEN c_categorii;
    LOOP
        FETCH c_categorii INTO v_cod_cat, v_nume_cat;
        EXIT WHEN c_categorii%NOTFOUND;

        DBMS_OUTPUT.PUT_LINE('Categoria: ' || v_nume_cat);

        OPEN c_articole_cat(v_cod_cat);
        LOOP
            FETCH c_articole_cat INTO v_titlu, v_data, v_limba;
            EXIT WHEN c_articole_cat%NOTFOUND;

            DBMS_OUTPUT.PUT_LINE('Articol: ' || v_titlu || ' Data: ' || TO_CHAR(v_data, 'DD-MM-YYYY')
                                     || ' Limba: ' || v_limba);
        end loop;
        IF c_articole_cat%ROWCOUNT = 0 THEN
            DBMS_OUTPUT.PUT_LINE('Aceasta categorie nu are articole');
        end if;
        CLOSE c_articole_cat;
    end loop;
    CLOSE c_categorii;
    EXCEPTION
    WHEN OTHERS THEN DBMS_OUTPUT.PUT_LINE('Eroare: ' || SQLERRM);
    IF c_categorii%ISOPEN THEN CLOSE c_categorii; END IF;
    IF c_articole_cat%ISOPEN THEN CLOSE c_articole_cat; END IF;
end;
/
BEGIN
    DBMS_OUTPUT.ENABLE();
    raport_categorii_articole;
end;
/
-- CERINTA 8
-- get_email_autor_articol
-- articolul este gasit si are un singur autor => returneaza mailul
-- articolul nu exista / nu are autor => NO_DATA_FOUND
-- articolul are mai mult de un autor => TOO_MANY_ROWS
CREATE OR REPLACE FUNCTION get_email_autor_articol(p_titlu_articol iN VARCHAR2)
RETURN VARCHAR2 IS
    v_email_autor UTILIZATORI.email%TYPE;
BEGIN
    SELECT u.email
    INTO v_email_autor
    FROM UTILIZATORI u
    JOIN SCRIE S  ON u.cod_utilizator = s.cod_utilizator
    JOIN ARTICOLE a ON s.cod_articol = a.cod_articol
    WHERE a.titlu = p_titlu_articol;

    RETURN 'Email-ul autorului este ' || v_email_autor;

EXCEPTION
    WHEN NO_DATA_FOUND THEN
        RETURN 'Nu exista niciun articol cu titlul ' || p_titlu_articol || ' sau nu are autor asignat';
    WHEN TOO_MANY_ROWS THEN
        RETURN 'Articolul are mai multi autori';
    WHEN OTHERS THEN RETURN 'Eroare: ' || SQLERRM;
end;

-- caz 1: functionare normala
SELECT get_email_autor_articol('Rezultate Sondaje') as Rezultat from DUAL;
-- caz 2: exceptia TOO_MANY_ROWS
SELECT get_email_autor_articol('Noi imagini de pe Marte') as Rezultat from DUAL;
-- caz 3: exceptia NO_DATA_FOUND
SELECT get_email_autor_articol('Cea mai inalta cladire din lume') as Rezultat from DUAL;

-- CERINTA 9
-- verifica_reputatie_autor
-- calculeaza media notelor obtinute de feedback de autor intr o categorie anume
-- EXC1: nu are niciun articol cu feedback in categoria respectiva
-- EXC2: autorul are reputatie slaba, media notelor sub 3
CREATE OR REPLACE PROCEDURE verifica_reputatie_autor(p_nume in VARCHAR2, p_categorie in VARCHAR2) IS
    v_medie_note NUMBER;
    v_nr_feedbackuri NUMBER;

    exc_autor_fara_activitate EXCEPTION;
    exc_reputatie_slaba EXCEPTION;
BEGIN
        SELECT AVG(f.nota), COUNT(f.cod_feedback)
        INTO v_medie_note, v_nr_feedbackuri
        FROM UTILIZATORI u
        JOIN AUTORI aut ON u.cod_utilizator = aut.cod_utilizator
        JOIN SCRIE s ON u.cod_utilizator = s.cod_utilizator
        JOIN ARTICOLE a ON s.cod_articol = a.cod_articol
        JOIN CATEGORIE c ON a.cod_categorie = c.cod_categorie
        JOIN FEEDBACK f ON a.cod_articol = f.cod_articol
        WHERE UPPER(u.nume) = UPPER(p_nume) AND UPPER(c.nume) = UPPER(p_categorie);

        IF v_medie_note IS NULL OR v_nr_feedbackuri = 0 THEN
            RAISE exc_autor_fara_activitate;
        end if;

        IF v_medie_note < 3 THEN
            RAISE exc_reputatie_slaba;
        end if;

        DBMS_OUTPUT.PUT_LINE('Raport Reputatie ' || p_nume);
        DBMS_OUTPUT.PUT_Line('Categorie: ' || p_categorie);
        DBMS_OUTPUT.PUT_LINE('Media notelor este ' || ROUND(v_medie_note, 2) || '(bazat pe ' || v_nr_feedbackuri || ' feedbackuri)');

EXCEPTION
    WHEN exc_autor_fara_activitate THEN
        DBMS_OUTPUT.PUT_LINE('Autorul nu a scris niciun articol in categoria ' || p_categorie);
    WHEN exc_reputatie_slaba THEN
        DBMS_OUTPUT.PUT_LINE('Autorul are o medie slaba (' || ROUND(v_medie_note, 2) || ') in categoria ' || p_categorie);

    WHEN OTHERS THEN DBMS_OUTPUT.PUT_LINE('Eroare: ' || SQLERRM);
end;

-- caz 1 functionare normala
BEGIN
    DBMS_OUTPUT.ENABLE();
    verifica_reputatie_autor('Ionescu', 'Tehnologie');
end;

-- caz 2 exceptie fara activitate
BEGIN
    DBMS_OUTPUT.ENABLE();
    verifica_reputatie_autor('Ionescu', 'Sport');
end;

-- caz 3 exceptie reputatie slaba
BEGIN
    DBMS_OUTPUT.ENABLE();
    verifica_reputatie_autor('Vasilescu', 'Sport');
end;

-- Cerinta 10

-- tabel log

CREATE TABLE ARTICOLE_LOG (
       user_oracle VARCHAR2(20),
       operatie VARCHAR2(20),
       data_ora DATE DEFAULT SYSDATE
);

CREATE OR REPLACE TRIGGER trg_audit_articole
    AFTER INSERT OR UPDATE OR DELETE ON ARTICOLE
DECLARE
    v_tip_op VARCHAR2(20);
BEGIN
    IF INSERTING THEN
        v_tip_op := 'Inserare';
    ELSIF UPDATING THEN
        v_tip_op := 'Actualizare';
    ELSIF DELETING THEN
        v_tip_op := 'Stergere';
    END IF;
    INSERT INTO ARTICOLE_LOG (user_oracle, operatie) VALUES (USER, v_tip_op);
end;
/
BEGIN DBMS_OUTPUT.ENABLE(); END;
/
UPDATE ARTICOLE
SET data_aparitie = SYSDATE
WHERE cod_categorie = 1;

SELECT * FROM ARTICOLE_LOG;

ROLLBACK;

-- trg_validare_complexa_feedback
-- un utilizator nu poate lasa un feedback daca nu a citit articolul
-- un utilizator nu isi poate da feedback la propriul articol
-- CERINTA 11
CREATE OR REPLACE TRIGGER trg_validare_complexa_feedback
    BEFORE INSERT ON FEEDBACK
    FOR EACH ROW
DECLARE
    v_data_citire DATE;
    v_este_autor NUMBER;
BEGIN
    -- verificare autor
    SELECT COUNT(*)
    INTO v_este_autor
    FROM SCRIE
    WHERE cod_utilizator = :NEW.cod_utilizator AND cod_articol = :NEW.cod_articol;

    if v_este_autor > 0 THEN
        RAISE_APPLICATION_ERROR(-20006, 'Conflict de interese: Nu iti poti evalua propriul articol!');
    end if;

    -- verificare istoric
    BEGIN
        SELECT data_citire
        INTO v_data_citire
        FROM ISTORIC_CITIRE
        WHERE cod_utilizator = :NEW.cod_utilizator AND cod_articol = :NEW.cod_articol;

        IF v_data_citire > SYSDATE THEN
            RAISE_APPLICATION_ERROR(-20007, 'Anomalie la data citirii');
        end if;

        EXCEPTION WHEN NO_DATA_FOUND THEN
        RAISE_APPLICATION_ERROR(-20005, 'Nu poti oferi feedback daca nu ai citit articolul');
    end;
end;

-- conflict de interese

INSERT INTO FEEDBACK (cod_feedback, cod_articol, cod_utilizator, tip_feedback, nota)
VALUES (777, 10, 2, 'Like', 5);

-- nu exista in istoric_citire

INSERT INTO FEEDBACK(cod_feedback, cod_articol, cod_utilizator, tip_feedback, nota)
VALUES (888, 10, 12, 'Like', 5);

-- succes

INSERT INTO FEEDBACK(cod_feedback, cod_articol, cod_utilizator, tip_feedback, nota)
VALUES (778, 10, 4, 'Rating', 1);

ROLLBACK;


-- CERINTA 12

CREATE TABLE LOG_DDL(
    utilizator_bd VARCHAR2(30),
    tip_operatie VARCHAR(20),
    tip_obiect VARCHAR2(30),
    nume_obiect VARCHAR2(50),
    data_ora DATE DEFAULT SYSDATE
);

CREATE OR REPLACE TRIGGER trg_log_ddl
AFTER CREATE OR ALTER OR DROP ON SCHEMA
BEGIN
    INSERT INTO LOG_DDL (
        utilizator_bd,
        tip_operatie,
        tip_obiect,
        nume_obiect,
        data_ora
    )
    VALUES (
        SYS_CONTEXT('USERENV', 'SESSION_USER'),
        SYS.SYSEVENT,
        SYS.DICTIONARY_OBJ_TYPE(),
        SYS.DICTIONARY_OBJ_NAME(),
        SYSDATE

    );
end;
/

CREATE TABLE TEST_DDL (
    id number
);
alter trigger trg_log_ddl enable;

alter table test_ddl add coloana1 varchar2(50);
alter table test_ddl add coloana2 varchar2(50);
select * from LOG_DDL
ORDER BY data_ora DESC;

-- CERINTA 13
-- un record pentru informatii despre articole
-- o colectie de articole
-- o functie care calculeaza popularitatea totala a unui eveniment pe baza tagurilor articolelor asociate
-- o functie care determina daca un articol este premium
-- o procedura care afiseaza toate articolele asociate unui eveniment
-- o procedura care afiseaza toate articolele disponibile unui utilizator, in functie de abonament

CREATE OR REPLACE PACKAGE pkg_analiza_editoriala IS
    TYPE t_articol is RECORD (
        titlu       VARCHAR2(150),
        categorie   VARCHAR2(50),
        limba       VARCHAR2(20)
    );

    TYPE t_lista_articole IS TABLE OF t_articol;

    FUNCTION popularitate_eveniment(p_cod_eveniment NUMBER)
        RETURN NUMBER;

    FUNCTION este_articol_premium(p_cod_articol NUMBER)
        RETURN VARCHAR2;

    PROCEDURE afiseaza_articole_eveniment(p_cod_eveniment NUMBER);
    PROCEDURE articole_disponibile_utilizator(p_cod_utilizator NUMBER);
END pkg_analiza_editoriala;
/

CREATE OR REPLACE PACKAGE BODY pkg_analiza_editoriala IS
    -- popularitate
    FUNCTION popularitate_eveniment(p_cod_eveniment NUMBER)
        RETURN NUMBER IS v_popularitate NUMBER;
    BEGIN
        SELECT NVL(SUM(t.popularitate), 0)
        INTO v_popularitate
        FROM ASOCIAT_LA al
        JOIN ARTICOL_ARE_TAG atg ON al.cod_articol = atg.cod_articol
        JOIN TAG t ON atg.cod_tag = t.cod_tag
        WHERE al.cod_eveniment = p_cod_eveniment;

        RETURN v_popularitate;
    end;
    -- articol premium
    FUNCTION este_articol_premium(p_cod_articol NUMBER)
        RETURN VARCHAR2 IS v_nr_surse NUMBER;
    BEGIN
        SELECT COUNT(*)
        INTO v_nr_surse
        FROM "INCLUDE" i
        WHERE i.cod_articol = p_cod_articol;

        IF v_nr_surse >=2 THEN
            RETURN 'PREMIUM';
        ELSE
            RETURN 'STANDARD';
        end if;
    end;

    -- articolele unui eveniment
    PROCEDURE afiseaza_articole_eveniment(p_cod_eveniment NUMBER) IS
        v_articole t_lista_articole;
    BEGIN
        SELECT a.titlu, c.nume, a.limba
        BULK COLLECT INTO v_articole
        FROM ASOCIAT_LA al
        JOIN ARTICOLE a ON al.cod_articol = a.cod_articol
        JOIN CATEGORIE c ON a.cod_categorie = c.cod_categorie
        WHERE al.cod_eveniment = p_cod_eveniment;

        DBMS_OUTPUT.PUT_LINE('Articolele evenimentului ' || p_cod_eveniment);
        FOR i in 1..v_articole.COUNT LOOP
            DBMS_OUTPUT.PUT_LINE('Titlu: ' || v_articole(i).titlu || ' Categorie: '
                                     || v_articole(i).categorie || ' Limba: ' || v_articole(i).limba);
            end loop;
    end;

    -- articole accesibile utilizatorului
    PROCEDURE articole_disponibile_utilizator(p_cod_utilizator NUMBER) IS
        v_tip_abonament ABONAMENTE.tip_abonament%type;
    BEGIN
        SELECT ab.tip_abonament
        INTO v_tip_abonament
        FROM utilizatori u
        JOIN ABONAMENTE ab ON u.cod_abonament = ab.cod_abonament
        WHERE u.cod_utilizator = p_cod_utilizator;

        DBMS_OUTPUT.PUT_LINE('Articolele disponibile pentru abonament ' || v_tip_abonament);
        FOR rec IN (
            SELECT a.cod_articol, a.titlu
            FROM ARTICOLE a
            ) LOOP
                IF v_tip_abonament IN ('GOLD', 'CORPORATE', 'SILVER', 'STUDENT') THEN
                    DBMS_OUTPUT.PUT_LINE('- ' || rec.titlu);
                ELSE
                    IF este_articol_premium(rec.cod_articol) = 'STANDARD' THEN
                        DBMS_OUTPUT.PUT_LINE('- ' || rec.titlu);
                    end if;
                end if;
            end loop;
    end;

END pkg_analiza_editoriala;
/


BEGIN
    DBMS_OUTPUT.ENABLE();
    DBMS_OUTPUT.PUT_LINE(
     'Popularitate eveniment 500: ' || pkg_analiza_editoriala.popularitate_eveniment(500)
    );

    pkg_analiza_editoriala.afiseaza_articole_eveniment(500);
    -- articole free
    pkg_analiza_editoriala.articole_disponibile_utilizator(4);
    -- articole premium
    pkg_analiza_editoriala.articole_disponibile_utilizator(9);

end;
/


