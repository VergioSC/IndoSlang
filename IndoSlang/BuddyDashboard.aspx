<%@ Page Title="Buddy Dashboard" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="BuddyDashboard.aspx.cs" Inherits="IndoSlang.BuddyDashboard" %>

<asp:Content ID="HeadContent" ContentPlaceHolderID="HeadContent" runat="server">
<style>
    .navbar{display:none!important}.site-footer{display:none!important}.site-main{padding:0!important;margin:0!important}
    body{margin:0;padding:0;overflow:hidden}
    .dashboard-layout{display:flex;height:100vh;overflow:hidden}

    /* sidebar */
    .sidebar{width:260px;min-width:260px;background:var(--brown);color:#fff;display:flex;flex-direction:column;padding:32px 0 24px;height:100vh;overflow:hidden;overflow-x:hidden;flex-shrink:0;transition:width .3s,min-width .3s}
    .sidebar.collapsed{width:0;min-width:0;overflow:hidden}
    .sidebar-logo{display:flex;align-items:center;gap:10px;padding:0 24px 32px;font-family:var(--font-display);font-size:1.3rem;color:#fff;text-decoration:none;white-space:nowrap}
    .sidebar-logo img{width:38px;height:38px;border-radius:50%;flex-shrink:0}
    .sidebar-nav{flex:1;overflow-y:auto;min-height:0}
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

    /* main */
    .dashboard-main{flex:1;display:flex;flex-direction:column;height:100vh;overflow:hidden;min-width:0;background:#fff}
    .topbar{background:#fff;border-bottom:1px solid var(--cream-mid);padding:18px 32px;display:flex;align-items:center;justify-content:space-between;flex-shrink:0}
    .topbar-greeting h2{font-family:var(--font-display);font-size:1.55rem;color:var(--brown);margin:0 0 2px}
    .topbar-greeting p{font-size:.83rem;color:var(--brown-mid);margin:0}

    /* clickable avatar */
    .topbar-user{display:flex;align-items:center;gap:10px;color:var(--brown);font-weight:700;font-size:.9rem;text-decoration:none;border-radius:12px;padding:6px 12px 6px 6px;transition:background .15s}
    .topbar-user:hover{background:var(--cream)}
    .topbar-avatar{width:38px;height:38px;border-radius:50%;background:var(--cream-mid);display:flex;align-items:center;justify-content:center;color:var(--brown);font-size:1.1rem;overflow:hidden;flex-shrink:0;border:2px solid var(--cream-mid)}
    .topbar-avatar img{width:100%;height:100%;object-fit:cover;border-radius:50%}
    .topbar-user-label{display:flex;flex-direction:column;line-height:1.2}
    .topbar-user-name{font-weight:700;font-size:.9rem;color:var(--brown)}
    .topbar-user-role{font-size:.74rem;color:var(--accent);font-weight:700}

    /* content */
    .dash-content{flex:1;overflow-y:auto;padding:32px}
    .stats-row{display:grid;grid-template-columns:repeat(4,1fr);gap:16px;margin-bottom:32px}
    .stat-card{background:#fff;border:1.5px solid var(--cream-mid);border-radius:14px;padding:18px 20px}
    .stat-label{font-size:.78rem;color:var(--brown-mid);margin-bottom:6px;font-weight:700;text-transform:uppercase;letter-spacing:.03em}
    .stat-value{font-family:var(--font-display);font-size:1.55rem;font-weight:700;color:var(--brown)}
    .section-title{font-family:var(--font-display);font-size:1.05rem;color:var(--brown);font-weight:700;margin:0 0 14px}

    /* upcoming */
    .session-list{display:flex;flex-direction:column;gap:10px;margin-bottom:28px}
    .session-card{display:flex;align-items:center;gap:14px;border:1.5px solid var(--cream-mid);border-radius:12px;padding:14px 18px;background:#fff}
    .session-avatar{width:42px;height:42px;border-radius:10px;background:var(--cream-mid);display:flex;align-items:center;justify-content:center;font-size:1.2rem;flex-shrink:0}
    .session-info{flex:1}
    .session-member{font-size:.93rem;font-weight:700;color:var(--brown);margin-bottom:2px}
    .session-time{font-size:.82rem;color:var(--brown-mid)}
    .session-dur{font-size:.8rem;color:var(--brown-mid);background:var(--cream-mid);padding:3px 10px;border-radius:999px;flex-shrink:0}
    .empty-card{text-align:center;padding:28px;color:var(--brown-mid);font-size:.88rem;font-style:italic;border:1.5px dashed var(--cream-mid);border-radius:12px}

    /* widgets */
    .widget-row{display:grid;grid-template-columns:1fr 1fr;gap:16px;margin-bottom:24px}
    .widget-card{border:1.5px solid var(--cream-mid);border-radius:14px;padding:20px;background:#fff}
    .widget-card h4{font-family:var(--font-display);font-size:.95rem;color:var(--brown);margin:0 0 6px}
    .widget-card p{font-size:.86rem;color:var(--brown-mid);margin:0 0 14px;line-height:1.5}
    .btn-widget{display:inline-block;padding:7px 16px;border:1.5px solid var(--brown-mid);border-radius:8px;background:#fff;color:var(--brown);font-size:.82rem;font-weight:700;text-decoration:none;transition:background .15s,color .15s}
    .btn-widget:hover{background:var(--brown);color:#fff;border-color:var(--brown)}

    /* earnings */
    .earnings-card{background:#fff;border:1.5px solid var(--cream-mid);border-radius:14px;padding:22px 24px}
    .earnings-card h4{font-family:var(--font-display);font-size:1rem;color:var(--brown);margin:0 0 18px}
    .earnings-row{display:grid;grid-template-columns:1fr 1fr 1fr auto;gap:20px;align-items:center}
    .earn-label{font-size:.76rem;color:var(--brown-mid);margin-bottom:4px;font-weight:700;text-transform:uppercase;letter-spacing:.03em}
    .earn-value{font-family:var(--font-display);font-size:1.1rem;color:var(--brown);font-weight:700}
    .btn-withdraw{background:var(--brown);color:#fff;border:none;padding:10px 20px;border-radius:10px;font-family:var(--font-display);font-size:.88rem;cursor:pointer;white-space:nowrap;text-decoration:none;display:inline-block;transition:background .2s}
    .btn-withdraw:hover{background:var(--brown-mid);color:#fff}
</style>
</asp:Content>

<asp:Content ID="MainContent" ContentPlaceHolderID="MainContent" runat="server">

    <button type="button" class="sidebar-toggle" onclick="toggleSidebar()" id="sidebarToggle">&#8249;</button>

    <div class="dashboard-layout">
        <aside class="sidebar" id="sidebar">
            <a href="HomePage.aspx" class="sidebar-logo">
                <img src="Images/OWI SPARKLE EYE BIG.png" alt="IndoSlang" />
                IndoSlang
            </a>
            <nav class="sidebar-nav">
                <a href="BuddyDashboard.aspx"    class="nav-link active"><span class="nav-icon">&#x1F3E0;</span> Dashboard</a>
                <a href="Modules.aspx"            class="nav-link"><span class="nav-icon">&#x1F4DA;</span> My Modules</a>
                <a href="SlangDictionary.aspx"    class="nav-link"><span class="nav-icon">&#x1F4D6;</span> Dictionary</a>
                <a href="CommunityChat.aspx"      class="nav-link"><span class="nav-icon">&#x1F4AC;</span> Community Chat</a>
                <a href="HostSession.aspx"        class="nav-link"><span class="nav-icon">&#x1F3A4;</span> Host Session</a>
                <a href="ManageAvailability.aspx" class="nav-link"><span class="nav-icon">&#x1F4C5;</span> Manage Availability</a>
                <a href="SessionHistory.aspx"     class="nav-link"><span class="nav-icon">&#x1F550;</span> Session History</a>
                <a href="SuggestSlang.aspx"       class="nav-link"><span class="nav-icon">&#x2728;</span> Suggest Slang</a>
                <hr class="sidebar-divider" />
                <a href="BuddyProfile.aspx"       class="nav-link"><span class="nav-icon">&#x1F464;</span> My Profile</a>
                <a href="WithdrawEarnings.aspx"   class="nav-link"><span class="nav-icon">&#x1F4B8;</span> Withdraw Earnings</a>
            </nav>
            <hr class="sidebar-divider" />
            <a href="Logout.aspx" class="nav-link signout"><span class="nav-icon">&#x1F6AA;</span> Sign Out</a>
        </aside>

        <div class="dashboard-main">
            <div class="topbar">
                <div class="topbar-greeting">
                    <h2 id="greetingText">Hello, <%= System.Web.HttpUtility.HtmlEncode(BuddyFirstName) %>!</h2>
                    <p>Buddy account &mdash; helping members learn Indonesian slang</p>
                </div>

                <!-- clickable avatar → BuddyProfile.aspx -->
                <a href="BuddyProfile.aspx" class="topbar-user" title="View profile">
                    <div class="topbar-avatar" id="topbarAvatar">
                        &#x1F464;
                    </div>
                    <div class="topbar-user-label">
                        <span class="topbar-user-name"><%= System.Web.HttpUtility.HtmlEncode(BuddyFirstName) %></span>
                        <span class="topbar-user-role">Buddy</span>
                    </div>
                </a>
            </div>

            <div class="dash-content">

                <div class="stats-row">
                    <div class="stat-card">
                        <div class="stat-label">Total sessions</div>
                        <div class="stat-value"><%: TotalSessions %></div>
                    </div>
                    <div class="stat-card">
                        <div class="stat-label">This month</div>
                        <div class="stat-value"><%: ThisMonthSessions %></div>
                    </div>
                    <div class="stat-card">
                        <div class="stat-label">Rating</div>
                        <div class="stat-value"><%: AvgRating %></div>
                    </div>
                    <div class="stat-card">
                        <div class="stat-label">Pending earnings</div>
                        <div class="stat-value"><%: PendingEarnings %></div>
                    </div>
                </div>

                <p class="section-title">Upcoming sessions</p>
                <div class="session-list">
                    <% if (UpcomingList.Count == 0) { %>
                    <div class="empty-card">No upcoming sessions. Add availability so members can book you!</div>
                    <% } else { %>
                        <% foreach (var s in UpcomingList) { %>
                        <div class="session-card">
                            <div class="session-avatar">&#x1F91D;</div>
                            <div class="session-info">
                                <div class="session-member"><%: s.MemberName %></div>
                                <div class="session-time"><%: s.DateDisplay %> at <%: s.TimeDisplay %></div>
                            </div>
                            <span class="session-dur"><%: s.Duration %> min</span>
                        </div>
                        <% } %>
                    <% } %>
                </div>

                <div class="widget-row">
                    <div class="widget-card">
                        <h4>Manage availability</h4>
                        <p>Set open time slots so members can book sessions with you.</p>
                        <a href="ManageAvailability.aspx" class="btn-widget">Open calendar</a>
                    </div>
                    <div class="widget-card">
                        <h4>Session history</h4>
                        <p>View all your past and upcoming sessions in one place.</p>
                        <a href="SessionHistory.aspx" class="btn-widget">View history</a>
                    </div>
                </div>

                <div class="earnings-card">
                    <h4>Earnings summary</h4>
                    <div class="earnings-row">
                        <div>
                            <div class="earn-label">This month</div>
                            <div class="earn-value"><%: EarningThisMonth %></div>
                        </div>
                        <div>
                            <div class="earn-label">All time</div>
                            <div class="earn-value"><%: EarningAllTime %></div>
                        </div>
                        <div>
                            <div class="earn-label">Last withdrawal</div>
                            <div class="earn-value" style="font-size:.9rem"><%: LastWithdrawal %></div>
                        </div>
                        <a href="WithdrawEarnings.aspx" class="btn-withdraw">Withdraw earnings</a>
                    </div>
                </div>

            </div>
        </div>
    </div>

</asp:Content>

<asp:Content ID="ScriptContent" ContentPlaceHolderID="ScriptContent" runat="server">
<script>
    // greeting
    (function () {
        var hour = new Date().getHours();
        var g = hour < 12 ? 'Good morning' : hour < 17 ? 'Good afternoon' : 'Good evening';
        document.getElementById('greetingText').textContent = g + ', <%= System.Web.HttpUtility.JavaScriptStringEncode(BuddyFirstName) %>!';
    })();

    // avatar — show profile image if available
    (function () {
        var src = '<%= AvatarSrc %>';
        if (src) {
            var el = document.getElementById('topbarAvatar');
            el.innerHTML = '<img src="' + src + '" alt="avatar" />';
        }
    })();

    function toggleSidebar() {
        var sb = document.getElementById('sidebar'), tg = document.getElementById('sidebarToggle');
        sb.classList.toggle('collapsed'); tg.classList.toggle('collapsed');
        tg.textContent = sb.classList.contains('collapsed') ? '\u203A' : '\u2039';
    }
</script>
</asp:Content>
