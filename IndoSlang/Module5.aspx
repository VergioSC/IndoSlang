<%@ Page Title="Module 5 — See Slang Online" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Module5.aspx.cs" Inherits="IndoSlang.Module5" %>

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

    /* Welcome screen */
    .welcome-screen { max-width: 680px; margin: 30px auto; text-align: center; padding: 50px 44px; }    .welcome-screen h2 { font-family: var(--font-display); font-size: 2rem; color: var(--brown); margin: 0 0 12px; line-height: 1.3; }
    .welcome-screen .subtitle { font-family: var(--font-display); font-size: 1.05rem; color: var(--brown); margin-bottom: 18px; font-weight: 700; }
    .welcome-screen p { color: var(--brown-mid); font-size: 0.95rem; line-height: 1.65; margin: 0 0 12px; }
    .btn-lets-start { display: inline-block; margin-top: 22px; background: var(--cream); color: var(--brown); border: 2px solid var(--brown); border-radius: 999px; padding: 13px 36px; font-family: var(--font-display); font-size: 1rem; cursor: pointer; transition: background 0.2s; }
    .btn-lets-start:hover { background: var(--cream-mid); }

    /* Summary screen */
    .summary-screen { max-width: 680px; margin: 0 auto; display: none; background: #fff; border: 2px solid var(--cream-mid); border-radius: 22px; padding: 40px 36px; box-shadow: 0 6px 22px rgba(59,42,26,0.09); }
    .summary-screen h2 { font-family: var(--font-display); font-size: 1.7rem; color: var(--brown); text-align: center; margin-bottom: 28px; }
    .summary-grid { display: grid; grid-template-columns: 1fr 1fr; gap: 12px 32px; margin-bottom: 32px; }
    .summary-item { display: flex; align-items: baseline; gap: 10px; padding: 8px 0; border-bottom: 1px solid var(--cream-mid); }
    .summary-word { font-family: var(--font-display); font-size: 1.05rem; font-weight: 800; color: var(--brown); min-width: 55px; }
    .summary-meaning { font-size: 0.88rem; color: var(--brown-mid); font-style: italic; }
    .btn-go-module { display: block; width: fit-content; margin: 0 auto; background: var(--brown); color: #fff; border: none; border-radius: 13px; padding: 13px 30px; font-family: var(--font-display); font-size: 1rem; cursor: pointer; transition: background 0.2s; }
    .btn-go-module:hover { background: var(--brown-mid); }

    /* Progress */
    .progress-bar-wrap { background: var(--cream-mid); border-radius: 999px; height: 10px; margin-bottom: 8px; overflow: hidden; max-width: 780px; }
    .progress-bar-fill { height: 100%; background: var(--brown); border-radius: 999px; transition: width 0.4s ease; }
    .progress-label { display: flex; justify-content: space-between; font-size: 0.82rem; color: var(--brown-mid); margin-bottom: 20px; max-width: 780px; }
    .score-tracker { display: none; }
    .score-dot { width: 18px; height: 18px; border-radius: 50%; border: 2px solid var(--cream-mid); background: #fff; transition: all 0.25s ease; }
    .score-dot.correct { background: var(--green); border-color: var(--green); }
    .score-dot.wrong { background: #c0392b; border-color: #c0392b; }

    /* Question card */
    .question-card { background: #fff; border: 2px solid var(--cream-mid); border-radius: 22px; padding: 32px 30px; box-shadow: 0 6px 22px rgba(59,42,26,0.09); margin: 0 auto 20px; max-width: 780px; }
    .question-type-tag { font-size: 0.75rem; font-weight: 800; text-transform: uppercase; letter-spacing: 1px; color: var(--accent); margin-bottom: 10px; }
    .q-count { font-size: 0.78rem; color: var(--brown-mid); float: right; font-weight: 700; }
    .source-badge { display: inline-block; background: var(--brown); color: #fff; font-size: 0.78rem; font-weight: 800; padding: 4px 13px; border-radius: 999px; margin-bottom: 12px; font-family: var(--font-display); }
    .question-context { background: var(--cream-mid); border-radius: 14px; padding: 14px 18px; font-size: 0.92rem; color: var(--brown); margin-bottom: 18px; line-height: 1.8; white-space: pre-line; }
    .question-image { max-width: 480px; width: 100%; border-radius: 16px; border: 2px solid var(--cream-mid); margin-bottom: 18px; display: none; display: block; margin-left: auto; margin-right: auto; }    .question-text { font-family: var(--font-display); font-size: 1.18rem; margin-bottom: 22px; line-height: 1.45; color: var(--brown); }

    /* MCQ */
    .mcq-options { display: flex; flex-direction: column; gap: 10px; }
    .mcq-option { background: var(--cream); border: 2px solid var(--cream-mid); border-radius: 14px; padding: 13px 18px; cursor: pointer; font-size: 0.95rem; transition: border-color 0.2s, background 0.2s; text-align: left; color: var(--brown); font-family: var(--font-body); }
    .mcq-option:hover { border-color: var(--accent); background: #fdf4ea; }
    .mcq-option.selected { border-color: var(--accent); background: #fce9d0; }
    .mcq-option.correct { border-color: var(--green); background: #d4edda; }
    .mcq-option.wrong { border-color: #c0392b; background: #fde8e8; }

    /* Drag & drop */
    .word-bank { display: flex; flex-wrap: wrap; gap: 10px; padding: 14px 16px; background: var(--cream-mid); border-radius: 14px; margin-bottom: 18px; }
    .word-chip { background: var(--brown); color: #fff; border: none; border-radius: 10px; padding: 8px 18px; font-family: var(--font-display); font-size: 0.92rem; cursor: pointer; transition: opacity 0.2s, transform 0.15s; }
    .word-chip:hover { opacity: 0.85; transform: scale(1.04); }
    .word-chip.chip-selected { outline: 3px solid var(--accent); }
    .word-chip.chip-used { opacity: 0.35; pointer-events: none; }
    .drag-sentences { display: flex; flex-direction: column; gap: 12px; }
    .drag-sentence-row { background: var(--cream); border: 2px solid var(--cream-mid); border-radius: 12px; padding: 12px 16px; font-size: 0.93rem; color: var(--brown); line-height: 1.6; }
    .drag-sentence-row.correct { border-color: var(--green); background: #d4edda; }
    .drag-sentence-row.wrong { border-color: #c0392b; background: #fde8e8; }
    .blank-slot { display: inline-block; min-width: 80px; padding: 3px 12px; border-bottom: 2px solid var(--brown-mid); background: #fff; border-radius: 6px; margin: 0 4px; text-align: center; font-weight: 800; cursor: pointer; transition: background 0.15s; }
    .blank-slot:hover { background: #fce9d0; }
    .blank-slot.filled { background: var(--cream-mid); border-bottom-color: var(--brown); }

    /* Word search */
    .ws-layout { display: flex; gap: 28px; align-items: flex-start; flex-wrap: wrap; }
    .ws-grid-wrap { flex-shrink: 0; }
    .ws-grid { display: inline-grid; gap: 4px; }
    .ws-cell { width: 36px; height: 36px; display: flex; align-items: center; justify-content: center; font-size: 0.9rem; font-weight: 800; color: var(--brown); background: var(--cream); border-radius: 8px; border: 2px solid var(--cream-mid); cursor: pointer; user-select: none; transition: background 0.1s; font-family: var(--font-display); }
    .ws-cell:hover { background: #fce9d0; }
    .ws-cell.ws-selecting { background: var(--accent); color: #fff; border-color: var(--accent); }
    .ws-cell.ws-found { background: var(--brown); color: #fff; border-color: var(--brown); }
    .ws-word-list { flex: 1; min-width: 200px; }
    .ws-word-item { display: flex; align-items: center; justify-content: space-between; padding: 9px 14px; border-radius: 10px; border: 2px solid var(--cream-mid); background: var(--cream); margin-bottom: 8px; font-size: 0.92rem; }
    .ws-word-item .ws-word-label { font-family: var(--font-display); font-weight: 800; color: var(--brown); }
    .ws-word-item .ws-word-status { font-size: 0.78rem; color: var(--brown-mid); }
    .ws-word-item.ws-word-found { border-color: var(--green); background: #d4edda; }
    .ws-word-item.ws-word-found .ws-word-label { color: #1a5c2a; }
    .ws-word-item.ws-word-found .ws-word-status { color: #1a5c2a; font-weight: 700; }
    .ws-hint { font-size: 0.8rem; color: var(--brown-mid); margin-bottom: 14px; }

    /* Feedback */
    .feedback-msg { margin-top: 14px; padding: 11px 16px; border-radius: 12px; font-size: 0.92rem; display: none; line-height: 1.5; }
    .feedback-msg.correct { background: #d4edda; color: #1a5c2a; display: block; }
    .feedback-msg.wrong { background: #fde8e8; color: #7b1515; display: block; }

    /* Buttons */
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
.btn-next-module { background: var(--brown); color: #fff; padding: 13px 30px; border-radius: 13px; font-family: var(--font-display); font-size: 1rem; text-decoration: none; display: inline-block; border: none; cursor: pointer; margin: 6px; }
.btn-next-module:hover { background: var(--brown-mid); }
.btn-retry { background: var(--cream-mid); color: var(--brown); border: 2px solid var(--brown-mid); padding: 12px 26px; border-radius: 13px; font-family: var(--font-display); font-size: 1rem; cursor: pointer; margin: 6px; }

/* Summary card — matches Module 3 style */
.summary-screen { display: none; max-width: 680px; margin: 0 auto; background: #fff; border: 2px solid var(--cream-mid); border-radius: 22px; padding: 36px 40px; box-shadow: 0 6px 22px rgba(59,42,26,0.09); }
.summary-screen h2 { font-family: var(--font-display); font-size: 1.5rem; color: var(--brown); text-align: center; margin-bottom: 4px; font-weight: 800; }
.summary-subtitle { text-align: center; color: var(--brown-mid); font-size: 0.9rem; margin-bottom: 28px; }
.summary-grid { display: grid; grid-template-columns: 1fr 1fr; gap: 0 40px; margin-bottom: 28px; }
.summary-item { display: flex; align-items: baseline; gap: 12px; padding: 10px 0; border-bottom: 1px solid var(--cream-mid); }
.summary-word { font-family: var(--font-display); font-size: 1rem; font-weight: 800; color: var(--brown); min-width: 60px; }
.summary-meaning { font-size: 0.88rem; color: var(--brown-mid); font-style: italic; }
.btn-go-module { display: block; width: fit-content; margin: 0 auto; background: var(--brown); color: #fff; border: none; border-radius: 13px; padding: 13px 30px; font-family: var(--font-display); font-size: 1rem; cursor: pointer; transition: background 0.2s; }
.btn-go-module:hover { background: var(--brown-mid); }

.module-header { margin-bottom: 28px; }
.module-badge { display: inline-block; background: var(--brown); color: #fff; font-family: var(--font-display); font-size: 0.85rem; padding: 5px 15px; border-radius: 999px; margin-bottom: 10px; }
.module-header h1 { font-family: var(--font-display); font-size: 2rem; margin: 0 0 6px; color: var(--brown); }
.module-header p { color: var(--brown-mid); font-size: 0.94rem; margin: 0; line-height: 1.6; }

.hidden-server-control { display: none; }
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
                    <span class="topbar-title">Module 5</span>
                </div>
                <div class="topbar-user">
                    <div class="topbar-avatar">&#x1F464;</div>
                    <span id="topbarName">Member</span>
                </div>
            </div>

            <div class="module-content">

                <!-- Welcome Screen -->
                <div class="welcome-screen" id="welcomeScreen">
                    <h2>Welcome to<br />Level 3 - Intermediate<br />Module 5 - See Slang Online</h2>
                    <p class="subtitle">Hey congrats! you&apos;re an intermediate student now</p>
                    <p>In this level, you&apos;ll meet Indonesian slang the way it actually lives &mdash; inside real Instagram captions, TikTok comment sections, and WhatsApp group chats.</p>
                    <p>No more simple sentences. Context is everything now. By the end of Level 3, you&apos;ll be reading real Indonesian social media and actually understanding what&apos;s going on.</p>
                    <button type="button" class="btn-lets-start" onclick="startQuiz()">Got it, let&apos;s start!</button>
                </div>

                <!-- Quiz Block -->
                <div id="quizBlock" style="display:none;">
                    <div class="module-header">
                        <span class="module-badge">Module 5 &middot; Intermediate</span>
                        <h1>See Slang Online</h1>
                        <p>Indonesian slang in real Instagram captions, TikTok comments, and WhatsApp chats.</p>
                    </div>

                    <div class="progress-bar-wrap">
                        <div class="progress-bar-fill" id="progressFill" style="width:0%"></div>
                    </div>
                    <div class="progress-label">
                        <span id="progressLabel">Question 1 of 5</span>
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
                                <button type="button" class="check-btn" id="checkBtn" onclick="checkAnswer()">Submit &#8594;</button>
                                <button type="button" class="next-btn" id="nextBtn" onclick="nextQuestion()">Next question &#8594;</button>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Score Card -->
                <div class="completion-card" id="completionCard">
                    <div class="score-circle">
                        <div class="score-circle-num" id="scoreNum">0</div>
                        <div class="score-circle-label" id="scoreOutOf">out of 5</div>
                    </div>
                    <p class="completion-main-msg" id="completionTitle"></p>
                    <p class="completion-sub-msg" id="completionMsg"></p>
                    <div class="result-actions" id="completionActions"></div>
                </div>

                <!-- Summary Screen -->
                <div class="summary-screen" id="summaryScreen">
                    <h2>You just learned 10 words!</h2>
                    <p class="summary-subtitle">Here are the slang words you practised in this module</p>
                    <div class="summary-grid">
                        <div class="summary-item"><span class="summary-word">FOMO</span><span class="summary-meaning">Fear of Missing Out</span></div>
                        <div class="summary-item"><span class="summary-word">Kepo</span><span class="summary-meaning">nosy / overly curious</span></div>
                        <div class="summary-item"><span class="summary-word">Galau</span><span class="summary-meaning">emotionally unsettled</span></div>
                        <div class="summary-item"><span class="summary-word">Kocak</span><span class="summary-meaning">hilarious</span></div>
                        <div class="summary-item"><span class="summary-word">Slay</span><span class="summary-meaning">killing it / looking amazing</span></div>
                        <div class="summary-item"><span class="summary-word">YGY</span><span class="summary-meaning">ya guys ya &mdash; used at the end of a sentence to seek agreement</span></div>
                        <div class="summary-item"><span class="summary-word">Alay</span><span class="summary-meaning">over the top / extra</span></div>
                        <div class="summary-item"><span class="summary-word">Gas</span><span class="summary-meaning">let&apos;s go</span></div>
                        <div class="summary-item"><span class="summary-word">YTTA</span><span class="summary-meaning">if you know, you know</span></div>
                        <div class="summary-item"><span class="summary-word">Halu</span><span class="summary-meaning">hallucinating</span></div>
                    </div>
                    <button type="button" class="btn-go-module" onclick="goToModule6()">Go to Module 6 &#8594;</button>
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

    function startQuiz() {
        document.getElementById('welcomeScreen').style.display = 'none';
        document.getElementById('quizBlock').style.display = 'block';
        buildDots();
        renderQuestion(0);
    }

    var PASS_SCORE = 4;
    var currentQ = 0;
    var score = 0;
    var answered = false;
    var answerRecords = [];
    var selectedChip = null;
    var slotFills = {};
    var wsMouseDown = false;
    var wsStartCell = null;
    var wsFoundWords = [];

    function normalise(v) { return (v || '').toString().trim().toLowerCase(); }

    function buildDots() {
        var c = document.getElementById('scoreDots');
        c.innerHTML = '';
        for (var i = 0; i < questions.length; i++) {
            var d = document.createElement('div');
            d.className = 'score-dot';
            d.id = 'dot-' + i;
            c.appendChild(d);
        }
    }

    function renderQuestion(index) {
        if (!questions || questions.length === 0) {
            document.getElementById('quizBlock').style.display = 'block';
            document.getElementById('emptyCard').style.display = 'block';
            return;
        }
        answered = false; selectedChip = null; slotFills = {}; wsFoundWords = [];
        var q = questions[index];
        var data = q.QuestionData || {};

        document.getElementById('progressLabel').textContent = 'Question ' + (index + 1) + ' of ' + questions.length;
        var pct = Math.round((index / questions.length) * 100);
        document.getElementById('progressPct').textContent = pct + '%';
        document.getElementById('progressFill').style.width = pct + '%';

        document.getElementById('qTypeTag').textContent = data.qLabel || q.QuestionType || 'MCQ';
        document.getElementById('questionText').innerHTML = data.question || '';
        document.getElementById('feedbackMsg').className = 'feedback-msg';
        document.getElementById('feedbackMsg').textContent = '';
        document.getElementById('checkBtn').style.display = 'inline-block';
        document.getElementById('checkBtn').textContent = 'Submit \u2192';
        document.getElementById('nextBtn').style.display = 'none';

        var sb = document.getElementById('sourceBadge');
        if (data.source) { sb.style.display = 'inline-block'; sb.textContent = data.source; }
        else { sb.style.display = 'none'; }

        var ctx = document.getElementById('qContext');
        if (data.context) { ctx.style.display = 'block'; ctx.textContent = data.context; }
        else { ctx.style.display = 'none'; }

        var img = document.getElementById('questionImage');
        if (data.image) { img.style.display = 'block'; img.src = data.image; }
        else { img.style.display = 'none'; img.removeAttribute('src'); }

        renderAnswer(q, data);
    }

    function renderAnswer(q, data) {
        var area = document.getElementById('answerArea');
        area.innerHTML = '';
        var qt = normalise(q.QuestionType);
        if (qt === 'drag') renderDrag(area, data);
        else if (qt === 'word_search') renderWordSearch(area, data, q);
        else renderMCQ(area, data);
    }

    function renderMCQ(area, data) {
        var opts = data.options || [];
        var div = document.createElement('div');
        div.className = 'mcq-options';
        for (var i = 0; i < opts.length; i++) {
            var btn = document.createElement('button');
            btn.type = 'button';
            btn.className = 'mcq-option';
            btn.textContent = opts[i];
            btn.setAttribute('data-answer', opts[i]);
            btn.setAttribute('data-letter', String.fromCharCode(65 + i));
            btn.onclick = function () {
                if (!answered) {
                    document.querySelectorAll('.mcq-option').forEach(function (b) { b.classList.remove('selected'); });
                    this.classList.add('selected');
                }
            };
            div.appendChild(btn);
        }
        area.appendChild(div);
    }

    function renderDrag(area, data) {
        var sentences = data.sentences || [];
        var bank = data.bank || [];
        var bankDiv = document.createElement('div');
        bankDiv.className = 'word-bank';
        bankDiv.id = 'wordBank';
        bank.forEach(function (w) {
            var chip = document.createElement('button');
            chip.type = 'button'; chip.className = 'word-chip'; chip.textContent = w;
            chip.onclick = function () {
                if (answered) return;
                document.querySelectorAll('.word-chip').forEach(function (c) { c.classList.remove('chip-selected'); });
                if (selectedChip === w) { selectedChip = null; return; }
                selectedChip = w; chip.classList.add('chip-selected');
            };
            bankDiv.appendChild(chip);
        });
        area.appendChild(bankDiv);
        var sentDiv = document.createElement('div');
        sentDiv.className = 'drag-sentences';
        sentences.forEach(function (s, idx) {
            var row = document.createElement('div');
            row.className = 'drag-sentence-row'; row.id = 'drag-row-' + idx;
            var parts = s.text.split('___');
            row.appendChild(document.createTextNode(parts[0]));
            var slot = document.createElement('span');
            slot.className = 'blank-slot'; slot.id = 'slot-' + idx;
            slot.textContent = '_____'; slot.setAttribute('data-idx', idx);
            slot.onclick = function () {
                if (answered) return;

                // Click a filled slot with no chip selected → return word to bank
                if (slotFills[idx] !== undefined && !selectedChip) {
                    delete slotFills[idx];
                    slot.textContent = '_____'; slot.classList.remove('filled');
                    document.querySelectorAll('.word-chip').forEach(function (c) {
                        c.classList.remove('chip-used');
                        if (Object.values(slotFills).indexOf(c.textContent) !== -1) c.classList.add('chip-used');
                    });
                    return;
                }

                if (!selectedChip) return;

                // Remove selected chip from any other slot it was in
                Object.keys(slotFills).forEach(function (k) {
                    if (slotFills[k] === selectedChip) {
                        var ps = document.getElementById('slot-' + k);
                        if (ps) { ps.textContent = '_____'; ps.classList.remove('filled'); }
                        delete slotFills[k];
                    }
                });
                slot.textContent = selectedChip; slot.classList.add('filled');
                slotFills[idx] = selectedChip;
                document.querySelectorAll('.word-chip').forEach(function (c) {
                    c.classList.remove('chip-selected', 'chip-used');
                    if (Object.values(slotFills).indexOf(c.textContent) !== -1) c.classList.add('chip-used');
                });
                selectedChip = null;
            };
            row.appendChild(slot);
            if (parts[1]) row.appendChild(document.createTextNode(parts[1]));
            sentDiv.appendChild(row);
        });
        area.appendChild(sentDiv);
        area.setAttribute('data-sentences', JSON.stringify(sentences));
    }

    function renderWordSearch(area, data, q) {
        var words = data.words || [];
        var grid = data.grid || [];
        document.getElementById('checkBtn').style.display = 'none';
        var hint = document.createElement('p');
        hint.className = 'ws-hint';
        hint.textContent = 'Tap letters to select a word \u2014 horizontal, vertical, or diagonal';
        area.appendChild(hint);
        var layout = document.createElement('div');
        layout.className = 'ws-layout';
        var gridWrap = document.createElement('div');
        gridWrap.className = 'ws-grid-wrap';
        var gridEl = document.createElement('div');
        gridEl.className = 'ws-grid';
        gridEl.style.gridTemplateColumns = 'repeat(' + grid[0].length + ', 1fr)';
        gridEl.id = 'wsGrid';
        for (var r = 0; r < grid.length; r++) {
            for (var c = 0; c < grid[r].length; c++) {
                var cell = document.createElement('div');
                cell.className = 'ws-cell'; cell.textContent = grid[r][c];
                cell.setAttribute('data-r', r); cell.setAttribute('data-c', c);
                cell.onmousedown = wsMouseDownFn;
                cell.onmouseenter = wsMouseEnterFn;
                cell.onmouseup = wsMouseUpFn;
                gridEl.appendChild(cell);
            }
        }
        gridWrap.appendChild(gridEl); layout.appendChild(gridWrap);
        var wordList = document.createElement('div');
        wordList.className = 'ws-word-list';
        words.forEach(function (w) {
            var item = document.createElement('div');
            item.className = 'ws-word-item'; item.id = 'wl-' + w.word;
            item.innerHTML = '<span class="ws-word-label">' + w.word + '</span><span class="ws-word-status">Not found yet</span>';
            wordList.appendChild(item);
        });
        layout.appendChild(wordList);
        area.appendChild(layout);
        area.setAttribute('data-ws-words', JSON.stringify(words));
        area.setAttribute('data-ws-grid', JSON.stringify(grid));
    }

    function wsMouseDownFn(e) {
        if (answered) return;
        wsMouseDown = true; wsStartCell = this;
        document.querySelectorAll('.ws-cell.ws-selecting').forEach(function (c) { c.classList.remove('ws-selecting'); });
        this.classList.add('ws-selecting');
    }
    function wsMouseEnterFn(e) {
        if (!wsMouseDown || answered) return;
        document.querySelectorAll('.ws-cell.ws-selecting').forEach(function (c) { c.classList.remove('ws-selecting'); });
        var sr = +wsStartCell.getAttribute('data-r'), sc = +wsStartCell.getAttribute('data-c');
        var er = +this.getAttribute('data-r'), ec = +this.getAttribute('data-c');
        var dr = er > sr ? 1 : (er < sr ? -1 : 0), dc = ec > sc ? 1 : (ec < sc ? -1 : 0);
        var r = sr, c = sc;
        for (var s = 0; s < 20; s++) {
            var cell = document.querySelector('[data-r="' + r + '"][data-c="' + c + '"]');
            if (cell) cell.classList.add('ws-selecting');
            if (r === er && c === ec) break;
            r += dr; c += dc;
        }
    }
    function wsMouseUpFn(e) {
        if (!wsMouseDown || answered) return;
        wsMouseDown = false;
        var selecting = document.querySelectorAll('.ws-cell.ws-selecting');
        var word = Array.from(selecting).map(function (c) { return c.textContent; }).join('');
        var wordRev = word.split('').reverse().join('');
        var area = document.getElementById('answerArea');
        var words = JSON.parse(area.getAttribute('data-ws-words') || '[]');
        var found = false;
        words.forEach(function (w) {
            if (wsFoundWords.indexOf(w.word) === -1 && (word === w.word || wordRev === w.word)) {
                found = true; wsFoundWords.push(w.word);
                selecting.forEach(function (c) { c.classList.remove('ws-selecting'); c.classList.add('ws-found'); });
                var item = document.getElementById('wl-' + w.word);
                if (item) { item.classList.add('ws-word-found'); item.querySelector('.ws-word-status').textContent = 'Found \u2014 ' + w.meaning; }
            }
        });
        if (!found) document.querySelectorAll('.ws-cell.ws-selecting').forEach(function (c) { c.classList.remove('ws-selecting'); });
        if (wsFoundWords.length >= words.length) {
            var fb = document.getElementById('feedbackMsg');
            fb.className = 'feedback-msg correct';
            fb.textContent = "Nice! You've found all the Level 3 words. Time to prove you know them!";
            answered = true; score++;
            saveAnswerRecord(questions[currentQ].QuestionID, 'all_found', true);
            document.getElementById('nextBtn').style.display = 'inline-block';
            document.getElementById('nextBtn').textContent = 'Next question \u2192';
        }
    }
    document.addEventListener('mouseup', function () { wsMouseDown = false; });

    function checkAnswer() {
        if (answered) return;
        var q = questions[currentQ];
        var data = q.QuestionData || {};
        var qt = normalise(q.QuestionType);
        var fb = document.getElementById('feedbackMsg');
        var selectedAnswer = '', isCorrect = false;

        if (qt === 'drag') {
            var area = document.getElementById('answerArea');
            var sentences = JSON.parse(area.getAttribute('data-sentences') || '[]');

            // Check if any slot is still empty — show warning like MCQ does
            var anyEmpty = false;
            sentences.forEach(function (s, idx) {
                if (!slotFills[idx]) anyEmpty = true;
            });
            if (anyEmpty) {
                fb.className = 'feedback-msg wrong';
                fb.textContent = 'Please fill in all the blanks first.';
                return;
            }

            var allOk = true;
            sentences.forEach(function (s, idx) {
                var filled = slotFills[idx] || '';
                var row = document.getElementById('drag-row-' + idx);
                var ok = normalise(filled) === normalise(s.answer);
                if (row) row.classList.add(ok ? 'correct' : 'wrong');
                if (!ok) allOk = false;
            });
            isCorrect = allOk;
            selectedAnswer = JSON.stringify(slotFills);
        } else {
            var sel = document.querySelector('.mcq-option.selected');
            if (!sel) { fb.className = 'feedback-msg wrong'; fb.textContent = 'Please select an option first.'; return; }
            selectedAnswer = sel.getAttribute('data-answer');
            var selLetter = sel.getAttribute('data-letter');
            isCorrect = normalise(selectedAnswer) === normalise(q.CorrectAnswer) || normalise(selLetter) === normalise(q.CorrectAnswer);
            document.querySelectorAll('.mcq-option').forEach(function (btn) {
                btn.disabled = true;
                var a = btn.getAttribute('data-answer'), l = btn.getAttribute('data-letter');
                if (normalise(a) === normalise(q.CorrectAnswer) || normalise(l) === normalise(q.CorrectAnswer)) btn.classList.add('correct');
                else if (btn.classList.contains('selected')) btn.classList.add('wrong');
            });
        }

        if (isCorrect) score++;
        answered = true;
        saveAnswerRecord(q.QuestionID, selectedAnswer, isCorrect);
        var dot = document.getElementById('dot-' + currentQ);
        if (dot) dot.classList.add(isCorrect ? 'correct' : 'wrong');
        fb.className = 'feedback-msg ' + (isCorrect ? 'correct' : 'wrong');
        fb.textContent = (isCorrect ? 'Correct. ' : 'Incorrect. ') + (data.explanation || '');
        document.getElementById('checkBtn').style.display = 'none';
        document.getElementById('nextBtn').style.display = 'inline-block';
        document.getElementById('nextBtn').textContent = 'Next question \u2192';
    }

    function saveAnswerRecord(questionId, selectedAnswer, isCorrect) {
        answerRecords.push({ questionId: questionId, selectedAnswer: selectedAnswer, isCorrect: isCorrect });
    }

    function nextQuestion() {
        currentQ++;
        if (currentQ >= questions.length) showCompletion();
        else renderQuestion(currentQ);
    }

    function showCompletion() {
        document.getElementById('quizBlock').style.display = 'none';
        document.getElementById('progressFill').style.width = '100%';
        document.getElementById('progressPct').textContent = '100%';
        document.getElementById('progressLabel').textContent = 'Complete';

        var passed = score >= PASS_SCORE;
        document.getElementById('completionCard').style.display = 'block';
        document.getElementById('scoreNum').textContent = score;
        document.getElementById('scoreOutOf').textContent = 'out of ' + questions.length;

        var actions = document.getElementById('completionActions');
        actions.innerHTML = '';

        if (passed) {
            document.getElementById('completionTitle').textContent = 'Well done! You passed Module 5.';
            document.getElementById('completionMsg').textContent = 'You got ' + score + ' out of ' + questions.length + ' correct. You\'re ready for the Intermediate Challenge!';
        } else {
            document.getElementById('completionTitle').textContent = 'Not quite there yet — give it another go!';
            document.getElementById('completionMsg').textContent = 'You got ' + score + ' out of ' + questions.length + '. You need at least ' + PASS_SCORE + '/' + questions.length + ' to unlock Module 6.';
        }

        var retryBtn = document.createElement('button');
        retryBtn.type = 'button'; retryBtn.className = 'btn-retry'; retryBtn.textContent = 'Try again';
        retryBtn.onclick = restartQuiz;
        actions.appendChild(retryBtn);

        var sumBtn = document.createElement('button');
        sumBtn.type = 'button'; sumBtn.className = 'btn-next-module'; sumBtn.textContent = 'Go to summary \u2192';
        sumBtn.onclick = function () { showSummary(passed); };
        actions.appendChild(sumBtn);
    }

    function showSummary(passed) {
        document.getElementById('completionCard').style.display = 'none';
        document.getElementById('summaryScreen').style.display = 'block';
        var goBtn = document.querySelector('#summaryScreen .btn-go-module');
        if (goBtn) {
            if (passed) {
                goBtn.textContent = 'Go to Module 6 \u2192';
                goBtn.onclick = saveModuleResult;
            } else {
                goBtn.textContent = 'Try Again';
                goBtn.onclick = restartQuiz;
            }
        }
    }

    function saveModuleResult() {
        document.getElementById('<%= hfScore.ClientID %>').value = score;
    document.getElementById('<%= hfPassed.ClientID %>').value = score >= PASS_SCORE ? 'true' : 'false';
    document.getElementById('<%= hfAnswersJson.ClientID %>').value = JSON.stringify(answerRecords);
    document.getElementById('<%= btnSaveResult.ClientID %>').click();
    }

    function restartQuiz() {
        currentQ = 0; score = 0; answered = false; answerRecords = [];
        document.getElementById('completionCard').style.display = 'none';
        document.getElementById('quizBlock').style.display = 'block';
        document.getElementById('progressFill').style.width = '0%';
        document.getElementById('progressPct').textContent = '0%';
        buildDots();
        renderQuestion(0);
    }
</script>
</asp:Content>