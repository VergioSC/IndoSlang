<%@ Page Title="Dashboard" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="MemberDashboard.aspx.cs" Inherits="IndoSlang.MemberDashboard" %>

<asp:Content ID="HeadContent" ContentPlaceHolderID="HeadContent" runat="server">
    <style>
        .navbar { display: none !important; }
        .site-footer { display: none !important; }
        .site-main { padding: 0 !important; margin: 0 !important; }
        body { margin: 0; padding: 0; overflow: hidden; }

        /* ── Layout ── */
        .dashboard-layout { display: flex; height: 100vh; overflow: hidden; }

        /* ── Sidebar ── */
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

        /* ── Main ── */
        .dashboard-main { flex: 1; display: flex; flex-direction: column; height: 100vh; overflow: hidden; min-width: 0; background: #fff; }

        /* ── Top bar ── */
        .topbar { background: #fff; border-bottom: 1px solid var(--cream-mid); padding: 20px 32px; display: flex; align-items: center; justify-content: space-between; flex-shrink: 0; }
        .topbar-greeting h2 { font-family: var(--font-display); font-size: 1.55rem; color: var(--brown); margin: 0 0 2px; }
        .topbar-greeting p { font-size: 0.83rem; color: var(--brown-mid); margin: 0; }
        .topbar-user { display: flex; align-items: center; gap: 9px; color: var(--brown); font-weight: 700; font-size: 0.9rem; }
        .topbar-avatar { width: 36px; height: 36px; border-radius: 50%; background: var(--brown-mid); display: flex; align-items: center; justify-content: center; color: #fff; font-size: 1.1rem; }

        /* ── Scrollable content ── */
        .dash-content { flex: 1; overflow-y: auto; padding: 32px; }

        /* ── Stat cards ── */
        .stats-row { display: grid; grid-template-columns: repeat(4, 1fr); gap: 16px; margin-bottom: 36px; }
        .stat-card { background: #fff; border: 1.5px solid var(--cream-mid); border-radius: 14px; padding: 18px 20px; }
        .stat-label { font-size: 0.8rem; color: var(--brown-mid); margin-bottom: 6px; }
        .stat-value { font-family: var(--font-display); font-size: 1.55rem; font-weight: 700; color: var(--brown); }

        /* ── Section title ── */
        .section-title { font-family: var(--font-display); font-size: 1.1rem; color: var(--brown); font-weight: 700; margin: 0 0 16px; }

        /* ── Module cards ── */
        .module-cards { display: flex; flex-direction: column; gap: 12px; margin-bottom: 32px; }
        .module-card { display: flex; align-items: center; gap: 16px; border: 1.5px solid var(--cream-mid); border-radius: 14px; padding: 16px 20px; background: #fff; }
        .module-badge { width: 48px; height: 48px; border-radius: 12px; background: var(--cream-mid); display: flex; align-items: center; justify-content: center; font-family: var(--font-display); font-size: 1rem; font-weight: 700; color: var(--brown); flex-shrink: 0; }
        .module-info { flex: 1; min-width: 0; }
        .module-name { font-size: 0.95rem; font-weight: 700; color: var(--brown); margin-bottom: 8px; white-space: nowrap; overflow: hidden; text-overflow: ellipsis; }
        .progress-track { height: 6px; background: var(--cream-mid); border-radius: 99px; overflow: hidden; }
        .progress-fill { height: 100%; background: var(--brown); border-radius: 99px; transition: width 0.4s ease; }
        .btn-module { flex-shrink: 0; padding: 8px 20px; border: 1.5px solid var(--brown); border-radius: 8px; background: #fff; color: var(--brown); font-size: 0.85rem; font-weight: 700; text-decoration: none; transition: background 0.15s, color 0.15s; cursor: pointer; }
        .btn-module:hover { background: var(--brown); color: #fff; }
        .btn-module.btn-start { border-color: var(--accent); color: var(--accent); }
        .btn-module.btn-start:hover { background: var(--accent); color: #fff; }

        /* ── All done card ── */
        .all-done-card { display: flex; align-items: center; gap: 16px; border: 1.5px solid var(--green); border-radius: 14px; padding: 20px 24px; background: #f0faf3; }
        .all-done-icon { font-size: 2rem; flex-shrink: 0; }
        .all-done-text h4 { font-family: var(--font-display); font-size: 1.1rem; color: var(--green); margin: 0 0 4px; }
        .all-done-text p { font-size: 0.85rem; color: var(--brown-mid); margin: 0; }

        /* ── Widget row ── */
        .widget-row { display: grid; grid-template-columns: 1fr 1fr; gap: 16px; }
        .widget-card { border: 1.5px solid var(--cream-mid); border-radius: 14px; padding: 20px; background: #fff; }
        .widget-card h4 { font-family: var(--font-display); font-size: 1rem; color: var(--brown); margin: 0 0 8px; }
        .widget-card p { font-size: 0.88rem; color: var(--brown-mid); margin: 0 0 14px; }
        .widget-card p.no-data { opacity: 0.55; font-style: italic; }
        .btn-widget { display: inline-block; padding: 7px 16px; border: 1.5px solid var(--brown-mid); border-radius: 8px; background: #fff; color: var(--brown); font-size: 0.83rem; font-weight: 700; text-decoration: none; transition: background 0.15s, color 0.15s; }
        .btn-widget:hover { background: var(--brown); color: #fff; border-color: var(--brown); }
    </style>
</asp:Content>

<asp:Content ID="MainContent" ContentPlaceHolderID="MainContent" runat="server">

    <button type="button" class="sidebar-toggle" onclick="toggleSidebar()" id="sidebarToggle">&lt;</button>

    <div class="dashboard-layout">

        <!-- Sidebar -->
        <aside class="sidebar" id="sidebar">
            <a href="HomePage.aspx" class="sidebar-logo">
                <img src="Images/OWI SPARKLE EYE BIG.png" alt="IndoSlang" />
                IndoSlang
            </a>
            <nav class="sidebar-nav">
                <a href="MemberDashboard.aspx" class="nav-link active"><span class="nav-icon">&#x1F3E0;</span> Dashboard</a>
                <a href="Modules.aspx" class="nav-link"><span class="nav-icon">&#x1F4DA;</span> My Modules</a>
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

            <!-- Top bar -->
            <div class="topbar">
                <div class="topbar-greeting">
                    <h2 id="greetingText">Good morning, <%= System.Web.HttpUtility.HtmlEncode(UserFirstName) %>!</h2>
                    <p><%= System.Web.HttpUtility.HtmlEncode(UserLevel) %> level - keep going!</p>
                </div>
                <a href="MemberProfile.aspx" class="topbar-user" style="text-decoration:none;">
                    <div class="topbar-avatar">&#x1F464;</div>
                    <span><%= System.Web.HttpUtility.HtmlEncode(UserFirstName) %></span>
                </a>
            </div>

            <!-- Scrollable content -->
            <div class="dash-content">

                <!-- Stats -->
                <div class="stats-row">
                    <div class="stat-card">
                        <div class="stat-label">Level</div>
                        <div class="stat-value"><%= System.Web.HttpUtility.HtmlEncode(UserLevel) %></div>
                    </div>
                    <div class="stat-card">
                        <div class="stat-label">Modules done</div>
                        <div class="stat-value"><%= ModulesDone %> / 8</div>
                    </div>
                    <div class="stat-card">
                        <div class="stat-label">Sessions</div>
                        <div class="stat-value"><%= SessionsCount %></div>
                    </div>
                    <div class="stat-card">
                        <div class="stat-label">Questions done</div>
                        <div class="stat-value"><%= QuestionsDone %></div>
                    </div>
                </div>

                <!-- Continue learning -->
                <p class="section-title">Continue learning</p>
                <div class="module-cards">

                    <% if (ModulesDone >= 8) { %>
                    <div class="all-done-card">
                        <div class="all-done-icon">&#x1F3C6;</div>
                        <div class="all-done-text">
                            <h4>You've completed all modules!</h4>
                            <p>Amazing work &mdash; you&apos;ve finished every IndoSlang module. Keep practising with the dictionary and buddy sessions.</p>
                        </div>
                    </div>
                    <% } else { %>

                        <% if (HasCurrentModule) { %>
                        <div class="module-card">
                            <div class="module-badge">M<%= CurrentModuleOrder %></div>
                            <div class="module-info">
                                <div class="module-name"><%= System.Web.HttpUtility.HtmlEncode(CurrentModuleTitle) %></div>
                                <div class="progress-track">
                                    <div class="progress-fill" data-pct="<%= CurrentModulePercent %>"></div>
                                </div>
                            </div>
                            <a href="<%= CurrentModuleLink %>" class="btn-module">Resume</a>
                        </div>
                        <% } %>

                        <% if (HasNextModule) { %>
                        <div class="module-card">
                            <div class="module-badge">M<%= NextModuleOrder %></div>
                            <div class="module-info">
                                <div class="module-name"><%= System.Web.HttpUtility.HtmlEncode(NextModuleTitle) %></div>
                                <div class="progress-track">
                                    <div class="progress-fill" style="width:0%"></div>
                                </div>
                            </div>
                            <a href="<%= NextModuleLink %>" class="btn-module btn-start">Start</a>
                        </div>
                        <% } %>

                        <% if (!HasCurrentModule && !HasNextModule) { %>
                        <div class="module-card">
                            <div class="module-badge">M1</div>
                            <div class="module-info">
                                <div class="module-name">Module 1 - Getting Started</div>
                                <div class="progress-track"><div class="progress-fill" style="width:0%"></div></div>
                            </div>
                            <a href="Modules.aspx" class="btn-module btn-start">Start</a>
                        </div>
                        <% } %>

                    <% } %>

                </div>

                <!-- Widgets -->
                <div class="widget-row">
                    <div class="widget-card">
                        <h4>Upcoming buddy session</h4>
                        <% if (HasUpcomingSession) { %>
                        <p><%= System.Web.HttpUtility.HtmlEncode(UpcomingBuddyName) %> - <%= System.Web.HttpUtility.HtmlEncode(UpcomingSessionTime) %> (<%= UpcomingDuration %> min)</p>
                        <a href="SessionHistory.aspx" class="btn-widget">View details</a>
                        <% } else { %>
                        <p class="no-data">No upcoming sessions</p>
                        <a href="BookSession.aspx" class="btn-widget">Book a buddy</a>
                        <% } %>
                    </div>
                    <div class="widget-card">
                        <h4>Community chat</h4>
                        <% if (NewMessages > 0) { %>
                        <p><%= NewMessages %> new message<%= NewMessages == 1 ? "" : "s" %> since last visit</p>
                        <% } else { %>
                        <p class="no-data">No new messages</p>
                        <% } %>
                        <a href="CommunityChat.aspx" class="btn-widget">Open chat</a>
                    </div>
                </div>

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
            toggle.textContent = sidebar.classList.contains('collapsed') ? '\u203A' : '\u2039';
        }

        (function () {
            var hour = new Date().getHours();
            var greeting = hour < 12 ? 'Good morning' : hour < 17 ? 'Good afternoon' : 'Good evening';
            document.getElementById('greetingText').textContent = greeting + ', <%= System.Web.HttpUtility.JavaScriptStringEncode(UserFirstName) %>!';

            document.querySelectorAll('.progress-fill[data-pct]').forEach(function (el) {
                el.style.width = el.getAttribute('data-pct') + '%';
            });
        })();
    </script>
</asp:Content>
