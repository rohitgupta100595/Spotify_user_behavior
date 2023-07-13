USE spotify_data;

-- Viewing Dataset
SELECT * FROM spotify_data;


-- CLEANING THE DATA

-- Creating Working Table spotify_tm with row_num or row_id
DROP TABLE IF EXISTS spotify_tm;
CREATE TABLE spotify_tm (
	row_num INT NULL,
	Age VARCHAR(20) NULL,
    Gender VARCHAR(50) NULL,
    spotify_usage_period VARCHAR(50) NULL,
    spotify_listening_device VARCHAR(100) NULL,
    spotify_subscription_plan VARCHAR(100) NULL,
    premium_sub_willingness VARCHAR(100) NULL,
    preffered_premium_plan VARCHAR(100) NULL,
    preferred_listening_content VARCHAR(50) NULL,
    fav_music_genre VARCHAR(50) NULL,
    music_time_slot VARCHAR(50) NULL,
    music_Influencial_mood VARCHAR(200) NULL,
    music_lis_frequency VARCHAR(100) NULL,
    music_expl_method VARCHAR(100) NULL,
    music_recc_rating INT NULL,
    pod_lis_frequency VARCHAR(100) NULL,
    fav_pod_genre VARCHAR(50) NULL,
    preffered_pod_format VARCHAR(50) NULL,
    pod_host_preference VARCHAR(100) NULL,
    preffered_pod_duration VARCHAR(50) NULL,
    pod_variety_satisfaction VARCHAR(100) NULL
    );
    
    INSERT INTO spotify_tm
    SELECT
		ROW_NUMBER() OVER (ORDER BY Age) AS row_num,
        Age,
    Gender,
    spotify_usage_period,
    spotify_listening_device,
    spotify_subscription_plan,
    premium_sub_willingness,
    preffered_premium_plan,
    preferred_listening_content,
    fav_music_genre,
    music_time_slot,
    music_Influencial_mood,
    music_lis_frequency,
    music_expl_method,
    music_recc_rating,
    pod_lis_frequency,
    fav_pod_genre,
    preffered_pod_format,
    pod_host_preference,
    preffered_pod_duration,
    pod_variety_satisfaction
FROM spotify_data;

SELECT * FROM spotify_tm;

DROP TABLE IF EXISTS max_row_num;
CREATE TABLE max_row_num
	(
		row_num INT NULL
	);
INSERT INTO max_row_num
SELECT MAX(row_num)
FROM spotify_tm
GROUP BY Age,
    Gender,
    spotify_usage_period,
    spotify_listening_device,
    spotify_subscription_plan,
    premium_sub_willingness,
    preffered_premium_plan,
    preferred_listening_content,
    fav_music_genre,
    music_time_slot,
    music_Influencial_mood,
    music_lis_frequency,
    music_expl_method,
    music_recc_rating,
    pod_lis_frequency,
    fav_pod_genre,
    preffered_pod_format,
    pod_host_preference,
    preffered_pod_duration,
    pod_variety_satisfaction;
	
-- Reviewing the data. 
SELECT * FROM spotify_tm
WHERE row_num NOT IN (SELECT row_num FROM max_row_num);

SET SQL_SAFE_UPDATES = 0;

-- Deleting the rows having duplicate values.
DELETE
FROM spotify_tm
WHERE row_num NOT IN (SELECT row_num FROM max_row_num);

SELECT * FROM spotify_tm;
-- One duplicate row was deleted

-- Checking for NULL Values.
SELECT * FROM spotify_tm
WHERE Age IS NULL OR
    Gender IS NULL OR
    spotify_usage_period IS NULL OR
    spotify_listening_device IS NULL OR
    spotify_subscription_plan IS NULL OR
    premium_sub_willingness IS NULL OR
    preffered_premium_plan IS NULL OR
    preferred_listening_content IS NULL OR
    fav_music_genre IS NULL OR
    music_time_slot IS NULL OR
    music_Influencial_mood IS NULL OR
    music_lis_frequency IS NULL OR
    music_expl_method IS NULL OR
    music_recc_rating IS NULL OR
    pod_lis_frequency IS NULL OR
    fav_pod_genre IS NULL OR
    preffered_pod_format IS NULL OR
    pod_host_preference IS NULL OR
    preffered_pod_duration IS NULL OR
    pod_variety_satisfaction IS NULL; 
-- No NULL Value Found.

-- ANALYZING DATASET
-- Gender wise distribution of users with different age-groups
SELECT Gender,Age,COUNT(*) AS num_of_users
FROM spotify_tm
GROUP BY Gender,Age;

-- Age and gender wise distribution of users (free and paid)
SELECT 
	Age,
    Gender,
    spotify_subscription_plan,
    COUNT(*) AS No_of_users
FROM spotify_tm
GROUP BY Age,Gender,spotify_subscription_plan
ORDER BY Age,Gender,spotify_subscription_plan;

-- Users that are not subscribed, but willing to subscribe
SELECT (SUM(willing_subscribers)/SUM(Free_subscribers))*100 AS Percent_of_paid_willing_subscribers
FROM (SELECT
	Age,
    CASE WHEN spotify_subscription_plan LIKE '%Free%' THEN 1 ELSE 0 END AS Free_subscribers,
    CASE WHEN spotify_subscription_plan LIKE '%Free%' AND premium_sub_willingness = 'Yes' THEN 1 ELSE 0 END AS willing_subscribers
FROM spotify_tm) AS a;

-- Users that are not subscribed, and not willing to subscribe
SELECT (SUM(willing_subscribers)/SUM(Free_subscribers))*100 AS Percent_of_no_paid_willing_subscribers
FROM (SELECT
	Age,
    CASE WHEN spotify_subscription_plan LIKE '%Free%' THEN 1 ELSE 0 END AS Free_subscribers,
    CASE WHEN spotify_subscription_plan LIKE '%Free%' AND premium_sub_willingness = 'No' THEN 1 ELSE 0 END AS willing_subscribers
FROM spotify_tm) AS a;

-- Age-wise distribution of users preffered premium plan
SELECT Age,preffered_premium_plan,COUNT(*) AS no_of_users
FROM spotify_tm
GROUP BY Age,preffered_premium_plan
ORDER BY Age,preffered_premium_plan;

-- No. of male and female users
SELECT
	Gender,
	COUNT(*) AS no_of_users
FROM spotify_tm
GROUP BY Gender;

-- Distribution of users on favourite music genre and music time slot.
SELECT Age, fav_music_genre, music_time_slot, COUNT(*) AS No_of_users
FROM spotify_tm
GROUP BY Age,fav_music_genre,music_time_slot
ORDER BY Age,fav_music_genre,music_time_slot;

-- ANALYZING MUSIC LISTENERS
DROP TABLE IF EXISTS spotify_cm;
CREATE TABLE spotify_cm (
	row_num INT,
    is_smartphone_user INT,
    is_computer_user INT,
    is_wearable_device_user INT,
    is_smart_speaker_user INT,
    Relax_mood INT,
    Sad_mood INT,
    Motivated INT,
    Gatherings INT,
    leisure_time INT,
    Office_hours INT,
    While_Traveling INT,
    Study_hours INT,
    Workout_session INT
    );
    
INSERT INTO spotify_cm
SELECT
	row_num,
    CASE WHEN spotify_listening_device LIKE '%Smartphone%' THEN 1 ELSE 0 END,
    CASE WHEN spotify_listening_device LIKE'%Computer%' THEN 1 ELSE 0 END,
    CASE WHEN spotify_listening_device LIKE '%Wearable%' THEN 1 ELSE 0 END,
    CASE WHEN spotify_listening_device LIKE '%Smart speaker%' THEN 1 ELSE 0 END,
    CASE WHEN music_Influencial_mood LIKE '%Relaxation%' THEN 1 ELSE 0 END,
    CASE WHEN music_Influencial_mood LIKE '%Sadness%' THEN 1 ELSE 0 END,
    CASE WHEN music_Influencial_mood LIKE '%motivational%' THEN 1 ELSE 0 END,
    CASE WHEN music_Influencial_mood LIKE '%gatherings%' THEN 1 ELSE 0 END,
    CASE WHEN music_lis_frequency LIKE '%leisure%' THEN 1 ELSE 0 END,
    CASE WHEN music_lis_frequency LIKE '%Office%' THEN 1 ELSE 0 END,
    CASE WHEN music_lis_frequency LIKE '%Traveling%' THEN 1 ELSE 0 END,
    CASE WHEN music_lis_frequency LIKE '%Study%' THEN 1 ELSE 0 END,
    CASE WHEN music_lis_frequency LIKE '%Workout%' THEN 1 ELSE 0 END
FROM spotify_tm;

SELECT * FROM spotify_cm;

-- Joining the tables to get required results
SELECT
	tm.row_num,
    tm.Age,
    tm.Gender,
    tm.spotify_usage_period,
    cm.is_smartphone_user,
    cm.is_computer_user,
    cm.is_wearable_device_user,
    cm.is_smart_speaker_user,
    tm.spotify_subscription_plan,
    tm.premium_sub_willingness,
    tm.preffered_premium_plan,
    tm.preferred_listening_content,
    tm.fav_music_genre,
    tm.music_time_slot,
    cm.Relax_mood,
    cm.Sad_mood,
    cm.Motivated,
    cm.Gatherings,
    cm.leisure_time,
    cm.Office_hours,
    cm.While_Traveling,
    cm.Study_hours,
    cm.Workout_session
FROM spotify_tm tm
JOIN spotify_cm cm ON tm.row_num = cm.row_num;








