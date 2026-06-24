<%@ Page Title="Manage Users" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="ManageUsers.aspx.cs" Inherits="IndoSlang.ManageUsers" EnableEventValidation="false" %>

<asp:Content ID="HeadContent" ContentPlaceHolderID="HeadContent" runat="server">
    <style>
        .navbar { display: none !important; }
        .site-footer { display: none !important; }
        .site-main { padding: 0 !important; margin: 0 !important; }
        body { margin: 0; padding: 0; overflow: hidden; }

        .admin-layout { display: flex; height: 100vh; overflow: hidden; }

        .sidebar {
            width: 260px; min-width: 260px;
            background: var(--brown); color: #fff;
            display: flex; flex-direction: column;
            padding: 32px 0 24px; height: 100vh;
            overflow: hidden; overflow-x: hidden;
            flex-shrink: 0;
            transition: width 0.3s ease, min-width 0.3s ease;
        }

        .sidebar.collapsed { width: 0; min-width: 0; overflow: hidden; }

        .sidebar-logo {
            display: flex; align-items: center; gap: 10px;
            padding: 0 24px 32px;
            font-family: var(--font-display); font-size: 1.3rem;
            color: #fff; text-decoration: none; white-space: nowrap;
        }

        .sidebar-logo img { width: 38px; height: 38px; border-radius: 50%; flex-shrink: 0; }

        .sidebar-nav { flex: 1; overflow-y: auto; min-height: 0; }

        .nav-link {
            display: flex; align-items: center; gap: 10px;
            padding: 10px 24px; color: rgba(255,255,255,0.75);
            text-decoration: none; font-size: 0.92rem;
            border-left: 3px solid transparent;
            transition: background 0.15s, color 0.15s, border-color 0.15s;
            white-space: nowrap;
        }

        .nav-link:hover { background: rgba(255,255,255,0.08); color: #fff; }

        .nav-link.active {
            background: rgba(255,255,255,0.12); color: #fff;
            border-left-color: var(--accent); font-weight: 700;
        }

        .nav-icon { font-size: 1rem; width: 20px; text-align: center; flex-shrink: 0; }

        .sidebar-divider { border: none; border-top: 1px solid rgba(255,255,255,0.12); margin: 16px 24px; }

        .nav-link.signout { color: rgba(255,255,255,0.45); }
        .nav-link.signout:hover { color: #ff8a8a; background: rgba(255,100,100,0.08); }

        .sidebar-toggle {
            position: fixed; left: 244px; top: 50vh;
            transform: translateY(-50%);
            width: 28px; height: 28px;
            background: var(--brown);
            border: 2px solid rgba(255,255,255,0.25);
            border-radius: 50%; color: #fff; cursor: pointer;
            display: flex; align-items: center; justify-content: center;
            font-size: 0.8rem; z-index: 9999;
            transition: left 0.3s ease, background 0.2s;
        }

        .sidebar-toggle:hover { background: var(--brown-mid); }
        .sidebar-toggle.collapsed { left: 0; }

        .admin-main { flex: 1; height: 100vh; overflow-y: auto; background: var(--cream); }

        .topbar {
            background: var(--cream); border-bottom: 2px solid var(--cream-mid);
            padding: 18px 36px;
            display: flex; align-items: center; justify-content: space-between;
        }

        .topbar-greeting h2 {
            font-family: var(--font-display); font-size: 1.6rem;
            color: var(--brown); margin: 0 0 2px;
        }

        .topbar-greeting p { font-size: 0.85rem; color: var(--brown-mid); margin: 0; }

        .topbar-user {
            display: flex; align-items: center; gap: 10px;
            color: var(--brown); font-weight: 700; font-size: 0.92rem;
        }

        .topbar-avatar {
            width: 38px; height: 38px; border-radius: 50%;
            background: var(--brown-mid);
            display: flex; align-items: center; justify-content: center;
            color: #fff; font-size: 1.2rem;
        }

        .content-wrap { padding: 32px 36px 70px; }

        .section-card {
            background: #fff;
            border: 2px solid rgba(59,42,26,0.10);
            border-radius: 22px;
            box-shadow: 0 8px 24px rgba(59,42,26,0.10);
            overflow: hidden;
        }

        .section-head {
            padding: 24px 26px; background: #fff8eb;
            border-bottom: 1px solid rgba(59,42,26,0.10);
        }

        .section-title { font-family: var(--font-display); color: var(--brown); font-size: 1.45rem; margin: 0 0 4px; }
        .section-note  { color: var(--brown-mid); font-size: 0.9rem; margin: 0; }

        .section-body { padding: 22px 26px 26px; }

        /* Search bar */
        .search-bar {
            display: flex; gap: 10px; align-items: center;
            margin-bottom: 20px; flex-wrap: wrap;
        }

        .search-bar input[type="text"] {
            flex: 1; min-width: 200px;
            padding: 9px 14px;
            border: 2px solid rgba(59,42,26,0.15);
            border-radius: 10px;
            font-size: 0.9rem; color: var(--brown);
            background: #fff; font-family: inherit;
        }

        .search-bar input:focus { outline: none; border-color: var(--brown); }

        .search-bar select {
            padding: 9px 14px;
            border: 2px solid rgba(59,42,26,0.15);
            border-radius: 10px;
            font-size: 0.9rem; color: var(--brown);
            background: #fff; font-family: inherit; cursor: pointer;
        }

        .search-btn {
            padding: 9px 18px;
            background: var(--brown); color: #fff;
            border: none; border-radius: 999px;
            font-weight: 800; font-size: 0.88rem; cursor: pointer;
        }

        .search-btn:hover { opacity: 0.88; }

        /* Table */
        .content-table { width: 100%; border-collapse: separate; border-spacing: 0 8px; }

        .content-table th {
            color: var(--brown-mid); font-size: 0.78rem;
            text-transform: uppercase; letter-spacing: 0.05em;
            text-align: left; padding: 0 14px 6px;
        }

        .content-table td {
            background: #fff; padding: 14px;
            color: var(--brown);
            border-top: 1px solid rgba(59,42,26,0.10);
            border-bottom: 1px solid rgba(59,42,26,0.10);
            font-size: 0.88rem;
        }

        .content-table td:first-child {
            border-left: 1px solid rgba(59,42,26,0.10);
            border-radius: 14px 0 0 14px;
            font-weight: 700;
        }

        .content-table td:last-child {
            border-right: 1px solid rgba(59,42,26,0.10);
            border-radius: 0 14px 14px 0;
        }

        .muted { color: var(--brown-mid); font-size: 0.82rem; font-weight: 400; }

        /* Badges */
        .badge {
            padding: 5px 11px; border-radius: 999px;
            font-size: 0.76rem; font-weight: 800;
            display: inline-block;
        }

        .badge.member       { background: rgba(59,42,26,0.10); color: var(--brown); }
        .badge.buddy        { background: rgba(74,124,89,0.14); color: var(--green); }
        .badge.active-status { background: rgba(74,124,89,0.14); color: var(--green); }
        .badge.banned       { background: rgba(200,50,50,0.13); color: #c43b3b; }

        /* Action buttons */
        .action-btn {
            padding: 7px 13px; border-radius: 999px;
            border: 1px solid rgba(59,42,26,0.18);
            background: #fff; color: var(--brown);
            font-weight: 800; cursor: pointer; font-size: 0.78rem;
        }

        .action-btn:hover { background: var(--cream-mid); }

        .danger-btn {
            padding: 7px 13px; border-radius: 999px;
            border: 1px solid rgba(200,50,50,0.25);
            background: #fff; color: #c43b3b;
            font-weight: 800; cursor: pointer; font-size: 0.78rem;
        }

        .danger-btn:hover { background: rgba(200,50,50,0.07); }

        .empty-state {
            text-align: center; padding: 48px;
            color: var(--brown-mid); font-size: 0.9rem;
        }
    </style>
</asp:Content>

<asp:Content ID="MainContent" ContentPlaceHolderID="MainContent" runat="server">

    <button type="button" class="sidebar-toggle" onclick="toggleSidebar()" id="sidebarToggle">&lt;</button>

    <div class="admin-layout">

        <aside class="sidebar" id="sidebar">
            <a href="HomePage.aspx" class="sidebar-logo">
                <img src="Images/OWI SPARKLE EYE BIG.png" alt="IndoSlang" />
                IndoSlang
            </a>
            <nav class="sidebar-nav">
                <a href="AdminDashboard.aspx"  class="nav-link"><span class="nav-icon">&#x1F3E0;</span> Dashboard</a>
                <a href="ManageUsers.aspx"      class="nav-link active"><span class="nav-icon">&#x1F465;</span> Manage users</a>
                <a href="ManageContent.aspx"    class="nav-link"><span class="nav-icon">&#x1F4CB;</span> Manage content</a>
                <a href="ApproveBuddy.aspx"     class="nav-link"><span class="nav-icon">&#x2705;</span> Approve buddies</a>
                <a href="ApproveSlang.aspx"     class="nav-link"><span class="nav-icon">&#x1F4DD;</span> Approve slang</a>
                <a href="SessionReports.aspx"   class="nav-link"><span class="nav-icon">&#x1F4CA;</span> Session reports</a>
                <a href="SlangDictionary.aspx"  class="nav-link"><span class="nav-icon">&#x1F4D6;</span> Slang dictionary</a>
            </nav>
            <hr class="sidebar-divider" />
            <a href="Logout.aspx" class="nav-link signout"><span class="nav-icon">&#128682;</span> Sign Out</a>
        </aside>

        <main class="admin-main">

            <div class="topbar">
                <div class="topbar-greeting">
                    <h2>Manage Users</h2>
                    <p>View, search, and ban or unban members and buddies</p>
                </div>
                <div class="topbar-user">
                    <div class="topbar-avatar">&#128100;</div>
                    <span>Admin</span>
                </div>
            </div>

            <div class="content-wrap">
                <section class="section-card">
                    <div class="section-head">
                        <h3 class="section-title">All Users</h3>
                        <p class="section-note">Admin accounts are not shown. Use Ban to restrict access; the account is not deleted.</p>
                    </div>

                    <div class="section-body">

                        <!-- Search & Filter -->
                        <div class="search-bar">
                            <asp:TextBox ID="txtSearch" runat="server"
                                placeholder="Search by name, username, or email..." />

                            <asp:DropDownList ID="ddlRoleFilter" runat="server" AutoPostBack="true">
                                <asp:ListItem Value="0">All Roles</asp:ListItem>
                                <asp:ListItem Value="2">Members Only</asp:ListItem>
                                <asp:ListItem Value="3">Buddies Only</asp:ListItem>
                            </asp:DropDownList>

                            <asp:Button ID="btnSearch" runat="server" Text="Search"
                                CssClass="search-btn" CausesValidation="false" />
                        </div>

                        <!-- Users Table -->
                        <asp:HiddenField ID="hfBanUserId" runat="server" />
                        <asp:Button ID="btnBanUser" runat="server" Text="BanUser"
                            Style="display:none" CausesValidation="false"
                            OnClick="btnBanUser_Click" />

                        <asp:Repeater ID="rptUsers" runat="server">
                            <HeaderTemplate>
                                <table class="content-table">
                                    <thead>
                                        <tr>
                                            <th>Name</th>
                                            <th>Username</th>
                                            <th>Email</th>
                                            <th>Role</th>
                                            <th>Level</th>
                                            <th>Status</th>
                                            <th>Joined</th>
                                            <th>Actions</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                            </HeaderTemplate>
                            <ItemTemplate>
                                <tr>
                                    <td><%# Eval("FirstName") %> <%# Eval("LastName") %></td>
                                    <td><span class="muted">@</span><%# Eval("Username") %></td>
                                    <td><%# Eval("Email") %></td>
                                    <td>
                                        <span class='<%# GetRoleBadgeCss(Eval("RoleID")) %>'>
                                            <%# GetRoleName(Eval("RoleID")) %>
                                        </span>
                                    </td>
                                    <td><%# Eval("CurrentLevel") %></td>
                                    <td>
                                        <span class='<%# GetStatusBadgeCss(Eval("Status")) %>'>
                                            <%# Eval("Status") %>
                                        </span>
                                    </td>
                                    <td><%# Convert.ToDateTime(Eval("CreatedAt")).ToString("dd MMM yyyy") %></td>
                                    <td>
                                        <button type="button"
                                            class='<%# GetBanButtonCss(Eval("Status")) %>'
                                            data-uid='<%# Eval("UserID") %>'
                                            data-status='<%# Eval("Status") %>'
                                            data-username='<%# Eval("Username") %>'
                                            onclick="toggleBan(this)"><%# GetBanButtonText(Eval("Status")) %></button>
                                    </td>
                                </tr>
                            </ItemTemplate>
                            <FooterTemplate>
                                    </tbody>
                                </table>
                            </FooterTemplate>
                        </asp:Repeater>

                        <asp:Panel ID="pnlEmpty" runat="server" Visible="false">
                            <div class="empty-state">No users found matching your search.</div>
                        </asp:Panel>

                    </div>
                </section>
            </div>

        </main>
    </div>

</asp:Content>

<asp:Content ID="ScriptContent" ContentPlaceHolderID="ScriptContent" runat="server">
    <script>
        function toggleSidebar() {
            var sidebar = document.getElementById('sidebar');
            var toggle  = document.getElementById('sidebarToggle');
            sidebar.classList.toggle('collapsed');
            toggle.classList.toggle('collapsed');
            toggle.textContent = sidebar.classList.contains('collapsed') ? '>' : '<';
        }

        function toggleBan(btn) {
            var userId   = btn.getAttribute('data-uid');
            var status   = btn.getAttribute('data-status');
            var username = btn.getAttribute('data-username');
            var action   = status === 'Banned' ? 'unban' : 'ban';
            if (!confirm('Are you sure you want to ' + action + ' @' + username + '?')) return;
            document.getElementById('<%= hfBanUserId.ClientID %>').value = userId;
            document.getElementById('<%= btnBanUser.ClientID %>').click();
        }
    </script>
</asp:Content>
