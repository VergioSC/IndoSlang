<%@ Page Title="Approve Slang" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="ApproveSlang.aspx.cs" Inherits="IndoSlang.ApproveSlang" %>

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
    .content-wrap{max-width:860px}

    /* filter tabs */
    .filter-tabs{display:flex;gap:10px;margin-bottom:28px;flex-wrap:wrap}
    .filter-tab{background:#fff;border:2px solid var(--cream-mid);border-radius:999px;padding:8px 20px;font-family:var(--font-body);font-size:.88rem;font-weight:700;color:var(--brown-mid);text-decoration:none;transition:all .15s;cursor:pointer}
    .filter-tab:hover{border-color:var(--brown-mid);color:var(--brown)}
    .filter-tab.active{background:var(--brown);border-color:var(--brown);color:#fff}

    /* action message */
    .action-msg{padding:12px 20px;border-radius:12px;margin-bottom:22px;font-size:.9rem;font-weight:700}
    .action-msg.success{background:#e8f5e9;color:#2e7d32;border:1.5px solid #a5d6a7}
    .action-msg.error{background:#fdecea;color:#c62828;border:1.5px solid #ef9a9a}

    /* suggestion card */
    .suggestion-card{background:#fff;border:2px solid var(--cream-mid);border-radius:18px;overflow:hidden;box-shadow:0 4px 14px rgba(59,42,26,.07);margin-bottom:16px}
    .suggestion-card.dimmed{opacity:.55}
    .card-top{display:flex;align-items:flex-start;justify-content:space-between;padding:20px 24px 0;gap:16px}
    .word-area{flex:1;min-width:0}
    .word-title{font-family:var(--font-display);font-size:1.35rem;font-weight:700;color:var(--brown);display:flex;align-items:center;gap:10px;flex-wrap:wrap;margin-bottom:4px}
    .tag{border-radius:999px;padding:4px 13px;font-size:.78rem;font-weight:700;border:1.5px solid var(--cream-mid);background:var(--cream);color:var(--brown-mid)}
    .tag.pos{background:var(--cream-mid);color:var(--brown);border-color:var(--brown-mid)}
    .tag.level-beginner{background:#e8f5e9;color:#2e7d32;border-color:#a5d6a7}
    .tag.level-intermediate{background:#fff3e0;color:#e65100;border-color:#ffcc80}
    .tag.level-advanced{background:#fce4ec;color:#880e4f;border-color:#f48fb1}
    .submitter-line{font-size:.82rem;color:var(--brown-mid)}
    .card-actions{display:flex;flex-direction:column;gap:8px;flex-shrink:0;padding-top:4px}
    .status-badge{border-radius:999px;padding:5px 14px;font-size:.8rem;font-weight:700;text-align:center;white-space:nowrap}
    .status-badge.pending{background:var(--cream-mid);color:var(--brown);border:1.5px solid var(--brown-mid)}
    .status-badge.approved{background:#e8f5e9;color:#2e7d32;border:1.5px solid #a5d6a7}
    .status-badge.rejected{background:#fdecea;color:#c62828;border:1.5px solid #ef9a9a}
    .btn-approve{background:var(--brown);color:#fff;border:none;border-radius:9px;padding:9px 22px;font-family:var(--font-display);font-size:.9rem;font-weight:700;cursor:pointer;transition:background .2s;white-space:nowrap;width:100%}
    .btn-approve:hover{background:var(--accent)}
    .btn-reject{background:#fff;color:var(--brown);border:2px solid var(--cream-mid);border-radius:9px;padding:7px 22px;font-family:var(--font-display);font-size:.9rem;font-weight:700;cursor:pointer;transition:all .2s;white-space:nowrap;width:100%}
    .btn-reject:hover{border-color:#ef9a9a;color:#c62828}
    .card-body{padding:14px 24px 20px}
    .detail-line{font-size:.9rem;color:var(--brown);margin-bottom:6px;line-height:1.6}
    .detail-line strong{color:var(--brown);font-weight:700}
    .done-badge{border-radius:999px;padding:6px 18px;font-size:.82rem;font-weight:700;white-space:nowrap;align-self:center}
    .done-badge.approved{background:#e8f5e9;color:#2e7d32;border:1.5px solid #a5d6a7}
    .done-badge.rejected{background:#fdecea;color:#c62828;border:1.5px solid #ef9a9a}

    /* empty state */
    .empty-state{text-align:center;padding:80px 40px;color:var(--brown-mid)}
    .empty-icon{font-size:3rem;margin-bottom:14px}
    .empty-title{font-family:var(--font-display);font-size:1.2rem;color:var(--brown);margin-bottom:6px}
</style>
</asp:Content>

<asp:Content ID="MainContent" ContentPlaceHolderID="MainContent" runat="server">

    <asp:HiddenField ID="hdnAction"       runat="server" />
    <asp:HiddenField ID="hdnSuggestionId" runat="server" />

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
                <a href="ApproveSlang.aspx"     class="nav-link active"><span class="nav-icon">&#x1F4DD;</span> Approve slang</a>
                <a href="SessionReports.aspx"   class="nav-link"><span class="nav-icon">&#x1F4CA;</span> Session reports</a>
                <a href="SlangDictionary.aspx"  class="nav-link"><span class="nav-icon">&#x1F4D6;</span> Slang dictionary</a>
            </nav>
            <hr class="sidebar-divider" />
            <a href="Logout.aspx" class="nav-link signout"><span class="nav-icon">&#x1F6AA;</span> Sign Out</a>
        </aside>

        <div class="dashboard-main">
            <div class="topbar">
                <div class="topbar-left">
                    <span class="topbar-title">Approve slang suggestions</span>
                    <span class="topbar-sub"><%: PendingCount %> pending review</span>
                </div>
                <div class="topbar-user">
                    <div class="topbar-avatar">&#x1F464;</div>
                    <span id="topbarName">Admin</span>
                </div>
            </div>

            <div class="module-content">
                <div class="content-wrap">

                    <div class="filter-tabs">
                        <a href="ApproveSlang.aspx?filter=all"      class="filter-tab <%= CurrentFilter == "all"      ? "active" : "" %>">All (<%: AllCount %>)</a>
                        <a href="ApproveSlang.aspx?filter=pending"   class="filter-tab <%= CurrentFilter == "pending"  ? "active" : "" %>">Pending (<%: PendingCount %>)</a>
                        <a href="ApproveSlang.aspx?filter=approved"  class="filter-tab <%= CurrentFilter == "approved" ? "active" : "" %>">Approved (<%: ApprovedCount %>)</a>
                        <a href="ApproveSlang.aspx?filter=rejected"  class="filter-tab <%= CurrentFilter == "rejected" ? "active" : "" %>">Rejected (<%: RejectedCount %>)</a>
                    </div>

                    <% if (!string.IsNullOrEmpty(ActionMessage)) { %>
                    <div class="action-msg <%= ActionSuccess ? "success" : "error" %>"><%: ActionMessage %></div>
                    <% } %>

                    <% foreach (var s in Suggestions) { %>
                    <div class="suggestion-card <%= s.Status != "Pending" ? "dimmed" : "" %>">
                        <div class="card-top">
                            <div class="word-area">
                                <div class="word-title">
                                    <%: s.Word %>
                                    <% if (!string.IsNullOrEmpty(s.PartOfSpeech)) { %>
                                        <span class="tag pos"><%: s.PartOfSpeech %></span>
                                    <% } %>
                                    <% if (!string.IsNullOrEmpty(s.DifficultyLevel)) { %>
                                        <span class="tag level-<%= s.DifficultyLevel.ToLower() %>"><%: s.DifficultyLevel %></span>
                                    <% } %>
                                </div>
                                <div class="submitter-line">
                                    Submitted by <%: s.SubmitterName %>
                                    <% if (s.SubmittedAt != DateTime.MinValue) { %> &bull; <%: s.SubmittedAt.ToString("MMM d, yyyy") %><% } %>
                                </div>
                            </div>
                            <div class="card-actions">
                                <% if (s.Status == "Pending") { %>
                                    <button type="button" class="btn-approve" onclick="doAction('approve', <%= s.SuggestionID %>)">Approve</button>
                                    <button type="button" class="btn-reject"  onclick="doAction('reject',  <%= s.SuggestionID %>)">Reject</button>
                                <% } else if (s.Status == "Approved") { %>
                                    <span class="done-badge approved">Approved &bull; added to dictionary</span>
                                <% } else { %>
                                    <span class="done-badge rejected">Rejected</span>
                                <% } %>
                            </div>
                        </div>
                        <% if (s.Status == "Pending") { %>
                        <div class="card-body">
                            <% if (!string.IsNullOrEmpty(s.Meaning)) { %>
                            <div class="detail-line"><strong>Meaning:</strong> <%: s.Meaning %></div>
                            <% } %>
                            <% if (!string.IsNullOrEmpty(s.ExampleSentence)) { %>
                            <div class="detail-line"><strong>Example:</strong> &ldquo;<%: s.ExampleSentence %>&rdquo;</div>
                            <% } %>
                            <% if (!string.IsNullOrEmpty(s.Translation)) { %>
                            <div class="detail-line"><strong>Translation:</strong> &ldquo;<%: s.Translation %>&rdquo;</div>
                            <% } %>
                        </div>
                        <% } %>
                    </div>
                    <% } %>

                    <% if (Suggestions.Count == 0) { %>
                    <div class="empty-state">
                        <div class="empty-icon">&#x1F4DD;</div>
                        <div class="empty-title">No suggestions here</div>
                        <div>Try a different filter or wait for members to submit slang.</div>
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
    document.getElementById('topbarName').textContent = _userName || 'Admin';

    function toggleSidebar() {
        var sb = document.getElementById('sidebar'), tg = document.getElementById('sidebarToggle');
        sb.classList.toggle('collapsed'); tg.classList.toggle('collapsed');
        tg.textContent = sb.classList.contains('collapsed') ? '›' : '‹';
    }

    function doAction(action, id) {
        document.getElementById('<%= hdnAction.ClientID %>').value = action;
        document.getElementById('<%= hdnSuggestionId.ClientID %>').value = id;
        document.getElementById('form1').submit();
    }
</script>
</asp:Content>
