<%@ Page Title="Module 1 — Slang Basics" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Module1.aspx.cs" Inherits="IndoSlang.Module1" %>

<asp:Content ID="HeadContent" ContentPlaceHolderID="HeadContent" runat="server">
<style>
    .navbar { display: none !important; }
    .site-footer { display: none !important; }
    .site-main { padding: 0 !important; margin: 0 !important; }
    body { margin: 0; padding: 0; overflow: hidden; }

    .dashboard-layout { display: flex; height: 100vh; overflow: hidden; }

    /* Sidebar */
    .sidebar { width: 260px; min-width: 260px; background: var(--brown); color: #fff; display: flex; flex-direction: column; padding: 32px 0 24px; height: 100vh; overflow-y: auto; overflow-x: hidden; flex-shrink: 0; transition: width 0.3s ease, min-width 0.3s ease; }
    .sidebar.collapsed { width: 0; min-width: 0; overflow: hidden; }
    .sidebar-logo { display: flex; align-items: center; gap: 10px; padding: 0 24px 32px; font-family: var(--font-display); font-size: 1.3rem; color: #fff; text-decoration: none; white-space: nowrap; }
    .sidebar-logo img { width: 38px; height: 38px; border-radius: 50%; flex-shrink: 0; }
    .sidebar-nav { flex: 1; }
    .nav-link { display: flex; align-items: center; gap: 10px; padding: 10px 24px; color: rgba(255,255,255,0.75); text-decoration: none; font-size: 0.92rem; border-left: 3px solid transparent; transition: background 0.15s, color 0.15s, border-color 0.15s; white-space: nowrap; }
    .nav-link:hover { background: rgba(255,255,255,0.08); color: #fff; }
    .nav-link.active { background: rgba(255,255,255,0.12); color: #fff; border-left-color: var(--accent); font-weight: 700; }
    .nav-link .nav-icon { font-size: 1rem; width: 20px; text-align: center; flex-shrink: 0; }
    .sidebar-divider { border: none; border-top: 1px solid rgba(255,255,255,0.12); margin: 16px 24px; }
    .nav-link.signout { color: rgba(255,255,255,0.45); }
    .nav-link.signout:hover { color: #ff8a8a; background: rgba(255,100,100,0.08); }

    /* Toggle */
    .sidebar-toggle { position: fixed; left: 244px; top: 50vh; transform: translateY(-50%); width: 28px; height: 28px; background: var(--brown); border: 2px solid rgba(255,255,255,0.25); border-radius: 50%; color: #fff; cursor: pointer; display: flex; align-items: center; justify-content: center; font-size: 0.8rem; z-index: 9999; transition: left 0.3s ease, background 0.2s; }
    .sidebar-toggle:hover { background: var(--brown-mid); }
    .sidebar-toggle.collapsed { left: 0px; }

    /* Main */
    .dashboard-main { flex: 1; display: flex; flex-direction: column; height: 100vh; overflow: hidden; min-width: 0; }

    /* Topbar */
    .topbar { background: var(--cream); border-bottom: 2px solid var(--cream-mid); padding: 14px 28px; display: flex; align-items: center; justify-content: space-between; flex-shrink: 0; }
    .topbar-left { display: flex; align-items: center; gap: 14px; }
    .btn-back { display: inline-flex; align-items: center; gap: 6px; background: var(--cream-mid); border: none; border-radius: 8px; padding: 7px 14px; font-family: var(--font-body); font-size: 0.85rem; color: var(--brown); cursor: pointer; text-decoration: none; font-weight: 600; transition: background 0.2s; }
    .btn-back:hover { background: #e8ddd0; }
    .topbar-title { font-family: var(--font-display); font-size: 1.5rem; color: var(--brown); font-weight: 700; }
    .topbar-user { display: flex; align-items: center; gap: 10px; color: var(--brown); font-weight: 700; font-size: 0.92rem; }
    .topbar-avatar { width: 36px; height: 36px; border-radius: 50%; background: var(--brown-mid); display: flex; align-items: center; justify-content: center; color: #fff; font-size: 1.1rem; }

    /* Module content */
    .module-content { flex: 1; overflow-y: auto; padding: 40px 48px 60px; font-family: var(--font-body); color: var(--brown); }

    /* ── SCREEN SYSTEM ── */
    .screen { display: none; }
    .screen.active { display: block; }

    /* ── INTRO SCREEN ── */
    .intro-wrap { max-width: 620px; margin: 0 auto; text-align: center; padding-top: 24px; }
    .intro-badge { display: inline-block; background: var(--accent); color: #fff; font-family: var(--font-display); font-size: 0.85rem; padding: 4px 16px; border-radius: 20px; margin-bottom: 20px; }
    .intro-wrap h1 { font-family: var(--font-display); font-size: 2rem; color: var(--brown); margin: 0 0 6px; }
    .intro-wrap h2 { font-family: var(--font-display); font-size: 1.3rem; color: var(--brown-mid); font-weight: 600; margin: 0 0 28px; }
    .intro-box { background: var(--cream); border: 2px solid var(--cream-mid); border-radius: 20px; padding: 32px 36px; box-shadow: 0 4px 20px var(--shadow); margin-bottom: 28px; text-align: left; }
    .intro-box p { margin: 0 0 14px; font-size: 0.97rem; line-height: 1.65; color: var(--brown); }
    .intro-box p:last-child { margin: 0; color: var(--brown-mid); font-style: italic; }
    .btn-start { background: var(--accent); color: #fff; border: none; border-radius: 14px; padding: 14px 40px; font-family: var(--font-display); font-size: 1.1rem; cursor: pointer; transition: background 0.2s, transform 0.15s; }
    .btn-start:hover { background: var(--accent-light); transform: translateY(-2px); }

    /* ── FLASHCARD SCREEN ── */
    .fc-header { display: flex; align-items: center; justify-content: space-between; margin-bottom: 20px; }
    .fc-header-title { font-family: var(--font-display); font-size: 1.2rem; color: var(--brown); font-weight: 700; }
    .fc-counter { font-family: var(--font-body); font-size: 0.9rem; color: var(--brown-mid); font-weight: 600; }
    .progress-bar-wrap { background: var(--cream-mid); border-radius: 99px; height: 8px; margin-bottom: 32px; overflow: hidden; }
    .progress-bar-fill { height: 100%; background: var(--accent); border-radius: 99px; transition: width 0.4s ease; }

    .flashcard-scene { perspective: 1200px; margin: 0 auto 24px; width: 100%; max-width: 640px; height: 300px; }
    .flashcard { width: 100%; height: 100%; position: relative; transform-style: preserve-3d; transition: transform 0.55s ease; cursor: pointer; }
    .flashcard.flipped { transform: rotateY(180deg); }
    .flashcard-face { position: absolute; inset: 0; border-radius: 24px; display: flex; flex-direction: column; align-items: center; justify-content: center; padding: 36px; backface-visibility: hidden; -webkit-backface-visibility: hidden; box-shadow: 0 8px 32px var(--shadow); }
    .flashcard-front { background: var(--cream); border: 2px solid var(--cream-mid); }
    .flashcard-back { background: var(--brown); color: #fff; transform: rotateY(180deg); }

    /* Front face */
    .fc-word { font-family: var(--font-display); font-size: 3rem; color: var(--brown); margin-bottom: 8px; line-height: 1; }
    .fc-pronunciation { font-size: 1rem; color: var(--brown-mid); font-style: italic; margin-bottom: 20px; }
    .fc-tap-hint { font-size: 0.82rem; color: var(--accent); font-weight: 600; letter-spacing: 0.02em; border: 1.5px solid var(--accent); border-radius: 20px; padding: 5px 14px; }

    /* Back face */
    .fc-back-word { font-family: var(--font-display); font-size: 1.8rem; color: #fff; margin-bottom: 6px; }
    .fc-meaning { font-size: 1.05rem; color: rgba(255,255,255,0.85); margin-bottom: 18px; font-style: italic; }
    .fc-example-indo { font-size: 0.92rem; color: rgba(255,255,255,0.9); margin-bottom: 4px; text-align: center; }
    .fc-example-en { font-size: 0.82rem; color: rgba(255,255,255,0.6); text-align: center; font-style: italic; }

    /* Card actions */
    .card-actions { display: flex; gap: 16px; justify-content: center; max-width: 640px; margin: 0 auto; }
    .btn-got-it, .btn-still-learning { flex: 1; max-width: 220px; padding: 13px 20px; border-radius: 14px; font-family: var(--font-display); font-size: 1rem; border: none; cursor: pointer; transition: transform 0.15s, box-shadow 0.15s, opacity 0.15s; }
    .btn-got-it { background: var(--green); color: #fff; }
    .btn-still-learning { background: var(--cream-mid); color: var(--brown); border: 2px solid var(--brown-mid); }
    .btn-got-it:hover, .btn-still-learning:hover { transform: translateY(-2px); box-shadow: 0 4px 14px rgba(0,0,0,0.12); }
    .card-actions.hidden { opacity: 0; pointer-events: none; }

    /* ── SUMMARY SCREEN ── */
    .summary-wrap { max-width: 780px; margin: 0 auto; }
    .summary-card { background: #fff; border: 1.5px solid var(--cream-mid); border-radius: 18px; padding: 44px 48px 40px; text-align: center; }
    .summary-card h2 { font-family: var(--font-display); font-size: 1.75rem; font-weight: 700; color: var(--brown); margin: 0 0 12px; line-height: 1.3; }
    .summary-score { font-size: 0.95rem; color: var(--brown-mid); line-height: 1.65; margin-bottom: 28px; font-style: italic; }
    .summary-grid { display: grid; grid-template-columns: 1fr 1fr; gap: 10px 48px; text-align: left; margin: 0 auto 28px; max-width: 560px; }
    .summary-item { display: flex; gap: 16px; align-items: baseline; padding: 6px 0; }
    .summary-item .s-word { font-family: var(--font-display); font-size: 1.05rem; font-weight: 700; color: var(--brown); min-width: 80px; }
    .summary-item .s-meaning { font-size: 0.9rem; color: var(--brown-mid); font-style: italic; }

    .summary-divider { border: none; border-top: 1.5px solid var(--cream-mid); margin: 0 0 24px; }
    .summary-note { font-style: italic; font-size: 0.92rem; color: var(--brown-mid); margin-bottom: 24px; }
    .summary-actions { display: flex; gap: 12px; justify-content: center; }
    .btn-retry { background: var(--cream-mid); color: var(--brown); border: 2px solid var(--brown-mid); padding: 12px 26px; border-radius: 13px; font-family: var(--font-display); font-size: 1rem; cursor: pointer; }
    .btn-retry:hover { background: #e8ddd0; }
    .btn-next-module { background: var(--brown); color: #fff; border: none; border-radius: 13px; padding: 13px 32px; font-family: var(--font-display); font-size: 1rem; cursor: pointer; transition: background 0.2s; }
    .btn-next-module:hover { background: var(--brown-mid); }
</style>
</asp:Content>

<asp:Content ID="MainContent" ContentPlaceHolderID="MainContent" runat="server">

    <asp:HiddenField ID="hfCompleted" runat="server" Value="0" />
    <asp:Button ID="btnSaveResult" runat="server" OnClick="btnSaveResult_Click" Style="display:none;" />

    <button type="button" class="sidebar-toggle" onclick="toggleSidebar()" id="sidebarToggle">&#8249;</button>

    <div class="dashboard-layout">

        <!-- Sidebar -->
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

        <!-- Main -->
        <div class="dashboard-main">

            <!-- Topbar -->
            <div class="topbar">
                <div class="topbar-left">
                    <a href="Modules.aspx" class="btn-back">← Modules</a>
                    <span class="topbar-title">Module 1</span>
                </div>
                <div class="topbar-user">
                    <div class="topbar-avatar">&#x1F464;</div>
                    <span id="topbarName">Member</span>
                </div>
            </div>

            <!-- Screens -->
            <div class="module-content">


            <!-- SCREEN 1: INTRO -->
            <div class="screen active" id="screenIntro">
                <div class="intro-card" style="display:flex; flex-direction:column; align-items:center; justify-content:center; text-align:center; padding:60px 40px; max-width:720px; margin:0 auto;">
                    <p style="font-family:var(--font-display); font-size:1.2rem; color:var(--brown-mid); margin:0 0 6px;">Welcome to</p>
                    <h1 style="font-family:var(--font-display); font-size:1.9rem; color:var(--brown); font-weight:700; margin:0 0 24px; line-height:1.35;">Level 1 - Beginner<br />Module 1 - Learn the Words</h1>
                    <p style="font-family:var(--font-display); font-size:1rem; color:var(--brown); font-weight:700; margin:0 0 16px;">Hey congrats! You're officially starting your IndoSlang journey.</p>
                    <p style="font-size:0.93rem; color:var(--brown-mid); margin:0 0 12px; line-height:1.7; max-width:600px;">In this module, you'll learn 5 basic slang words — what they mean, and how Indonesians actually use them in everyday chats. Think of it as your warm-up before diving into the fun stuff.</p>
                    <p style="font-size:0.93rem; color:var(--brown-mid); margin:0 0 12px; line-height:1.7; max-width:600px;">By the end of Level 1, you'll be able to recognize and use common slang naturally, just like locals do.</p>
                    <button type="button" class="btn-start" onclick="startCards()" style="margin-top:20px; border-radius:999px; padding:13px 36px; background:#fff; color:var(--brown); border:2px solid var(--brown); font-family:var(--font-display); font-size:1rem; cursor:pointer;">Got it, let's start!</button>
                </div>
            </div>

                <!-- SCREEN 2: FLASHCARDS -->
                <div class="screen" id="screenCards">
                    <div class="fc-header">
                        <span class="fc-header-title">Flashcards</span>
                        <span class="fc-counter" id="fcCounter">Card 1 of 5</span>
                    </div>
                    <div class="progress-bar-wrap">
                        <div class="progress-bar-fill" id="progressFill" style="width:0%"></div>
                    </div>

                    <div class="flashcard-scene">
                        <div class="flashcard" id="flashcard" onclick="flipCard()">
                            <div class="flashcard-face flashcard-front">
                                <div class="fc-word" id="cardWord"></div>
                                <div class="fc-pronunciation" id="cardPronunciation"></div>
                                <div class="fc-tap-hint">Tap to flip &amp; see how people use it!</div>
                            </div>
                            <div class="flashcard-face flashcard-back">
                                <div class="fc-back-word" id="cardBackWord"></div>
                                <div class="fc-meaning" id="cardMeaning"></div>
                                <div class="fc-example-indo" id="cardExampleIndo"></div>
                                <div class="fc-example-en" id="cardExampleEn"></div>
                            </div>
                        </div>
                    </div>

                    <div class="card-actions hidden" id="cardActions">
                        <button type="button" class="btn-still-learning" onclick="markCard('still')">😅 Still Learning</button>
                        <button type="button" class="btn-got-it" onclick="markCard('got')">✅ Got It!</button>
                    </div>
                </div>

                <!-- SCREEN 3: SUMMARY -->
                <div class="screen" id="screenSummary">
                    <div class="summary-wrap">
                        <div class="summary-card">
                            <h2>🎉 You just learned 5 words!</h2>
                            <p class="summary-score" id="summaryScore"></p>

                            <div class="summary-grid" id="summaryGrid"></div>
                            <hr class="summary-divider" />
                            <p class="summary-note">Now let's see if they stick. Module 2 is up next — same words, but this time you're doing the talking.</p>
                            <div class="summary-actions">
                                <button type="button" class="btn-retry" onclick="restartCards()">↩ Restart</button>
                                <button type="button" class="btn-next-module" onclick="saveAndNext()">Go to Module 2 →</button>
                            </div>
                        </div>
                    </div>
                </div>

            </div>
        </div>
    </div>
</asp:Content>

<asp:Content ID="ScriptContent" ContentPlaceHolderID="ScriptContent" runat="server">
<script>
    var userName = '<%= UserDisplayName %>';
    document.getElementById('topbarName').textContent = userName;

    function toggleSidebar() {
        var sidebar = document.getElementById('sidebar');
        var toggle = document.getElementById('sidebarToggle');
        sidebar.classList.toggle('collapsed');
        toggle.classList.toggle('collapsed');
        toggle.textContent = sidebar.classList.contains('collapsed') ? '\u203A' : '\u2039';
    }

    var cards = [
        { word: "Gabut", pronunciation: "/ gah-boot /", meaning: "Bored with nothing to do", exampleIndo: "Aku lagi gabut di rumah, gak ngapa-ngapain.", exampleEn: "I'm just bored at home, not doing anything." },
        { word: "Mager", pronunciation: "/ mah-ger /", meaning: "Too lazy to move", exampleIndo: "Mager banget hari ini, gak mau kemana-mana.", exampleEn: "So lazy today, don't want to go anywhere." },
        { word: "Santuy", pronunciation: "/ san-tooy /", meaning: "Chill, relaxed, no stress", exampleIndo: "Santuy aja, gak usah buru-buru.", exampleEn: "Just chill, no need to rush." },
        { word: "Yuk", pronunciation: "/ yook /", meaning: "Let's go! / Come on!", exampleIndo: "Yuk makan, udah lapar nih!", exampleEn: "Come on let's eat, I'm already hungry!" },
        { word: "Oke", pronunciation: "/ oh-keh /", meaning: "Okay / Sure / Got it", exampleIndo: "Oke, gue siap berangkat!", exampleEn: "Okay, I'm ready to go!" }
    ];

    var currentIndex = 0;
    var isFlipped = false;
    var stillLearning = [];

    function showScreen(id) {
        document.querySelectorAll('.screen').forEach(function (s) { s.classList.remove('active'); });
        document.getElementById(id).classList.add('active');
    }

    function startCards() {
        showScreen('screenCards');
        loadCard(0);
    }

    function loadCard(index) {
        var c = cards[index];
        document.getElementById('cardWord').textContent = c.word;
        document.getElementById('cardPronunciation').textContent = c.pronunciation;
        document.getElementById('cardBackWord').textContent = c.word;
        document.getElementById('cardMeaning').textContent = c.meaning;
        document.getElementById('cardExampleIndo').textContent = c.exampleIndo;
        document.getElementById('cardExampleEn').textContent = c.exampleEn;

        var fc = document.getElementById('flashcard');
        fc.classList.remove('flipped');
        isFlipped = false;

        document.getElementById('cardActions').classList.add('hidden');

        var pct = (index / cards.length) * 100;
        document.getElementById('progressFill').style.width = pct + '%';
        document.getElementById('fcCounter').textContent = 'Card ' + (index + 1) + ' of ' + cards.length;
    }

    function flipCard() {
        var fc = document.getElementById('flashcard');
        fc.classList.toggle('flipped');
        isFlipped = !isFlipped;
        if (isFlipped) {
            document.getElementById('cardActions').classList.remove('hidden');
        }
    }

    function markCard(status) {
        if (status === 'still') {
            // Mark it but stay on the same card — flip back to front
            if (stillLearning.indexOf(cards[currentIndex].word) === -1) {
                stillLearning.push(cards[currentIndex].word);
            }
            var fc = document.getElementById('flashcard');
            fc.classList.remove('flipped');
            isFlipped = false;
            document.getElementById('cardActions').classList.add('hidden');
            return;
        }
        // Got It — advance
        currentIndex++;
        if (currentIndex >= cards.length) {
            showSummary();
        } else {
            loadCard(currentIndex);
        }
    }

    function showSummary() {
        document.getElementById('progressFill').style.width = '100%';

        var gotCount = cards.length - stillLearning.length;
        document.getElementById('summaryScore').textContent = 'You got ' + gotCount + ' out of ' + cards.length + ' words!';

        var grid = document.getElementById('summaryGrid');
        grid.innerHTML = '';
        cards.forEach(function (c) {
            var div = document.createElement('div');
            div.className = 'summary-item';
            div.innerHTML = '<span class="s-word">' + c.word + '</span><span class="s-meaning">' + c.meaning + '</span>';
            grid.appendChild(div);
        });

        showScreen('screenSummary');
    }

    function saveAndNext() {
        document.getElementById('<%= hfCompleted.ClientID %>').value = '1';
        document.getElementById('<%= btnSaveResult.ClientID %>').click();
    }

    function restartCards() {
        currentIndex = 0;
        isFlipped = false;
        stillLearning = [];
        document.getElementById('summaryGrid').innerHTML = '';
        showScreen('screenCards');
        loadCard(0);
    }

    loadCard(0);
</script>
</asp:Content>
