<%@ Page Title="Slang Dictionary" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="SlangDictionary.aspx.cs" Inherits="IndoSlang.SlangDictionary" %>

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

    .topbar { background: #fff; border-bottom: 1px solid var(--cream-mid); padding: 20px 32px; display: flex; align-items: center; justify-content: space-between; flex-shrink: 0; }
    .topbar-title { font-family: var(--font-display); font-size: 1.55rem; color: var(--brown); font-weight: 700; }
    .topbar-user { display: flex; align-items: center; gap: 9px; color: var(--brown); font-weight: 700; font-size: 0.9rem; }
    .topbar-avatar { width: 36px; height: 36px; border-radius: 50%; background: var(--brown-mid); display: flex; align-items: center; justify-content: center; color: #fff; font-size: 1.1rem; }

    .dict-content { flex: 1; overflow-y: auto; padding: 32px; background: var(--cream); }

    .search-wrap { display: flex; align-items: center; gap: 12px; margin-bottom: 20px; }
    .search-input { flex: 1; max-width: 460px; padding: 11px 18px; border: 1.5px solid var(--cream-mid); border-radius: 12px; font-family: var(--font-body); font-size: 0.95rem; color: var(--brown); background: #fff; outline: none; transition: border-color 0.2s; }
    .search-input:focus { border-color: var(--accent); }
    .word-count { font-size: 0.82rem; color: var(--brown-mid); min-width: 60px; }

    .filter-row { display: flex; gap: 8px; flex-wrap: wrap; margin-bottom: 14px; }
    .filter-tab { padding: 6px 16px; border-radius: 999px; border: 1.5px solid var(--cream-mid); background: #fff; color: var(--brown); font-size: 0.82rem; font-weight: 600; cursor: pointer; transition: all 0.15s; font-family: var(--font-body); }
    .filter-tab:hover { border-color: var(--accent); color: var(--accent); }
    .filter-tab.active { background: var(--brown); border-color: var(--brown); color: #fff; }

    .letter-row { display: flex; gap: 4px; flex-wrap: wrap; margin-bottom: 28px; }
    .letter-btn { width: 28px; height: 28px; border-radius: 7px; border: 1.5px solid var(--cream-mid); background: #fff; color: var(--brown); font-size: 0.75rem; font-weight: 700; cursor: pointer; display: flex; align-items: center; justify-content: center; transition: all 0.15s; font-family: var(--font-body); }
    .letter-btn:hover { border-color: var(--accent); color: var(--accent); }
    .letter-btn.active { background: var(--brown); border-color: var(--brown); color: #fff; }

    .words-grid { display: grid; grid-template-columns: repeat(auto-fill, minmax(210px, 1fr)); gap: 14px; }
    .word-card { background: #fff; border: 1.5px solid var(--cream-mid); border-radius: 16px; padding: 18px; cursor: pointer; transition: box-shadow 0.15s, border-color 0.15s, transform 0.15s; display: flex; flex-direction: column; }
    .word-card:hover { box-shadow: 0 4px 18px rgba(59,42,26,0.10); border-color: var(--accent); transform: translateY(-2px); }
    .word-card-word { font-family: var(--font-display); font-size: 1.3rem; color: var(--brown); margin-bottom: 2px; }
    .word-card-pron { font-size: 0.76rem; color: var(--brown-mid); margin-bottom: 6px; font-style: italic; }
    .word-card-pos { display: inline-block; font-size: 0.7rem; font-weight: 700; color: var(--brown-mid); background: var(--cream-mid); border-radius: 5px; padding: 2px 8px; margin-bottom: 10px; text-transform: capitalize; }
    .word-card-meaning { font-size: 0.86rem; color: var(--brown); line-height: 1.5; flex: 1; overflow: hidden; display: -webkit-box; -webkit-line-clamp: 2; -webkit-box-orient: vertical; margin-bottom: 12px; }
    .word-card-footer { display: flex; justify-content: flex-end; }

    .level-badge { display: inline-block; font-size: 0.68rem; font-weight: 700; padding: 2px 9px; border-radius: 999px; text-transform: capitalize; }
    .level-beginner { background: var(--green); color: #fff; }
    .level-elementary { background: #007aff; color: #fff; }
    .level-intermediate { background: var(--accent); color: #fff; }
    .level-advanced { background: #c0392b; color: #fff; }

    .empty-state { text-align: center; padding: 60px 20px; color: var(--brown-mid); display: none; }
    .empty-icon { font-size: 2.5rem; margin-bottom: 12px; }
    .empty-text { font-size: 1rem; }

    /* Visitor gate */
    .visitor-gate { display: none; text-align: center; padding: 0 16px 48px; }
    .visitor-fade { height: 90px; background: linear-gradient(to bottom, transparent, var(--cream)); margin-top: -90px; position: relative; z-index: 5; pointer-events: none; }
    .visitor-cta-box { background: #fff; border: 2px solid var(--cream-mid); border-radius: 24px; padding: 36px 32px; max-width: 480px; margin: 0 auto; box-shadow: 0 8px 28px rgba(59,42,26,0.10); }
    .visitor-cta-icon { font-size: 2.4rem; margin-bottom: 12px; }
    .visitor-cta-title { font-family: var(--font-display); font-size: 1.3rem; color: var(--brown); margin-bottom: 10px; }
    .visitor-cta-desc { font-size: 0.88rem; color: var(--brown-mid); line-height: 1.6; margin-bottom: 22px; }
    .visitor-cta-btns { display: flex; gap: 12px; justify-content: center; }
    .visitor-btn-signup { background: var(--accent); color: #fff; border: none; padding: 11px 28px; border-radius: 11px; font-family: var(--font-display); font-size: 0.95rem; cursor: pointer; text-decoration: none; transition: background 0.2s; }
    .visitor-btn-signup:hover { background: var(--accent-light); color: #fff; }
    .visitor-btn-login  { background: var(--cream-mid); color: var(--brown); border: 2px solid var(--brown-mid); padding: 11px 28px; border-radius: 11px; font-family: var(--font-display); font-size: 0.95rem; cursor: pointer; text-decoration: none; transition: background 0.2s; }
    .visitor-btn-login:hover { background: #e8ddd0; color: var(--brown); }
</style>
</asp:Content>

<asp:Content ID="MainContent" ContentPlaceHolderID="MainContent" runat="server">

    <button type="button" class="sidebar-toggle" onclick="toggleSidebar()" id="sidebarToggle">&lt;</button>

    <div class="dashboard-layout">

        <!-- Sidebar -->
        <aside class="sidebar" id="sidebar">
            <a runat="server" id="lnkDashboard" class="sidebar-logo">
                <img src="Images/OWI SPARKLE EYE BIG.png" alt="IndoSlang" />
                IndoSlang
            </a>
            <nav class="sidebar-nav">
                <a runat="server" id="lnkDashboard2" class="nav-link"><span class="nav-icon">&#x1F3E0;</span> Dashboard</a>

                <!-- Visitor nav -->
                <asp:Panel ID="pnlVisitorNav" runat="server" Visible="false">
                    <a href="SlangDictionary.aspx" class="nav-link active"><span class="nav-icon">&#x1F4D6;</span> Dictionary</a>
                    <hr class="sidebar-divider" />
                    <a href="Login.aspx"    class="nav-link"><span class="nav-icon">&#x1F511;</span> Log In</a>
                    <a href="PlacementQuiz.aspx" class="nav-link"><span class="nav-icon">&#x1F464;</span> Sign Up Free</a>
                </asp:Panel>

                <!-- Member nav -->
                <asp:Panel ID="pnlMemberNav" runat="server">
                    <a href="Modules.aspx"         class="nav-link"><span class="nav-icon">&#x1F4DA;</span> My Modules</a>
                    <a href="SlangDictionary.aspx"  class="nav-link active"><span class="nav-icon">&#x1F4D6;</span> Dictionary</a>
                    <a href="CommunityChat.aspx"    class="nav-link"><span class="nav-icon">&#x1F4AC;</span> Community Chat</a>
                    <a href="BookSession.aspx"      class="nav-link"><span class="nav-icon">&#x1F91D;</span> Book a Buddy</a>
                    <a href="SessionHistory.aspx"   class="nav-link"><span class="nav-icon">&#x1F550;</span> Session History</a>
                    <a href="SuggestSlang.aspx"     class="nav-link"><span class="nav-icon">&#x2728;</span> Suggest Slang</a>
                    <hr class="sidebar-divider" />
                    <a href="MemberProfile.aspx"    class="nav-link"><span class="nav-icon">&#x1F464;</span> My Profile</a>
                    <a href="ApplyBuddy.aspx"       class="nav-link"><span class="nav-icon">&#x1F64B;</span> Apply as Buddy</a>
                </asp:Panel>

                <!-- Buddy nav -->
                <asp:Panel ID="pnlBuddyNav" runat="server" Visible="false">
                    <a href="Modules.aspx"            class="nav-link"><span class="nav-icon">&#x1F4DA;</span> My Modules</a>
                    <a href="SlangDictionary.aspx"    class="nav-link active"><span class="nav-icon">&#x1F4D6;</span> Dictionary</a>
                    <a href="CommunityChat.aspx"      class="nav-link"><span class="nav-icon">&#x1F4AC;</span> Community Chat</a>
                    <a href="HostSession.aspx"        class="nav-link"><span class="nav-icon">&#x1F3A4;</span> Host Session</a>
                    <a href="ManageAvailability.aspx" class="nav-link"><span class="nav-icon">&#x1F4C5;</span> Manage Availability</a>
                    <a href="SessionHistory.aspx"     class="nav-link"><span class="nav-icon">&#x1F550;</span> Session History</a>
                    <a href="SuggestSlang.aspx"       class="nav-link"><span class="nav-icon">&#x2728;</span> Suggest Slang</a>
                    <hr class="sidebar-divider" />
                    <a href="BuddyProfile.aspx"       class="nav-link"><span class="nav-icon">&#x1F464;</span> My Profile</a>
                    <a href="WithdrawEarnings.aspx"   class="nav-link"><span class="nav-icon">&#x1F4B8;</span> Withdraw Earnings</a>
                </asp:Panel>

                <!-- Admin nav -->
                <asp:Panel ID="pnlAdminNav" runat="server" Visible="false">
                    <a href="ManageUsers.aspx"      class="nav-link"><span class="nav-icon">&#x1F465;</span> Manage users</a>
                    <a href="ManageContent.aspx"    class="nav-link"><span class="nav-icon">&#x1F4CB;</span> Manage content</a>
                    <a href="ApproveBuddy.aspx"     class="nav-link"><span class="nav-icon">&#x2705;</span> Approve buddies</a>
                    <a href="ApproveSlang.aspx"     class="nav-link"><span class="nav-icon">&#x1F4DD;</span> Approve slang</a>
                    <a href="SessionReports.aspx"   class="nav-link"><span class="nav-icon">&#x1F4CA;</span> Session reports</a>
                    <a href="SlangDictionary.aspx"  class="nav-link active"><span class="nav-icon">&#x1F4D6;</span> Slang dictionary</a>
                </asp:Panel>
            </nav>
            <hr class="sidebar-divider" />
            <a href="Logout.aspx" class="nav-link signout"><span class="nav-icon">&#x1F6AA;</span> Sign Out</a>
        </aside>

        <!-- Main -->
        <div class="dashboard-main">

            <!-- Top bar -->
            <div class="topbar">
                <div class="topbar-title">&#x1F4D6; Slang Dictionary</div>
                <div class="topbar-user">
                    <div class="topbar-avatar">&#x1F464;</div>
                    <span><%= System.Web.HttpUtility.HtmlEncode(UserDisplayName) %></span>
                </div>
            </div>

            <!-- Dictionary content -->
            <div class="dict-content">

                <!-- Search bar -->
                <div class="search-wrap">
                    <input type="text" id="searchInput" class="search-input" placeholder="Search a word..." oninput="filterWords()" />
                    <span class="word-count" id="wordCountLabel"><%= Words.Count %> words</span>
                </div>

                <!-- Level filter tabs -->
                <div class="filter-row">
                    <button type="button" class="filter-tab active" data-level="all" onclick="setLevel(this)">All levels</button>
                    <button type="button" class="filter-tab" data-level="beginner" onclick="setLevel(this)">Beginner</button>
                    <button type="button" class="filter-tab" data-level="elementary" onclick="setLevel(this)">Elementary</button>
                    <button type="button" class="filter-tab" data-level="intermediate" onclick="setLevel(this)">Intermediate</button>
                    <button type="button" class="filter-tab" data-level="advanced" onclick="setLevel(this)">Advanced</button>
                </div>

                <!-- Letter filter -->
                <div class="letter-row">
                    <button type="button" class="letter-btn active" data-letter="all" onclick="setLetter(this)">All</button>
                    <% foreach (char c in "ABCDEFGHIJKLMNOPQRSTUVWXYZ") { %>
                    <button type="button" class="letter-btn" data-letter="<%= c.ToString().ToLower() %>" onclick="setLetter(this)"><%= c %></button>
                    <% } %>
                </div>

                <!-- Word cards grid -->
                <div class="words-grid" id="wordsGrid">
                    <% foreach (var w in Words) { %>
                    <div class="word-card"
                         data-word="<%= System.Web.HttpUtility.HtmlAttributeEncode(w.Word.ToLower()) %>"
                         data-level="<%= System.Web.HttpUtility.HtmlAttributeEncode(w.Level.ToLower()) %>"
                         data-letter="<%= w.Word.Length > 0 ? w.Word.ToLower()[0].ToString() : "" %>"
                         onclick="window.location='SlangDetail.aspx?id=<%= w.SlangID %>'">
                        <div class="word-card-word"><%= System.Web.HttpUtility.HtmlEncode(w.Word) %></div>
                        <% if (!string.IsNullOrEmpty(w.Pronunciation)) { %>
                        <div class="word-card-pron">/<%= System.Web.HttpUtility.HtmlEncode(w.Pronunciation) %>/</div>
                        <% } %>
                        <% if (!string.IsNullOrEmpty(w.PartOfSpeech)) { %>
                        <span class="word-card-pos"><%= System.Web.HttpUtility.HtmlEncode(w.PartOfSpeech) %></span>
                        <% } %>
                        <div class="word-card-meaning"><%= System.Web.HttpUtility.HtmlEncode(w.Meaning) %></div>
                        <div class="word-card-footer">
                            <% if (!string.IsNullOrEmpty(w.Level)) { %>
                            <span class="level-badge <%= GetLevelClass(w.Level) %>"><%= System.Web.HttpUtility.HtmlEncode(w.Level) %></span>
                            <% } %>
                        </div>
                    </div>
                    <% } %>
                </div>

                <!-- Empty state -->
                <div class="empty-state" id="emptyState">
                    <div class="empty-icon">&#x1F50D;</div>
                    <div class="empty-text">No words found. Try a different search or filter.</div>
                </div>

                <!-- Visitor gate (shown only for guests) -->
                <div class="visitor-gate" id="visitorGate">
                    <div class="visitor-fade"></div>
                    <div class="visitor-cta-box">
                        <div class="visitor-cta-icon">&#x1F4D6;</div>
                        <div class="visitor-cta-title">Unlock the Full Dictionary</div>
                        <p class="visitor-cta-desc">You&apos;re seeing a preview of <strong><%= Words.Count %> words</strong>. Sign up for free to search, filter, and explore the complete IndoSlang dictionary.</p>
                        <div class="visitor-cta-btns">
                            <a href="Register.aspx" class="visitor-btn-signup">Sign Up Free</a>
                            <a href="Login.aspx"    class="visitor-btn-login">Log In</a>
                        </div>
                    </div>
                </div>

            </div>
        </div>
    </div>

</asp:Content>

<asp:Content ID="ScriptContent" ContentPlaceHolderID="ScriptContent" runat="server">
<script>
    var activeLevel = 'all';
    var activeLetter = 'all';
    var isVisitor = <%= IsVisitor ? "true" : "false" %>;
    var VISITOR_LIMIT = 10;

    function toggleSidebar() {
        var sidebar = document.getElementById('sidebar');
        var toggle = document.getElementById('sidebarToggle');
        sidebar.classList.toggle('collapsed');
        toggle.classList.toggle('collapsed');
        toggle.textContent = sidebar.classList.contains('collapsed') ? '>' : '<';
    }

    function setLevel(btn) {
        document.querySelectorAll('.filter-tab').forEach(function (t) { t.classList.remove('active'); });
        btn.classList.add('active');
        activeLevel = btn.getAttribute('data-level');
        filterWords();
    }

    function setLetter(btn) {
        document.querySelectorAll('.letter-btn').forEach(function (t) { t.classList.remove('active'); });
        btn.classList.add('active');
        activeLetter = btn.getAttribute('data-letter');
        filterWords();
    }

    function filterWords() {
        var q = document.getElementById('searchInput').value.toLowerCase().trim();
        var cards = document.querySelectorAll('.word-card');
        var visible = 0;
        cards.forEach(function (card) {
            var word   = card.getAttribute('data-word')   || '';
            var level  = card.getAttribute('data-level')  || '';
            var letter = card.getAttribute('data-letter') || '';
            var matchSearch = !q || word.indexOf(q) !== -1;
            var matchLevel  = activeLevel  === 'all' || level  === activeLevel;
            var matchLetter = activeLetter === 'all' || letter === activeLetter;

            var passes = matchSearch && matchLevel && matchLetter;

            if (isVisitor) {
                // visitors see only the first VISITOR_LIMIT matching cards
                if (passes && visible < VISITOR_LIMIT) {
                    card.style.display = '';
                    visible++;
                } else {
                    card.style.display = 'none';
                }
            } else {
                if (passes) {
                    card.style.display = '';
                    visible++;
                } else {
                    card.style.display = 'none';
                }
            }
        });

        document.getElementById('emptyState').style.display = visible === 0 ? 'block' : 'none';
        document.getElementById('wordCountLabel').textContent = visible + (visible === 1 ? ' word' : ' words');

        // show or hide visitor gate
        if (isVisitor) {
            document.getElementById('visitorGate').style.display = visible > 0 ? 'block' : 'none';
        }
    }

    // run on page load so visitor gate appears immediately
    filterWords();
</script>
</asp:Content>
