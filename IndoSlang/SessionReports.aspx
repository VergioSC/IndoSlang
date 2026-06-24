<%@ Page Title="Session Reports" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="SessionReports.aspx.cs" Inherits="IndoSlang.SessionReports" %>

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
    .topbar-right{display:flex;align-items:center;gap:14px}
    .topbar-user{display:flex;align-items:center;gap:10px;color:var(--brown);font-weight:700;font-size:.92rem}
    .topbar-avatar{width:38px;height:38px;border-radius:50%;background:var(--brown-mid);display:flex;align-items:center;justify-content:center;color:#fff;font-size:1.1rem}
    .btn-export{background:var(--brown);color:#fff;border:none;border-radius:10px;padding:10px 20px;font-family:var(--font-display);font-size:.9rem;font-weight:700;cursor:pointer;text-decoration:none;display:inline-block;transition:background .2s;white-space:nowrap}
    .btn-export:hover{background:var(--accent);color:#fff}

    /* scroll area */
    .module-content{flex:1;overflow-y:auto;padding:32px 44px 70px;background:var(--cream);font-family:var(--font-body);color:var(--brown)}

    /* stat cards */
    .stats-row{display:grid;grid-template-columns:repeat(4,1fr);gap:18px;margin-bottom:28px}
    .stat-card{background:#fff;border:2px solid var(--cream-mid);border-radius:18px;padding:22px 24px;box-shadow:0 4px 16px rgba(59,42,26,.07)}
    .stat-label{font-size:.79rem;font-weight:700;color:var(--brown-mid);text-transform:uppercase;letter-spacing:.5px;margin-bottom:8px}
    .stat-value{font-family:var(--font-display);font-size:1.9rem;font-weight:700;color:var(--brown);line-height:1}

    /* toolbar */
    .toolbar{display:flex;align-items:center;gap:14px;margin-bottom:20px;flex-wrap:wrap}
    .search-wrap{flex:1;min-width:200px;position:relative}
    .search-input{width:100%;background:#fff;border:2px solid var(--cream-mid);border-radius:12px;padding:11px 16px 11px 40px;font-family:var(--font-body);font-size:.92rem;color:var(--brown);outline:none;transition:border-color .2s;box-sizing:border-box}
    .search-input:focus{border-color:var(--accent)}
    .search-icon{position:absolute;left:14px;top:50%;transform:translateY(-50%);color:var(--brown-mid);font-size:.95rem;pointer-events:none}
    .filter-tabs{display:flex;gap:8px;flex-wrap:wrap}
    .filter-tab{background:#fff;border:2px solid var(--cream-mid);border-radius:999px;padding:8px 18px;font-family:var(--font-body);font-size:.85rem;font-weight:700;color:var(--brown-mid);text-decoration:none;transition:all .15s;white-space:nowrap}
    .filter-tab:hover{border-color:var(--brown-mid);color:var(--brown)}
    .filter-tab.active{background:var(--brown);border-color:var(--brown);color:#fff}

    /* table */
    .table-card{background:#fff;border:2px solid var(--cream-mid);border-radius:18px;overflow:hidden;box-shadow:0 4px 16px rgba(59,42,26,.07);margin-bottom:20px}
    .report-table{width:100%;border-collapse:collapse}
    .report-table th{background:var(--cream-mid);color:var(--brown);font-size:.8rem;font-weight:700;text-transform:uppercase;letter-spacing:.4px;padding:12px 18px;text-align:left;border-bottom:2px solid var(--cream-mid)}
    .report-table td{padding:14px 18px;font-size:.9rem;color:var(--brown);border-bottom:1px solid var(--cream-mid);vertical-align:middle}
    .report-table tr:last-child td{border-bottom:none}
    .report-table tr:hover td{background:var(--cream)}
    .session-id{font-family:var(--font-display);font-weight:700;color:var(--brown-mid)}
    .status-pill{border-radius:999px;padding:4px 12px;font-size:.78rem;font-weight:700;white-space:nowrap}
    .status-pill.completed{background:#e8f5e9;color:#2e7d32;border:1.5px solid #a5d6a7}
    .status-pill.upcoming{background:var(--cream-mid);color:var(--brown);border:1.5px solid var(--brown-mid)}
    .status-pill.scheduled{background:var(--cream-mid);color:var(--brown);border:1.5px solid var(--brown-mid)}
    .status-pill.cancelled{background:#fdecea;color:#c62828;border:1.5px solid #ef9a9a}

    /* pagination */
    .pagination-row{display:flex;align-items:center;justify-content:space-between;padding:4px 2px}
    .pg-info{font-size:.85rem;color:var(--brown-mid)}
    .pg-btns{display:flex;gap:6px;align-items:center}
    .pg-btn{background:#fff;border:2px solid var(--cream-mid);border-radius:9px;padding:7px 14px;font-family:var(--font-body);font-size:.85rem;font-weight:700;color:var(--brown);text-decoration:none;transition:all .15s}
    .pg-btn:hover{border-color:var(--brown-mid)}
    .pg-btn.active{background:var(--brown);border-color:var(--brown);color:#fff}
    .pg-btn.disabled{color:var(--brown-mid);pointer-events:none;opacity:.5}

    /* empty state */
    .empty-row td{text-align:center;padding:60px;color:var(--brown-mid);font-size:.95rem}
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
                <a href="AdminDashboard.aspx"  class="nav-link"><span class="nav-icon">&#x1F3E0;</span> Dashboard</a>
                <a href="ManageUsers.aspx"      class="nav-link"><span class="nav-icon">&#x1F465;</span> Manage users</a>
                <a href="ManageContent.aspx"    class="nav-link"><span class="nav-icon">&#x1F4CB;</span> Manage content</a>
                <a href="ApproveBuddy.aspx"     class="nav-link"><span class="nav-icon">&#x2705;</span> Approve buddies</a>
                <a href="ApproveSlang.aspx"     class="nav-link"><span class="nav-icon">&#x1F4DD;</span> Approve slang</a>
                <a href="SessionReports.aspx"   class="nav-link active"><span class="nav-icon">&#x1F4CA;</span> Session reports</a>
                <a href="SlangDictionary.aspx"  class="nav-link"><span class="nav-icon">&#x1F4D6;</span> Slang dictionary</a>
            </nav>
            <hr class="sidebar-divider" />
            <a href="Logout.aspx" class="nav-link signout"><span class="nav-icon">&#x1F6AA;</span> Sign Out</a>
        </aside>

        <div class="dashboard-main">
            <div class="topbar">
                <div class="topbar-left">
                    <span class="topbar-title">Session reports</span>
                    <span class="topbar-sub">All sessions and payment records</span>
                </div>
                <div class="topbar-right">
                    <a href="<%= ExportUrl %>" class="btn-export">Export CSV</a>
                    <div class="topbar-user">
                        <div class="topbar-avatar">&#x1F464;</div>
                        <span id="topbarName">Admin</span>
                    </div>
                </div>
            </div>

            <div class="module-content">

                <div class="stats-row">
                    <div class="stat-card">
                        <div class="stat-label">Total sessions</div>
                        <div class="stat-value"><%: TotalSessions %></div>
                    </div>
                    <div class="stat-card">
                        <div class="stat-label">Total revenue</div>
                        <div class="stat-value">RM <%: TotalRevenue.ToString("N2") %></div>
                    </div>
                    <div class="stat-card">
                        <div class="stat-label">Platform 5%</div>
                        <div class="stat-value">RM <%: PlatformFee.ToString("N2") %></div>
                    </div>
                    <div class="stat-card">
                        <div class="stat-label">Paid to buddies 95%</div>
                        <div class="stat-value">RM <%: PaidToBuddies.ToString("N2") %></div>
                    </div>
                </div>

                <div class="toolbar">
                    <div class="search-wrap">
                        <span class="search-icon">&#x1F50D;</span>
                        <input type="text" class="search-input" id="searchBox"
                               placeholder="Search member or buddy..."
                               value="<%: SearchTerm %>"
                               onkeydown="if(event.key==='Enter')doSearch()" />
                    </div>
                    <div class="filter-tabs">
                        <a href="<%= FilterUrl("all") %>"       class="filter-tab <%= CurrentFilter == "all"       ? "active" : "" %>">All</a>
                        <a href="<%= FilterUrl("completed") %>"  class="filter-tab <%= CurrentFilter == "completed"  ? "active" : "" %>">Completed</a>
                        <a href="<%= FilterUrl("upcoming") %>"   class="filter-tab <%= CurrentFilter == "upcoming"   ? "active" : "" %>">Upcoming</a>
                        <a href="<%= FilterUrl("cancelled") %>"  class="filter-tab <%= CurrentFilter == "cancelled"  ? "active" : "" %>">Cancelled</a>
                    </div>
                </div>

                <div class="table-card">
                    <table class="report-table">
                        <thead>
                            <tr>
                                <th>#</th>
                                <th>Member</th>
                                <th>Buddy</th>
                                <th>Date &amp; time</th>
                                <th>Dur.</th>
                                <th>Amount</th>
                                <th>Status</th>
                            </tr>
                        </thead>
                        <tbody>
                            <% if (Sessions.Count == 0) { %>
                            <tr class="empty-row"><td colspan="7">No sessions found</td></tr>
                            <% } %>
                            <% foreach (var s in Sessions) { %>
                            <tr>
                                <td><span class="session-id">#<%: s.SessionID.ToString("D3") %></span></td>
                                <td><strong><%: s.MemberName %></strong></td>
                                <td><%: s.BuddyName %></td>
                                <td><%: s.FormattedDate %></td>
                                <td><%: s.DurationMinutes %>m</td>
                                <td><strong>RM <%: s.TotalAmount.ToString("0.00") %></strong></td>
                                <td><span class="status-pill <%: s.StatusClass %>"><%: s.StatusDisplay %></span></td>
                            </tr>
                            <% } %>
                        </tbody>
                    </table>
                </div>

                <% if (TotalPages > 1 || TotalCount > 0) { %>
                <div class="pagination-row">
                    <span class="pg-info">Showing <%: Sessions.Count %> of <%: TotalCount %> sessions</span>
                    <div class="pg-btns">
                        <a href="<%= PageUrl(CurrentPage - 1) %>"
                           class="pg-btn <%= CurrentPage <= 1 ? "disabled" : "" %>">&larr; Prev</a>
                        <% for (int p = Math.Max(1, CurrentPage - 2); p <= Math.Min(TotalPages, CurrentPage + 2); p++) { %>
                        <a href="<%= PageUrl(p) %>" class="pg-btn <%= p == CurrentPage ? "active" : "" %>"><%: p %></a>
                        <% } %>
                        <a href="<%= PageUrl(CurrentPage + 1) %>"
                           class="pg-btn <%= CurrentPage >= TotalPages ? "disabled" : "" %>">Next &rarr;</a>
                    </div>
                </div>
                <% } %>

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

    function doSearch() {
        var q = document.getElementById('searchBox').value.trim();
        var url = 'SessionReports.aspx?filter=<%= CurrentFilter %>';
        if (q) url += '&q=' + encodeURIComponent(q);
        window.location.href = url;
    }
</script>
</asp:Content>
