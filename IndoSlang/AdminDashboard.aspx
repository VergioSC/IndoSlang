<%@ Page Title="Admin Dashboard" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="AdminDashboard.aspx.cs" Inherits="IndoSlang.AdminDashboard" %>

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
    .module-content{flex:1;overflow-y:auto;padding:32px 44px 70px;background:var(--cream);font-family:var(--font-body);color:var(--brown)}

    /* stat cards */
    .stats-row{display:grid;grid-template-columns:repeat(5,1fr);gap:18px;margin-bottom:28px}
    .stat-card{background:#fff;border:2px solid var(--cream-mid);border-radius:18px;padding:22px 24px;box-shadow:0 4px 16px rgba(59,42,26,.07)}
    .stat-label{font-size:.79rem;font-weight:700;color:var(--brown-mid);text-transform:uppercase;letter-spacing:.5px;margin-bottom:8px}
    .stat-value{font-family:var(--font-display);font-size:2.1rem;font-weight:700;color:var(--brown);line-height:1}
    .stat-value.accent{color:var(--accent)}

    /* mid two-col */
    .mid-row{display:grid;grid-template-columns:1fr 340px;gap:20px;margin-bottom:28px;align-items:start}

    /* section card */
    .section-card{background:#fff;border:2px solid var(--cream-mid);border-radius:18px;overflow:hidden;box-shadow:0 4px 16px rgba(59,42,26,.07)}
    .section-card-header{background:var(--brown);padding:14px 22px}
    .section-card-header h2{font-family:var(--font-display);font-size:1rem;color:#fff;font-weight:700;margin:0}

    /* pending rows */
    .pending-row{display:flex;align-items:center;gap:14px;padding:16px 22px;border-bottom:1px solid var(--cream-mid)}
    .pending-row:last-child{border-bottom:none}
    .pending-label{flex:1;font-weight:700;font-size:.93rem;color:var(--brown)}
    .pending-badge{border-radius:999px;padding:5px 14px;font-size:.8rem;font-weight:700;white-space:nowrap;border:1.5px solid var(--brown-mid);background:var(--cream-mid);color:var(--brown)}
    .pending-badge.zero{background:var(--cream);color:var(--brown-mid);border-color:var(--cream-mid)}
    .btn-review{background:var(--brown);color:#fff;border:none;border-radius:9px;padding:7px 18px;font-family:var(--font-body);font-size:.85rem;font-weight:700;cursor:pointer;text-decoration:none;display:inline-block;transition:background .2s;white-space:nowrap}
    .btn-review:hover{background:var(--brown-mid);color:#fff}

    /* recent registrations */
    .reg-row{display:flex;align-items:center;gap:12px;padding:13px 22px;border-bottom:1px solid var(--cream-mid)}
    .reg-row:last-child{border-bottom:none}
    .reg-avatar{width:34px;height:34px;border-radius:50%;background:var(--cream-mid);display:flex;align-items:center;justify-content:center;font-size:1rem;color:var(--brown-mid);flex-shrink:0}
    .reg-name{font-weight:700;font-size:.92rem;color:var(--brown);flex:1}
    .reg-date{font-size:.82rem;color:var(--brown-mid)}
    .btn-view-all{display:block;text-align:center;padding:13px 22px;color:var(--accent);font-weight:700;font-size:.9rem;text-decoration:none;border-top:2px solid var(--cream-mid);font-family:var(--font-display)}
    .btn-view-all:hover{background:var(--cream)}

    /* chart */
    .chart-card{background:#fff;border:2px solid var(--cream-mid);border-radius:18px;overflow:hidden;box-shadow:0 4px 16px rgba(59,42,26,.07)}
    .chart-header{background:var(--brown);padding:14px 22px}
    .chart-header h2{font-family:var(--font-display);font-size:1rem;color:#fff;font-weight:700;margin:0}
    .chart-body{padding:28px 28px 20px}
    .bar-chart{display:flex;align-items:flex-end;gap:10px;height:130px}
    .bar-col{flex:1;display:flex;flex-direction:column;align-items:center;gap:8px}
    .bar-wrap{flex:1;width:100%;display:flex;align-items:flex-end}
    .bar{width:100%;background:var(--accent);border-radius:6px 6px 0 0;min-height:4px;opacity:.85;transition:opacity .2s}
    .bar:hover{opacity:1}
    .bar-empty{width:100%;background:var(--cream-mid);border-radius:6px 6px 0 0;min-height:4px}
    .bar-label{font-size:.78rem;color:var(--brown-mid);font-weight:700}
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
                <a href="AdminDashboard.aspx"  class="nav-link active"><span class="nav-icon">&#x1F3E0;</span> Dashboard</a>
                <a href="ManageUsers.aspx"      class="nav-link"><span class="nav-icon">&#x1F465;</span> Manage users</a>
                <a href="ManageContent.aspx"    class="nav-link"><span class="nav-icon">&#x1F4CB;</span> Manage content</a>
                <a href="ApproveBuddy.aspx"     class="nav-link"><span class="nav-icon">&#x2705;</span> Approve buddies</a>
                <a href="ApproveSlang.aspx"     class="nav-link"><span class="nav-icon">&#x1F4DD;</span> Approve slang</a>
                <a href="SessionReports.aspx"   class="nav-link"><span class="nav-icon">&#x1F4CA;</span> Session reports</a>
                <a href="SlangDictionary.aspx"  class="nav-link"><span class="nav-icon">&#x1F4D6;</span> Slang dictionary</a>
            </nav>
            <hr class="sidebar-divider" />
            <a href="Logout.aspx" class="nav-link signout"><span class="nav-icon">&#x1F6AA;</span> Sign Out</a>
        </aside>

        <div class="dashboard-main">
            <div class="topbar">
                <div class="topbar-left">
                    <span class="topbar-title">Admin dashboard</span>
                    <span class="topbar-sub">System overview &bull; <%= DateTime.Today.ToString("MMM d, yyyy") %></span>
                </div>
                <div class="topbar-user">
                    <div class="topbar-avatar">&#x1F464;</div>
                    <span id="topbarName">Admin</span>
                </div>
            </div>

            <div class="module-content">

                <div class="stats-row">
                    <div class="stat-card">
                        <div class="stat-label">Active members</div>
                        <div class="stat-value"><%: ActiveMembers %></div>
                    </div>
                    <div class="stat-card">
                        <div class="stat-label">Total users</div>
                        <div class="stat-value"><%: TotalUsers %></div>
                    </div>
                    <div class="stat-card">
                        <div class="stat-label">Active buddies</div>
                        <div class="stat-value"><%: ActiveBuddies %></div>
                    </div>
                    <div class="stat-card">
                        <div class="stat-label">Sessions this month</div>
                        <div class="stat-value"><%: SessionsThisMonth %></div>
                    </div>
                    <div class="stat-card">
                        <div class="stat-label">Revenue this month</div>
                        <div class="stat-value accent">RM <%: RevenueThisMonth.ToString("N0") %></div>
                    </div>
                </div>

                <div class="mid-row">
                    <div class="section-card">
                        <div class="section-card-header"><h2>Pending actions</h2></div>
                        <div class="pending-row">
                            <span class="pending-label">Buddy applications</span>
                            <span class="pending-badge <%= PendingBuddies == 0 ? "zero" : "" %>"><%: PendingBuddies %> pending</span>
                            <a href="ApproveBuddy.aspx" class="btn-review">Review</a>
                        </div>
                        <div class="pending-row">
                            <span class="pending-label">Slang suggestions</span>
                            <span class="pending-badge <%= PendingSlang == 0 ? "zero" : "" %>"><%: PendingSlang %> pending</span>
                            <a href="ApproveSlang.aspx?filter=pending" class="btn-review">Review</a>
                        </div>
                        <div class="pending-row">
                            <span class="pending-label">Reported messages</span>
                            <span class="pending-badge zero"><%: PendingReports %> pending</span>
                            <a href="CommunityChat.aspx" class="btn-review">View</a>
                        </div>
                    </div>

                    <div class="section-card">
                        <div class="section-card-header"><h2>Recent registrations</h2></div>
                        <% foreach (var u in RecentUsers) { %>
                        <div class="reg-row">
                            <div class="reg-avatar">&#x1F464;</div>
                            <span class="reg-name"><%: u.FullName %></span>
                            <span class="reg-date"><%: u.WhenLabel %></span>
                        </div>
                        <% } %>
                        <% if (RecentUsers.Count == 0) { %>
                        <div class="reg-row"><span class="reg-name" style="color:var(--brown-mid)">No users yet</span></div>
                        <% } %>
                        <a href="ManageUsers.aspx" class="btn-view-all">View all users</a>
                    </div>
                </div>

                <div class="chart-card">
                    <div class="chart-header"><h2>Session activity &mdash; this week</h2></div>
                    <div class="chart-body">
                        <div class="bar-chart" id="weekChart"></div>
                    </div>
                </div>

            </div>
        </div>
    </div>
</asp:Content>

<asp:Content ID="ScriptContent" ContentPlaceHolderID="ScriptContent" runat="server">
<script>
    var _userName = '<%= UserDisplayName %>';
    document.getElementById('topbarName').textContent = _userName || 'Admin';

    function toggleSidebar() {
        var sb = document.getElementById('sidebar'), tg = document.getElementById('sidebarToggle');
        sb.classList.toggle('collapsed'); tg.classList.toggle('collapsed');
        tg.textContent = sb.classList.contains('collapsed') ? '›' : '‹';
    }

    (function () {
        var data = <%= WeeklyChartJson %>;
        var days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
        var max = 0;
        for (var i = 0; i < data.length; i++) if (data[i].count > max) max = data[i].count;
        if (max === 0) max = 1;
        var wrap = document.getElementById('weekChart');
        days.forEach(function (day, i) {
            var cnt = data[i] ? data[i].count : 0;
            var pct = Math.round(cnt / max * 100);
            var col = document.createElement('div');
            col.className = 'bar-col';
            col.innerHTML =
                '<div class="bar-wrap"><div class="' + (cnt > 0 ? 'bar' : 'bar-empty') + '" style="height:' + Math.max(pct, 3) + '%"></div></div>' +
                '<span class="bar-label">' + day + '</span>';
            wrap.appendChild(col);
        });
    })();
</script>
</asp:Content>
