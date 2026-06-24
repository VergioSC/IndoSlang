-- ============================================================
-- IndoSlang Database Setup Script
-- Run this against your LocalDB before starting the app.
-- All statements are safe to re-run (IF NOT EXISTS guards).
-- ============================================================

-- ------------------------------------------------------------
-- 1. Add/patch columns on PlacementResult (if missing)
-- ------------------------------------------------------------
IF NOT EXISTS (SELECT 1 FROM sys.columns WHERE object_id = OBJECT_ID('PlacementResult') AND name = 'SessionToken')
    ALTER TABLE PlacementResult ADD SessionToken NVARCHAR(200) NULL;

IF NOT EXISTS (SELECT 1 FROM sys.columns WHERE object_id = OBJECT_ID('PlacementResult') AND name = 'AssignedLevel')
    ALTER TABLE PlacementResult ADD AssignedLevel NVARCHAR(100) NULL;

IF NOT EXISTS (SELECT 1 FROM sys.columns WHERE object_id = OBJECT_ID('PlacementResult') AND name = 'TakenAt')
    ALTER TABLE PlacementResult ADD TakenAt DATETIME NULL;

IF NOT EXISTS (SELECT 1 FROM sys.columns WHERE object_id = OBJECT_ID('PlacementResult') AND name = 'OnboardingGoal')
    ALTER TABLE PlacementResult ADD OnboardingGoal NVARCHAR(200) NULL;

IF NOT EXISTS (SELECT 1 FROM sys.columns WHERE object_id = OBJECT_ID('PlacementResult') AND name = 'OnboardingFrequency')
    ALTER TABLE PlacementResult ADD OnboardingFrequency NVARCHAR(200) NULL;

IF NOT EXISTS (SELECT 1 FROM sys.columns WHERE object_id = OBJECT_ID('PlacementResult') AND name = 'OnboardingKnowledge')
    ALTER TABLE PlacementResult ADD OnboardingKnowledge NVARCHAR(200) NULL;

-- ------------------------------------------------------------
-- 2. Ensure all 8 Module rows exist with correct ModuleOrder
-- ------------------------------------------------------------
IF NOT EXISTS (SELECT 1 FROM Module WHERE ModuleOrder = 1)
    INSERT INTO Module (Title, ModuleOrder, Status) VALUES (N'Vocabulary Flashcards', 1, 'Published');
ELSE
    UPDATE Module SET Status = 'Published' WHERE ModuleOrder = 1;

IF NOT EXISTS (SELECT 1 FROM Module WHERE ModuleOrder = 2)
    INSERT INTO Module (Title, ModuleOrder, Status) VALUES (N'Beginner Quiz', 2, 'Published');
ELSE
    UPDATE Module SET Status = 'Published' WHERE ModuleOrder = 2;

IF NOT EXISTS (SELECT 1 FROM Module WHERE ModuleOrder = 3)
    INSERT INTO Module (Title, ModuleOrder, Status) VALUES (N'See Slang in a Chat', 3, 'Published');
ELSE
    UPDATE Module SET Status = 'Published' WHERE ModuleOrder = 3;

IF NOT EXISTS (SELECT 1 FROM Module WHERE ModuleOrder = 4)
    INSERT INTO Module (Title, ModuleOrder, Status) VALUES (N'Elementary Challenge', 4, 'Published');
ELSE
    UPDATE Module SET Status = 'Published' WHERE ModuleOrder = 4;

IF NOT EXISTS (SELECT 1 FROM Module WHERE ModuleOrder = 5)
    INSERT INTO Module (Title, ModuleOrder, Status) VALUES (N'Intermediate Slang 1', 5, 'Published');
ELSE
    UPDATE Module SET Status = 'Published' WHERE ModuleOrder = 5;

IF NOT EXISTS (SELECT 1 FROM Module WHERE ModuleOrder = 6)
    INSERT INTO Module (Title, ModuleOrder, Status) VALUES (N'Intermediate Slang 2', 6, 'Published');
ELSE
    UPDATE Module SET Status = 'Published' WHERE ModuleOrder = 6;

IF NOT EXISTS (SELECT 1 FROM Module WHERE ModuleOrder = 7)
    INSERT INTO Module (Title, ModuleOrder, Status) VALUES (N'Advanced Slang 1', 7, 'Published');
ELSE
    UPDATE Module SET Status = 'Published' WHERE ModuleOrder = 7;

IF NOT EXISTS (SELECT 1 FROM Module WHERE ModuleOrder = 8)
    INSERT INTO Module (Title, ModuleOrder, Status) VALUES (N'Advanced Slang 2', 8, 'Published');
ELSE
    UPDATE Module SET Status = 'Published' WHERE ModuleOrder = 8;

-- ------------------------------------------------------------
-- 3. Module 2 questions
--    QuestionType: 'mcq'  — CorrectAnswer is the 0-based index ("0","1","2","3")
--    QuestionType: 'fill' — CorrectAnswer is the expected text (lowercased)
--    QuestionType: 'tf'   — CorrectAnswer is "true" or "false"
--    QuestionData is JSON: {"question":"...","options":[...],"explanation":"..."}
-- ------------------------------------------------------------
DECLARE @Mod2ID INT = (SELECT TOP 1 ModuleID FROM Module WHERE ModuleOrder = 2);

IF @Mod2ID IS NOT NULL AND NOT EXISTS (SELECT 1 FROM Question WHERE ModuleID = @Mod2ID AND QuestionNumber = 1)
INSERT INTO Question (ModuleID, QuestionNumber, QuestionType, QuestionData, CorrectAnswer) VALUES
(@Mod2ID, 1, 'mcq',
N'{"question":"What does \"gue\" or \"gw\" mean in Indonesian slang?","options":["Saya / Aku — I / me","Kamu — you","Dia — he / she","Kita — we"],"explanation":"\"Gue\" or \"gw\" is informal slang for \"saya\" or \"aku\", meaning I or me."}',
'0');

IF @Mod2ID IS NOT NULL AND NOT EXISTS (SELECT 1 FROM Question WHERE ModuleID = @Mod2ID AND QuestionNumber = 2)
INSERT INTO Question (ModuleID, QuestionNumber, QuestionType, QuestionData, CorrectAnswer) VALUES
(@Mod2ID, 2, 'mcq',
N'{"question":"What does \"lo\" or \"lu\" mean in Indonesian slang?","options":["Saya — I","Kamu — you","Kami — we","Mereka — they"],"explanation":"\"Lo\" or \"lu\" is informal slang for \"kamu\", meaning you."}',
'1');

IF @Mod2ID IS NOT NULL AND NOT EXISTS (SELECT 1 FROM Question WHERE ModuleID = @Mod2ID AND QuestionNumber = 3)
INSERT INTO Question (ModuleID, QuestionNumber, QuestionType, QuestionData, CorrectAnswer) VALUES
(@Mod2ID, 3, 'tf',
N'{"question":"\"Ga\" or \"gak\" is informal Indonesian slang for \"tidak\" (no / not).","explanation":"Correct! \"Ga\", \"gak\", and \"enggak\" are all casual ways to say \"tidak\" (no / not)."}',
'true');

IF @Mod2ID IS NOT NULL AND NOT EXISTS (SELECT 1 FROM Question WHERE ModuleID = @Mod2ID AND QuestionNumber = 4)
INSERT INTO Question (ModuleID, QuestionNumber, QuestionType, QuestionData, CorrectAnswer) VALUES
(@Mod2ID, 4, 'mcq',
N'{"question":"What does \"baper\" mean?","options":["Sangat senang — very happy","Terlalu sensitif, mudah terbawa perasaan — overly emotional","Sangat sibuk — very busy","Tidak mau makan — refusing to eat"],"explanation":"\"Baper\" is short for \"bawa perasaan\" — being overly emotional or taking things too personally."}',
'1');

IF @Mod2ID IS NOT NULL AND NOT EXISTS (SELECT 1 FROM Question WHERE ModuleID = @Mod2ID AND QuestionNumber = 5)
INSERT INTO Question (ModuleID, QuestionNumber, QuestionType, QuestionData, CorrectAnswer) VALUES
(@Mod2ID, 5, 'fill',
N'{"question":"Type the Indonesian slang word that means \"cool\" or \"stylish\" (hint: starts with K).","explanation":"\"Kece\" means cool or stylish. It is commonly used among Indonesian youth."}',
'kece');

IF @Mod2ID IS NOT NULL AND NOT EXISTS (SELECT 1 FROM Question WHERE ModuleID = @Mod2ID AND QuestionNumber = 6)
INSERT INTO Question (ModuleID, QuestionNumber, QuestionType, QuestionData, CorrectAnswer) VALUES
(@Mod2ID, 6, 'tf',
N'{"question":"\"Bokap\" is Indonesian slang for \"ibu\" (mother).","explanation":"False. \"Bokap\" means \"ayah\" (father). The slang for mother is \"nyokap\"."}',
'false');

IF @Mod2ID IS NOT NULL AND NOT EXISTS (SELECT 1 FROM Question WHERE ModuleID = @Mod2ID AND QuestionNumber = 7)
INSERT INTO Question (ModuleID, QuestionNumber, QuestionType, QuestionData, CorrectAnswer) VALUES
(@Mod2ID, 7, 'mcq',
N'{"question":"What does \"gabut\" describe?","options":["Sangat lapar — very hungry","Tidak ada kerjaan dan bosan — idle and bored","Sangat capek — very tired","Marah sekali — very angry"],"explanation":"\"Gabut\" means having nothing to do and feeling bored — idle and restless."}',
'1');

IF @Mod2ID IS NOT NULL AND NOT EXISTS (SELECT 1 FROM Question WHERE ModuleID = @Mod2ID AND QuestionNumber = 8)
INSERT INTO Question (ModuleID, QuestionNumber, QuestionType, QuestionData, CorrectAnswer) VALUES
(@Mod2ID, 8, 'fill',
N'{"question":"\"Santuy\" is a casual slang version of what formal Indonesian word? (Type the formal word.)","explanation":"\"Santuy\" comes from \"santai\", meaning relaxed or chill."}',
'santai');

IF @Mod2ID IS NOT NULL AND NOT EXISTS (SELECT 1 FROM Question WHERE ModuleID = @Mod2ID AND QuestionNumber = 9)
INSERT INTO Question (ModuleID, QuestionNumber, QuestionType, QuestionData, CorrectAnswer) VALUES
(@Mod2ID, 9, 'tf',
N'{"question":"\"Mantul\" is short for \"mantap betul\", meaning really great or excellent.","explanation":"True! \"Mantul\" = \"mantap betul\". It is used to say something is awesome or on point."}',
'true');

IF @Mod2ID IS NOT NULL AND NOT EXISTS (SELECT 1 FROM Question WHERE ModuleID = @Mod2ID AND QuestionNumber = 10)
INSERT INTO Question (ModuleID, QuestionNumber, QuestionType, QuestionData, CorrectAnswer) VALUES
(@Mod2ID, 10, 'mcq',
N'{"question":"What does \"mager\" mean?","options":["Marah besar — very angry","Males gerak — too lazy to move or do anything","Makan garam — experienced / wise","Maju terus — keep moving forward"],"explanation":"\"Mager\" is short for \"males gerak\" — feeling too lazy to move or do anything."}',
'1');

-- ------------------------------------------------------------
-- 4. Withdrawal table (used by WithdrawEarnings.aspx)
-- ------------------------------------------------------------
IF NOT EXISTS (SELECT 1 FROM sys.objects WHERE type = 'U' AND name = 'Withdrawal')
CREATE TABLE Withdrawal (
    WithdrawalID   INT           IDENTITY(1,1) PRIMARY KEY,
    BuddyUserID    INT           NOT NULL REFERENCES [User](UserID),
    Amount         DECIMAL(10,2) NOT NULL,
    PaymentMethod  NVARCHAR(100) NOT NULL,
    Notes          NVARCHAR(500) NULL,
    Status         NVARCHAR(50)  NOT NULL DEFAULT 'Pending',
    RequestedAt    DATETIME      NOT NULL DEFAULT GETDATE()
);

-- ------------------------------------------------------------
-- 5. Module 6 question corrections (always updates — safe to re-run)
-- ------------------------------------------------------------
DECLARE @Mod6ID INT = (SELECT TOP 1 ModuleID FROM Module WHERE ModuleOrder = 6);

-- Q3: FOMO, Slay, Kepo (was Lowkey), Alay, Gas
IF @Mod6ID IS NOT NULL AND EXISTS (SELECT 1 FROM Question WHERE ModuleID = @Mod6ID AND QuestionNumber = 3)
    UPDATE Question SET QuestionType = 'match',
        QuestionData = N'{"source":"MATCH","question":"Match each slang word to its correct meaning.","pairs":[{"left":"FOMO","right":"Fear of missing out"},{"left":"Slay","right":"Killing it / looking amazing"},{"left":"Kepo","right":"Too curious / nosy"},{"left":"Alay","right":"Over the top / try-hard / extra"},{"left":"Gas","right":"Let''s go / go for it"}],"explanation":"FOMO = Fear of Missing Out. Slay = killing it. Kepo = too curious / nosy. Alay = over the top. Gas = let''s go."}',
        CorrectAnswer = 'ALL'
    WHERE ModuleID = @Mod6ID AND QuestionNumber = 3;

-- Q6: Galau, YGY, halu, YTTA, kocak
IF @Mod6ID IS NOT NULL AND EXISTS (SELECT 1 FROM Question WHERE ModuleID = @Mod6ID AND QuestionNumber = 6)
    UPDATE Question SET QuestionType = 'match',
        QuestionData = N'{"source":"MATCH","question":"Match the remaining 5 words to their meanings.","pairs":[{"left":"Galau","right":"Emotionally unsettled"},{"left":"YGY","right":"Ya guys ya — used to seek agreement"},{"left":"Halu","right":"Hallucinating"},{"left":"YTTA","right":"If you know, you know"},{"left":"Kocak","right":"Hilarious"}],"explanation":"Kepo = nosy. FOMO = Fear of Missing Out. Slay = killing it. Alay = extra / over the top. Gas = let''s go."}',
        CorrectAnswer = 'ALL'
    WHERE ModuleID = @Mod6ID AND QuestionNumber = 6;

-- Q7: A/B chat exchange (multiline), question fixed to "conversation"
IF @Mod6ID IS NOT NULL AND EXISTS (SELECT 1 FROM Question WHERE ModuleID = @Mod6ID AND QuestionNumber = 7)
    UPDATE Question SET QuestionType = 'mcq',
        QuestionData = N'{"source":"Chat","context":"A: \"Eh nilai lo berapa? Mau tau dong\"\n\nB: \"Ih kepo banget\"","question":"What does this conversation mean in English?","options":["A is sharing the score. B is excited about it.","A is asking about B''s score, A wants to know. B is playfully calling A nosy for asking.","A is asking B to buy tickets together. B is declining.","A and B are both trying to find out the score together."],"explanation":"Kepo means nosy or overly curious. B is playfully calling A out for being nosy about the score."}',
        CorrectAnswer = '1'
    WHERE ModuleID = @Mod6ID AND QuestionNumber = 7;

-- Q8: Group chat fill-in-blank (multiline), answer = FOMO
IF @Mod6ID IS NOT NULL AND EXISTS (SELECT 1 FROM Question WHERE ModuleID = @Mod6ID AND QuestionNumber = 8)
    UPDATE Question SET QuestionType = 'mcq',
        QuestionData = N'{"source":"Group Chat","context":"Alin: Eh, kalian tau gak kenapa si itu tiba-tiba keluar dari grup sebelah?\n\nCaitlyn: Hah? Apaan nih? Spill dong!\n\nAlin: Udah lah nggak usah ditanya, ntar lo malah kepikiran terus pengen jadian sama dia. Jangan ___ deh, dia udah ada yang punya.","question":"Fill in the blank.","options":["FOMO","alay","halu","YGY"],"explanation":"FOMO (Fear of Missing Out) — Alin is telling everyone not to be FOMO about the situation."}',
        CorrectAnswer = '0'
    WHERE ModuleID = @Mod6ID AND QuestionNumber = 8;

-- Q9: Comment thread (multiline)
IF @Mod6ID IS NOT NULL AND EXISTS (SELECT 1 FROM Question WHERE ModuleID = @Mod6ID AND QuestionNumber = 9)
    UPDATE Question SET QuestionType = 'mcq',
        QuestionData = N'{"source":"Comment Thread","context":"felix: \"reaksinya kocak banget, gue ngakak nonton nya.\"\n\nmarco: \"iya tapi thumbnailnya alay parah haha\"\n\nfelix: \"hahaha betul sih tp kontennya tetep keren lah\"","question":"What does this comment thread mean?","options":["Felix loves the video. Marco thinks everything about it is bad.","Felix finds it hilarious. Marco thinks the thumbnail is too extra, but both agree the content is good.","Both are criticising the video for different reasons.","Felix is defending the creator. Marco is being genuinely negative."],"explanation":"Kocak means hilarious, alay means over the top/extra. Both agree the content is keren (good)."}',
        CorrectAnswer = '1'
    WHERE ModuleID = @Mod6ID AND QuestionNumber = 9;

-- Q10: Group Chat — "What does gas mean?"
IF @Mod6ID IS NOT NULL AND EXISTS (SELECT 1 FROM Question WHERE ModuleID = @Mod6ID AND QuestionNumber = 10)
    UPDATE Question SET QuestionType = 'mcq',
        QuestionData = N'{"source":"Group Chat","context":"A: \"guys pergi yuk, gua gabut\"\n\nB: \"gas\"","question":"What does ''gas'' mean?","options":["Not coming","Let''s go","Yes","Gabut"],"explanation":"Gas is slang for gaskeun — meaning let''s go / let''s do it. B is agreeing to go out."}',
        CorrectAnswer = '1'
    WHERE ModuleID = @Mod6ID AND QuestionNumber = 10;

-- ------------------------------------------------------------
-- 6. Module 8 questions — correct final version (delete + re-insert)
-- ------------------------------------------------------------
DECLARE @Mod8ID INT = (SELECT TOP 1 ModuleID FROM Module WHERE ModuleOrder = 8);

IF @Mod8ID IS NOT NULL BEGIN
    DELETE FROM UserQuestionAnswer WHERE QuestionID IN (SELECT QuestionID FROM Question WHERE ModuleID = @Mod8ID);
    DELETE FROM Question WHERE ModuleID = @Mod8ID;
END

-- Q1: Drag & Drop Match
IF @Mod8ID IS NOT NULL INSERT INTO Question (ModuleID, QuestionNumber, QuestionType, QuestionData, CorrectAnswer) VALUES
(@Mod8ID, 1, 'drag_match',
N'{"question":"Drag each slang word to match its correct meaning!","pairs":[{"left":"Kuy","right":"Let''s go / come on"},{"left":"Mager","right":"Too lazy to move"},{"left":"Gercep","right":"Moves fast / quick action"},{"left":"Woles","right":"Relaxed / take it easy"}],"note":"All 4 pairs must be correct for full points. The meanings are shuffled on screen.","explanation":"Kuy = let''s go / come on, Mager = too lazy to move, Gercep = moves fast / quick action, Woles = relaxed / take it easy."}',
'ALL');

-- Q2: Scenario MCQ — Mager (index 1)
IF @Mod8ID IS NOT NULL INSERT INTO Question (ModuleID, QuestionNumber, QuestionType, QuestionData, CorrectAnswer) VALUES
(@Mod8ID, 2, 'mcq',
N'{"qLabel":"Scenario MCQ","scenario":"SITUATION","context":"Your friend is lying on the sofa scrolling their phone. You ask them to go out and grab food. They say \"Nah, I don''t feel like moving at all.\" Which slang best describes how they''re feeling?","question":"Read the situation and pick the slang that fits best!","options":["Gabut","Mager","Baper","Gercep"],"explanation":"\"Mager\" = males gerak (too lazy to move). The key is \"don''t feel like moving at all\" — mager is specifically about physical laziness, different from gabut which is just having nothing to do."}',
'1');

-- Q3: Timed MCQ — julid (index 1)
IF @Mod8ID IS NOT NULL INSERT INTO Question (ModuleID, QuestionNumber, QuestionType, QuestionData, CorrectAnswer) VALUES
(@Mod8ID, 3, 'timed_mcq',
N'{"question":"What does the bold word mean in this sentence?","context":"\"Dia tuh sukanya <strong>julid</strong> sama orang, padahal hidupnya sendiri gak beres.\"","options":["Too serious about everything","Likes to make negative comments about others","Easily gets angry","Too much of a perfectionist"],"explanation":"\"Julid\" = someone who constantly makes snarky or negative comments about other people. The irony — judging others while her own life is a mess — is very typical julid behaviour."}',
'1');

-- Q4: Drag & Drop Match
IF @Mod8ID IS NOT NULL INSERT INTO Question (ModuleID, QuestionNumber, QuestionType, QuestionData, CorrectAnswer) VALUES
(@Mod8ID, 4, 'drag_match',
N'{"question":"Drag each slang word to match its correct meaning!","pairs":[{"left":"Baper","right":"Getting too emotionally worked up"},{"left":"Bucin","right":"Completely head over heels for someone"},{"left":"PHP","right":"Someone who gives false hope"},{"left":"Galau","right":"Feeling anxious / overthinking"}],"note":"Category: feelings & emotions slang. All 4 pairs must be matched correctly for full points.","explanation":"Baper = getting too emotionally worked up, Bucin = completely head over heels, PHP = gives false hope, Galau = feeling anxious / overthinking."}',
'ALL');

-- Q5: Timed MCQ — gabut (index 1)
IF @Mod8ID IS NOT NULL INSERT INTO Question (ModuleID, QuestionNumber, QuestionType, QuestionData, CorrectAnswer) VALUES
(@Mod8ID, 5, 'timed_mcq',
N'{"question":"What does the bold word most accurately mean in this sentence?","context":"\"Udah sore gini masih <strong>gabut</strong> di rumah, gak ada temen yang ngajakin ngapa-ngapain.\"","options":["Working really hard","Bored with nothing to do","Staying home because of illness","Too lazy to go outside"],"explanation":"\"Gabut\" = having nothing to do, idle and bored. It''s different from \"mager\" — gabut is about zero activity, while mager is about refusing to move even when there''s something to do."}',
'1');

-- Q6: Scenario MCQ — Bucin (index 2)
IF @Mod8ID IS NOT NULL INSERT INTO Question (ModuleID, QuestionNumber, QuestionType, QuestionData, CorrectAnswer) VALUES
(@Mod8ID, 6, 'mcq',
N'{"qLabel":"Scenario MCQ","scenario":"SITUATION","context":"Your classmate texts their crush every 5 minutes, saves all their photos, and brings them up in every conversation. Everyone around them is like \"you need to calm down.\" Which slang best describes this classmate?","question":"Read the situation and pick the slang that fits best!","options":["Galau","Cuek","Bucin","Gabut"],"explanation":"\"Bucin\" = budak cinta — someone so obsessed with their crush that everything revolves around that person. Peak bucin."}',
'2');

-- Q7: Drag & Drop Match
IF @Mod8ID IS NOT NULL INSERT INTO Question (ModuleID, QuestionNumber, QuestionType, QuestionData, CorrectAnswer) VALUES
(@Mod8ID, 7, 'drag_match',
N'{"question":"Drag each slang word to match its correct meaning!","pairs":[{"left":"Lebay","right":"Over-dramatic / exaggerating"},{"left":"Gabut","right":"Idle, nothing to do"},{"left":"Gaskeun","right":"Let''s do it / just go for it"},{"left":"Cuek","right":"Indifferent / doesn''t show feelings"}],"note":"Category: behaviour & attitude slang. Meanings are shuffled on screen for the user.","explanation":"Lebay = over-dramatic / exaggerating, Gabut = idle / nothing to do, Gaskeun = let''s do it, Cuek = indifferent / doesn''t show feelings."}',
'ALL');

-- Q8: Timed MCQ — lebay (index 1)
IF @Mod8ID IS NOT NULL INSERT INTO Question (ModuleID, QuestionNumber, QuestionType, QuestionData, CorrectAnswer) VALUES
(@Mod8ID, 8, 'timed_mcq',
N'{"question":"What does the bold word most accurately mean in this sentence?","context":"\"Cuma hujan gerimis dikit aja langsung bilang banjir, <strong>lebay</strong> deh kamu.\"","options":["Overly worried and anxious","Exaggerating a small situation","Taking things too seriously","Not paying attention"],"explanation":"\"Lebay\" = over-dramatic, blowing things out of proportion. Calling a light drizzle a flood — the gap between reality and reaction is what makes it lebay."}',
'1');

-- Q9: Scenario MCQ — Galau (index 2)
IF @Mod8ID IS NOT NULL INSERT INTO Question (ModuleID, QuestionNumber, QuestionType, QuestionData, CorrectAnswer) VALUES
(@Mod8ID, 9, 'mcq',
N'{"qLabel":"Scenario MCQ","scenario":"SITUATION","context":"Your friend has been quietly staring at their phone for an hour, sighing every few minutes. When you ask what''s wrong, they say ''I don''t know... I just feel unsettled about everything.'' Which slang describes what they''re going through?","question":"Read the situation and choose the slang that fits!","options":["Mager","Lebay","Galau","Gercep"],"explanation":"\"Galau\" = feeling unsettled, anxious, overwhelmed with mixed thoughts. The sighing and \"I don''t know\" are classic galau signs."}',
'2');

-- Q10: Timed MCQ — PHP (index 2)
IF @Mod8ID IS NOT NULL INSERT INTO Question (ModuleID, QuestionNumber, QuestionType, QuestionData, CorrectAnswer) VALUES
(@Mod8ID, 10, 'timed_mcq',
N'{"question":"Final question! What does the bold word mean in this sentence?","context":"\"Temen gue tuh <strong>PHP</strong> banget, bilangnya mau dateng ke acara ulang tahun gue, eh gak muncul-muncul.\"","options":["Very forgetful","Cancels plans at the last minute","Gives hope but doesn''t follow through","Doesn''t like social events"],"explanation":"\"PHP\" = Pemberi Harapan Palsu (false hope giver). She said she was coming, raising expectations — then never showed up."}',
'2');

-- Done.
