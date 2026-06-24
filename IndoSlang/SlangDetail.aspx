<%@ Page Title="Word Detail" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="SlangDetail.aspx.cs" Inherits="IndoSlang.SlangDetail" %>

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

    .topbar { background: #fff; border-bottom: 1px solid var(--cream-mid); padding: 16px 32px; display: flex; align-items: center; justify-content: space-between; flex-shrink: 0; }
    .topbar-left { display: flex; align-items: center; gap: 12px; }
    .btn-back { display: inline-flex; align-items: center; gap: 6px; background: var(--cream-mid); border: none; border-radius: 10px; padding: 8px 16px; font-family: var(--font-body); font-size: 0.85rem; color: var(--brown); cursor: pointer; text-decoration: none; font-weight: 700; transition: background 0.2s; }
    .btn-back:hover { background: #e8ddd0; color: var(--brown); }
    .topbar-user { display: flex; align-items: center; gap: 9px; color: var(--brown); font-weight: 700; font-size: 0.9rem; }
    .topbar-avatar { width: 36px; height: 36px; border-radius: 50%; background: var(--brown-mid); display: flex; align-items: center; justify-content: center; color: #fff; font-size: 1.1rem; }

    .detail-content { flex: 1; overflow-y: auto; padding: 36px 32px; background: var(--cream); }

    .detail-card { background: #fff; border: 1.5px solid var(--cream-mid); border-radius: 22px; padding: 36px 40px; max-width: 720px; }

    .word-big { font-family: var(--font-display); font-size: 2.6rem; color: var(--brown); line-height: 1.1; margin-bottom: 8px; }
    .word-meta { display: flex; align-items: center; gap: 10px; flex-wrap: wrap; margin-bottom: 4px; }
    .word-pron { font-size: 0.9rem; color: var(--brown-mid); font-style: italic; }
    .word-sep { color: var(--cream-mid); font-size: 1.1rem; }
    .word-pos { display: inline-block; font-size: 0.78rem; font-weight: 700; color: var(--brown-mid); background: var(--cream-mid); border-radius: 6px; padding: 3px 10px; text-transform: capitalize; }

    .level-badge { display: inline-block; font-size: 0.75rem; font-weight: 700; padding: 3px 12px; border-radius: 999px; text-transform: capitalize; }
    .level-beginner { background: var(--green); color: #fff; }
    .level-elementary { background: #007aff; color: #fff; }
    .level-intermediate { background: var(--accent); color: #fff; }
    .level-advanced { background: #c0392b; color: #fff; }

    .detail-divider { border: none; border-top: 1px solid var(--cream-mid); margin: 24px 0; }

    .detail-section { margin-bottom: 22px; }
    .detail-label { font-size: 0.7rem; font-weight: 800; text-transform: uppercase; letter-spacing: 1.2px; color: var(--accent); margin-bottom: 9px; }
    .detail-text { font-size: 0.95rem; color: var(--brown); line-height: 1.7; }

    .example-box { background: var(--cream); border-left: 3px solid var(--brown); border-radius: 0 12px 12px 0; padding: 14px 18px; }
    .example-id { font-size: 0.97rem; color: var(--brown); font-style: italic; margin-bottom: 5px; }
    .example-en { font-size: 0.87rem; color: var(--brown-mid); }

    .context-box { background: var(--cream); border-radius: 12px; padding: 14px 18px; font-size: 0.92rem; color: var(--brown); line-height: 1.65; }

    .origin-badge { display: inline-flex; align-items: center; gap: 6px; background: var(--cream-mid); border-radius: 8px; padding: 7px 14px; font-size: 0.84rem; color: var(--brown); font-weight: 600; }
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
                <a href="Modules.aspx" class="nav-link"><span class="nav-icon">&#x1F4DA;</span> My Modules</a>
                <a href="SlangDictionary.aspx" class="nav-link active"><span class="nav-icon">&#x1F4D6;</span> Dictionary</a>
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

            <!-- Top bar -->
            <div class="topbar">
                <div class="topbar-left">
                    <a href="SlangDictionary.aspx" class="btn-back">&#x2190; Dictionary</a>
                    <% if (WordFound && !string.IsNullOrEmpty(Level)) { %>
                    <span class="level-badge <%= GetLevelClass(Level) %>"><%= System.Web.HttpUtility.HtmlEncode(Level) %></span>
                    <% } %>
                </div>
                <div class="topbar-user">
                    <div class="topbar-avatar">&#x1F464;</div>
                    <span><%= System.Web.HttpUtility.HtmlEncode(UserDisplayName) %></span>
                </div>
            </div>

            <!-- Detail content -->
            <div class="detail-content">

                <% if (WordFound) { %>
                <div class="detail-card">

                    <!-- Word title -->
                    <div class="word-big"><%= System.Web.HttpUtility.HtmlEncode(Word) %></div>

                    <!-- Pronunciation + part of speech -->
                    <div class="word-meta">
                        <% if (!string.IsNullOrEmpty(Pronunciation)) { %>
                        <span class="word-pron">/<%= System.Web.HttpUtility.HtmlEncode(Pronunciation) %>/</span>
                        <% } %>
                        <% if (!string.IsNullOrEmpty(PartOfSpeech)) { %>
                        <span class="word-sep">&middot;</span>
                        <span class="word-pos"><%= System.Web.HttpUtility.HtmlEncode(PartOfSpeech) %></span>
                        <% } %>
                    </div>

                    <hr class="detail-divider" />

                    <!-- Meaning -->
                    <% if (!string.IsNullOrEmpty(Meaning)) { %>
                    <div class="detail-section">
                        <div class="detail-label">Meaning</div>
                        <div class="detail-text"><%= System.Web.HttpUtility.HtmlEncode(Meaning) %></div>
                    </div>
                    <% } %>

                    <!-- Full explanation -->
                    <% if (!string.IsNullOrEmpty(FullExplanation)) { %>
                    <div class="detail-section">
                        <div class="detail-label">About this word</div>
                        <div class="detail-text"><%= System.Web.HttpUtility.HtmlEncode(FullExplanation) %></div>
                    </div>
                    <% } %>

                    <!-- Example sentence -->
                    <% if (!string.IsNullOrEmpty(ExampleSentence)) { %>
                    <hr class="detail-divider" />
                    <div class="detail-section">
                        <div class="detail-label">Example</div>
                        <div class="example-box">
                            <div class="example-id">&#x201C;<%= System.Web.HttpUtility.HtmlEncode(ExampleSentence) %>&#x201D;</div>
                            <% if (!string.IsNullOrEmpty(ExampleTranslation)) { %>
                            <div class="example-en"><%= System.Web.HttpUtility.HtmlEncode(ExampleTranslation) %></div>
                            <% } %>
                        </div>
                    </div>
                    <% } %>

                    <!-- Used in context -->
                    <% if (!string.IsNullOrEmpty(UsedInContext)) { %>
                    <hr class="detail-divider" />
                    <div class="detail-section">
                        <div class="detail-label">Used in context</div>
                        <div class="context-box"><%= System.Web.HttpUtility.HtmlEncode(UsedInContext) %></div>
                    </div>
                    <% } %>

                    <!-- Origin -->
                    <% if (!string.IsNullOrEmpty(Origin)) { %>
                    <hr class="detail-divider" />
                    <div class="detail-section">
                        <div class="detail-label">Origin</div>
                        <span class="origin-badge">&#x1F30F; <%= System.Web.HttpUtility.HtmlEncode(Origin) %></span>
                    </div>
                    <% } %>

                </div>
                <% } %>

            </div>
        </div>
    </div>

</asp:Content>

<asp:Content ID="ScriptContent" ContentPlaceHolderID="ScriptContent" runat="server">
<script>
    function toggleSidebar() {
        var sidebar = document.getElementById('sidebar');
        var toggle = document.getElementById('sidebarToggle');
        sidebar.classList.toggle('collapsed');
        toggle.classList.toggle('collapsed');
        toggle.textContent = sidebar.classList.contains('collapsed') ? '>' : '<';
    }
</script>
</asp:Content>
