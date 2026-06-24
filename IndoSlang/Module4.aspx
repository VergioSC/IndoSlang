<%@ Page Title="Module 4 — Elementary" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Module4.aspx.cs" Inherits="IndoSlang.Module4" %>

<asp:Content ID="HeadContent" ContentPlaceHolderID="HeadContent" runat="server">
    <style>
        .navbar { display: none !important; }
        .site-footer { display: none !important; }
        .site-main { padding: 0 !important; margin: 0 !important; }
        body { margin: 0; padding: 0; overflow: hidden; }

        .dashboard-layout { display: flex; height: 100vh; overflow: hidden; }

        .sidebar { width: 260px; min-width: 260px; background: var(--brown); color: #fff; display: flex; flex-direction: column; padding: 32px 0 24px; height: 100vh; overflow: hidden; overflow-x: hidden; flex-shrink: 0; transition: width 0.3s ease, min-width 0.3s ease; }
        .sidebar.collapsed { width: 0; min-width: 0; overflow: hidden; }
        .sidebar-logo { display: flex; align-items: center; gap: 10px; padding: 0 24px 32px; font-family: var(--font-display); font-size: 1.3rem; color: #fff; text-decoration: none; white-space: nowrap; }
        .sidebar-logo img { width: 38px; height: 38px; border-radius: 50%; flex-shrink: 0; }
        .sidebar-nav { flex: 1; overflow-y: auto; min-height: 0; }
        .nav-link { display: flex; align-items: center; gap: 10px; padding: 10px 24px; color: rgba(255,255,255,0.75); text-decoration: none; font-size: 0.92rem; border-left: 3px solid transparent; transition: background 0.15s, color 0.15s, border-color 0.15s; white-space: nowrap; }
        .nav-link:hover { background: rgba(255,255,255,0.08); color: #fff; }
        .nav-link.active { background: rgba(255,255,255,0.12); color: #fff; border-left-color: var(--accent); font-weight: 700; }
        .nav-icon { font-size: 1rem; width: 20px; text-align: center; flex-shrink: 0; }
        .sidebar-divider { border: none; border-top: 1px solid rgba(255,255,255,0.12); margin: 16px 24px; }
        .nav-link.signout { color: rgba(255,255,255,0.45); }
        .nav-link.signout:hover { color: #ff8a8a; background: rgba(255,100,100,0.08); }

        .sidebar-toggle { position: fixed; left: 244px; top: 50vh; transform: translateY(-50%); width: 28px; height: 28px; background: var(--brown); border: 2px solid rgba(255,255,255,0.25); border-radius: 50%; color: #fff; cursor: pointer; display: flex; align-items: center; justify-content: center; font-size: 0.8rem; z-index: 9999; transition: left 0.3s ease, background 0.2s; }
        .sidebar-toggle:hover { background: var(--brown-mid); }
        .sidebar-toggle.collapsed { left: 0; }

        .dashboard-main { flex: 1; display: flex; flex-direction: column; height: 100vh; overflow: hidden; min-width: 0; }

        .topbar { background: var(--cream); border-bottom: 2px solid var(--cream-mid); padding: 16px 34px; display: flex; align-items: center; justify-content: space-between; flex-shrink: 0; }
        .topbar-left { display: flex; align-items: center; gap: 14px; }
        .btn-back { display: inline-flex; align-items: center; gap: 6px; background: var(--cream-mid); border: none; border-radius: 10px; padding: 8px 15px; font-family: var(--font-body); font-size: 0.85rem; color: var(--brown); cursor: pointer; text-decoration: none; font-weight: 700; transition: background 0.2s; }
        .btn-back:hover { background: #e8ddd0; }
        .topbar-title { font-family: var(--font-display); font-size: 1.55rem; color: var(--brown); font-weight: 700; }
        .topbar-user { display: flex; align-items: center; gap: 10px; color: var(--brown); font-weight: 700; font-size: 0.92rem; }
        .topbar-avatar { width: 38px; height: 38px; border-radius: 50%; background: var(--brown-mid); display: flex; align-items: center; justify-content: center; color: #fff; font-size: 1.1rem; }

        .module-content { flex: 1; overflow-y: auto; padding: 38px 46px 70px; background: var(--cream); font-family: var(--font-body); color: var(--brown); }

        .module-header { margin-bottom: 28px; }
        .module-badge { display: inline-block; background: var(--brown); color: #fff; font-family: var(--font-display); font-size: 0.85rem; padding: 5px 15px; border-radius: 999px; margin-bottom: 10px; }
        .module-header h1 { font-family: var(--font-display); font-size: 2rem; margin: 0 0 6px; color: var(--brown); }
        .module-header p { color: var(--brown-mid); font-size: 0.94rem; margin: 0; line-height: 1.6; }

        .progress-bar-wrap { background: var(--cream-mid); border-radius: 999px; height: 10px; margin-bottom: 8px; overflow: hidden; }
        .progress-bar-fill { height: 100%; background: var(--brown); border-radius: 999px; transition: width 0.4s ease; }
        .progress-label { display: flex; justify-content: space-between; font-size: 0.82rem; color: var(--brown-mid); margin-bottom: 20px; }

        .score-tracker { display: none; }
        .score-dot { width: 18px; height: 18px; border-radius: 50%; border: 2px solid var(--cream-mid); background: #fff; transition: all 0.25s ease; }
        .score-dot.correct { background: var(--green); border-color: var(--green); }
        .score-dot.wrong { background: #c0392b; border-color: #c0392b; }

        .question-card { background: #fff; border: 2px solid var(--cream-mid); border-radius: 22px; padding: 32px 30px; box-shadow: 0 6px 22px rgba(59,42,26,0.09); margin: 0 auto 20px; max-width: 780px; }
        .question-type-tag { font-size: 0.75rem; font-weight: 800; text-transform: uppercase; letter-spacing: 1px; color: var(--accent); margin-bottom: 10px; }
        .source-badge { display: inline-block; background: var(--brown); color: #fff; font-size: 0.78rem; font-weight: 800; padding: 4px 13px; border-radius: 999px; margin-bottom: 12px; font-family: var(--font-display); }
        .question-context { background: var(--cream-mid); border-left: 4px solid var(--brown); padding: 11px 16px; border-radius: 0 12px 12px 0; font-size: 0.92rem; color: var(--brown-mid); margin-bottom: 18px; line-height: 1.6; }
        .question-image { max-width: 100%; border-radius: 16px; border: 2px solid var(--cream-mid); margin-bottom: 18px; display: none; }
        .question-text { font-family: var(--font-display); font-size: 1.28rem; margin-bottom: 22px; line-height: 1.45; color: var(--brown); }

        .mcq-options { display: flex; flex-direction: column; gap: 10px; }
        .mcq-option { background: var(--cream); border: 2px solid var(--cream-mid); border-radius: 14px; padding: 13px 18px; cursor: pointer; font-size: 0.95rem; transition: border-color 0.2s, background 0.2s; text-align: left; color: var(--brown); font-family: var(--font-body); }
        .mcq-option:hover { border-color: var(--accent); background: #fdf4ea; }
        .mcq-option.selected { border-color: var(--accent); background: #fce9d0; }
        .mcq-option.correct { border-color: var(--green); background: #d4edda; }
        .mcq-option.wrong { border-color: #c0392b; background: #fde8e8; }

        .fill-blank-input { width: 100%; box-sizing: border-box; padding: 13px 16px; border: 2px solid var(--cream-mid); border-radius: 14px; font-family: var(--font-body); font-size: 1rem; color: var(--brown); background: var(--cream); outline: none; transition: border-color 0.2s; }
        .fill-blank-input:focus { border-color: var(--accent); }
        .fill-blank-input.correct { border-color: var(--green); background: #d4edda; }
        .fill-blank-input.wrong { border-color: #c0392b; background: #fde8e8; }

        .tf-options { display: flex; gap: 14px; }
        .tf-btn { flex: 1; padding: 14px; border-radius: 14px; border: 2px solid var(--cream-mid); background: var(--cream); font-family: var(--font-display); font-size: 1.05rem; cursor: pointer; color: var(--brown); transition: border-color 0.2s, background 0.2s; }
        .tf-btn:hover { border-color: var(--accent); }
        .tf-btn.selected { border-color: var(--accent); background: #fce9d0; }
        .tf-btn.correct { border-color: var(--green); background: #d4edda; }
        .tf-btn.wrong { border-color: #c0392b; background: #fde8e8; }

        .feedback-msg { margin-top: 14px; padding: 11px 16px; border-radius: 12px; font-size: 0.92rem; display: none; line-height: 1.5; }
        .feedback-msg.correct { background: #d4edda; color: #1a5c2a; display: block; }
        .feedback-msg.wrong { background: #fde8e8; color: #7b1515; display: block; }

        .check-btn, .next-btn { color: #fff; border: none; padding: 12px 28px; border-radius: 13px; font-family: var(--font-display); font-size: 1rem; cursor: pointer; transition: background 0.2s, transform 0.15s; margin-top: 14px; }
        .check-btn { background: var(--accent); }
        .check-btn:hover { background: var(--accent-light); transform: translateY(-2px); }
        .next-btn { background: var(--brown); display: none; margin-left: 8px; }
        .next-btn:hover { background: var(--brown-mid); transform: translateY(-2px); }

        .completion-card { display: none; text-align: center; background: #fff; border: 1.5px solid var(--cream-mid); border-radius: 18px; padding: 48px 40px 40px; max-width: 620px; margin: 0 auto; }
        .score-circle { width: 160px; height: 160px; border-radius: 50%; border: 3px solid var(--brown); display: flex; flex-direction: column; align-items: center; justify-content: center; margin: 0 auto 32px; }
        .score-circle-num { font-family: var(--font-display); font-size: 3.2rem; font-weight: 700; color: var(--brown); line-height: 1; }
        .score-circle-label { font-size: 0.85rem; color: var(--brown-mid); margin-top: 4px; }
        .completion-main-msg { font-family: var(--font-display); font-size: 1.4rem; font-weight: 700; color: var(--brown); margin: 0 0 12px; }
        .completion-sub-msg { font-size: 0.95rem; color: var(--brown-mid); line-height: 1.65; margin: 0 0 28px; }
        .result-actions { display: flex; justify-content: center; gap: 12px; flex-wrap: wrap; }
        .btn-next-module { background: var(--accent); color: #fff; padding: 13px 30px; border-radius: 13px; font-family: var(--font-display); font-size: 1rem; text-decoration: none; display: inline-block; border: none; cursor: pointer; }
        .btn-next-module:hover { background: var(--accent-light); }
        .btn-retry { background: var(--cream-mid); color: var(--brown); border: 2px solid var(--brown-mid); padding: 12px 26px; border-radius: 13px; font-family: var(--font-display); font-size: 1rem; cursor: pointer; margin-right: 12px; }

        .empty-card { background: #fff; border: 2px dashed var(--cream-mid); border-radius: 22px; padding: 36px 28px; max-width: 780px; margin: 0 auto; color: var(--brown-mid); line-height: 1.7; display: none; }
        .empty-card strong { color: var(--brown); }
        .hidden-server-control { display: none; }

        .btn-go-summary { background: var(--brown); color: #fff; border: none; padding: 12px 26px; border-radius: 13px; font-family: var(--font-display); font-size: 0.95rem; cursor: pointer; transition: background 0.15s; }
        .btn-go-summary:hover { background: var(--brown-mid); }
        .summary-card { display: none; background: #fff; border: 1.5px solid var(--cream-mid); border-radius: 22px; padding: 40px; max-width: 780px; margin: 0 auto; }
        .summary-title { font-family: var(--font-display); font-size: 1.5rem; color: var(--brown); text-align: center; margin: 0 0 8px; font-weight: 700; }
        .summary-sub { text-align: center; font-size: 0.88rem; color: var(--brown-mid); margin: 0 0 32px; font-style: italic; }
        .vocab-grid { display: grid; grid-template-columns: 1fr 1fr; gap: 18px 48px; margin-bottom: 32px; }
        .vocab-item { display: flex; align-items: baseline; gap: 10px; }
        .vocab-word { font-family: var(--font-display); font-size: 1.05rem; font-weight: 700; color: var(--brown); min-width: 90px; }
        .vocab-meaning { font-size: 0.87rem; color: var(--brown-mid); font-style: italic; }
        .summary-actions { text-align: center; }
        .btn-next-module { background: var(--brown); color: #fff; padding: 13px 30px; border-radius: 13px; font-family: var(--font-display); font-size: 1rem; text-decoration: none; display: inline-block; border: none; cursor: pointer; transition: background 0.15s; }
        .btn-next-module:hover { background: var(--brown-mid); }
        .btn-retry-summary { background: #fff; color: var(--brown); border: 2px solid var(--brown-mid); padding: 12px 26px; border-radius: 13px; font-family: var(--font-display); font-size: 0.95rem; cursor: pointer; transition: background 0.15s; }
        .btn-retry-summary:hover { background: var(--cream-mid); }

        .chat-window { background: #f5f5f5; border-radius: 18px; padding: 16px 20px; margin-bottom: 18px; max-height: 300px; overflow-y: auto; }
        .chat-timestamp { text-align: center; font-size: 0.72rem; color: #8e8e93; margin-bottom: 14px; }
        .chat-msg { display: flex; flex-direction: column; margin-bottom: 10px; }
        .chat-msg.left { align-items: flex-start; }
        .chat-msg.right { align-items: flex-end; }
        .chat-sender-name { font-size: 0.7rem; color: #8e8e93; margin-bottom: 3px; padding: 0 6px; }
        .chat-bubble { max-width: 72%; padding: 10px 14px; border-radius: 20px; font-size: 0.9rem; line-height: 1.45; word-break: break-word; }
        .chat-msg.left .chat-bubble { background: #e9e9eb; color: #1c1c1e; border-bottom-left-radius: 5px; }
        .chat-msg.right .chat-bubble { background: #007aff; color: #fff; border-bottom-right-radius: 5px; }
        .chat-msg.right .chat-sender-name { text-align: right; }
        .chat-highlight { text-decoration: underline; font-weight: 700; }
        .question-context.chat-context { background: none; border-left: none; padding: 0; border-radius: 0; }

        .intro-card { display: flex; flex-direction: column; align-items: center; justify-content: center; text-align: center; padding: 60px 40px; max-width: 720px; margin: 0 auto; }
        .intro-welcome { font-family: var(--font-display); font-size: 1.2rem; color: var(--brown-mid); font-weight: 400; margin: 0 0 6px; }
        .intro-title { font-family: var(--font-display); font-size: 1.9rem; color: var(--brown); font-weight: 700; margin: 0 0 24px; line-height: 1.35; }
        .intro-sub { font-family: var(--font-display); font-size: 1rem; color: var(--brown); font-weight: 700; margin: 0 0 16px; }
        .intro-desc { font-size: 0.93rem; color: var(--brown-mid); margin: 0 0 12px; line-height: 1.7; max-width: 600px; }
        .btn-start-quiz { background: #fff; color: var(--brown); border: 2px solid var(--brown-mid); padding: 13px 36px; border-radius: 999px; font-family: var(--font-display); font-size: 1rem; cursor: pointer; margin-top: 20px; transition: background 0.2s, color 0.2s; }
        .btn-start-quiz:hover { background: var(--brown); color: #fff; border-color: var(--brown); }
    </style>
</asp:Content>

<asp:Content ID="MainContent" ContentPlaceHolderID="MainContent" runat="server">

    <asp:HiddenField ID="hfScore" runat="server" />
    <asp:HiddenField ID="hfPassed" runat="server" />
    <asp:HiddenField ID="hfAnswersJson" runat="server" />
    <asp:Button ID="btnSaveResult" runat="server" Text="Save Result" CssClass="hidden-server-control" OnClick="btnSaveResult_Click" />

    <button type="button" class="sidebar-toggle" onclick="toggleSidebar()" id="sidebarToggle">&lt;</button>

    <div class="dashboard-layout">

        <aside class="sidebar" id="sidebar">
            <a runat="server" id="lnkLogo" class="sidebar-logo">
                <img src="Images/OWI SPARKLE EYE BIG.png" alt="IndoSlang" style="width:40px; height:40px;" />
                IndoSlang
            </a>

            <nav class="sidebar-nav">
                <a runat="server" id="lnkDashboard" class="nav-link"><span class="nav-icon">&#x1F3E0;</span> Dashboard</a>
                <a href="Modules.aspx" class="nav-link active"><span class="nav-icon">&#x1F4DA;</span> My Modules</a>
                <a href="SlangDictionary.aspx" class="nav-link"><span class="nav-icon">&#x1F4D6;</span> Dictionary</a>
                <a href="CommunityChat.aspx" class="nav-link"><span class="nav-icon">&#x1F4AC;</span> Community Chat</a>
                <a href="BookSession.aspx" class="nav-link"><span class="nav-icon">&#x1F91D;</span> Book a Buddy</a>
                <a href="SessionHistory.aspx" class="nav-link"><span class="nav-icon">&#x1F550;</span> Session History</a>
                <a href="SuggestSlang.aspx" class="nav-link"><span class="nav-icon">&#x2728;</span> Suggest Slang</a>
                <hr class="sidebar-divider" />
                <a href="MemberProfile.aspx" class="nav-link"><span class="nav-icon">&#x1F464;</span> My Profile</a>
                <a href="ApplyBuddy.aspx" class="nav-link"><span class="nav-icon">&#x1F64B;</span> Apply as Buddy</a>
            </nav>
            <hr class="sidebar-divider" />
            <a href="Logout.aspx" class="nav-link signout"><span class="nav-icon">&#x1F6AA;</span> Sign Out</a>
        </aside>

        <div class="dashboard-main">
            <div class="topbar">
                <div class="topbar-left">
                    <a href="Modules.aspx" class="btn-back">← Modules</a>
                    <span class="topbar-title">Module 4</span>
                </div>
                <div class="topbar-user">
                    <div class="topbar-avatar">&#x1F464;</div>
                    <span id="topbarName">Member</span>
                </div>
            </div>

            <div class="module-content">

                <div class="intro-card" id="introCard">
                    <p class="intro-welcome">Welcome to</p>
                    <h1 class="intro-title">Level 2 - Elementary<br />Module 4 - Slang in Conversation</h1>
                    <p class="intro-sub">Time to level up &mdash; now you'll read slang inside full conversations.</p>
                    <p class="intro-desc">Module 4 puts slang into context. You'll read real chat exchanges and figure out what the highlighted word means from the conversation itself &mdash; no hints, just context clues.</p>
                    <p class="intro-desc">You'll also unscramble mixed-up chats and put them back in the right order. By the end, you'll start thinking in Indonesian slang, not just translating it.</p>
                    <button type="button" class="btn-start-quiz" onclick="startQuiz()">Got it, let's start!</button>
                </div>

                <div class="empty-card" id="emptyCard">
                    <strong>No questions found for Module 4.</strong><br />
                    Insert rows into the <strong>Question</strong> table where ModuleID belongs to Module 4.
                </div>

                <div id="quizBlock" style="display:none">
                    <div class="module-header">
                        <span class="module-badge">Module 4 &middot; Elementary</span>
                        <h1>Slang in Conversation</h1>
                        <p>Read real chat exchanges and understand the highlighted slang from context.</p>
                    </div>

                    <div class="progress-bar-wrap">
                        <div class="progress-bar-fill" id="progressFill" style="width:0%"></div>
                    </div>
                    <div class="progress-label">
                        <span id="progressLabel">Question 1 of 10</span>
                        <span id="progressPct">0%</span>
                    </div>

                    <div class="score-tracker" id="scoreDots"></div>

                    <div id="quizArea">
                        <div class="question-card" id="questionCard">
                            <div class="question-type-tag" id="qTypeTag"></div>
                            <div class="source-badge" id="sourceBadge" style="display:none;"></div>
                            <div class="question-context" id="qContext" style="display:none;"></div>
                            <img id="questionImage" class="question-image" alt="Question image" />
                            <div class="question-text" id="questionText"></div>
                            <div id="answerArea"></div>
                            <div class="feedback-msg" id="feedbackMsg"></div>
                            <div>
                                <button type="button" class="check-btn" id="checkBtn" onclick="checkAnswer()">Check ✓</button>
                                <button type="button" class="next-btn" id="nextBtn" onclick="nextQuestion()">Next →</button>
                            </div>
                        </div>
                    </div>
                </div>

                <div class="completion-card" id="completionCard">
                    <div class="score-circle">
                        <div class="score-circle-num" id="scoreNum">0</div>
                        <div class="score-circle-label" id="scoreOutOf">out of 10</div>
                    </div>
                    <p class="completion-main-msg" id="completionTitle"></p>
                    <p class="completion-sub-msg" id="completionMsg"></p>
                    <div class="result-actions">
                        <button type="button" class="btn-retry" id="btnTryAgain" onclick="restartQuiz()" style="display:none;">Try again</button>
                        <button type="button" class="btn-go-summary" onclick="showSummary()">Go to summary &#x2192;</button>
                    </div>
                </div>

                <div class="summary-card" id="summaryCard">
                    <h2 class="summary-title">You just completed Module 4!</h2>
                    <p class="summary-sub">Here are the slang words you practised in this module</p>
                    <div class="vocab-grid">
                        <div class="vocab-item"><span class="vocab-word">Baper</span><span class="vocab-meaning">Easily emotional</span></div>
                        <div class="vocab-item"><span class="vocab-word">Gokil</span><span class="vocab-meaning">Crazy / awesome</span></div>
                        <div class="vocab-item"><span class="vocab-word">Santuy</span><span class="vocab-meaning">Relaxed / chill</span></div>
                        <div class="vocab-item"><span class="vocab-word">Ngopi</span><span class="vocab-meaning">Hanging out over coffee</span></div>
                        <div class="vocab-item"><span class="vocab-word">Kepo</span><span class="vocab-meaning">Nosy / curious</span></div>
                        <div class="vocab-item"><span class="vocab-word">Mager</span><span class="vocab-meaning">Too lazy to move</span></div>
                        <div class="vocab-item"><span class="vocab-word">Bucin</span><span class="vocab-meaning">Lovesick / devoted</span></div>
                        <div class="vocab-item"><span class="vocab-word">Spill</span><span class="vocab-meaning">To reveal / share info</span></div>
                    </div>
                    <div class="summary-actions" id="summaryActions"></div>
                </div>

            </div>
        </div>
    </div>
</asp:Content>

<asp:Content ID="ScriptContent" ContentPlaceHolderID="ScriptContent" runat="server">
    <script>
        var userName = '<%= UserDisplayName %>';
        var questions = <%= QuestionsJson %>;

        document.getElementById('topbarName').textContent = userName || 'Member';

        function toggleSidebar() {
            var sidebar = document.getElementById('sidebar');
            var toggle = document.getElementById('sidebarToggle');
            sidebar.classList.toggle('collapsed');
            toggle.classList.toggle('collapsed');
            toggle.textContent = sidebar.classList.contains('collapsed') ? '\u203A' : '\u2039';
        }

        var PASS_SCORE = 8;
        var currentQ = 0;
        var score = 0;
        var answered = false;
        var answerRecords = [];

        function normalise(value) {
            return (value || '').toString().trim().toLowerCase();
        }

        function buildDots() {
            var container = document.getElementById('scoreDots');
            container.innerHTML = '';
            for (var i = 0; i < questions.length; i++) {
                var dot = document.createElement('div');
                dot.className = 'score-dot';
                dot.id = 'dot-' + i;
                container.appendChild(dot);
            }
        }

        function renderQuestion(index) {
            if (!questions || questions.length === 0) {
                document.getElementById('quizBlock').style.display = 'none';
                document.getElementById('emptyCard').style.display = 'block';
                return;
            }

            var q = questions[index];
            var data = q.QuestionData || {};
            answered = false;

            document.getElementById('progressLabel').textContent = 'Question ' + (index + 1) + ' of ' + questions.length;
            var pct = Math.round((index / questions.length) * 100);
            document.getElementById('progressPct').textContent = pct + '%';
            document.getElementById('progressFill').style.width = pct + '%';

            var _tl = { mcq: 'Multiple Choice', fill: 'Fill in the Blank', fill_blank: 'Fill in the Blank', translate: 'Translate', tf: 'True / False', true_false: 'True / False' };
            document.getElementById('qTypeTag').textContent = _tl[normalise(q.QuestionType)] || q.QuestionType || 'Multiple Choice';
            document.getElementById('questionText').textContent = data.question || data.questionText || 'Question text missing';
            document.getElementById('feedbackMsg').className = 'feedback-msg';
            document.getElementById('feedbackMsg').textContent = '';
            document.getElementById('checkBtn').style.display = 'inline-block';
            document.getElementById('nextBtn').style.display = 'none';

            var sourceBadge = document.getElementById('sourceBadge');
            if (data.source || data.sourceTitle) {
                sourceBadge.style.display = 'inline-block';
                sourceBadge.textContent = data.source || data.sourceTitle;
            } else {
                sourceBadge.style.display = 'none';
            }

            var contextBox = document.getElementById('qContext');
            if (data.chat && Array.isArray(data.chat)) {
                contextBox.style.display = 'block';
                contextBox.className = 'question-context chat-context';
                contextBox.innerHTML = '';
                contextBox.appendChild(renderChatWindow(data));
            } else if (data.context) {
                var parsed = parseChatMessages(data.context);
                if (parsed) {
                    contextBox.style.display = 'block';
                    contextBox.className = 'question-context chat-context';
                    contextBox.innerHTML = '';
                    contextBox.appendChild(renderChatWindow({ chat: parsed, highlight: data.highlight }));
                } else {
                    contextBox.style.display = 'block';
                    contextBox.className = 'question-context';
                    contextBox.textContent = data.context;
                }
            } else {
                contextBox.style.display = 'none';
                contextBox.className = 'question-context';
            }

            var image = document.getElementById('questionImage');
            if (data.image) {
                image.style.display = 'block';
                image.src = data.image;
            } else {
                image.style.display = 'none';
                image.removeAttribute('src');
            }

            renderAnswer(q, data);
        }

        function renderAnswer(q, data) {
            var answerArea = document.getElementById('answerArea');
            answerArea.innerHTML = '';
            var questionType = normalise(q.QuestionType);

            if (questionType === 'fill' || questionType === 'fill_blank' || questionType === 'translate') {
                var input = document.createElement('input');
                input.type = 'text';
                input.className = 'fill-blank-input';
                input.id = 'fillInput';
                input.placeholder = questionType === 'translate' ? 'Type your translation...' : 'Type your answer...';
                input.addEventListener('keydown', function (event) { if (event.key === 'Enter') checkAnswer(); });
                answerArea.appendChild(input);
                return;
            }

            if (questionType === 'tf' || questionType === 'true_false' || questionType === 'true/false') {
                var tfDiv = document.createElement('div');
                tfDiv.className = 'tf-options';
                var trueBtn = document.createElement('button');
                trueBtn.type = 'button'; trueBtn.className = 'tf-btn'; trueBtn.textContent = 'True ✓'; trueBtn.setAttribute('data-answer', 'true');
                var falseBtn = document.createElement('button');
                falseBtn.type = 'button'; falseBtn.className = 'tf-btn'; falseBtn.textContent = 'False ✗'; falseBtn.setAttribute('data-answer', 'false');
                trueBtn.onclick = selectTfOption;
                falseBtn.onclick = selectTfOption;
                tfDiv.appendChild(trueBtn); tfDiv.appendChild(falseBtn);
                answerArea.appendChild(tfDiv);
                return;
            }

            renderMcqQuestion(data);
        }

        function renderMcqQuestion(data) {
            var answerArea = document.getElementById('answerArea');
            var options = data.options || [];
            var div = document.createElement('div');
            div.className = 'mcq-options';
            for (var i = 0; i < options.length; i++) {
                var btn = document.createElement('button');
                btn.type = 'button'; btn.className = 'mcq-option'; btn.textContent = options[i];
                btn.setAttribute('data-index', i);
                btn.setAttribute('data-answer', options[i]);
                btn.setAttribute('data-letter', String.fromCharCode(65 + i));
                btn.onclick = function () {
                    if (!answered) {
                        document.querySelectorAll('.mcq-option').forEach(function (b) { b.classList.remove('selected'); });
                        this.classList.add('selected');
                    }
                };
                div.appendChild(btn);
            }
            answerArea.appendChild(div);
        }

        function selectTfOption() {
            if (answered) return;
            document.querySelectorAll('.tf-btn').forEach(function (btn) { btn.classList.remove('selected'); });
            this.classList.add('selected');
        }

        function isAnswerCorrect(selectedText, selectedLetter, correctAnswer) {
            return normalise(selectedText) === normalise(correctAnswer) || normalise(selectedLetter) === normalise(correctAnswer);
        }

        function checkAnswer() {
            if (answered) return;
            var q = questions[currentQ];
            var questionType = normalise(q.QuestionType);
            var feedback = document.getElementById('feedbackMsg');
            var selectedAnswer = '';
            var isCorrect = false;

            if (questionType === 'fill' || questionType === 'fill_blank' || questionType === 'translate') {
                var input = document.getElementById('fillInput');
                selectedAnswer = input.value.trim();
                isCorrect = normalise(selectedAnswer) === normalise(q.CorrectAnswer);
                input.classList.add(isCorrect ? 'correct' : 'wrong');
                input.disabled = true;

            } else if (questionType === 'tf' || questionType === 'true_false' || questionType === 'true/false') {
                var selectedTf = document.querySelector('.tf-btn.selected');
                if (!selectedTf) { feedback.className = 'feedback-msg wrong'; feedback.textContent = 'Please choose True or False.'; return; }
                selectedAnswer = selectedTf.getAttribute('data-answer');
                isCorrect = normalise(selectedAnswer) === normalise(q.CorrectAnswer);
                document.querySelectorAll('.tf-btn').forEach(function (btn) {
                    btn.disabled = true;
                    if (normalise(btn.getAttribute('data-answer')) === normalise(q.CorrectAnswer)) btn.classList.add('correct');
                    else if (btn.classList.contains('selected')) btn.classList.add('wrong');
                });

            } else {
                var selected = document.querySelector('.mcq-option.selected');
                if (!selected) { feedback.className = 'feedback-msg wrong'; feedback.textContent = 'Please select an option first.'; return; }
                selectedAnswer = selected.getAttribute('data-answer');
                var selectedLetter = selected.getAttribute('data-letter');
                isCorrect = isAnswerCorrect(selectedAnswer, selectedLetter, q.CorrectAnswer);
                document.querySelectorAll('.mcq-option').forEach(function (btn) {
                    btn.disabled = true;
                    if (isAnswerCorrect(btn.getAttribute('data-answer'), btn.getAttribute('data-letter'), q.CorrectAnswer)) btn.classList.add('correct');
                    else if (btn.classList.contains('selected')) btn.classList.add('wrong');
                });
            }

            if (isCorrect) score++;
            saveAnswerRecord(q.QuestionID, selectedAnswer, isCorrect);

            var dot = document.getElementById('dot-' + currentQ);
            if (dot) dot.classList.add(isCorrect ? 'correct' : 'wrong');

            answered = true;
            var data = q.QuestionData || {};
            feedback.className = 'feedback-msg ' + (isCorrect ? 'correct' : 'wrong');
            feedback.textContent = (isCorrect ? 'Correct. ' : 'Incorrect. ') + (data.explanation || '');
            document.getElementById('checkBtn').style.display = 'none';
            document.getElementById('nextBtn').style.display = 'inline-block';
        }

        function saveAnswerRecord(questionId, selectedAnswer, isCorrect) {
            answerRecords.push({ questionId: questionId, selectedAnswer: selectedAnswer, isCorrect: isCorrect });
        }

        function nextQuestion() {
            currentQ++;
            if (currentQ >= questions.length) showCompletion();
            else renderQuestion(currentQ);
        }

        var passedModule = false;

        function parseChatMessages(text) {
            var pattern = /([A-Z][a-z]*):\s/g;
            var matches = [];
            var m;
            while ((m = pattern.exec(text)) !== null) {
                matches.push({ name: m[1], msgStart: m.index + m[0].length });
            }
            if (matches.length < 2) return null;
            var speakerOrder = [];
            var messages = [];
            for (var i = 0; i < matches.length; i++) {
                var speaker = matches[i].name;
                var start = matches[i].msgStart;
                var end = i < matches.length - 1 ? matches[i + 1].msgStart - matches[i + 1].name.length - 2 : text.length;
                var msgText = text.slice(start, end).replace(/\s+$/, '');
                if (speakerOrder.indexOf(speaker) === -1) speakerOrder.push(speaker);
                var side = speakerOrder.indexOf(speaker) % 2 === 0 ? 'left' : 'right';
                messages.push({ side: side, name: speaker, text: msgText });
            }
            return messages;
        }

        function renderChatWindow(data) {
            var win = document.createElement('div');
            win.className = 'chat-window';
            if (data.chatTimestamp) {
                var ts = document.createElement('div');
                ts.className = 'chat-timestamp';
                ts.textContent = data.chatTimestamp;
                win.appendChild(ts);
            }
            var msgs = data.chat || [];
            var highlight = (data.highlight || '').toLowerCase();
            for (var i = 0; i < msgs.length; i++) {
                var m = msgs[i];
                var row = document.createElement('div');
                row.className = 'chat-msg ' + (m.side || 'left');
                if (m.name) {
                    var nm = document.createElement('div');
                    nm.className = 'chat-sender-name';
                    nm.textContent = m.name;
                    row.appendChild(nm);
                }
                var bubble = document.createElement('div');
                bubble.className = 'chat-bubble';
                var txt = m.text || '';
                if (highlight) {
                    bubble.innerHTML = txt.replace(new RegExp('(' + highlight.replace(/[.*+?^${}()|[\]\\]/g, '\\$&') + ')', 'gi'), '<span class="chat-highlight">$1</span>');
                } else {
                    bubble.textContent = txt;
                }
                row.appendChild(bubble);
                win.appendChild(row);
            }
            return win;
        }

        function showCompletion() {
            document.getElementById('quizArea').style.display = 'none';
            document.getElementById('progressFill').style.width = '100%';
            document.getElementById('progressPct').textContent = '100%';
            document.getElementById('progressLabel').textContent = 'Complete';

            passedModule = score >= PASS_SCORE;

            var card = document.getElementById('completionCard');
            card.style.display = 'block';

            document.getElementById('scoreNum').textContent = score;
            document.getElementById('scoreOutOf').textContent = 'out of ' + questions.length;

            if (passedModule) {
                document.getElementById('completionTitle').textContent = 'Great job! You passed!';
                document.getElementById('completionMsg').textContent = 'You got ' + score + ' out of ' + questions.length + ' correct. You\'re ready for the next level!';
                document.getElementById('btnTryAgain').style.display = 'none';
            } else {
                document.getElementById('completionTitle').textContent = 'Not quite there yet — give it another go!';
                document.getElementById('completionMsg').textContent = 'You got ' + score + ' out of ' + questions.length + ' correct. You need at least ' + PASS_SCORE + '/' + questions.length + ' to unlock Module 5. Review the slang you missed and try again — you\'re almost there!';
                document.getElementById('btnTryAgain').style.display = '';
            }
        }

        function showSummary() {
            document.getElementById('completionCard').style.display = 'none';
            document.getElementById('summaryCard').style.display = 'block';
            var actions = document.getElementById('summaryActions');
            actions.innerHTML = '';
            if (passedModule) {
                var btn = document.createElement('button');
                btn.type = 'button'; btn.className = 'btn-next-module'; btn.textContent = 'Go to Module 5 →';
                btn.onclick = saveModuleResult;
                actions.appendChild(btn);
            } else {
                var btn = document.createElement('button');
                btn.type = 'button'; btn.className = 'btn-retry-summary'; btn.textContent = 'Try again';
                btn.onclick = restartQuiz;
                actions.appendChild(btn);
            }
        }

        function saveModuleResult() {
            document.getElementById('<%= hfScore.ClientID %>').value = score;
            document.getElementById('<%= hfPassed.ClientID %>').value = passedModule ? 'true' : 'false';
            document.getElementById('<%= hfAnswersJson.ClientID %>').value = JSON.stringify(answerRecords);
            document.getElementById('<%= btnSaveResult.ClientID %>').click();
        }

        function restartQuiz() {
            currentQ = 0; score = 0; answered = false; answerRecords = []; passedModule = false;
            document.getElementById('quizArea').style.display = 'block';
            document.getElementById('completionCard').style.display = 'none';
            document.getElementById('summaryCard').style.display = 'none';
            buildDots();
            renderQuestion(0);
        }

        function startQuiz() {
            document.getElementById('introCard').style.display = 'none';
            document.getElementById('quizBlock').style.display = 'block';
        }

        buildDots();
        renderQuestion(0);
    </script>
</asp:Content>