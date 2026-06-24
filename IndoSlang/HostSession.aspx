<%@ Page Title="Host a Session" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="HostSession.aspx.cs" Inherits="IndoSlang.HostSession" %>

<asp:Content ID="HeadContent" ContentPlaceHolderID="HeadContent" runat="server">
<style>
    .navbar{display:none!important}.site-footer{display:none!important}.site-main{padding:0!important;margin:0!important}
    body{margin:0;padding:0;overflow:hidden}
    .dashboard-layout{display:flex;height:100vh;overflow:hidden}

    /* sidebar */
    .sidebar{width:260px;min-width:260px;background:var(--brown);color:#fff;display:flex;flex-direction:column;padding:32px 0 24px;height:100vh;overflow-y:auto;overflow-x:hidden;flex-shrink:0;transition:width .3s,min-width .3s}
    .sidebar.collapsed{width:0;min-width:0;overflow:hidden}
    .sidebar-logo{display:flex;align-items:center;gap:10px;padding:0 24px 32px;font-family:var(--font-display);font-size:1.3rem;color:#fff;text-decoration:none;white-space:nowrap}
    .sidebar-logo img{width:38px;height:38px;border-radius:50%;flex-shrink:0}
    .sidebar-nav{flex:1}
    .nav-link{display:flex;align-items:center;gap:10px;padding:10px 24px;color:rgba(255,255,255,.75);text-decoration:none;font-size:.92rem;border-left:3px solid transparent;transition:background .15s,color .15s,border-color .15s;white-space:nowrap}
    .nav-link:hover{background:rgba(255,255,255,.08);color:#fff}
    .nav-link.active{background:rgba(255,255,255,.12);color:#fff;border-left-color:var(--accent);font-weight:700}
    .nav-icon{font-size:1rem;width:20px;text-align:center;flex-shrink:0}
    .sidebar-divider{border:none;border-top:1px solid rgba(255,255,255,.12);margin:16px 24px}
    .nav-link.signout{color:rgba(255,255,255,.45)}
    .nav-link.signout:hover{color:#ff8a8a;background:rgba(255,100,100,.08)}
    .sidebar-toggle{position:fixed;left:244px;top:50vh;transform:translateY(-50%);width:28px;height:28px;background:var(--brown);border:2px solid rgba(255,255,255,.25);border-radius:50%;color:#fff;cursor:pointer;display:flex;align-items:center;justify-content:center;font-size:.8rem;z-index:9999;transition:left .3s,background .2s}
    .sidebar-toggle:hover{background:var(--brown-mid)}
    .sidebar-toggle.collapsed{left:0}

    /* main shell */
    .dashboard-main{flex:1;display:flex;flex-direction:column;height:100vh;overflow:hidden;min-width:0}
    .topbar{background:var(--cream);border-bottom:2px solid var(--cream-mid);padding:14px 34px;display:flex;align-items:center;justify-content:space-between;flex-shrink:0}
    .topbar-left{display:flex;flex-direction:column;gap:2px}
    .topbar-title{font-family:var(--font-display);font-size:1.55rem;color:var(--brown);font-weight:700;line-height:1.2}
    .topbar-sub{font-size:.85rem;color:var(--brown-mid)}
    .topbar-user{display:flex;align-items:center;gap:10px;color:var(--brown);font-weight:700;font-size:.92rem}
    .topbar-avatar{width:38px;height:38px;border-radius:50%;background:var(--brown-mid);display:flex;align-items:center;justify-content:center;color:#fff;font-size:1.1rem}

    /* scroll area */
    .module-content{flex:1;overflow-y:auto;padding:36px 44px 70px;background:var(--cream);font-family:var(--font-body);color:var(--brown)}
    .content-wrap{max-width:820px}

    /* section heading */
    .section-heading{font-family:var(--font-display);font-size:1.2rem;font-weight:700;color:var(--brown);margin:0 0 14px}
    .section-wrap{margin-bottom:36px}

    /* session card shell */
    .session-card{background:#fff;border:2px solid var(--cream-mid);border-radius:22px;overflow:hidden;box-shadow:0 6px 22px rgba(59,42,26,.09);margin-bottom:12px}
    .card-row{display:flex;align-items:center;gap:16px;padding:20px 24px}
    .s-avatar{width:50px;height:50px;border-radius:50%;background:var(--cream-mid);display:flex;align-items:center;justify-content:center;font-size:1.6rem;flex-shrink:0;color:var(--brown-mid)}
    .s-info{flex:1;min-width:0}
    .s-name{font-family:var(--font-display);font-size:1.05rem;font-weight:700;color:var(--brown);margin-bottom:3px}
    .s-time{font-size:.87rem;color:var(--brown-mid);margin-bottom:2px}
    .s-meta{font-size:.83rem;color:var(--brown-mid)}
    .s-actions{display:flex;flex-direction:column;align-items:flex-end;gap:10px;flex-shrink:0}

    /* badges */
    .badge-soon{background:var(--cream-mid);color:var(--brown);border:1.5px solid var(--brown-mid);border-radius:999px;padding:5px 14px;font-size:.83rem;font-weight:700;white-space:nowrap}
    .badge-upcoming{background:var(--cream);color:var(--brown-mid);border:1.5px solid var(--cream-mid);border-radius:999px;padding:5px 14px;font-size:.83rem;font-weight:700;white-space:nowrap}
    .badge-now{background:var(--accent);color:#fff;border:1.5px solid var(--accent);border-radius:999px;padding:5px 14px;font-size:.83rem;font-weight:700;white-space:nowrap}

    /* join button */
    .btn-join{background:var(--brown);color:#fff;border:none;border-radius:10px;padding:10px 22px;font-family:var(--font-display);font-size:.95rem;cursor:pointer;text-decoration:none;display:inline-block;transition:background .2s;white-space:nowrap}
    .btn-join:hover{background:var(--brown-mid);color:#fff}

    /* session link box */
    .link-box{background:var(--cream);border-top:2px solid var(--cream-mid);padding:14px 24px}
    .link-box-label{font-size:.75rem;font-weight:700;color:var(--brown-mid);text-transform:uppercase;letter-spacing:.5px;margin-bottom:6px}
    .link-box-url{font-size:.9rem;color:var(--brown);background:#fff;border:2px solid var(--cream-mid);border-radius:10px;padding:9px 14px;word-break:break-all;user-select:all}

    /* cut column */
    .s-cut{text-align:right;flex-shrink:0}
    .s-cut-amount{font-family:var(--font-display);font-size:1.05rem;font-weight:700;color:var(--brown)}
    .s-cut-label{font-size:.78rem;color:var(--brown-mid)}

    /* empty state */
    .empty-state{text-align:center;padding:80px 40px;max-width:500px}
    .empty-icon{font-size:3.5rem;margin-bottom:16px}
    .empty-title{font-family:var(--font-display);font-size:1.3rem;color:var(--brown);margin-bottom:8px}
    .empty-desc{font-size:.93rem;color:var(--brown-mid);line-height:1.7}
</style>
</asp:Content>

<asp:Content ID="MainContent" ContentPlaceHolderID="MainContent" runat="server">

    <button type="button" class="sidebar-toggle" onclick="toggleSidebar()" id="sidebarToggle">&lt;</button>

    <div class="dashboard-layout">

        <aside class="sidebar" id="sidebar">
            <a runat="server" id="lnkLogo" class="sidebar-logo">
                <img src="Images/OWI SPARKLE EYE BIG.png" alt="IndoSlang" />
                IndoSlang
            </a>
            <nav class="sidebar-nav">
                <a href="BuddyDashboard.aspx" class="nav-link"><span class="nav-icon">&#x1F3E0;</span> Dashboard</a>
                <a href="Modules.aspx"         class="nav-link"><span class="nav-icon">&#x1F4DA;</span> My Modules</a>
                <a href="SlangDictionary.aspx" class="nav-link"><span class="nav-icon">&#x1F4D6;</span> Dictionary</a>
                <a href="CommunityChat.aspx"   class="nav-link"><span class="nav-icon">&#x1F4AC;</span> Community Chat</a>
                <a href="HostSession.aspx"     class="nav-link active"><span class="nav-icon">&#x1F3A4;</span> Host Session</a>
                <a href="ManageAvailability.aspx" class="nav-link"><span class="nav-icon">&#x1F4C5;</span> Manage Availability</a>
                <a href="SessionHistory.aspx"  class="nav-link"><span class="nav-icon">&#x1F550;</span> Session History</a>
                <a href="SuggestSlang.aspx"    class="nav-link"><span class="nav-icon">&#x2728;</span> Suggest Slang</a>
                <hr class="sidebar-divider" />
                <a href="BuddyProfile.aspx"    class="nav-link"><span class="nav-icon">&#x1F464;</span> My Profile</a>
                <a href="WithdrawEarnings.aspx" class="nav-link"><span class="nav-icon">&#x1F4B8;</span> Withdraw Earnings</a>
            </nav>
            <hr class="sidebar-divider" />
            <a href="Logout.aspx" class="nav-link signout"><span class="nav-icon">&#x1F6AA;</span> Sign Out</a>
        </aside>

        <div class="dashboard-main">
            <div class="topbar">
                <div class="topbar-left">
                    <span class="topbar-title">Host a session</span>
                    <span class="topbar-sub">Upcoming booked sessions from members</span>
                </div>
                <div class="topbar-user">
                    <div class="topbar-avatar">&#x1F464;</div>
                    <span id="topbarName">Buddy</span>
                </div>
            </div>

            <div class="module-content">
                <div class="content-wrap">

                    <% if (NextSession != null) { %>
                    <div class="section-wrap">
                        <h2 class="section-heading">Next session &#8212; starting soon</h2>
                        <div class="session-card">
                            <div class="card-row">
                                <div class="s-avatar">&#x1F464;</div>
                                <div class="s-info">
                                    <div class="s-name"><%: NextSession.MemberName %></div>
                                    <div class="s-time"><%: NextSession.FormattedTime %></div>
                                    <div class="s-meta"><%: NextSession.MemberLevel %> level &bull; <%: NextSession.MemberTotalSessions %> sessions total</div>
                                </div>
                                <div class="s-actions">
                                    <% if (NextSession.IsStartingSoon) { %>
                                        <span class="<%= NextSession.TimeLabel == "Starting now" ? "badge-now" : "badge-soon" %>">
                                            <%: NextSession.TimeLabel %>
                                        </span>
                                    <% } else { %>
                                        <span class="badge-upcoming"><%: NextSession.TimeLabel %></span>
                                    <% } %>
                                    <a href="<%= HttpUtility.HtmlAttributeEncode(NextSession.SafeSessionUrl) %>"
                                       class="btn-join" target="_blank" rel="noopener noreferrer">Join session</a>
                                </div>
                            </div>
                            <div class="link-box">
                                <div class="link-box-label">Session room link</div>
                                <div class="link-box-url"><%: NextSession.SafeSessionUrl %></div>
                            </div>
                        </div>
                    </div>
                    <% } %>

                    <% if (OtherSessions.Count > 0) { %>
                    <div class="section-wrap">
                        <h2 class="section-heading">Other upcoming</h2>
                        <% foreach (var s in OtherSessions) { %>
                        <div class="session-card">
                            <div class="card-row">
                                <div class="s-avatar">&#x1F464;</div>
                                <div class="s-info">
                                    <div class="s-name"><%: s.MemberName %></div>
                                    <div class="s-time"><%: s.FormattedTime %></div>
                                </div>
                                <span class="badge-upcoming"><%: s.TimeLabel %></span>
                                <div class="s-cut">
                                    <div class="s-cut-amount">RM <%: s.BuddyCut.ToString("0.00") %></div>
                                    <div class="s-cut-label">your cut</div>
                                </div>
                            </div>
                        </div>
                        <% } %>
                    </div>
                    <% } %>

                    <% if (NextSession == null && OtherSessions.Count == 0) { %>
                    <div class="empty-state">
                        <div class="empty-icon">&#x1F4C5;</div>
                        <div class="empty-title">No upcoming sessions</div>
                        <div class="empty-desc">
                            When members book a session with you, it will appear here.<br />
                            Make sure your availability is set in
                            <a href="ManageAvailability.aspx" style="color:var(--accent);font-weight:700">Manage Availability</a>.
                        </div>
                    </div>
                    <% } %>

                </div>
            </div>
        </div>
    </div>
</asp:Content>

<asp:Content ID="ScriptContent" ContentPlaceHolderID="ScriptContent" runat="server">
<script>
    var _userName = '<%= UserDisplayName %>';
    document.getElementById('topbarName').textContent = _userName || 'Buddy';

    function toggleSidebar() {
        var sb = document.getElementById('sidebar'), tg = document.getElementById('sidebarToggle');
        sb.classList.toggle('collapsed'); tg.classList.toggle('collapsed');
        tg.textContent = sb.classList.contains('collapsed') ? '›' : '‹';
    }
</script>
</asp:Content>
