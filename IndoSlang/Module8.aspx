<%@ Page Title="Module 8 — Final Challenge" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Module8.aspx.cs" Inherits="IndoSlang.Module8" %>

<asp:Content ID="HeadContent" ContentPlaceHolderID="HeadContent" runat="server">
    <style>
        .navbar { display: none !important; }
        .site-footer { display: none !important; }
        .site-main { padding: 0 !important; margin: 0 !important; }
        body { margin: 0; padding: 0; overflow: hidden; }

        .dashboard-layout {
            display: flex;
            height: 100vh;
            overflow: hidden;
        }

        .sidebar {
            width: 260px;
            min-width: 260px;
            background: var(--brown);
            color: #fff;
            display: flex;
            flex-direction: column;
            padding: 32px 0 24px;
            height: 100vh;
            overflow: hidden;
            overflow-x: hidden;
            flex-shrink: 0;
            transition: width 0.3s ease, min-width 0.3s ease;
        }

        .sidebar.collapsed {
            width: 0;
            min-width: 0;
            overflow: hidden;
        }

        .sidebar-logo {
            display: flex;
            align-items: center;
            gap: 10px;
            padding: 0 24px 32px;
            font-family: var(--font-display);
            font-size: 1.3rem;
            color: #fff;
            text-decoration: none;
            white-space: nowrap;
        }

        .sidebar-logo img {
            width: 38px;
            height: 38px;
            border-radius: 50%;
            flex-shrink: 0;
        }

        .sidebar-nav { flex: 1; overflow-y: auto; min-height: 0; }

        .nav-link {
            display: flex;
            align-items: center;
            gap: 10px;
            padding: 10px 24px;
            color: rgba(255,255,255,0.75);
            text-decoration: none;
            font-size: 0.92rem;
            border-left: 3px solid transparent;
            transition: background 0.15s, color 0.15s, border-color 0.15s;
            white-space: nowrap;
        }

        .nav-link:hover {
            background: rgba(255,255,255,0.08);
            color: #fff;
        }

        .nav-link.active {
            background: rgba(255,255,255,0.12);
            color: #fff;
            border-left-color: var(--accent);
            font-weight: 700;
        }

        .nav-icon {
            font-size: 1rem;
            width: 20px;
            text-align: center;
            flex-shrink: 0;
        }

        .sidebar-divider {
            border: none;
            border-top: 1px solid rgba(255,255,255,0.12);
            margin: 16px 24px;
        }

        .nav-link.signout {
            color: rgba(255,255,255,0.45);
        }

        .nav-link.signout:hover {
            color: #ff8a8a;
            background: rgba(255,100,100,0.08);
        }

        .sidebar-toggle {
            position: fixed;
            left: 244px;
            top: 50vh;
            transform: translateY(-50%);
            width: 28px;
            height: 28px;
            background: var(--brown);
            border: 2px solid rgba(255,255,255,0.25);
            border-radius: 50%;
            color: #fff;
            cursor: pointer;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 0.8rem;
            z-index: 9999;
            transition: left 0.3s ease, background 0.2s;
        }

        .sidebar-toggle:hover { background: var(--brown-mid); }
        .sidebar-toggle.collapsed { left: 0; }

        .dashboard-main {
            flex: 1;
            display: flex;
            flex-direction: column;
            height: 100vh;
            overflow: hidden;
            min-width: 0;
        }

        .topbar {
            background: var(--cream);
            border-bottom: 2px solid var(--cream-mid);
            padding: 16px 34px;
            display: flex;
            align-items: center;
            justify-content: space-between;
            flex-shrink: 0;
        }

        .topbar-left {
            display: flex;
            align-items: center;
            gap: 14px;
        }

        .btn-back {
            display: inline-flex;
            align-items: center;
            gap: 6px;
            background: var(--cream-mid);
            border: none;
            border-radius: 10px;
            padding: 8px 15px;
            font-family: var(--font-body);
            font-size: 0.85rem;
            color: var(--brown);
            cursor: pointer;
            text-decoration: none;
            font-weight: 700;
            transition: background 0.2s;
        }

        .btn-back:hover { background: #e8ddd0; }

        .topbar-title {
            font-family: var(--font-display);
            font-size: 1.55rem;
            color: var(--brown);
            font-weight: 700;
        }

        .topbar-user {
            display: flex;
            align-items: center;
            gap: 10px;
            color: var(--brown);
            font-weight: 700;
            font-size: 0.92rem;
        }

        .topbar-avatar {
            width: 38px;
            height: 38px;
            border-radius: 50%;
            background: var(--brown-mid);
            display: flex;
            align-items: center;
            justify-content: center;
            color: #fff;
            font-size: 1.1rem;
        }

        .module-content {
            flex: 1;
            overflow-y: auto;
            padding: 38px 46px 70px;
            background: var(--cream);
            font-family: var(--font-body);
            color: var(--brown);
        }

        .module-header {
            margin-bottom: 28px;
        }

        .module-badge {
            display: inline-block;
            background: var(--brown);
            color: #fff;
            font-family: var(--font-display);
            font-size: 0.85rem;
            padding: 5px 15px;
            border-radius: 999px;
            margin-bottom: 10px;
        }

        .module-header h1 {
            font-family: var(--font-display);
            font-size: 2rem;
            margin: 0 0 6px;
            color: var(--brown);
        }

        .module-header p {
            color: var(--brown-mid);
            font-size: 0.94rem;
            margin: 0;
            line-height: 1.6;
        }

        .progress-bar-wrap {
            background: var(--cream-mid);
            border-radius: 999px;
            height: 10px;
            margin-bottom: 8px;
            overflow: hidden;
           
        }

        .progress-bar-fill {
            height: 100%;
            background: var(--brown);
            border-radius: 999px;
            transition: width 0.4s ease;
        }

        .progress-label {
            display: flex;
            justify-content: space-between;
            font-size: 0.82rem;
            color: var(--brown-mid);
            margin-bottom: 22px;
           
        }

        .timer-wrap {
            display: flex;
            align-items: center;
            gap: 10px;
            margin-bottom: 18px;
        }

        .timer-badge {
            background: var(--brown);
            color: #fff;
            font-family: var(--font-display);
            font-size: 1.05rem;
            font-weight: 700;
            padding: 8px 18px;
            border-radius: 999px;
            min-width: 82px;
            text-align: center;
            transition: background 0.3s;
        }

        .timer-badge.warning { background: var(--accent); }
        .timer-badge.danger { background: #c0392b; }

        .timer-label {
            font-size: 0.82rem;
            color: var(--brown-mid);
            font-weight: 700;
        }

        .question-card {
            background: #fff;
            border: 2px solid var(--cream-mid);
            border-radius: 22px;
            padding: 32px 30px;
            box-shadow: 0 6px 22px rgba(59,42,26,0.09);
            margin: 0 auto 20px;
            max-width: 780px;
        }

        .question-type-tag {
            font-size: 0.75rem;
            font-weight: 800;
            text-transform: uppercase;
            letter-spacing: 1px;
            color: var(--brown);
            margin-bottom: 10px;
        }

        .scenario-badge {
            display: inline-block;
            background: var(--accent);
            color: #fff;
            font-size: 0.78rem;
            font-weight: 800;
            padding: 4px 13px;
            border-radius: 999px;
            margin-bottom: 12px;
            font-family: var(--font-display);
        }

        .question-context {
            background: var(--cream-mid);
            border-left: 4px solid var(--brown);
            padding: 11px 16px;
            border-radius: 0 12px 12px 0;
            font-style: italic;
            font-size: 0.92rem;
            color: var(--brown-mid);
            margin-bottom: 18px;
            line-height: 1.6;
        }

        .question-text {
            font-family: var(--font-display);
            font-size: 1.3rem;
            margin-bottom: 22px;
            line-height: 1.45;
            color: var(--brown);
        }

        .mcq-options {
            display: flex;
            flex-direction: column;
            gap: 10px;
        }

        .mcq-option {
            background: var(--cream);
            border: 2px solid var(--cream-mid);
            border-radius: 14px;
            padding: 13px 18px;
            cursor: pointer;
            font-size: 0.95rem;
            transition: border-color 0.2s, background 0.2s;
            text-align: left;
            color: var(--brown);
            font-family: var(--font-body);
        }

        .mcq-option:hover {
            border-color: var(--accent);
            background: #fdf4ea;
        }

        .mcq-option.selected {
            border-color: var(--accent);
            background: #fce9d0;
        }

        .mcq-option.correct {
            border-color: var(--green);
            background: #d4edda;
        }

        .mcq-option.wrong {
            border-color: #c0392b;
            background: #fde8e8;
        }

        .feedback-msg {
            margin-top: 14px;
            padding: 11px 16px;
            border-radius: 12px;
            font-size: 0.92rem;
            display: none;
            line-height: 1.5;
        }

        .feedback-msg.correct {
            background: #d4edda;
            color: #1a5c2a;
            display: block;
        }

        .feedback-msg.wrong {
            background: #fde8e8;
            color: #7b1515;
            display: block;
        }

        .quiz-nav {
            display: flex;
            justify-content: flex-end;
            gap: 12px;
            margin-top: 8px;
            max-width: 780px;
        }

        .btn-check,
        .btn-next {
            color: #fff;
            border: none;
            padding: 12px 28px;
            border-radius: 13px;
            font-family: var(--font-display);
            font-size: 1rem;
            cursor: pointer;
            transition: background 0.2s, transform 0.15s;
        }

        .btn-check {
            background: var(--accent);
        }

        .btn-check:hover {
            background: var(--accent-light);
            transform: translateY(-2px);
        }

        .btn-next {
            background: var(--brown);
            display: none;
        }

        .btn-next:hover {
            background: var(--brown-mid);
            transform: translateY(-2px);
        }

        .completion-card {
            display: none;
            text-align: center;
            background: var(--cream);
            border: 1.5px solid var(--cream-mid);
            border-radius: 18px;
            padding: 48px 40px 40px;
            max-width: 780px;
            margin: 0 auto;
        }

        .score-circle {
            width: 160px;
            height: 160px;
            border-radius: 50%;
            border: 3px solid var(--brown);
            display: flex;
            flex-direction: column;
            align-items: center;
            justify-content: center;
            margin: 0 auto 32px;
        }

        .score-circle-num {
            font-family: var(--font-display);
            font-size: 3.2rem;
            font-weight: 700;
            color: var(--brown);
            line-height: 1;
        }

        .score-circle-label {
            font-size: 0.85rem;
            color: var(--brown-mid);
            margin-top: 4px;
        }

        .completion-main-msg {
            font-family: var(--font-display);
            font-size: 1.4rem;
            font-weight: 700;
            color: var(--brown);
            margin: 0 0 12px;
        }

        .completion-sub-msg {
            font-size: 0.95rem;
            color: var(--brown-mid);
            line-height: 1.65;
            margin: 0 0 28px;
        }

        .result-actions { display: flex; justify-content: center; gap: 12px; flex-wrap: wrap; }

        .btn-retry {
            background: #fff;
            color: var(--brown);
            border: 2px solid var(--brown);
            padding: 12px 28px;
            border-radius: 40px;
            font-family: var(--font-display);
            font-size: 0.95rem;
            font-weight: 700;
            cursor: pointer;
            transition: background 0.15s, color 0.15s;
        }

        .btn-retry:hover { background: var(--cream-mid); }

        .btn-summary {
            background: var(--brown);
            color: #fff;
            border: 2px solid var(--brown);
            padding: 12px 28px;
            border-radius: 40px;
            font-family: var(--font-display);
            font-size: 0.95rem;
            font-weight: 700;
            cursor: pointer;
            transition: background 0.15s;
        }

        .btn-summary:hover { background: var(--brown-mid); border-color: var(--brown-mid); }

        /* Summary Card */
        .summary-card { display: none; background: var(--cream); border: 1.5px solid var(--cream-mid); border-radius: 18px; padding: 40px 48px; max-width: 780px; margin: 0 auto; text-align: center; }
        .summary-title { font-family: var(--font-display); font-size: 2rem; font-weight: 700; color: var(--brown); margin: 0 0 12px; }
        .summary-subtitle { font-size: 0.95rem; color: var(--brown-mid); font-style: italic; margin: 0 0 32px; line-height: 1.6; }
        .slang-grid { display: grid; grid-template-columns: 1fr 1fr; gap: 10px 48px; max-width: 600px; margin: 0 auto 28px; text-align: left; }
        .slang-row { display: flex; align-items: baseline; gap: 12px; }
        .slang-word { font-family: var(--font-display); font-size: 1.1rem; font-weight: 700; color: var(--brown); min-width: 80px; }
        .slang-meaning { font-size: 0.88rem; color: var(--brown-mid); font-style: italic; }
        .summary-footer { font-size: 0.92rem; color: var(--brown-mid); font-style: italic; font-weight: 700; margin-bottom: 24px; }
        .btn-go-dashboard { background: var(--brown); color: #fff; border: none; padding: 13px 30px; border-radius: 40px; font-family: var(--font-display); font-size: 1rem; font-weight: 700; cursor: pointer; transition: background 0.15s; }
        .btn-go-dashboard:hover { background: var(--brown-mid); }

        /* Welcome / Intro Screen */
        .welcome-screen { max-width: 680px; margin: 30px auto; text-align: center; padding: 50px 44px; }
        .welcome-screen h2 { font-family: var(--font-display); font-size: 2rem; color: var(--brown); margin: 0 0 12px; line-height: 1.3; }
        .welcome-screen .subtitle { font-family: var(--font-display); font-size: 1.05rem; color: var(--brown); margin-bottom: 18px; font-weight: 700; }
        .welcome-screen p { color: var(--brown-mid); font-size: 0.95rem; line-height: 1.65; margin: 0 0 12px; }
        .btn-lets-start { display: inline-block; margin-top: 22px; background: var(--cream); color: var(--brown); border: 2px solid var(--brown); border-radius: 999px; padding: 13px 36px; font-family: var(--font-display); font-size: 1rem; cursor: pointer; transition: background 0.2s; }
        .btn-lets-start:hover { background: var(--cream-mid); }

        .empty-card {
            background: #fff;
            border: 2px dashed var(--cream-mid);
            border-radius: 22px;
            padding: 36px 28px;
            max-width: 780px;
            margin: 0 auto;
            color: var(--brown-mid);
            line-height: 1.7;
            display: none;
        }

        .empty-card strong {
            color: var(--brown);
        }

        .hidden-server-control { display: none; }

        /* Drag & drop match */
        .match-drag-grid { display: grid; grid-template-columns: 170px 1fr; gap: 8px; margin-bottom: 12px; max-width: 560px; }
        .match-col-header { font-size: 0.78rem; font-weight: 700; text-transform: uppercase; letter-spacing: 0.5px; color: var(--brown-mid); padding-bottom: 4px; }
        .match-slang-cell { background: var(--cream); border: 2px solid var(--cream-mid); border-radius: 12px; padding: 13px 16px; font-family: var(--font-display); font-size: 1rem; color: var(--brown); font-weight: 700; text-align: center; display: flex; align-items: center; justify-content: center; }
        .match-drop-zone { border: 2px dashed var(--cream-mid); border-radius: 12px; padding: 13px 16px; min-height: 50px; display: flex; align-items: center; font-size: 0.9rem; color: #c5b9ad; font-style: italic; background: #faf7f2; transition: border-color 0.2s, background 0.2s; cursor: pointer; }
        .match-drop-zone.filled { color: var(--brown); font-style: normal; font-weight: 600; background: #fff; border-style: solid; border-color: var(--brown-mid); }
        .match-drop-zone.drag-over { border-color: var(--accent); background: #fdf4ea; }
        .match-drop-zone.correct { border-color: var(--green); background: #d4edda; color: #1a5c2a; border-style: solid; }
        .match-drop-zone.wrong { border-color: #c0392b; background: #fde8e8; color: #7b1515; border-style: solid; }
        .meaning-bank { background: var(--cream-mid); border-radius: 14px; padding: 14px 16px; margin-top: 8px; max-width: 560px; }
        .meaning-bank-label { font-size: 0.78rem; font-weight: 700; color: var(--brown-mid); margin-bottom: 10px; text-transform: uppercase; letter-spacing: 0.5px; }
        .meaning-chips { display: flex; flex-wrap: wrap; gap: 8px; }
        .meaning-chip { background: var(--brown); color: #fff; border-radius: 10px; padding: 8px 16px; font-size: 0.88rem; cursor: grab; user-select: none; transition: opacity 0.2s; }
        .meaning-chip:hover { opacity: 0.85; }
        .meaning-chip.chip-used { opacity: 0.3; pointer-events: none; }
        .meaning-chip.chip-dragging { opacity: 0.5; }
        .mcq-options.grid-2 { display: grid; grid-template-columns: 1fr 1fr; gap: 10px; }
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
                    <span class="topbar-title">Module 8</span>
                </div>

                <div class="topbar-user">
                    <div class="topbar-avatar">&#x1F464;</div>
                    <span id="topbarName">Member</span>
                </div>
            </div>

            <div class="module-content">

                <div class="welcome-screen" id="welcomeScreen">
                    <h2>Welcome to<br />Level 4 - Advanced<br />Module 8 - Final Challenge Quiz</h2>
                    <p class="subtitle">This is it. Show everything you&apos;ve learned.</p>
                    <p>You&apos;ve worked through 7 modules of Indonesian slang &mdash; from the basics all the way to social media and chat context.</p>
                    <p>Module 8 tests everything: meanings, context, drag &amp; drop, and timed challenges. You need 8/10 to pass.</p>
                    <button type="button" class="btn-lets-start" onclick="startQuiz()">Got it, let&apos;s start!</button>
                </div>

                <div class="empty-card" id="emptyCard">
                    <strong>No questions found for Module 8.</strong><br />
                    Insert rows into the <strong>Question</strong> table where ModuleID belongs to Module 8.
                </div>

                <div id="quizBlock" style="display:none">
                    <div class="module-header">
                        <span class="module-badge">Module 8 &middot; Final Challenge</span>
                        <h1>Final Challenge</h1>
                        <p>The final test covering all levels.</p>
                    </div>

                    <div class="progress-bar-wrap">
                        <div class="progress-bar-fill" id="progressFill" style="width:0%"></div>
                    </div>

                    <div class="progress-label">
                        <span id="progressLabel">Question 1 of 10</span>
                        <span id="progressPct">0%</span>
                    </div>

                    <div class="timer-wrap" id="timerWrap">
                        <div class="timer-badge" id="timerBadge">⏱ 15s</div>
                        <span class="timer-label">Time per question</span>
                    </div>

                    <div id="quizArea">
                        <div class="question-card" id="questionCard">
                            <div class="question-type-tag" id="qTypeTag"></div>
                            <div class="scenario-badge" id="scenarioBadge" style="display:none;"></div>
                            <div class="question-context" id="qContext" style="display:none;"></div>
                            <div class="question-text" id="qText"></div>
                            <div id="qAnswer"></div>
                            <div class="feedback-msg" id="feedbackMsg"></div>
                        </div>

                        <div class="quiz-nav">
                            <button type="button" class="btn-check" id="btnCheck" onclick="checkAnswer()">Check ✓</button>
                            <button type="button" class="btn-next" id="btnNext" onclick="nextQuestion()">Next →</button>
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
                    <h2 class="summary-title">You are officially a Slang Master!</h2>
                    <p class="summary-subtitle">You&apos;ve completed all 4 levels and mastered Indonesian slang &mdash; from basic words to full conversations</p>
                    <div class="slang-grid">
                        <div class="slang-row"><span class="slang-word">Kuy</span><span class="slang-meaning">Let&apos;s go / come on</span></div>
                        <div class="slang-row"><span class="slang-word">PHP</span><span class="slang-meaning">Gives false hope</span></div>
                        <div class="slang-row"><span class="slang-word">Woles</span><span class="slang-meaning">Relaxed / chill</span></div>
                        <div class="slang-row"><span class="slang-word">Gaskeun</span><span class="slang-meaning">Let&apos;s just do it</span></div>
                        <div class="slang-row"><span class="slang-word">Bucin</span><span class="slang-meaning">Head over heels</span></div>
                        <div class="slang-row"><span class="slang-word">Gercep</span><span class="slang-meaning">Moves fast</span></div>
                        <div class="slang-row"><span class="slang-word">Gabut</span><span class="slang-meaning">Bored, nothing to do</span></div>
                        <div class="slang-row"><span class="slang-word">Baper</span><span class="slang-meaning">Emotionally carried away</span></div>
                        <div class="slang-row"><span class="slang-word">Mager</span><span class="slang-meaning">Too lazy to move</span></div>
                        <div class="slang-row"><span class="slang-word">Galau</span><span class="slang-meaning">Anxious / overthinking</span></div>
                        <div class="slang-row"><span class="slang-word">Julid</span><span class="slang-meaning">Snarky / negative comments</span></div>
                        <div class="slang-row"><span class="slang-word">Lebay</span><span class="slang-meaning">Over-dramatic</span></div>
                    </div>
                    <p class="summary-footer">All 4 levels complete. You&apos;ve officially levelled up.</p>
                    <button type="button" class="btn-go-dashboard" onclick="saveModuleResult()">Go to Dashboard -&gt;</button>
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
        var TIMER_SECONDS = 15;
        var currentQ = 0;
        var score = 0;
        var answered = false;
        var timerInterval = null;
        var timeLeft = TIMER_SECONDS;
        var answerRecords = [];

        function normalise(value) {
            return (value || '').toString().trim().toLowerCase();
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
            clearTimer();

            var _tl = { mcq: 'MCQ', timed_mcq: 'Timed MCQ', drag_match: 'Drag & Drop Match', fill: 'Fill in the Blank', tf: 'True / False' };
            document.getElementById('qTypeTag').textContent = data.qLabel || _tl[normalise(q.QuestionType)] || q.QuestionType || 'MCQ';
            document.getElementById('qText').innerHTML = data.question || 'Question text missing';
            document.getElementById('feedbackMsg').className = 'feedback-msg';
            document.getElementById('feedbackMsg').textContent = '';
            document.getElementById('btnCheck').style.display = 'inline-block';
            document.getElementById('btnNext').style.display = 'none';

            var pct = Math.round((index / questions.length) * 100);
            document.getElementById('progressFill').style.width = pct + '%';
            document.getElementById('progressPct').textContent = pct + '%';
            document.getElementById('progressLabel').textContent = 'Question ' + (index + 1) + ' of ' + questions.length;

            var ctx = document.getElementById('qContext');

            if (data.context) {
                ctx.style.display = 'block';
                ctx.innerHTML = data.context;
            } else {
                ctx.style.display = 'none';
                ctx.textContent = '';
            }

            var scenarioBadge = document.getElementById('scenarioBadge');

            if (data.scenario) {
                scenarioBadge.style.display = 'inline-block';
                scenarioBadge.textContent = data.scenario;
            } else {
                scenarioBadge.style.display = 'none';
                scenarioBadge.textContent = '';
            }

            var timerWrap = document.getElementById('timerWrap');
            var questionType = normalise(q.QuestionType);

            if (questionType === 'timed_mcq' || questionType === 'timed mcq') {
                timerWrap.style.display = 'flex';
                startTimer();
            } else {
                timerWrap.style.display = 'none';
            }

            var answerArea = document.getElementById('qAnswer');
            answerArea.innerHTML = '';

            if (questionType === 'drag_match' || questionType === 'drag match') {
                renderDragMatch(data);
                document.getElementById('btnCheck').textContent = 'Submit →';
            } else {
                var options = data.options || [];
                var optionsDiv = document.createElement('div');
                optionsDiv.className = 'mcq-options' + (options.length === 4 ? ' grid-2' : '');

                for (var i = 0; i < options.length; i++) {
                    var btn = document.createElement('button');
                    btn.type = 'button';
                    btn.className = 'mcq-option';
                    btn.textContent = String.fromCharCode(65 + i) + '. ' + options[i];
                    btn.setAttribute('data-index', i);
                    btn.setAttribute('data-answer', options[i]);
                    btn.setAttribute('data-letter', String.fromCharCode(65 + i));

                    btn.onclick = function () {
                        if (!answered) {
                            document.querySelectorAll('.mcq-option').forEach(function (b) {
                                b.classList.remove('selected');
                            });
                            this.classList.add('selected');
                        }
                    };

                    optionsDiv.appendChild(btn);
                }

                answerArea.appendChild(optionsDiv);
                document.getElementById('btnCheck').textContent = 'Submit →';
            }
        }

        function startTimer() {
            timeLeft = TIMER_SECONDS;
            updateTimerDisplay();

            timerInterval = setInterval(function () {
                timeLeft--;
                updateTimerDisplay();

                if (timeLeft <= 0) {
                    clearTimer();

                    if (!answered) {
                        autoFailTimer();
                    }
                }
            }, 1000);
        }

        function updateTimerDisplay() {
            var badge = document.getElementById('timerBadge');
            badge.textContent = '⏱ ' + timeLeft + 's';
            badge.className = timeLeft <= 5 ? 'timer-badge danger' : (timeLeft <= 8 ? 'timer-badge warning' : 'timer-badge');
        }

        var _dragMeaningSelected = null;

        function renderDragMatch(data) {
            var area = document.getElementById('qAnswer');
            var pairs = data.pairs || [];

            var grid = document.createElement('div');
            grid.className = 'match-drag-grid';

            var hSlang = document.createElement('div'); hSlang.className = 'match-col-header'; hSlang.textContent = 'Slang';
            var hMean  = document.createElement('div'); hMean.className  = 'match-col-header'; hMean.textContent  = 'Meaning — drop here';
            grid.appendChild(hSlang); grid.appendChild(hMean);

            pairs.forEach(function (pair, idx) {
                var slangCell = document.createElement('div');
                slangCell.className = 'match-slang-cell';
                slangCell.textContent = pair.left;

                var dropZone = document.createElement('div');
                dropZone.className = 'match-drop-zone';
                dropZone.id = 'mdrop-' + idx;
                dropZone.setAttribute('data-correct', pair.right);
                dropZone.setAttribute('data-placed', '');
                dropZone.textContent = 'drop here';

                dropZone.addEventListener('dragover', function (e) { e.preventDefault(); this.classList.add('drag-over'); });
                dropZone.addEventListener('dragleave', function ()  { this.classList.remove('drag-over'); });
                dropZone.addEventListener('drop', function (e) {
                    e.preventDefault();
                    this.classList.remove('drag-over');
                    if (answered) return;
                    var meaning = e.dataTransfer.getData('text/plain');
                    if (!meaning) return;
                    placeChip(this, meaning);
                });
                dropZone.addEventListener('click', function () {
                    if (answered) return;
                    var placed = this.getAttribute('data-placed');
                    if (placed) {
                        this.setAttribute('data-placed', '');
                        this.textContent = 'drop here';
                        this.classList.remove('filled');
                        var chip = document.querySelector('.meaning-chip[data-meaning="' + placed + '"]');
                        if (chip) chip.classList.remove('chip-used');
                    }
                });

                grid.appendChild(slangCell);
                grid.appendChild(dropZone);
            });

            area.appendChild(grid);

            var bank = document.createElement('div');
            bank.className = 'meaning-bank';
            var lbl = document.createElement('div'); lbl.className = 'meaning-bank-label'; lbl.textContent = 'Available meanings — drag up to match:';
            bank.appendChild(lbl);

            var chipsWrap = document.createElement('div');
            chipsWrap.className = 'meaning-chips';
            var meanings = pairs.map(function (p) { return p.right; }).sort(function () { return Math.random() - 0.5; });

            meanings.forEach(function (meaning) {
                var chip = document.createElement('div');
                chip.className = 'meaning-chip';
                chip.textContent = meaning;
                chip.setAttribute('draggable', 'true');
                chip.setAttribute('data-meaning', meaning);
                chip.addEventListener('dragstart', function (e) {
                    e.dataTransfer.setData('text/plain', meaning);
                    this.classList.add('chip-dragging');
                });
                chip.addEventListener('dragend', function () { this.classList.remove('chip-dragging'); });
                chipsWrap.appendChild(chip);
            });

            bank.appendChild(chipsWrap);
            area.appendChild(bank);
        }

        function placeChip(dropZone, meaning) {
            // Remove from any other drop zone
            document.querySelectorAll('.match-drop-zone').forEach(function (z) {
                if (z.getAttribute('data-placed') === meaning && z !== dropZone) {
                    z.setAttribute('data-placed', '');
                    z.textContent = 'drop here';
                    z.classList.remove('filled');
                }
            });
            // Clear previous chip in this zone
            var prev = dropZone.getAttribute('data-placed');
            if (prev) {
                var prevChip = document.querySelector('.meaning-chip[data-meaning="' + prev + '"]');
                if (prevChip) prevChip.classList.remove('chip-used');
            }
            dropZone.setAttribute('data-placed', meaning);
            dropZone.textContent = meaning;
            dropZone.classList.add('filled');
            var chip = document.querySelector('.meaning-chip[data-meaning="' + meaning + '"]');
            if (chip) chip.classList.add('chip-used');
        }

        function clearTimer() {
            if (timerInterval) {
                clearInterval(timerInterval);
                timerInterval = null;
            }
        }

        function isAnswerCorrect(selectedText, selectedLetter, correctAnswer) {
            var selectedTextNorm = normalise(selectedText);
            var selectedLetterNorm = normalise(selectedLetter);
            var correctNorm = normalise(correctAnswer);

            return selectedTextNorm === correctNorm || selectedLetterNorm === correctNorm;
        }

        function autoFailTimer() {
            answered = true;

            var q = questions[currentQ];

            document.querySelectorAll('.mcq-option').forEach(function (btn) {
                btn.disabled = true;

                if (isAnswerCorrect(btn.getAttribute('data-answer'), btn.getAttribute('data-letter'), q.CorrectAnswer)) {
                    btn.classList.add('correct');
                }
            });

            saveAnswerRecord(q.QuestionID, "TIMEOUT", false);

            var feedback = document.getElementById('feedbackMsg');
            feedback.className = 'feedback-msg wrong';
            feedback.textContent = "Time's up. Correct answer: " + q.CorrectAnswer;

            document.getElementById('btnCheck').style.display = 'none';
            document.getElementById('btnNext').style.display = 'inline-block';
            document.getElementById('timerBadge').textContent = '⏱ 0s';
        }

        function checkAnswer() {
            if (answered) return;

            var q = questions[currentQ];
            var data = q.QuestionData || {};
            var qType = normalise(q.QuestionType);
            var feedback = document.getElementById('feedbackMsg');

            clearTimer();

            if (qType === 'drag_match' || qType === 'drag match') {
                var drops = document.querySelectorAll('.match-drop-zone');
                var allFilled = true;
                var allCorrect = true;
                var parts = [];

                drops.forEach(function (drop) {
                    var placed = drop.getAttribute('data-placed');
                    if (!placed) { allFilled = false; }
                    parts.push(placed || '');
                    var correct = drop.getAttribute('data-correct');
                    if (normalise(placed) === normalise(correct)) {
                        drop.classList.add('correct');
                        drop.textContent = placed + ' ✓';
                    } else {
                        drop.classList.add('wrong');
                        allCorrect = false;
                    }
                    drop.style.pointerEvents = 'none';
                });

                if (!allFilled) {
                    feedback.className = 'feedback-msg wrong';
                    feedback.textContent = 'Please match all slang words before submitting.';
                    drops.forEach(function (d) { d.classList.remove('correct', 'wrong'); d.style.pointerEvents = ''; });
                    return;
                }

                if (allCorrect) score++;
                saveAnswerRecord(q.QuestionID, parts.join(' | '), allCorrect);
                answered = true;
                feedback.className = 'feedback-msg ' + (allCorrect ? 'correct' : 'wrong');
                feedback.textContent = (allCorrect ? 'Correct! ' : 'Incorrect. ') + (data.explanation || '');
                document.getElementById('btnCheck').style.display = 'none';
                document.getElementById('btnNext').style.display = 'inline-block';
                document.getElementById('btnNext').textContent = 'Next question →';
                return;
            }

            var selected = document.querySelector('.mcq-option.selected');
            if (!selected) {
                feedback.className = 'feedback-msg wrong';
                feedback.textContent = 'Please select an option first.';
                return;
            }

            var selectedText = selected.getAttribute('data-answer');
            var selectedLetter = selected.getAttribute('data-letter');
            var isCorrect = isAnswerCorrect(selectedText, selectedLetter, q.CorrectAnswer);

            document.querySelectorAll('.mcq-option').forEach(function (btn) {
                btn.disabled = true;
                if (isAnswerCorrect(btn.getAttribute('data-answer'), btn.getAttribute('data-letter'), q.CorrectAnswer)) btn.classList.add('correct');
                else if (btn.classList.contains('selected')) btn.classList.add('wrong');
            });

            if (isCorrect) score++;
            saveAnswerRecord(q.QuestionID, selectedText, isCorrect);
            answered = true;
            feedback.className = 'feedback-msg ' + (isCorrect ? 'correct' : 'wrong');
            feedback.textContent = (isCorrect ? 'Correct. ' : 'Incorrect. ') + (data.explanation || '');
            document.getElementById('btnCheck').style.display = 'none';
            document.getElementById('btnNext').style.display = 'inline-block';
            document.getElementById('btnNext').textContent = 'Next question →';
        }

        function saveAnswerRecord(questionId, selectedAnswer, isCorrect) {
            answerRecords.push({
                questionId: questionId,
                selectedAnswer: selectedAnswer,
                isCorrect: isCorrect
            });
        }

        function nextQuestion() {
            currentQ++;

            if (currentQ >= questions.length) {
                showCompletion();
            } else {
                renderQuestion(currentQ);
            }
        }

        function showCompletion() {
            clearTimer();

            document.getElementById('quizArea').style.display = 'none';
            document.getElementById('timerWrap').style.display = 'none';
            document.getElementById('progressFill').style.width = '100%';
            document.getElementById('progressLabel').textContent = 'Result';
            document.getElementById('progressPct').textContent = '100%';

            var passed = score >= PASS_SCORE;

            document.getElementById('scoreNum').textContent = score;
            document.getElementById('scoreOutOf').textContent = 'out of ' + questions.length;
            document.getElementById('completionCard').style.display = 'block';

            var actions = document.getElementById('completionActions');
            actions.innerHTML = '';

            if (passed) {
                document.getElementById('completionTitle').textContent = 'Well done! You passed Module 8.';
                document.getElementById('completionMsg').textContent =
                    'You got ' + score + ' out of ' + questions.length + ' correct.\n' +
                    'You\'re reading Indonesian slang in context like a local!';

                var retryBtn = document.createElement('button');
                retryBtn.type = 'button';
                retryBtn.className = 'btn-retry';
                retryBtn.textContent = 'Try again';
                retryBtn.onclick = restartQuiz;
                actions.appendChild(retryBtn);

                var sumBtn = document.createElement('button');
                sumBtn.type = 'button';
                sumBtn.className = 'btn-summary';
                sumBtn.textContent = 'Go to summary ->';
                sumBtn.onclick = showSummary;
                actions.appendChild(sumBtn);
            } else {
                document.getElementById('completionTitle').textContent = 'Not quite! Keep practising.';
                document.getElementById('completionMsg').textContent =
                    'You got ' + score + ' out of ' + questions.length + ' correct.\n' +
                    'You need at least ' + PASS_SCORE + '/10 to pass. Give it another go!';

                var saveExitBtn = document.createElement('button');
                saveExitBtn.type = 'button';
                saveExitBtn.className = 'btn-summary';
                saveExitBtn.textContent = 'Save & Exit';
                saveExitBtn.onclick = saveModuleResult;
                actions.appendChild(saveExitBtn);

                var retryBtn = document.createElement('button');
                retryBtn.type = 'button';
                retryBtn.className = 'btn-retry';
                retryBtn.textContent = 'Try again';
                retryBtn.onclick = restartQuiz;
                actions.appendChild(retryBtn);
            }
        }

        function showSummary() {
            document.getElementById('completionCard').style.display = 'none';
            document.getElementById('summaryCard').style.display = 'block';
            document.getElementById('progressLabel').textContent = 'Summary';
            document.getElementById('progressPct').textContent = 'Q' + questions.length + ' of ' + questions.length;
        }

        function saveModuleResult() {
            document.getElementById('<%= hfScore.ClientID %>').value = score;
            document.getElementById('<%= hfPassed.ClientID %>').value = score >= PASS_SCORE ? 'true' : 'false';
            document.getElementById('<%= hfAnswersJson.ClientID %>').value = JSON.stringify(answerRecords);

            document.getElementById('<%= btnSaveResult.ClientID %>').click();
        }

        function startQuiz() {
            document.getElementById('welcomeScreen').style.display = 'none';
            document.getElementById('quizBlock').style.display = 'block';
            renderQuestion(0);
        }

        function restartQuiz() {
            currentQ = 0;
            score = 0;
            answered = false;
            answerRecords = [];

            clearTimer();

            document.getElementById('quizArea').style.display = 'block';
            document.getElementById('completionCard').style.display = 'none';
            document.getElementById('summaryCard').style.display = 'none';

            renderQuestion(0);
        }

        // Check if no questions exist and show empty card instead of welcome
        if (!questions || questions.length === 0) {
            document.getElementById('welcomeScreen').style.display = 'none';
            document.getElementById('emptyCard').style.display = 'block';
        }
    </script>
</asp:Content>