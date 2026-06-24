<%@ Page Title="Module 2 — Beginner" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Module2.aspx.cs" Inherits="IndoSlang.Module2" %>

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

        /* Intro */
        .intro-card { display: flex; flex-direction: column; align-items: center; justify-content: center; text-align: center; padding: 60px 40px; max-width: 720px; margin: 0 auto; }
        .intro-welcome { font-family: var(--font-display); font-size: 1.2rem; color: var(--brown-mid); font-weight: 400; margin: 0 0 6px; }
        .intro-title { font-family: var(--font-display); font-size: 1.9rem; color: var(--brown); font-weight: 700; margin: 0 0 24px; line-height: 1.35; }
        .intro-sub { font-family: var(--font-display); font-size: 1rem; color: var(--brown); font-weight: 700; margin: 0 0 16px; }
        .intro-desc { font-size: 0.93rem; color: var(--brown-mid); margin: 0 0 12px; line-height: 1.7; max-width: 600px; }
        .btn-start-quiz { background: #fff; color: var(--brown); border: 2px solid var(--brown-mid); padding: 13px 36px; border-radius: 999px; font-family: var(--font-display); font-size: 1rem; cursor: pointer; margin-top: 20px; transition: background 0.2s, color 0.2s; }
        .btn-start-quiz:hover { background: var(--brown); color: #fff; border-color: var(--brown); }

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
        .question-text { font-family: var(--font-display); font-size: 1.28rem; margin-bottom: 22px; line-height: 1.45; color: var(--brown); }
        .mcq-options { display: flex; flex-direction: column; gap: 10px; }
        .mcq-option { background: var(--cream); border: 2px solid var(--cream-mid); border-radius: 14px; padding: 13px 18px; cursor: pointer; font-size: 0.95rem; transition: border-color 0.2s, background 0.2s; text-align: left; color: var(--brown); font-family: var(--font-body); }
        .mcq-option:hover { border-color: var(--accent); background: #fdf4ea; }
        .mcq-option.selected { border-color: var(--accent); background: #fce9d0; }
        .mcq-option.correct { border-color: var(--green); background: #d4edda; }
        .mcq-option.wrong { border-color: #c0392b; background: #fde8e8; }
        .tf-options { display: flex; gap: 14px; }
        .tf-btn { flex: 1; padding: 14px; border-radius: 14px; border: 2px solid var(--cream-mid); background: var(--cream); font-family: var(--font-display); font-size: 1.05rem; cursor: pointer; color: var(--brown); transition: border-color 0.2s, background 0.2s; }
        .tf-btn:hover { border-color: var(--accent); }
        .tf-btn.selected { border-color: var(--accent); background: #fce9d0; }
        .tf-btn.correct { border-color: var(--green); background: #d4edda; }
        .tf-btn.wrong { border-color: #c0392b; background: #fde8e8; }
        .feedback-msg { margin-top: 14px; padding: 11px 16px; border-radius: 12px; font-size: 0.92rem; display: none; line-height: 1.5; }
        .feedback-msg.correct { background: #d4edda; color: #1a5c2a; display: block; }
        .feedback-msg.wrong { background: #fde8e8; color: #7b1515; display: block; }
        .btn-check, .btn-next { color: #fff; border: none; padding: 12px 28px; border-radius: 13px; font-family: var(--font-display); font-size: 1rem; cursor: pointer; transition: background 0.2s, transform 0.15s; margin-top: 14px; }
        .btn-check { background: var(--accent); }
        .btn-check:hover { background: var(--accent-light); transform: translateY(-2px); }
        .btn-next { background: var(--brown); display: none; margin-left: 8px; }
        .btn-next:hover { background: var(--brown-mid); transform: translateY(-2px); }
        .completion-card { display: none; text-align: center; background: #fff; border: 1.5px solid var(--cream-mid); border-radius: 18px; padding: 48px 40px 40px; max-width: 620px; margin: 0 auto; }
        .score-circle { width: 160px; height: 160px; border-radius: 50%; border: 3px solid var(--brown); display: flex; flex-direction: column; align-items: center; justify-content: center; margin: 0 auto 32px; }
        .score-circle-num { font-family: var(--font-display); font-size: 3.2rem; font-weight: 700; color: var(--brown); line-height: 1; }
        .score-circle-label { font-size: 0.85rem; color: var(--brown-mid); margin-top: 4px; }
        .completion-main-msg { font-family: var(--font-display); font-size: 1.4rem; font-weight: 700; color: var(--brown); margin: 0 0 12px; }
        .completion-sub-msg { font-size: 0.95rem; color: var(--brown-mid); line-height: 1.65; margin: 0 0 28px; }
        .result-actions { display: flex; justify-content: center; gap: 12px; flex-wrap: wrap; }
        .btn-retry { background: var(--cream-mid); color: var(--brown); border: 2px solid var(--brown-mid); padding: 12px 26px; border-radius: 13px; font-family: var(--font-display); font-size: 1rem; cursor: pointer; }
        .btn-go-summary { background: var(--brown); color: #fff; border: none; padding: 12px 26px; border-radius: 13px; font-family: var(--font-display); font-size: 1rem; cursor: pointer; transition: background 0.15s; }
        .btn-go-summary:hover { background: var(--brown-mid); }
        .hidden-server-control { display: none; }
        .summary-card { display: none; background: #fff; border: 1.5px solid var(--cream-mid); border-radius: 18px; padding: 44px 48px 40px; max-width: 780px; margin: 0 auto; text-align: center; }
        .summary-congrats { font-family: var(--font-display); font-size: 1.75rem; font-weight: 700; color: var(--brown); margin-bottom: 12px; line-height: 1.3; }
        .summary-sub { font-size: 0.95rem; color: var(--brown-mid); line-height: 1.65; margin-bottom: 28px; font-style: italic; }
        .summary-word-grid { display: grid; grid-template-columns: 1fr 1fr; gap: 10px 48px; text-align: left; margin: 0 auto 28px; max-width: 560px; }
        .summary-word-row { display: flex; gap: 16px; align-items: baseline; padding: 6px 0; }
        .summary-word-key { font-family: var(--font-display); font-size: 1.05rem; font-weight: 700; color: var(--brown); min-width: 80px; }
        .summary-word-val { font-size: 0.9rem; color: var(--brown-mid); font-style: italic; }
        .summary-footer-note { font-style: italic; font-size: 0.92rem; color: var(--brown-mid); margin-bottom: 24px; }
        .btn-next-level { background: var(--brown); color: #fff; border: none; border-radius: 13px; padding: 13px 32px; font-family: var(--font-display); font-size: 1rem; cursor: pointer; transition: background 0.2s; }
        .btn-next-level:hover { background: var(--brown-mid); }
    </style>
</asp:Content>

<asp:Content ID="MainContent" ContentPlaceHolderID="MainContent" runat="server">

    <asp:HiddenField ID="hfScore" runat="server" />
    <asp:HiddenField ID="hfPassed" runat="server" />
    <asp:HiddenField ID="hfAnswersJson" runat="server" />
    <asp:Button ID="btnSaveResult" runat="server" Text="Save Result" CssClass="hidden-server-control" OnClick="btnSaveResult_Click" />

    <button type="button" class="sidebar-toggle" onclick="toggleSidebar()" id="sidebarToggle">&#8249;</button>

    <div class="dashboard-layout">
        <aside class="sidebar" id="sidebar">
            <a runat="server" id="lnkLogo" class="sidebar-logo">
                <img src="Images/OWI SPARKLE EYE BIG.png" alt="IndoSlang" />
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
                    <a href="Modules.aspx" class="btn-back">&#8592; Modules</a>
                    <span class="topbar-title">Module 2</span>
                </div>
                <div class="topbar-user">
                    <div class="topbar-avatar">&#x1F464;</div>
                    <span id="topbarName">Member</span>
                </div>
            </div>

            <div class="module-content">

                <!-- Intro Screen -->
                <div class="intro-card" id="introCard">
                    <p class="intro-welcome">Welcome to</p>
                    <h1 class="intro-title">Level 1 - Beginner<br />Module 2 - Test the Words</h1>
                    <p class="intro-sub">You&apos;ve started your IndoSlang journey &mdash; now it&apos;s time to see how much you remember!</p>
                    <p class="intro-desc">This module will review the 5 slang words from Module 1 to check your knowledge, and then introduce 5 brand-new words through fun context clues. Even if the words are new, the sentences will guide you to figure them out naturally.</p>
                    <button type="button" class="btn-start-quiz" onclick="startQuiz()">Got it, let&apos;s start!</button>
                </div>

                <!-- Quiz Block (hidden until startQuiz) -->
                <div id="quizBlock" style="display:none;">
                    <div class="module-header">
                        <span class="module-badge">Module 2 &middot; Beginner</span>
                        <h1>Mixed Quiz</h1>
                        <p>Test your knowledge from Module 1 and learn 5 new slang words through 10 interactive questions.</p>
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
                            <div class="question-text" id="questionText"></div>
                            <div id="answerArea"></div>
                            <div class="feedback-msg" id="feedbackMsg"></div>
                            <div>
                                <button type="button" class="btn-check" id="checkBtn" onclick="checkAnswer()">Check &#x2713;</button>
                                <button type="button" class="btn-next" id="nextBtn" onclick="nextQuestion()">Next &#x2192;</button>
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
                    <div class="result-actions" id="completionActions"></div>
                </div>

                <div class="summary-card" id="summaryCard">
                    <div class="summary-congrats">Congrats! You&apos;ve unlocked your first slang set.</div>
                    <p class="summary-sub">You&apos;ve mastered your first set of Indonesian slang &mdash; from the basics to figuring out new words in context.</p>
                    <div class="summary-word-grid">
                        <div class="summary-word-row"><span class="summary-word-key">Gabut</span><span class="summary-word-val">Bored with nothing to do</span></div>
                        <div class="summary-word-row"><span class="summary-word-key">Seru</span><span class="summary-word-val">Fun / exciting</span></div>
                        <div class="summary-word-row"><span class="summary-word-key">Mager</span><span class="summary-word-val">Too lazy to move</span></div>
                        <div class="summary-word-row"><span class="summary-word-key">Capek</span><span class="summary-word-val">Tired / worn out</span></div>
                        <div class="summary-word-row"><span class="summary-word-key">Santuy</span><span class="summary-word-val">Chill / relaxed</span></div>
                        <div class="summary-word-row"><span class="summary-word-key">Baper</span><span class="summary-word-val">Too emotional</span></div>
                        <div class="summary-word-row"><span class="summary-word-key">Yuk</span><span class="summary-word-val">Let&apos;s go!</span></div>
                        <div class="summary-word-row"><span class="summary-word-key">Gak</span><span class="summary-word-val">No / not</span></div>
                        <div class="summary-word-row"><span class="summary-word-key">Oke</span><span class="summary-word-val">Okay / sure</span></div>
                        <div class="summary-word-row"><span class="summary-word-key">Wkwk</span><span class="summary-word-val">Hahaha / lol</span></div>
                    </div>
                    <p class="summary-footer-note">You&apos;re officially done with Level 1 &ndash; Beginner.</p>
                    <div id="summaryActions"></div>
                </div>

            </div>
        </div>
    </div>
</asp:Content>

<asp:Content ID="ScriptContent" ContentPlaceHolderID="ScriptContent" runat="server">
    <script>
        var userName = '<%= HttpUtility.JavaScriptStringEncode(Session["UserName"] == null ? "Member" : Session["UserName"].ToString()) %>';
        document.getElementById('topbarName').textContent = userName;

        var questions = <%= QuestionsJson %>;
        var PASS_SCORE = 7;
        var currentQ = 0;
        var score = 0;
        var answered = false;
        var answerLog = [];

        function toggleSidebar() {
            var sidebar = document.getElementById('sidebar');
            var toggle = document.getElementById('sidebarToggle');
            sidebar.classList.toggle('collapsed');
            toggle.classList.toggle('collapsed');
            toggle.textContent = sidebar.classList.contains('collapsed') ? '\u203A' : '\u2039';
        }

        function startQuiz() {
            document.getElementById('introCard').style.display = 'none';
            document.getElementById('quizBlock').style.display = 'block';
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
            if (!questions || questions.length === 0) return;
            var q = questions[index];
            answered = false;
            document.getElementById('progressLabel').textContent = 'Question ' + (index + 1) + ' of ' + questions.length;
            document.getElementById('progressPct').textContent = Math.round((index / questions.length) * 100) + '%';
            document.getElementById('progressFill').style.width = ((index / questions.length) * 100) + '%';
            var _tl = { mcq: 'Multiple Choice', tf: 'True / False' };
            document.getElementById('qTypeTag').textContent = _tl[q.QuestionType.toLowerCase()] || q.QuestionType;
            document.getElementById('questionText').textContent = q.QuestionData.question;
            document.getElementById('feedbackMsg').className = 'feedback-msg';
            document.getElementById('feedbackMsg').textContent = '';
            document.getElementById('checkBtn').style.display = 'inline-block';
            document.getElementById('nextBtn').style.display = 'none';

            var answerArea = document.getElementById('answerArea');
            answerArea.innerHTML = '';

            if (q.QuestionType.toLowerCase() === 'mcq') {
                var div = document.createElement('div');
                div.className = 'mcq-options';
                q.QuestionData.options.forEach(function (opt) {
                    var btn = document.createElement('button');
                    btn.type = 'button'; btn.className = 'mcq-option'; btn.textContent = opt;
                    btn.onclick = function () {
                        if (!answered) {
                            document.querySelectorAll('.mcq-option').forEach(function (b) { b.classList.remove('selected'); });
                            btn.classList.add('selected');
                        }
                    };
                    div.appendChild(btn);
                });
                answerArea.appendChild(div);
            } else if (q.QuestionType.toLowerCase() === 'tf') {
                var tfDiv = document.createElement('div');
                tfDiv.className = 'tf-options';
                [{ label: 'True \u2713', val: 'true' }, { label: 'False \u2717', val: 'false' }].forEach(function (item) {
                    var btn = document.createElement('button');
                    btn.type = 'button'; btn.className = 'tf-btn'; btn.textContent = item.label;
                    btn.setAttribute('data-value', item.val);
                    btn.onclick = function () {
                        if (!answered) {
                            document.querySelectorAll('.tf-btn').forEach(function (b) { b.classList.remove('selected'); });
                            btn.classList.add('selected');
                        }
                    };
                    tfDiv.appendChild(btn);
                });
                answerArea.appendChild(tfDiv);
            }
        }

        function checkAnswer() {
            if (answered) return;
            var q = questions[currentQ];
            var isCorrect = false;
            var userAnswer = '';
            var feedback = document.getElementById('feedbackMsg');

            if (q.QuestionType.toLowerCase() === 'mcq') {
                var selected = document.querySelector('.mcq-option.selected');
                if (!selected) { feedback.className = 'feedback-msg wrong'; feedback.textContent = 'Please select an option!'; return; }
                userAnswer = selected.textContent.trim();
                isCorrect = userAnswer === q.CorrectAnswer.trim();
                document.querySelectorAll('.mcq-option').forEach(function (b) {
                    if (b.textContent.trim() === q.CorrectAnswer.trim()) b.classList.add('correct');
                    else if (b.classList.contains('selected')) b.classList.add('wrong');
                });
            } else if (q.QuestionType.toLowerCase() === 'tf') {
                var selectedTF = document.querySelector('.tf-btn.selected');
                if (!selectedTF) { feedback.className = 'feedback-msg wrong'; feedback.textContent = 'Please select True or False!'; return; }
                userAnswer = selectedTF.getAttribute('data-value');
                isCorrect = userAnswer === q.CorrectAnswer.toLowerCase().trim();
                document.querySelectorAll('.tf-btn').forEach(function (b) {
                    if (b.getAttribute('data-value') === q.CorrectAnswer.toLowerCase().trim()) b.classList.add('correct');
                    else if (b.classList.contains('selected')) b.classList.add('wrong');
                });
            }

            if (isCorrect) score++;
            answerLog.push({ questionId: q.QuestionID, selectedAnswer: userAnswer, isCorrect: isCorrect });
            var dot = document.getElementById('dot-' + currentQ);
            if (dot) dot.classList.add(isCorrect ? 'correct' : 'wrong');
            answered = true;
            feedback.className = 'feedback-msg ' + (isCorrect ? 'correct' : 'wrong');
            feedback.textContent = (isCorrect ? '\u2705 Correct! ' : '\u274C Incorrect. ') + (q.QuestionData.explanation || '');
            document.getElementById('checkBtn').style.display = 'none';
            document.getElementById('nextBtn').style.display = 'inline-block';
        }

        function nextQuestion() {
            currentQ++;
            if (currentQ >= questions.length) showCompletion();
            else renderQuestion(currentQ);
        }

        function showCompletion() {
            document.getElementById('quizArea').style.display = 'none';
            document.getElementById('progressFill').style.width = '100%';
            document.getElementById('progressLabel').textContent = 'Complete';
            document.getElementById('progressPct').textContent = '100%';
            var passed = score >= PASS_SCORE;
            document.getElementById('scoreNum').textContent = score;
            document.getElementById('scoreOutOf').textContent = 'out of ' + questions.length;
            document.getElementById('completionCard').style.display = 'block';

            if (passed) {
                document.getElementById('completionTitle').textContent = 'Well done! You passed Module 2.';
                document.getElementById('completionMsg').textContent = 'You got ' + score + ' out of ' + questions.length + ' correct. You\'re reading Indonesian slang in context like a local!';
            } else {
                document.getElementById('completionTitle').textContent = 'Not quite there yet \u2014 give it another go!';
                document.getElementById('completionMsg').textContent = 'You got ' + score + ' out of ' + questions.length + ' correct. You need at least ' + PASS_SCORE + '/10 to move on. Try again!';
            }

            var actions = document.getElementById('completionActions');
            actions.innerHTML = '';
            var retryBtn = document.createElement('button');
            retryBtn.type = 'button'; retryBtn.className = 'btn-retry'; retryBtn.textContent = 'Try again';
            retryBtn.onclick = restartQuiz;
            actions.appendChild(retryBtn);
            var sumBtn = document.createElement('button');
            sumBtn.type = 'button'; sumBtn.className = 'btn-go-summary'; sumBtn.textContent = 'Go to summary \u2192';
            sumBtn.onclick = function () { showSummary(passed); };
            actions.appendChild(sumBtn);
        }

        function showSummary(passed) {
            document.getElementById('completionCard').style.display = 'none';
            document.getElementById('summaryCard').style.display = 'block';
            var actions = document.getElementById('summaryActions');
            actions.innerHTML = '';
            if (passed) {
                var nextBtn = document.createElement('button');
                nextBtn.type = 'button'; nextBtn.className = 'btn-next-level'; nextBtn.textContent = 'Go to Level 2 \u2192';
                nextBtn.onclick = submitResult;
                actions.appendChild(nextBtn);
            } else {
                var retryBtn = document.createElement('button');
                retryBtn.type = 'button'; retryBtn.className = 'btn-next-level'; retryBtn.textContent = 'Try Again';
                retryBtn.onclick = restartQuiz;
                actions.appendChild(retryBtn);
            }
        }

        function submitResult() {
            document.getElementById('<%= hfScore.ClientID %>').value = score;
            document.getElementById('<%= hfPassed.ClientID %>').value = (score >= PASS_SCORE) ? 'true' : 'false';
            document.getElementById('<%= hfAnswersJson.ClientID %>').value = JSON.stringify(answerLog);
            document.getElementById('<%= btnSaveResult.ClientID %>').click();
        }

        function restartQuiz() {
            currentQ = 0; score = 0; answered = false; answerLog = [];
            buildDots();
            document.getElementById('quizArea').style.display = 'block';
            document.getElementById('completionCard').style.display = 'none';
            document.getElementById('summaryCard').style.display = 'none';
            document.getElementById('progressLabel').textContent = 'Question 1 of ' + questions.length;
            document.getElementById('progressPct').textContent = '0%';
            renderQuestion(0);
        }

        buildDots();
        renderQuestion(0);
    </script>
</asp:Content>
