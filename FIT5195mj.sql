DROP TABLE topic;

DROP TABLE program;

DROP TABLE event;

DROP TABLE media_channel;

DROP TABLE event_marketing;

DROP TABLE person;

DROP TABLE address;

DROP TABLE volunteer;

DROP TABLE participant;

DROP TABLE follow_up;

DROP TABLE person_interest;

DROP TABLE subscription;

DROP TABLE attendance;

DROP TABLE registration;

CREATE TABLE topic
    AS
        SELECT
            *
        FROM
            monexplore.topic;

CREATE TABLE program
    AS
        SELECT
            *
        FROM
            monexplore.program;

CREATE TABLE event
    AS
        SELECT
            *
        FROM
            monexplore.event;

CREATE TABLE media_channel
    AS
        SELECT
            *
        FROM
            monexplore.media_channel;

CREATE TABLE event_marketing
    AS
        SELECT
            *
        FROM
            monexplore.event_marketing;

CREATE TABLE person
    AS
        SELECT
            *
        FROM
            monexplore.person;

CREATE TABLE address
    AS
        SELECT
            *
        FROM
            monexplore.address;

CREATE TABLE volunteer
    AS
        SELECT
            *
        FROM
            monexplore.volunteer;

CREATE TABLE participant
    AS
        SELECT
            *
        FROM
            monexplore.participant;

CREATE TABLE follow_up
    AS
        SELECT
            *
        FROM
            monexplore.follow_up;

CREATE TABLE subscription
    AS
        SELECT
            *
        FROM
            monexplore.subscription;

CREATE TABLE person_interest
    AS
        SELECT
            *
        FROM
            monexplore.person_interest;

CREATE TABLE attendance
    AS
        SELECT
            *
        FROM
            monexplore.attendance;

CREATE TABLE registration
    AS
        SELECT
            *
        FROM
            monexplore.registration;
--Select * from TABLE
SELECT
    *
FROM
    topic;

SELECT
    *
FROM
    program;

SELECT
    *
FROM
    event;

SELECT
    *
FROM
    media_channel;

SELECT
    *
FROM
    event_marketing;

SELECT
    *
FROM
    person;

SELECT
    *
FROM
    address;

SELECT
    *
FROM
    volunteer;

SELECT
    *
FROM
    participant;

SELECT
    *
FROM
    follow_up;

SELECT
    *
FROM
    person_interest;

SELECT
    *
FROM
    subscription;

SELECT
    *
FROM
    attendance;

SELECT
    *
FROM
    registration;

--Duplication Problems

-- check all tables;
SELECT
    person_id,
    COUNT(*)
FROM
    person
GROUP BY
    person_id
HAVING
    COUNT(*) > 1;

SELECT
    subscription_id,
    COUNT(*)
FROM
    subscription
GROUP BY
    subscription_id
HAVING
    COUNT(*) > 1;

-- check the duplication attributes;
SELECT
    *
FROM
    person
WHERE
    person_id = 'PE057'
    OR person_id = 'PE078'
    OR person_id = 'PE021';

SELECT
    *
FROM
    subscription
WHERE
    subscription_id = 'SU021'
    OR subscription_id = 'SU243';

-- fix the duplication problem;
DROP TABLE person;

CREATE TABLE person
    AS
        SELECT DISTINCT
            *
        FROM
            monexplore.person;

DROP TABLE subscription;

CREATE TABLE subscription
    AS
        SELECT DISTINCT
            *
        FROM
            monexplore.subscription;
            
    

--Relationship problems

-- check all tables;

SELECT
    *
FROM
    volunteer
WHERE
    person_id NOT IN (
        SELECT
            person_id
        FROM
            person
    );

SELECT
    *
FROM
    event
WHERE
    program_id NOT IN (
        SELECT
            program_id
        FROM
            program
    ); 

-- check the attributes;
SELECT
    *
FROM
    event
WHERE
    program_id = 'PR000'
    OR program_id = 'PR020';

SELECT
    *
FROM
    volunteer
WHERE
    person_id = 'PE000'
    OR person_id = 'PE110';

SELECT
    *
FROM
    follow_up
WHERE
    person_id = 'PE000'
OR person_id = 'PE110';

SELECT
    *
FROM
    follow_up
WHERE
    person_id2 = 'PE000'
OR person_id2 = 'PE110';

-- fix the relationship problems;
DELETE FROM event
WHERE
    program_id = 'PR000'
    OR program_id = 'PR020';

DELETE FROM volunteer
WHERE
    person_id = 'PE000'
    OR person_id = 'PE110';
    

--Inconsistent Problem
--Identify
--1.event_size < 0
SELECT
    *
FROM
    event
WHERE
    event_size < 0;
--2.event_start_date > event_end_date
SELECT
    *
FROM
    event
WHERE
    to_date(event_start_date, 'DD-MON-YY') > to_date(event_end_date, 'DD-MON-YY');
--SELECT * FROM EVENT WHERE event_start_date > event_end_date;
--3.vol_start_date > vol_end_date
SELECT
    *
FROM
    volunteer
WHERE
    vol_start_date > vol_end_date;
--4.att_donation_amount < 0
SELECT
    *
FROM
    attendance
WHERE
    att_donation_amount < 0;
--check and fix the inconsistent problem
--1.event_size < 0
--Check whether an event with a negative event_size exists in the REGISTRATION table
SELECT
    *
FROM
    registration
WHERE
    event_id = 11
    OR event_id = 47;
--Because events which id is 11 and 47 exist in the REGISTRATION table, change the negative number to a positive number
UPDATE event
SET
    event_size = 10
WHERE
    event_id = 11;

UPDATE event
SET
    event_size = 75
WHERE
    event_id = 47;

SELECT
    *
FROM
    event
WHERE
    event_id = 11
    OR event_id = 47;
--2.event_start_date > event_end_date
--Check whether an event with unreasonable start and end dates exists in the REGISTRATION table
SELECT
    *
FROM
    registration
WHERE
    event_id = 162
    OR event_id = 163;
--Because events which id is 162 and 163 exist in the REGISTRATION table, so switch the start date and end date
UPDATE event
SET
    event_start_date = event_end_date,
    event_end_date = event_start_date
WHERE
    event_id = 162
    OR event_id = 163;

SELECT
    *
FROM
    event
WHERE
    event_id = 162
    OR event_id = 163;
--3.vol_start_date > vol_end_date
--delete 
DELETE FROM volunteer
WHERE
    person_id = 'PE110';
--4.att_donation_amount < 0
--Check whether people with an abnormal number of donations exist in the REGISTRATION table
SELECT
    *
FROM
    registration
WHERE
        person_id = 'PE006'
    AND event_id = 159;

SELECT
    *
FROM
    registration
WHERE
        person_id = 'PE031'
    AND event_id = 72;
--Since these people(id = 'PE006' and id = 'PE031') exist in the REGISTRATION table, change the negative number to a positive number
UPDATE attendance
SET
    att_donation_amount = 25
WHERE
    att_id = 639;

UPDATE attendance
SET
    att_donation_amount = 5
WHERE
    att_id = 1001;

--Null Problems
--Identify
--1.topic_description
SELECT
    *
FROM
    topic
WHERE
    topic_description IS NULL;
--2.media_id
SELECT
    *
FROM
    media_channel
WHERE
    media_id IS NULL;
--check and fix the inconsistent problem
--1.topic_description
--Check whether the topic of the topic_description exists in the program table and person_interest table
SELECT
    *
FROM
    program
WHERE
    topic_id = 'T010';

SELECT
    *
FROM
    person_interest
WHERE
    topic_id = 'T010';
--This topic (TOPIC_ID = T010) does not have any programs but someone is interested in it, so after modifying the description information of this topic (TOPIC_ID = T010)
UPDATE topic
SET
    topic_description = 'no description'
WHERE
    topic_id = 'T010';
--2.media_id
--Delete this row because the primary key is empty
DELETE FROM media_channel
WHERE
    media_id IS NULL;
--End for data clean

--SCD
--registration table
SELECT
    person_id,
    event_id,
    COUNT(*)
FROM
    registration
GROUP BY
    person_id,
    event_id
HAVING
    COUNT(*) > 1;

SELECT
    *
FROM
    registration
WHERE
        person_id = 'PE065'
    AND event_id = 75;
    
--att table
SELECT
    event_id,
    person_id,
    att_date,
    COUNT(*)
FROM
    attendance
GROUP BY
    event_id,
    person_id,
    att_date
HAVING
    COUNT(*) > 1;

SELECT
    *
FROM
    attendance
WHERE
        event_id = 118
    AND person_id = 'PE053'
    AND att_date = to_date('03-MAR-20');

--
--Start of create version 1
--create dim1 table
DROP TABLE topic_dim1;

DROP TABLE location_dim1;

DROP TABLE program_length_dim1;

DROP TABLE event_size_dim1;

DROP TABLE age_group_dim1;

DROP TABLE marital_dim1;

DROP TABLE occupation_dim1;

DROP TABLE program_dim1_temp;

DROP TABLE program_dim1;

DROP TABLE event_dim1_temp;

DROP TABLE event_dim1;

DROP TABLE time_dim1_temp;

DROP TABLE time_dim1;

DROP TABLE media_dim1;

--topic_dim1
CREATE TABLE topic_dim1
    AS
        SELECT
            *
        FROM
            topic;
--location dim1
CREATE TABLE location_dim1
    AS
        SELECT
            *
        FROM
            address;
--program_length_dim1
CREATE TABLE program_length_dim1 (
    programlength_id  NUMBER(1),
    description       VARCHAR2(50)
);

INSERT INTO program_length_dim1 VALUES (
    1,
    'short : less than three sessions'
);

INSERT INTO program_length_dim1 VALUES (
    2,
    'medium : between three to six sessions'
);

INSERT INTO program_length_dim1 VALUES (
    3,
    'long : greater than six sessions'
);
--event_size_dim1
CREATE TABLE event_size_dim1 (
    eventsize_id  NUMBER(1),
    description   VARCHAR2(50)
);

INSERT INTO event_size_dim1 VALUES (
    1,
    'small: event <= 10 people'
);

INSERT INTO event_size_dim1 VALUES (
    2,
    'medium :event between 11 and 30 people'
);

INSERT INTO event_size_dim1 VALUES (
    3,
    'large : event > 30 people'
);
--age_group_dim1
CREATE TABLE age_group_dim1 (
    agegroup_id  NUMBER(1),
    description  VARCHAR2(50)
);

INSERT INTO age_group_dim1 VALUES (
    1,
    'Child: 0-16 years old'
);

INSERT INTO age_group_dim1 VALUES (
    2,
    'Young adults: 17-30 years old'
);

INSERT INTO age_group_dim1 VALUES (
    3,
    'Middle-aged adults: 31-45 years old'
);

INSERT INTO age_group_dim1 VALUES (
    4,
    'Old-aged adults: Over 45 years old'
);
--marital_dim1
CREATE TABLE marital_dim1 (
    marital_id   NUMBER(1),
    description  VARCHAR2(50)
);

INSERT INTO marital_dim1 VALUES (
    1,
    'Married'
);

INSERT INTO marital_dim1 VALUES (
    2,
    'Unmarried'
);

INSERT INTO marital_dim1 VALUES (
    3,
    'Divorced'
);
--occupation_dim1
CREATE TABLE occupation_dim1 (
    occpation_id  NUMBER(1),
    description   VARCHAR2(50)
);

INSERT INTO occupation_dim1 VALUES (
    1,
    'Student'
);

INSERT INTO occupation_dim1 VALUES (
    2,
    'Staff'
);

INSERT INTO occupation_dim1 VALUES (
    3,
    'Community'
);

--program_dim1
CREATE TABLE program_dim1_temp
    AS
        ( SELECT
            *
        FROM
            program
        );

ALTER TABLE program_dim1_temp ADD (
    programlength_id NUMBER(1)
);

UPDATE program_dim1_temp
SET
    programlength_id = 1
WHERE
    program_length = '1 session'
    OR program_length = '2 sessions';

UPDATE program_dim1_temp
SET
    programlength_id = 2
WHERE
    program_length = '3 sessions'
    OR program_length = '4 sessions'
    OR program_length = '5 sessions'
    OR program_length = '6 sessions';

UPDATE program_dim1_temp
SET
    programlength_id = 3
WHERE
    programlength_id IS NULL;

CREATE TABLE program_dim1
    AS
        ( SELECT
            program_id,
            program_name,
            program_details,
            program_fee,
            programlength_id,
            program_frequency
        FROM
            program_dim1_temp
        );
--event_dim1
CREATE TABLE event_dim1_temp
    AS
        ( SELECT
            *
        FROM
            event
        );

ALTER TABLE event_dim1_temp ADD (
    eventsize_id NUMBER(1)
);

UPDATE event_dim1_temp
SET
    eventsize_id = 1
WHERE
    event_size <= '10';

UPDATE event_dim1_temp
SET
    eventsize_id = 2
WHERE
        event_size <= '30'
    AND event_size > 10;

UPDATE event_dim1_temp
SET
    eventsize_id = 3
WHERE
    event_size > 30;

CREATE TABLE event_dim1
    AS
        ( SELECT
            event_id,
            event_start_date,
            event_end_date,
            eventsize_id,
            event_location,
            event_cost,
            program_id
        FROM
            event_dim1_temp
        );
        
--time_dim1
CREATE TABLE time_dim1_temp
    AS
        ( SELECT
            reg_date AS tt
        FROM
            registration
        UNION
        SELECT
            att_date AS tt
        FROM
            attendance
        UNION
        SELECT
            subscription_date AS tt
        FROM
            subscription
        );

CREATE TABLE time_dim1
    AS
        SELECT DISTINCT
            to_char(tt, 'mmyyyy')      AS time_id,
            to_char(tt, 'mm')          AS month,
            to_char(tt, 'yyyy')        AS year
        FROM
            time_dim1_temp;
--media_dim1

CREATE TABLE media_dim1
    AS
        SELECT
            *
        FROM
            media_channel;
        
--create fact1 table
DROP TABLE att_fact1_temp;

DROP TABLE att_fact1;

DROP TABLE sub_fact1_temp;

DROP TABLE sub_fact1;

DROP TABLE reg_fact1_temp;

DROP TABLE reg_fact1;

DROP TABLE interested_fact1_temp;

DROP TABLE interested_fact1;

--att fact 

CREATE TABLE att_fact1_temp
    AS
        ( SELECT
            a.event_id,
            to_char(a.att_date, 'mmyyyy') AS time_id,
            b.person_job,
            b.person_age,
            b.person_marital_status,
            b.address_id,
            a.att_num_of_people_attended,
            a.att_donation_amount
        FROM
            (
                SELECT
                    *
                FROM
                    (
                        SELECT
                            event_id,
                            person_id,
                            att_date,
                            att_num_of_people_attended,
                            att_donation_amount,
                            RANK()
                            OVER(PARTITION BY event_id, person_id,
                                              att_date
                                 ORDER BY att_id DESC
                            ) AS rank
                        FROM
                            attendance
                        ORDER BY
                            event_id,
                            person_id,
                            att_date
                    ) s
                WHERE
                    s.rank = '1'
            )       a
            LEFT JOIN person  b ON a.person_id = b.person_id
        );

ALTER TABLE att_fact1_temp ADD (
    occpation_id NUMBER(1)
);

UPDATE att_fact1_temp
SET
    occpation_id = 1
WHERE
    person_job = 'Student';

UPDATE att_fact1_temp
SET
    occpation_id = 2
WHERE
    person_job = 'Staff';

UPDATE att_fact1_temp
SET
    occpation_id = 3
WHERE
    occpation_id IS NULL;

ALTER TABLE att_fact1_temp ADD (
    agegroup_id NUMBER(1)
);

UPDATE att_fact1_temp
SET
    agegroup_id = 1
WHERE
    person_age <= '16';

UPDATE att_fact1_temp
SET
    agegroup_id = 2
WHERE
        person_age <= '30'
    AND person_age >= '17';

UPDATE att_fact1_temp
SET
    agegroup_id = 3
WHERE
        person_age <= '45'
    AND person_age >= '31';

UPDATE att_fact1_temp
SET
    agegroup_id = 4
WHERE
    person_age >= '46';

ALTER TABLE att_fact1_temp ADD (
    marital_id NUMBER(1)
);

UPDATE att_fact1_temp
SET
    marital_id = 1
WHERE
    person_marital_status = 'Married';

UPDATE att_fact1_temp
SET
    marital_id = 2
WHERE
    person_marital_status = 'Not married';
    
UPDATE att_fact1_temp
SET
    marital_id = 3
WHERE
    person_marital_status = 'Divorced';

CREATE TABLE att_fact1
    AS
        ( SELECT
            event_id,
            time_id,
            occpation_id,
            address_id,
            agegroup_id,
            marital_id,
            SUM(att_num_of_people_attended)     AS att_num_of_people_attended,
            SUM(att_donation_amount)            AS att_donation_amount
        FROM
            att_fact1_temp
        GROUP BY
            event_id,
            time_id,
            occpation_id,
            address_id,
            agegroup_id,
            marital_id
        );

--sub fact 
CREATE TABLE sub_fact1_temp
    AS
        ( SELECT
            program_id,
            person_job,
            person_age,
            person_marital_status,
            address_id,
            to_char(subscription_date, 'mmyyyy') AS time_id
        FROM
            subscription  s
            LEFT JOIN person        p ON s.person_id = p.person_id
        );

ALTER TABLE sub_fact1_temp ADD (
    occpation_id NUMBER(1)
);

UPDATE sub_fact1_temp
SET
    occpation_id = 1
WHERE
    person_job = 'Student';

UPDATE sub_fact1_temp
SET
    occpation_id = 2
WHERE
    person_job = 'Staff';

UPDATE sub_fact1_temp
SET
    occpation_id = 3
WHERE
    occpation_id IS NULL;

ALTER TABLE sub_fact1_temp ADD (
    agegroup_id NUMBER(1)
);

UPDATE sub_fact1_temp
SET
    agegroup_id = 1
WHERE
    person_age <= '16';

UPDATE sub_fact1_temp
SET
    agegroup_id = 2
WHERE
        person_age <= '30'
    AND person_age >= '17';

UPDATE sub_fact1_temp
SET
    agegroup_id = 3
WHERE
        person_age <= '45'
    AND person_age >= '31';

UPDATE sub_fact1_temp
SET
    agegroup_id = 4
WHERE
    person_age >= '46';

ALTER TABLE sub_fact1_temp ADD (
    marital_id NUMBER(1)
);

UPDATE sub_fact1_temp
SET
    marital_id = 1
WHERE
    person_marital_status = 'Married';

UPDATE sub_fact1_temp
SET
    marital_id = 2
WHERE
    person_marital_status = 'Not married';
    
UPDATE sub_fact1_temp
SET
    marital_id = 3
WHERE
    person_marital_status = 'Divorced';

CREATE TABLE sub_fact1
    AS
        ( SELECT
            program_id,
            time_id,
            occpation_id,
            address_id,
            agegroup_id,
            marital_id,
            COUNT(*) AS number_of_people_sub
        FROM
            sub_fact1_temp
        GROUP BY
            program_id,
            time_id,
            occpation_id,
            address_id,
            agegroup_id,
            marital_id
        ); 
        

--reg fact 
CREATE TABLE reg_fact1_temp
    AS
        ( SELECT
            a.media_id,
            to_char(a.reg_date, 'mmyyyy') AS time_id,
            b.person_job,
            b.person_age,
            b.person_marital_status,
            b.address_id,
            a.reg_num_of_people_registered
        FROM
            (
                SELECT
                    *
                FROM
                    (
                        SELECT
                            media_id,
                            person_id,
                            reg_date,
                            reg_num_of_people_registered,
                            RANK()
                            OVER(PARTITION BY event_id, person_id,
                                              reg_date
                                 ORDER BY reg_id DESC
                            ) AS rank
                        FROM
                            registration
                        ORDER BY
                            event_id,
                            person_id,
                            reg_date
                    ) s
                WHERE
                    s.rank = '1'
            )       a
            LEFT JOIN person  b ON a.person_id = b.person_id
        );

ALTER TABLE reg_fact1_temp ADD (
    occpation_id NUMBER(1)
);

UPDATE reg_fact1_temp
SET
    occpation_id = 1
WHERE
    person_job = 'Student';

UPDATE reg_fact1_temp
SET
    occpation_id = 2
WHERE
    person_job = 'Staff';

UPDATE reg_fact1_temp
SET
    occpation_id = 3
WHERE
    occpation_id IS NULL;

ALTER TABLE reg_fact1_temp ADD (
    agegroup_id NUMBER(1)
);

UPDATE reg_fact1_temp
SET
    agegroup_id = 1
WHERE
    person_age <= '16';

UPDATE reg_fact1_temp
SET
    agegroup_id = 2
WHERE
        person_age <= '30'
    AND person_age >= '17';

UPDATE reg_fact1_temp
SET
    agegroup_id = 3
WHERE
        person_age <= '45'
    AND person_age >= '31';

UPDATE reg_fact1_temp
SET
    agegroup_id = 4
WHERE
    person_age >= '46';

ALTER TABLE reg_fact1_temp ADD (
    marital_id NUMBER(1)
);

UPDATE reg_fact1_temp
SET
    marital_id = 1
WHERE
    person_marital_status = 'Married';

UPDATE reg_fact1_temp
SET
    marital_id = 2
WHERE
    person_marital_status = 'Not married';
    
UPDATE reg_fact1_temp
SET
    marital_id = 3
WHERE
    person_marital_status = 'Divorced';

SELECT
    *
FROM
    reg_fact1_temp;

CREATE TABLE reg_fact1
    AS
        ( SELECT
            media_id,
            time_id,
            occpation_id,
            address_id,
            agegroup_id,
            marital_id,
            SUM(reg_num_of_people_registered) AS reg_num_of_people_registered
        FROM
            reg_fact1_temp
        GROUP BY
            media_id,
            time_id,
            occpation_id,
            address_id,
            agegroup_id,
            marital_id
        );

--Intersted fact
CREATE TABLE interested_fact1_temp
    AS
        SELECT
            a.topic_id,
            a.person_id,
            p.person_age,
            p.address_id,
            p.person_job,
            p.person_marital_status
        FROM
            person_interest a
            LEFT JOIN person p ON a.person_id = p.person_id;


ALTER TABLE interested_fact1_temp ADD (
    marital_id NUMBER(1),
    agegroup_id NUMBER(1),
    occpation_id NUMBER(1)
);

UPDATE interested_fact1_temp
SET
    marital_id = 1
WHERE
    person_marital_status = 'Married';

UPDATE interested_fact1_temp
SET
    marital_id = 2
WHERE
    person_marital_status = 'Not married';

UPDATE interested_fact1_temp
SET
    marital_id = 3
WHERE
    person_marital_status = 'Divorced';
    
UPDATE interested_fact1_temp
SET
    agegroup_id = 1
WHERE
    person_age <= '16';

UPDATE interested_fact1_temp
SET
    agegroup_id = 2
WHERE
        person_age <= '30'
    AND person_age >= '17';

UPDATE interested_fact1_temp
SET
    agegroup_id = 3
WHERE
        person_age <= '45'
    AND person_age >= '31';

UPDATE interested_fact1_temp
SET
    agegroup_id = 4
WHERE
    person_age >= '46';
    
UPDATE interested_fact1_temp
SET
    occpation_id = 1
WHERE
    person_job = 'Student';

UPDATE interested_fact1_temp
SET
    occpation_id = 2
WHERE
    person_job = 'Staff';

UPDATE interested_fact1_temp
SET
    occpation_id = 3
WHERE
    occpation_id IS NULL;

CREATE TABLE interested_fact1
    AS
        ( SELECT
            topic_id,
            marital_id,
            agegroup_id,
            occpation_id,
            address_id,
            COUNT(*) AS num_of_people_interested
        FROM
            interested_fact1_temp
        GROUP BY
            topic_id,
            marital_id,
            agegroup_id,
            occpation_id,
            address_id
        );
--select all fact1
SELECT
    *
FROM
    intersted_fact1;

SELECT
    *
FROM
    sub_fact1;

SELECT
    *
FROM
    att_fact1;

SELECT
    *
FROM
    reg_fact1;
--end of create version1

--start of create version2
--drop dim table
DROP TABLE event_size_dim2;

DROP TABLE program_length_dim2;

DROP TABLE location_dim2;

DROP TABLE media_dim2;

DROP TABLE topic_dim2;

DROP TABLE event_dim2;

DROP TABLE program_dim2;

DROP TABLE person_dim2_temp;

DROP TABLE person_dim2;

DROP TABLE time_dim2_temp;

DROP TABLE time_dim2;
--event_size_dim2
CREATE TABLE event_size_dim2
    AS
        SELECT
            *
        FROM
            event_size_dim1;
--program_length_dim2
CREATE TABLE program_length_dim2
    AS
        SELECT
            *
        FROM
            program_length_dim1;
--location_dim2
CREATE TABLE location_dim2
    AS
        SELECT
            *
        FROM
            location_dim1;
--media_dim2
CREATE TABLE media_dim2
    AS
        SELECT
            *
        FROM
            media_dim1;
--topic_dim2
CREATE TABLE topic_dim2
    AS
        SELECT
            *
        FROM
            topic_dim1;
--event_dim2
CREATE TABLE event_dim2
    AS
        SELECT
            *
        FROM
            event_dim1;
--program_dim2
CREATE TABLE program_dim2
    AS
        SELECT
            *
        FROM
            program_dim1;

--time dim
CREATE TABLE time_dim2_temp
    AS
        ( SELECT
            reg_date AS tt
        FROM
            registration
        UNION
        SELECT
            att_date AS tt
        FROM
            attendance
        UNION
        SELECT
            subscription_date AS tt
        FROM
            subscription
        );

CREATE TABLE time_dim2
    AS
        SELECT DISTINCT
            to_char(tt, 'ddmmyyyy')      AS time_id,
            to_char(tt, 'dd')            AS day,
            to_char(tt, 'mm')            AS month,
            to_char(tt, 'yyyy')          AS year
        FROM
            time_dim2_temp;

-- person dim

CREATE TABLE person_dim2_temp
    AS
        SELECT
            *
        FROM
            person;

ALTER TABLE person_dim2_temp ADD (
    occpation_type VARCHAR2(50)
);

UPDATE person_dim2_temp
SET
    occpation_type = 'Student'
WHERE
    person_job = 'Student';

UPDATE person_dim2_temp
SET
    occpation_type = 'Staff'
WHERE
    person_job = 'Staff';

UPDATE person_dim2_temp
SET
    occpation_type = 'Community'
WHERE
    occpation_type IS NULL;

ALTER TABLE person_dim2_temp ADD (
    age_type VARCHAR2(50)
);

UPDATE person_dim2_temp
SET
    age_type = 'Child: 0-16 years old'
WHERE
    person_age <= '16';

UPDATE person_dim2_temp
SET
    age_type = 'Young adults: 17-30 years old'
WHERE
        person_age <= '30'
    AND person_age >= '17';

UPDATE person_dim2_temp
SET
    age_type = 'Middle-aged adults: 31-45 years old'
WHERE
        person_age <= '45'
    AND person_age >= '31';

UPDATE person_dim2_temp
SET
    age_type = 'Old-aged adults: Over 45 years old'
WHERE
    person_age >= '46';

CREATE TABLE person_dim2
    AS
        SELECT
    person_id,
    person_name,
    person_phone,
    person_email,
    person_gender,
    person_marital_status,
    address_id,
    age_type, occpation_type FROM person_dim2_temp ;

--create table of fact
--drop version 2 fact table
DROP TABLE att_fact2_temp;

DROP TABLE att_fact2;

DROP TABLE sub_fact2_temp;

DROP TABLE sub_fact2;

DROP TABLE reg_fact2_temp;

DROP TABLE reg_fact2;

DROP TABLE interested_fact2_temp;

DROP TABLE interested_fact2;
-- att fact
    
 CREATE TABLE att_fact2_temp
    AS
        ( SELECT
            event_id,
            to_char(att_date, 'ddmmyyyy') AS time_id,
            person_id,
            att_num_of_people_attended,
            att_donation_amount
        FROM
            (
                SELECT
                    *
                FROM
                    (
                        SELECT
                            event_id,
                            person_id,
                            att_date,
                            att_num_of_people_attended,
                            att_donation_amount,
                            RANK()
                            OVER(PARTITION BY event_id, person_id, att_date
                                 ORDER BY att_id DESC
                            ) AS rank
                        FROM
                            attendance
                        ORDER BY
                            event_id,
                            person_id,
                            att_date
                    )
                WHERE
                    rank = '1'
            )
        );

CREATE TABLE att_fact2
    AS
        ( SELECT
            event_id,
            time_id,
            person_id,
            SUM(att_num_of_people_attended)  AS att_num_of_people_attended,
            SUM(att_donation_amount)         AS att_donation_amount
        FROM
            att_fact2_temp
        GROUP BY
            event_id,
            time_id,
            person_id
        );

-- sub fact 
CREATE TABLE sub_fact2_temp
    AS
        ( SELECT
            program_id,
            person_id,
            to_char(subscription_date, 'ddmmyyyy') AS time_id
        FROM
            subscription
        );

CREATE TABLE sub_fact2
    AS
        ( SELECT
            program_id,
            person_id,
            time_id,
            COUNT(*) AS number_of_people_sub
        FROM
            sub_fact2_temp
        GROUP BY
            program_id,
            person_id,
            time_id
        );
        

-- reg fact
CREATE TABLE reg_fact2_temp
    AS
        ( SELECT
            *
        FROM
            (
                SELECT
                    event_id,
                    person_id,
                    media_id,
                    to_char(reg_date, 'ddmmyyyy')  AS time_id,
                    reg_num_of_people_registered,
                    RANK()
                    OVER(PARTITION BY event_id, person_id, reg_date
                         ORDER BY reg_id DESC
                    )                                  AS rank
                FROM
                    registration
                ORDER BY
                    event_id,
                    person_id,
                    reg_date
            ) s
        WHERE
            s.rank = '1'
        );

CREATE TABLE reg_fact2
    AS
        ( SELECT
            event_id,
            person_id,
            media_id,
            time_id,
            SUM(reg_num_of_people_registered) AS num_of_people_registered
        FROM
            reg_fact2_temp
        GROUP BY
            event_id,
            person_id,
            media_id,
            time_id
        );


-- interesed fact
CREATE TABLE interested_fact2_temp
    AS
        SELECT
            *
        FROM
            person_interest;

CREATE TABLE interested_fact2
    AS
        ( SELECT
            topic_id,
            person_id,
            COUNT(*) AS num_of_people_interested
        FROM
            interested_fact2_temp
        GROUP BY
            topic_id,
            person_id
        );

--select all fact2

SELECT
    *
FROM
    interested_fact2;

SELECT
    *
FROM
    sub_fact2;

SELECT
    *
FROM
    att_fact2;

SELECT
    *
FROM
    reg_fact2;
--end of create version2
--commit
COMMIT;