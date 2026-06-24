# Vergio (TP079623) — My Part in IndoSlang
## What to say to your lecturer, explained from scratch

---

## What is IndoSlang?

IndoSlang is a web application that teaches users Indonesian slang words. It has three types of users:
- **Member** — a regular learner
- **Buddy** — a tutor/helper
- **Admin** — manages the whole platform

The project is built using **ASP.NET Web Forms** (C#) with a **SQL Server** database.

---

## My Pages and What They Do

---

### 1. SlangDictionary.aspx
**Who uses it:** Members and Buddies  
**What it does:** Shows a searchable list of all Indonesian slang words in the system.

**CRUD role:** READ only  
The page reads from the `SlangWord` table in the database and displays the words in a grid with their meaning and difficulty level. Users can filter by level (Beginner, Intermediate, Advanced) and search by keyword.

**Key functions in SlangDictionary.aspx.cs:**
- `Page_Load` — runs every time the page loads; checks if the user is logged in, then calls `LoadWords()`
- `LoadWords()` — connects to the database, runs `SELECT * FROM SlangWord`, and stores the results in a list that the page displays
- `GetLevelClass()` — a helper that returns a CSS class name (e.g. "level-beginner") so the word badge shows the right color

---

### 2. SlangDetail.aspx
**Who uses it:** Members and Buddies  
**What it does:** Shows the full details of a single slang word (pronunciation, meaning, full explanation, example sentence, translation).

**CRUD role:** READ only  
When a user clicks a word in the dictionary, they are sent to this page with the word's ID in the URL (e.g. `SlangDetail.aspx?id=5`). The page reads that ID and fetches just that one word from the database.

**Key functions in SlangDetail.aspx.cs:**
- `Page_Load` — checks login, reads the `id` from the URL, calls `LoadWord()`
- `LoadWord()` — runs `SELECT ... FROM SlangWord WHERE SlangID = @SlangID` to get the specific word's data, then stores each field (Word, Pronunciation, Meaning, etc.) as a public variable that the ASPX page displays

---

### 3. Module3.aspx
**Who uses it:** Members and Buddies (only after completing Module 2)  
**What it does:** An interactive quiz module at the Elementary level. Users answer questions (MCQ, fill in the blank, true/false, translate) about Indonesian slang, and their results are saved.

**CRUD role:** READ (load questions) + CREATE (save results)  
Questions are read from the database. When the user finishes, their score and answers are saved.

**Key functions in Module3.aspx.cs:**
- `Page_Load` — checks login, sets up the sidebar links, calls `CheckModuleAccess()` and `LoadQuestionsFromDatabase()`
- `CheckModuleAccess()` — checks if the user has already passed Module 2. If not, redirects them to the Modules page (so they can't skip ahead)
- `LoadQuestionsFromDatabase()` — fetches all questions for Module 3 from the `Question` table, converts them into JSON format so the JavaScript quiz engine on the page can use them
- `btnSaveResult_Click` — fires when the user submits their answers; calls `CreateProgressAttempt()` and `SaveQuestionAnswers()`, then redirects to Module 4 if passed, or Modules page if failed
- `CreateProgressAttempt()` — saves one row to `UserModuleProgress` (records that this user attempted this module, with their score and whether they passed)
- `SaveQuestionAnswers()` — loops through every answer the user gave and saves each one to `UserQuestionAnswer` (records which question, what they answered, and whether it was correct)
- `HasCompletedModule()` — checks if the user has a passing record for a given module
- `GetNextAttemptNumber()` — figures out what attempt number this is for the user (1st try, 2nd try, etc.)

---

### 4. Module4.aspx
**Who uses it:** Members and Buddies (only after completing Module 3)  
**What it does:** Exactly the same structure as Module 3, but this is the last Elementary module. It uses chat-scenario style questions. On pass, redirects to Module 5.

**CRUD role:** READ (questions) + CREATE (results)  
Same functions as Module 3, just with `ModuleOrder = 4` and `PassingScore = 8`.

---

### 5. SuggestSlang.aspx
**Who uses it:** Members and Buddies only (Admin cannot access this page)  
**What it does:** Lets users suggest a new slang word for the dictionary. The suggestion goes into a "Pending" queue and an admin reviews it. The page also shows the user's past suggestions and their status (Pending / Approved / Rejected).

**CRUD role:** CREATE (submit suggestion) + READ (view own past suggestions)

**Key functions in SuggestSlang.aspx.cs:**
- `Page_Load` — checks login, and also checks the Role. If the user is an Admin (RoleID = 1), they get redirected away — Admins don't suggest slang
- `btnSubmit_Click` — takes all the form fields (Word, Pronunciation, Part of Speech, Meaning, Example, etc.) and runs an `INSERT INTO SlangSuggestion` SQL query. The status is automatically set to `'Pending'`
- `LoadMySuggestions()` — runs `SELECT ... FROM SlangSuggestion WHERE UserID = @UID` to show only this user's own suggestions
- `ClearForm()` — resets all the form fields to empty after a successful submission
- `GetStatusCss()` — returns the right CSS class for the status badge (green = Approved, red = Rejected, orange = Pending)
- `FormatDate()` — formats the submission date nicely (e.g. "19 May 2026")

---

### 6. CommunityChat.aspx
**Who uses it:** Members, Buddies, AND Admins (all logged-in users)  
**What it does:** A real-time-style group chat room for all members of the platform. Users can send messages and see messages from everyone else. The page auto-refreshes every 10 seconds to show new messages.

**CRUD role:** CREATE (send a message) + READ (view messages)

**Key functions in CommunityChat.aspx.cs:**
- `Page_Load` — checks login, then sets the sidebar differently depending on role (Admin sees admin links, Member/Buddy sees member links). Calls `LoadMessages()` on first load
- `btnSend_Click` — takes the text from the input box, runs `INSERT INTO ChatMessage (ChannelID, UserID, Content, SentAt)`, then reloads the messages
- `LoadMessages()` — runs a `SELECT TOP 50` query joining `ChatMessage` with the `User` table (to get the sender's name), reverses the list so oldest shows at top, and binds to the repeater
- `GetDefaultChannelId()` — finds the default chat channel in the database. If no channel exists yet, it automatically creates one called "General"
- `GetInitial()` — returns the first letter of the user's name, used for the avatar circle (e.g. "A" for "Ahmad")
- `GetWrapCss()`, `GetBubbleCss()`, `GetAvatarCss()` — helper functions that check if a message is from the current user. If yes, the bubble appears on the RIGHT (brown background). If from someone else, it appears on the LEFT (white background)
- `FormatTime()` — shows "HH:mm" for today's messages, or "dd MMM, HH:mm" for older ones

**How auto-refresh works:** JavaScript runs `setInterval` every 10 seconds and calls `location.reload()` to refresh the page. It pauses the refresh if the user is currently typing (so their message doesn't get cleared mid-type).

---

### 7. ManageContent.aspx
**Who uses it:** Admin only  
**What it does:** The admin's control panel for managing the platform's content. Has two tabs:
- **Dictionary tab** — Admin can Add, Edit, and Delete words in the slang dictionary
- **Module Questions tab** — Admin can select any module (2–8) and Add, Edit, or Delete its quiz questions. Module 1 is flashcards only, so it has no questions to manage here.

**CRUD role:** Full CRUD — Create, Read, Update, Delete (for both SlangWord and Question tables)

**Key functions in ManageContent.aspx.cs:**

*Dictionary side:*
- `LoadDictionary()` — reads all words from `SlangWord` and displays them in the table
- `btnShowAddWord_Click` — makes the word form appear (blank, ready for a new word)
- `btnSaveWord_Click` — if `hfSlangID` (a hidden field) is 0, runs an INSERT (add new). If it has a real ID, runs an UPDATE (edit existing). Then hides the form and refreshes the list
- `rptDictionary_ItemCommand` — fires when the Edit or Delete button is clicked on a row. Edit: fetches that word's data from DB and fills the form. Delete: runs `DELETE FROM SlangWord WHERE SlangID = @ID`
- `AddWordParams()` — a shared helper that adds all the word form fields as SQL parameters (avoids repeating code in both INSERT and UPDATE)
- `ClearWordForm()` — resets the word form fields

*Module Questions side:*
- `PopulateModuleDropdown()` — fills the module selector dropdown with "Module 1" through "Module 8"
- `ddlModule_SelectedIndexChanged` — fires when admin picks a module. Module 1 shows a note ("flashcards only, no questions"). Modules 2–8 show the questions list and an Add Question button
- `LoadModuleQuestions()` — reads questions for the selected module from the `Question` table
- `btnSaveQuestion_Click` — saves a new or edited question. Question data (the question text, options, explanation) is stored as a JSON string in the database
- `rptQuestions_ItemCommand` — handles Edit (fills form) and Delete. Delete removes from `UserQuestionAnswer` first (to avoid a foreign key error), then deletes from `Question`
- `SerializeQuestionData()` — converts the form fields into a JSON string before saving (MCQ includes options array; fill/truefalse don't)
- `GetQuestionText()` — parses the JSON from the database to show just the question text in the table (truncated to 80 characters)
- `GetTypeBadge()` — converts "mcq" → "MCQ", "fill" → "Fill", "truefalse" → "T/F" for display

**How tab state is preserved:** When the user saves a word and the page reloads (postback), it would normally jump back to the Dictionary tab. A hidden field (`hfActiveTab`) stores which tab was active, and JavaScript reads it on page load to re-activate the correct tab.

---

### 8. ManageUsers.aspx
**Who uses it:** Admin only  
**What it does:** Shows a full list of all Members and Buddies (Admins are excluded). The admin can search by name/username/email, filter by role, and Ban or Unban users.

**CRUD role:** READ + UPDATE (no Create — users self-register; no Delete — we ban instead of delete to preserve data)

**Key functions in ManageUsers.aspx.cs:**
- `Page_Load` — checks that only Admins can access this; calls `LoadUsers()` every time (not just on first load, so search results always show correctly)
- `LoadUsers()` — builds a SQL query dynamically: always excludes Admins (RoleID ≠ 1), adds a `LIKE` search clause if the admin typed a name, and adds a role filter if selected. Results are bound to the repeater table
- `rptUsers_ItemCommand` — fires when Ban/Unban is clicked. Gets the user's current status, flips it (Active → Banned or Banned → Active), and runs `UPDATE [User] SET Status = @Status WHERE UserID = @UID`
- `GetCurrentStatus()` — queries the database to get the user's current Status before flipping it
- `GetRoleName()` — converts RoleID number (2 or 3) to readable text ("Member" or "Buddy")
- `GetBanButtonText()` — shows "Ban" if user is Active, "Unban" if Banned
- `GetBanButtonCss()` — shows the button in red style for Ban, normal style for Unban
- `GetBanConfirm()` — generates the JavaScript confirmation popup text ("Are you sure you want to ban @username?")

---

## Key Technical Concepts to Know

### Session
When a user logs in, their information is stored in `Session` — a temporary memory that lasts while they're on the site. Every page checks `Session["UserID"]` to make sure the user is logged in, and `Session["RoleID"]` to check if they're a Member (2), Buddy (3), or Admin (1).

### DBHelper.GetConnection()
Every page uses this to connect to the SQL Server database. It's a shared helper class so the connection string doesn't have to be repeated everywhere.

### Postback
In ASP.NET Web Forms, clicking a button on the page sends the form back to the server (called a "postback"). The server runs the C# code, updates the data, and sends the HTML back. This is how saving, deleting, and editing all work without JavaScript APIs.

### Repeater
A server-side control that loops through a list of data and renders HTML for each row. Used in the messages list, dictionary table, questions table, users table, and suggestions table.

### Hidden Fields (HiddenField)
Invisible form fields that store values across postbacks. Used to remember things like "which word is being edited" (`hfSlangID`), "which tab was active" (`hfActiveTab`), and quiz answers (`hfAnswersJson`).

### CRUD Summary Table

| Page | Create | Read | Update | Delete |
|------|--------|------|--------|--------|
| SlangDictionary | ✗ | ✓ SlangWord | ✗ | ✗ |
| SlangDetail | ✗ | ✓ SlangWord | ✗ | ✗ |
| Module3 | ✓ UserModuleProgress, UserQuestionAnswer | ✓ Question | ✗ | ✗ |
| Module4 | ✓ UserModuleProgress, UserQuestionAnswer | ✓ Question | ✗ | ✗ |
| SuggestSlang | ✓ SlangSuggestion | ✓ SlangSuggestion | ✗ | ✗ |
| CommunityChat | ✓ ChatMessage | ✓ ChatMessage, User | ✗ | ✗ |
| ManageContent | ✓ SlangWord, Question | ✓ SlangWord, Question | ✓ SlangWord, Question | ✓ SlangWord, Question |
| ManageUsers | ✗ | ✓ User | ✓ User (ban/unban) | ✗ |

---

## If Your Lecturer Asks "How Does X Work?"

**"How does the dictionary work?"**  
The page connects to the database and runs a SELECT query on the SlangWord table. The results are stored in a C# list and displayed using a loop in the HTML. There's no hardcoded data — everything comes from the database.

**"How does the quiz save results?"**  
When the user finishes the quiz, JavaScript collects all their answers as JSON and puts them in a hidden field. When they click Submit, the page sends that to the server, which parses the JSON and saves one row per answer into the UserQuestionAnswer table, plus one overall row in UserModuleProgress.

**"How does the chat auto-refresh?"**  
JavaScript runs a timer (`setInterval`) that reloads the page every 10 seconds. The page checks if the user is typing first — if they typed in the last 4 seconds, it waits so it doesn't erase their message.

**"How does the ban feature work?"**  
There's no actual deletion. The User table has a `Status` column that is either "Active" or "Banned". Clicking Ban just updates that column to "Banned". The login page checks this status and blocks banned users from logging in.

**"Why can't Admin suggest slang?"**  
The SuggestSlang page checks `Session["RoleID"]`. If the role is 1 (Admin), the page immediately redirects to the login page. Only roles 2 (Member) and 3 (Buddy) are allowed through.

**"How does the edit in ManageContent work?"**  
When the Edit button is clicked, it fires a server event that reads that word's data from the database and fills a form with it. The word's ID is saved in a hidden field. When Save is clicked, the code checks if the hidden field has an ID — if yes, it runs an UPDATE; if it's 0, it runs an INSERT.
