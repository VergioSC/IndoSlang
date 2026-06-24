<%@ Page Title="Session History" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="SessionHistory.aspx.cs" Inherits="IndoSlang.SessionHistory" %>

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
        .dashboard-main { flex: 1; display: flex; flex-direction: column; height: 100vh; overflow: hidden; min-width: 0; background: #fff; }
        .topbar { background: #fff; border-bottom: 1px solid var(--cream-mid); padding: 20px 32px; display: flex; align-items: center; justify-content: space-between; flex-shrink: 0; }
        .topbar-left h2 { font-family: var(--font-display); font-size: 1.55rem; color: var(--brown); margin: 0 0 2px; }
        .topbar-left p { font-size: 0.83rem; color: var(--brown-mid); margin: 0; }
        .topbar-user { display: flex; align-items: center; gap: 9px; color: var(--brown); font-weight: 700; font-size: 0.9rem; }
        .topbar-avatar { width: 36px; height: 36px; border-radius: 50%; background: var(--brown-mid); display: flex; align-items: center; justify-content: center; color: #fff; font-size: 1.1rem; }
        .dash-content { flex: 1; overflow-y: auto; padding: 32px; }
        .section-title { font-family: var(--font-display); font-size: 1.1rem; color: var(--brown); font-weight: 700; margin: 0 0 16px; }
        .msg-success { position: fixed; top: 0; left: 0; right: 0; z-index: 99999; background: #d4edda; color: #1a5c2a; padding: 10px 20px; font-size: 0.88rem; text-align: center; border-bottom: 1px solid #a5d6a7; display: none; }
        .msg-error { position: fixed; top: 0; left: 0; right: 0; z-index: 99999; background: #fde8e8; color: #7b1515; padding: 10px 20px; font-size: 0.88rem; text-align: center; border-bottom: 1px solid #ef9a9a; display: none; }
        .filter-tabs { display: flex; gap: 8px; margin-bottom: 28px; flex-wrap: wrap; }
        .tab-btn { padding: 7px 20px; border: 1.5px solid var(--cream-mid); border-radius: 999px; background: #fff; color: var(--brown-mid); font-size: 0.85rem; font-weight: 600; cursor: pointer; transition: all 0.15s; }
        .tab-btn:hover { border-color: var(--brown); color: var(--brown); }
        .tab-btn.active { background: var(--brown); border-color: var(--brown); color: #fff; }
        .session-group { margin-bottom: 28px; }
        .group-title { font-size: 0.8rem; font-weight: 700; color: var(--brown-mid); text-transform: uppercase; letter-spacing: 0.06em; margin: 0 0 12px; }
        .session-card { display: flex; align-items: center; background: #fff; border: 1.5px solid var(--cream-mid); border-radius: 14px; padding: 16px 20px; margin-bottom: 10px; gap: 16px; }
        .session-avatar { width: 42px; height: 42px; border-radius: 50%; background: var(--cream-mid); display: flex; align-items: center; justify-content: center; color: var(--brown); font-size: 1.15rem; flex-shrink: 0; }
        .session-info { flex: 1; min-width: 0; }
        .session-name { font-weight: 700; color: var(--brown); font-size: 0.95rem; margin: 0 0 3px; }
        .session-meta { color: var(--brown-mid); font-size: 0.82rem; }
        .session-right { display: flex; align-items: center; gap: 14px; flex-shrink: 0; }
        .session-amount-block { text-align: right; min-width: 68px; }
        .session-amount { font-weight: 700; color: var(--brown); font-size: 0.95rem; }
        .session-earn-label { font-size: 0.78rem; color: var(--brown-mid); }
        .status-badge { display: inline-block; padding: 4px 14px; border-radius: 8px; font-size: 0.78rem; font-weight: 600; white-space: nowrap; background: #e8e8e8; color: #444; }
        .status-cancelled { background: #fde8e8; color: #7b1515; }
        .btn-cancel { padding: 6px 16px; border: 1.5px solid var(--brown); border-radius: 8px; background: #fff; color: var(--brown); font-size: 0.82rem; font-weight: 600; cursor: pointer; transition: background 0.15s; }
        .btn-cancel:hover { background: var(--cream-mid); }
        .btn-join { display: block; padding: 5px 16px; border: 1.5px solid var(--brown-mid); border-radius: 8px; background: var(--cream-mid); color: var(--brown); font-size: 0.82rem; font-weight: 600; cursor: pointer; text-decoration: none; text-align: center; transition: background 0.15s; margin-top: 6px; }
        .btn-join:hover { background: var(--cream); color: var(--brown); }
        .btn-review { padding: 6px 16px; border: 1.5px solid var(--brown); border-radius: 8px; background: #fff; color: var(--brown); font-size: 0.82rem; font-weight: 600; cursor: pointer; transition: background 0.15s; }
        .btn-review:hover { background: var(--cream-mid); }
        .btn-receipt { padding: 6px 16px; border: 1.5px solid var(--brown); border-radius: 8px; background: #fff; color: var(--brown); font-size: 0.82rem; font-weight: 600; cursor: pointer; transition: background 0.15s; }
        .btn-receipt:hover { background: var(--cream-mid); }
        .session-card.alt-row { background: #f5f5f5; }
        .total-footer { display: flex; justify-content: space-between; align-items: center; background: var(--cream-mid); border-radius: 12px; padding: 16px 20px; margin-top: 8px; }
        .total-label { color: var(--brown-mid); font-size: 0.9rem; }
        .total-amount { font-weight: 700; color: var(--brown); font-size: 1rem; }
        .btn-book-new { padding: 10px 20px; background: var(--brown); color: #fff; border: none; border-radius: 10px; font-family: var(--font-display); font-size: 0.88rem; font-weight: 700; cursor: pointer; text-decoration: none; display: inline-flex; align-items: center; gap: 6px; transition: opacity 0.15s; }
        .btn-book-new:hover { opacity: 0.88; color: #fff; }
        .topbar-right { display: flex; align-items: center; gap: 14px; }
        .empty-sessions { text-align: center; padding: 48px 32px; color: var(--brown-mid); font-size: 0.9rem; font-style: italic; border: 1.5px dashed var(--cream-mid); border-radius: 14px; }
        .hidden-control { display: none; }
    </style>
</asp:Content>

<asp:Content ID="MainContent" ContentPlaceHolderID="MainContent" runat="server">

    <asp:HiddenField ID="hfCancelId" runat="server" />
    <asp:Button ID="btnCancelConfirm" runat="server" Text="Cancel" CssClass="hidden-control" OnClick="btnCancelConfirm_Click" />
    <asp:Label ID="lblMessage" runat="server" CssClass="msg-success" Style="display:none" />

    <button type="button" class="sidebar-toggle" onclick="toggleSidebar()" id="sidebarToggle">&lt;</button>

    <div class="dashboard-layout">

        <!-- Sidebar: Member nav -->
        <% if (!IsBuddy) { %>
        <aside class="sidebar" id="sidebar">
            <a href="HomePage.aspx" class="sidebar-logo">
                <img src="Images/OWI SPARKLE EYE BIG.png" alt="IndoSlang" />
                IndoSlang
            </a>
            <nav class="sidebar-nav">
                <a href="MemberDashboard.aspx" class="nav-link"><span class="nav-icon">&#x1F3E0;</span> Dashboard</a>
                <a href="Modules.aspx" class="nav-link"><span class="nav-icon">&#x1F4DA;</span> My Modules</a>
                <a href="SlangDictionary.aspx" class="nav-link"><span class="nav-icon">&#x1F4D6;</span> Dictionary</a>
                <a href="CommunityChat.aspx" class="nav-link"><span class="nav-icon">&#x1F4AC;</span> Community Chat</a>
                <a href="BookSession.aspx" class="nav-link"><span class="nav-icon">&#x1F91D;</span> Book a Buddy</a>
                <a href="SessionHistory.aspx" class="nav-link active"><span class="nav-icon">&#x1F550;</span> Session History</a>
                <a href="SuggestSlang.aspx" class="nav-link"><span class="nav-icon">&#x2728;</span> Suggest Slang</a>
                <hr class="sidebar-divider" />
                <a href="MemberProfile.aspx" class="nav-link"><span class="nav-icon">&#x1F464;</span> My Profile</a>
                <a href="ApplyBuddy.aspx" class="nav-link"><span class="nav-icon">&#x1F64B;</span> Apply as Buddy</a>
            </nav>
            <hr class="sidebar-divider" />
            <a href="Logout.aspx" class="nav-link signout"><span class="nav-icon">&#x1F6AA;</span> Sign Out</a>
        </aside>
        <% } else { %>
        <!-- Sidebar: Buddy nav -->
        <aside class="sidebar" id="sidebar">
            <a href="HomePage.aspx" class="sidebar-logo">
                <img src="Images/OWI SPARKLE EYE BIG.png" alt="IndoSlang" />
                IndoSlang
            </a>
            <nav class="sidebar-nav">
                <a href="BuddyDashboard.aspx" class="nav-link"><span class="nav-icon">&#x1F3E0;</span> Dashboard</a>
                <a href="Modules.aspx" class="nav-link"><span class="nav-icon">&#x1F4DA;</span> My Modules</a>
                <a href="SlangDictionary.aspx" class="nav-link"><span class="nav-icon">&#x1F4D6;</span> Dictionary</a>
                <a href="CommunityChat.aspx" class="nav-link"><span class="nav-icon">&#x1F4AC;</span> Community Chat</a>
                <a href="HostSession.aspx" class="nav-link"><span class="nav-icon">&#x1F3A4;</span> Host Session</a>
                <a href="ManageAvailability.aspx" class="nav-link"><span class="nav-icon">&#x1F4C5;</span> Manage Availability</a>
                <a href="SessionHistory.aspx" class="nav-link active"><span class="nav-icon">&#x1F550;</span> Session History</a>
                <a href="SuggestSlang.aspx" class="nav-link"><span class="nav-icon">&#x2728;</span> Suggest Slang</a>
                <hr class="sidebar-divider" />
                <a href="BuddyProfile.aspx" class="nav-link"><span class="nav-icon">&#x1F464;</span> My Profile</a>
                <a href="WithdrawEarnings.aspx" class="nav-link"><span class="nav-icon">&#x1F4B8;</span> Withdraw Earnings</a>
            </nav>
            <hr class="sidebar-divider" />
            <a href="Logout.aspx" class="nav-link signout"><span class="nav-icon">&#x1F6AA;</span> Sign Out</a>
        </aside>
        <% } %>

        <div class="dashboard-main">
            <div class="topbar">
                <div class="topbar-left">
                    <h2>Session History</h2>
                    <p><%= IsBuddy ? "Sessions you have hosted or are hosting" : "Sessions you have booked" %></p>
                </div>
                <div class="topbar-right">
                    <% if (!IsBuddy) { %>
                    <a href="BookSession.aspx" class="btn-book-new">&#x2795; Book new session</a>
                    <% } %>
                    <div class="topbar-user">
                        <div class="topbar-avatar">&#x1F464;</div>
                        <span><%= System.Web.HttpUtility.HtmlEncode(UserName) %></span>
                    </div>
                </div>
            </div>

            <div class="dash-content">

                <% if (Sessions.Count == 0) { %>
                <div class="empty-sessions">
                    <% if (IsBuddy) { %>No sessions yet. Add availability so members can book you!
                    <% } else { %>No sessions yet. <a href="BookSession.aspx">Book a buddy</a> to get started!
                    <% } %>
                </div>
                <% } else { %>

                <div class="filter-tabs">
                    <button type="button" class="tab-btn active" onclick="filterSessions('all', this)">All</button>
                    <button type="button" class="tab-btn" onclick="filterSessions('upcoming', this)">Upcoming</button>
                    <button type="button" class="tab-btn" onclick="filterSessions('completed', this)">Completed</button>
                    <button type="button" class="tab-btn" onclick="filterSessions('cancelled', this)">Cancelled</button>
                </div>

                <% if (UpcomingSessions.Count > 0) { %>
                <div class="session-group" data-status="upcoming">
                    <p class="group-title">Upcoming</p>
                    <% foreach (var s in UpcomingSessions) { %>
                    <div class="session-card">
                        <div class="session-avatar">&#x1F464;</div>
                        <div class="session-info">
                            <p class="session-name">Session with <%= System.Web.HttpUtility.HtmlEncode(s.OtherName) %></p>
                            <p class="session-meta"><%= System.Web.HttpUtility.HtmlEncode(s.DateDisplay) %> &bull; <%= System.Web.HttpUtility.HtmlEncode(s.TimeDisplay) %> &bull; <%= s.Duration %> min</p>
                        </div>
                        <div class="session-right">
                            <div>
                                <span class="status-badge">Upcoming</span>
                                <a href="<%= System.Web.HttpUtility.HtmlAttributeEncode(s.JoinUrl) %>"
                                   class="btn-join" target="_blank" rel="noopener noreferrer">Join</a>
                            </div>
                            <div class="session-amount-block">
                                <div class="session-amount"><%= s.AmountDisplay %></div>
                                <div class="session-earn-label">Paid</div>
                            </div>
                            <div>
                                <% if (s.CanCancel) { %>
                                <button type="button" class="btn-cancel" onclick="cancelSession(<%= s.SessionID %>)">Cancel</button>
                                <% } %>
                            </div>
                        </div>
                    </div>
                    <% } %>
                </div>
                <% } %>

                <% if (CompletedSessions.Count > 0) { %>
                <div class="session-group" data-status="completed">
                    <p class="group-title">Completed</p>
                    <% for (int i = 0; i < CompletedSessions.Count; i++) {
                           var s = CompletedSessions[i];
                           string rowClass = i % 2 == 1 ? "session-card alt-row" : "session-card";
                    %>
                    <div class="<%= rowClass %>">
                        <div class="session-avatar">&#x1F464;</div>
                        <div class="session-info">
                            <p class="session-name">Session with <%= System.Web.HttpUtility.HtmlEncode(s.OtherName) %></p>
                            <p class="session-meta"><%= System.Web.HttpUtility.HtmlEncode(s.DateDisplay) %> &bull; <%= System.Web.HttpUtility.HtmlEncode(s.TimeDisplay) %> &bull; <%= s.Duration %> min</p>
                        </div>
                        <div class="session-right">
                            <span class="status-badge">Completed</span>
                            <div class="session-amount-block">
                                <div class="session-amount"><%= s.AmountDisplay %></div>
                                <div class="session-earn-label"><%= IsBuddy ? "earned" : "Paid" %></div>
                            </div>
                            <div>
                                <% if (i == 0) { %>
                                <button type="button" class="btn-review">Review</button>
                                <% } else { %>
                                <button type="button" class="btn-receipt">Receipt</button>
                                <% } %>
                            </div>
                        </div>
                    </div>
                    <% } %>
                </div>
                <% } %>

                <% if (CancelledSessions.Count > 0) { %>
                <div class="session-group" data-status="cancelled">
                    <p class="group-title">Cancelled</p>
                    <% foreach (var s in CancelledSessions) { %>
                    <div class="session-card">
                        <div class="session-avatar">&#x1F464;</div>
                        <div class="session-info">
                            <p class="session-name">Session with <%= System.Web.HttpUtility.HtmlEncode(s.OtherName) %></p>
                            <p class="session-meta"><%= System.Web.HttpUtility.HtmlEncode(s.DateDisplay) %> &bull; <%= System.Web.HttpUtility.HtmlEncode(s.TimeDisplay) %> &bull; <%= s.Duration %> min</p>
                        </div>
                        <div class="session-right">
                            <span class="status-badge status-cancelled">Cancelled</span>
                            <div class="session-amount-block">
                                <div class="session-amount" style="color:var(--brown-mid)"><%= s.AmountDisplay %></div>
                            </div>
                        </div>
                    </div>
                    <% } %>
                </div>
                <% } %>

                <% if (CompletedCount > 0) { %>
                <div class="total-footer">
                    <% if (IsBuddy) { %>
                    <span class="total-label">Total earned &bull; <%= CompletedCount %> session<%= CompletedCount != 1 ? "s" : "" %> hosted</span>
                    <span class="total-amount">RM <%= TotalEarned.ToString("0.00") %></span>
                    <% } else { %>
                    <span class="total-label">Total spent &bull; <%= CompletedCount %> session<%= CompletedCount != 1 ? "s" : "" %> completed</span>
                    <span class="total-amount">RM <%= TotalSpent.ToString("0.00") %></span>
                    <% } %>
                </div>
                <% } %>

                <% } %>

            </div>
        </div>
    </div>

</asp:Content>

<asp:Content ID="ScriptContent" ContentPlaceHolderID="ScriptContent" runat="server">
    <script>
        (function() {
            var banners = document.querySelectorAll('.msg-success, .msg-error');
            banners.forEach(function(b) {
                if (b.style.display !== 'none' && b.textContent.trim() !== '') {
                    setTimeout(function() {
                        b.style.transition = 'opacity 0.4s';
                        b.style.opacity = '0';
                        setTimeout(function() { b.style.display = 'none'; }, 400);
                    }, 3000);
                }
            });
        })();

        function toggleSidebar() {
            var sidebar = document.getElementById('sidebar');
            var toggle = document.getElementById('sidebarToggle');
            sidebar.classList.toggle('collapsed');
            toggle.classList.toggle('collapsed');
            toggle.textContent = sidebar.classList.contains('collapsed') ? '>' : '<';
        }

        function filterSessions(filter, btn) {
            document.querySelectorAll('.tab-btn').forEach(function(b) { b.classList.remove('active'); });
            btn.classList.add('active');
            document.querySelectorAll('.session-group').forEach(function(g) {
                g.style.display = (filter === 'all' || g.dataset.status === filter) ? '' : 'none';
            });
        }

        function cancelSession(id) {
            if (!confirm('Cancel this session? The time slot will be freed up.')) return;
            document.getElementById('<%= hfCancelId.ClientID %>').value = id;
            document.getElementById('<%= btnCancelConfirm.ClientID %>').click();
        }
    </script>
</asp:Content>
