<%@ Page Title="Approve Buddy Applications" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="ApproveBuddy.aspx.cs" Inherits="IndoSlang.ApproveBuddy" %>

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
        .msg-success { background: #d4edda; color: #1a5c2a; padding: 10px 16px; border-radius: 10px; font-size: 0.88rem; margin-bottom: 20px; display: none; }
        .msg-error { background: #fde8e8; color: #7b1515; padding: 10px 16px; border-radius: 10px; font-size: 0.88rem; margin-bottom: 20px; display: none; }
        .app-card { border: 1.5px solid var(--cream-mid); border-radius: 14px; padding: 20px 24px; margin-bottom: 16px; background: #fff; }
        .app-card.pending { border-color: #ffe082; background: #fffdf0; }
        .app-header { display: flex; align-items: flex-start; justify-content: space-between; gap: 16px; margin-bottom: 10px; }
        .app-name { font-size: 1rem; font-weight: 700; color: var(--brown); margin-bottom: 2px; }
        .app-meta { font-size: 0.82rem; color: var(--brown-mid); }
        .status-badge { display: inline-block; padding: 3px 12px; border-radius: 999px; font-size: 0.78rem; font-weight: 700; flex-shrink: 0; }
        .status-pending { background: #fff8e1; color: #b8860b; border: 1px solid #ffe082; }
        .status-approved { background: #d4edda; color: #1a5c2a; }
        .status-rejected { background: #fde8e8; color: #7b1515; }
        .app-reason { font-size: 0.88rem; color: var(--brown); background: var(--cream); border-radius: 8px; padding: 10px 14px; margin: 10px 0 14px; line-height: 1.55; white-space: pre-wrap; }
        .app-actions { display: flex; gap: 10px; }
        .btn-approve { padding: 7px 18px; border: none; border-radius: 8px; background: #2e7d32; color: #fff; font-size: 0.85rem; font-weight: 700; cursor: pointer; transition: background 0.15s; }
        .btn-approve:hover { background: #1b5e20; }
        .btn-reject { padding: 7px 18px; border: 1.5px solid #c0392b; border-radius: 8px; background: #fff; color: #c0392b; font-size: 0.85rem; font-weight: 700; cursor: pointer; transition: background 0.15s; }
        .btn-reject:hover { background: #fde8e8; }
        .empty-card { text-align: center; padding: 48px 32px; color: var(--brown-mid); font-size: 0.9rem; font-style: italic; border: 1.5px dashed var(--cream-mid); border-radius: 14px; }
        .hidden-control { display: none; }
    </style>
</asp:Content>

<asp:Content ID="MainContent" ContentPlaceHolderID="MainContent" runat="server">

    <asp:HiddenField ID="hfApplicationId" runat="server" />
    <asp:HiddenField ID="hfAction" runat="server" />
    <asp:Button ID="btnActionConfirm" runat="server" Text="Action" CssClass="hidden-control" OnClick="btnActionConfirm_Click" />
    <asp:Label ID="lblMessage" runat="server" CssClass="msg-success" Style="display:none" />

    <button type="button" class="sidebar-toggle" onclick="toggleSidebar()" id="sidebarToggle">&lt;</button>

    <div class="dashboard-layout">
        <aside class="sidebar" id="sidebar">
            <a href="HomePage.aspx" class="sidebar-logo">
                <img src="Images/OWI SPARKLE EYE BIG.png" alt="IndoSlang" />
                IndoSlang
            </a>
            <nav class="sidebar-nav">
                <a href="AdminDashboard.aspx"  class="nav-link"><span class="nav-icon">&#x1F3E0;</span> Dashboard</a>
                <a href="ManageUsers.aspx"      class="nav-link"><span class="nav-icon">&#x1F465;</span> Manage users</a>
                <a href="ManageContent.aspx"    class="nav-link"><span class="nav-icon">&#x1F4CB;</span> Manage content</a>
                <a href="ApproveBuddy.aspx"     class="nav-link active"><span class="nav-icon">&#x2705;</span> Approve buddies</a>
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
                    <h2>Approve Buddy Applications</h2>
                    <p>Review and process member applications to become a Buddy</p>
                </div>
                <div class="topbar-user">
                    <div class="topbar-avatar">&#x1F464;</div>
                    <span><%= System.Web.HttpUtility.HtmlEncode(Session["UserName"] != null ? Session["UserName"].ToString() : "Admin") %></span>
                </div>
            </div>

            <div class="dash-content">

                <% if (Applications.Count == 0) { %>
                <div class="empty-card">No buddy applications yet.</div>
                <% } else { %>
                <p class="section-title">All applications (<%= Applications.Count %>)</p>
                <% foreach (var app in Applications) { %>
                <div class="app-card <%= app.Status == "Pending" ? "pending" : "" %>">
                    <div class="app-header">
                        <div>
                            <div class="app-name"><%= System.Web.HttpUtility.HtmlEncode(app.FullName) %></div>
                            <div class="app-meta">
                                @<%= System.Web.HttpUtility.HtmlEncode(app.Username) %> &nbsp;&middot;&nbsp;
                                <%= System.Web.HttpUtility.HtmlEncode(app.Email) %> &nbsp;&middot;&nbsp;
                                Applied <%= System.Web.HttpUtility.HtmlEncode(app.AppliedAt) %>
                            </div>
                        </div>
                        <span class="status-badge status-<%= app.Status.ToLower() %>">
                            <%= System.Web.HttpUtility.HtmlEncode(app.Status) %>
                        </span>
                    </div>
                    <div class="app-reason"><%= System.Web.HttpUtility.HtmlEncode(app.Reason) %></div>
                    <% if (app.Status == "Pending") { %>
                    <div class="app-actions">
                        <button type="button" class="btn-approve"
                            onclick="processApp(<%= app.ApplicationID %>, 'approve', '<%= System.Web.HttpUtility.JavaScriptStringEncode(app.FullName) %>')">
                            Approve
                        </button>
                        <button type="button" class="btn-reject"
                            onclick="processApp(<%= app.ApplicationID %>, 'reject', '<%= System.Web.HttpUtility.JavaScriptStringEncode(app.FullName) %>')">
                            Reject
                        </button>
                    </div>
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
        function toggleSidebar() {
            var sidebar = document.getElementById('sidebar');
            var toggle = document.getElementById('sidebarToggle');
            sidebar.classList.toggle('collapsed');
            toggle.classList.toggle('collapsed');
            toggle.textContent = sidebar.classList.contains('collapsed') ? '>' : '<';
        }

        function processApp(id, action, name) {
            var msg = action === 'approve'
                ? 'Approve ' + name + ' as a Buddy?'
                : 'Reject the application from ' + name + '?';
            if (!confirm(msg)) return;
            document.getElementById('<%= hfApplicationId.ClientID %>').value = id;
            document.getElementById('<%= hfAction.ClientID %>').value = action;
            document.getElementById('<%= btnActionConfirm.ClientID %>').click();
        }
    </script>
</asp:Content>
