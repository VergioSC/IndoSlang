<%@ Page Title="Community Chat" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="CommunityChat.aspx.cs" Inherits="IndoSlang.CommunityChat" %>

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

    /* Main layout */
    .dashboard-main { flex: 1; display: flex; flex-direction: column; height: 100vh; overflow: hidden; min-width: 0; }

    .topbar { background: #fff; border-bottom: 1px solid var(--cream-mid); padding: 16px 28px; display: flex; align-items: center; justify-content: space-between; flex-shrink: 0; }
    .topbar-left { display: flex; align-items: center; gap: 12px; }
    .topbar-icon { width: 40px; height: 40px; background: var(--cream-mid); border-radius: 12px; display: flex; align-items: center; justify-content: center; font-size: 1.2rem; }
    .topbar-info h2 { font-family: var(--font-display); font-size: 1.2rem; color: var(--brown); margin: 0; }
    .topbar-info p  { font-size: 0.78rem; color: var(--brown-mid); margin: 0; }
    .topbar-user { display: flex; align-items: center; gap: 9px; color: var(--brown); font-weight: 700; font-size: 0.9rem; }
    .topbar-avatar { width: 36px; height: 36px; border-radius: 50%; background: var(--brown-mid); display: flex; align-items: center; justify-content: center; color: #fff; font-size: 1rem; font-weight: 700; }

    /* Chat area */
    .chat-area { flex: 1; overflow-y: auto; padding: 24px 28px; background: var(--cream); display: flex; flex-direction: column; gap: 14px; }

    .msg-wrap { display: flex; align-items: flex-end; gap: 10px; }
    .msg-wrap.own { flex-direction: row-reverse; }

    .msg-avatar { width: 34px; height: 34px; border-radius: 50%; background: var(--brown-mid); color: #fff; display: flex; align-items: center; justify-content: center; font-weight: 700; font-size: 0.85rem; flex-shrink: 0; }
    .msg-avatar.own-avatar { background: var(--accent); }

    .msg-body { max-width: 62%; display: flex; flex-direction: column; gap: 3px; }
    .msg-wrap.own .msg-body { align-items: flex-end; }

    .msg-meta { font-size: 0.74rem; color: var(--brown-mid); display: flex; gap: 6px; align-items: center; }
    .msg-name { font-weight: 700; color: var(--brown); }

    .msg-bubble { padding: 10px 15px; border-radius: 18px; font-size: 0.9rem; line-height: 1.5; color: var(--brown); word-break: break-word; }
    .msg-bubble.other { background: #fff; border-bottom-left-radius: 4px; border: 1px solid rgba(59,42,26,0.10); }
    .msg-bubble.own   { background: var(--brown); color: #fff; border-bottom-right-radius: 4px; }

    .no-messages { text-align: center; padding: 60px 20px; color: var(--brown-mid); font-size: 0.9rem; margin: auto; }
    .no-messages-icon { font-size: 2.4rem; margin-bottom: 10px; }

    /* Input bar */
    .chat-input-bar { background: #fff; border-top: 1px solid var(--cream-mid); padding: 14px 28px; display: flex; align-items: center; gap: 12px; flex-shrink: 0; }

    .chat-input-bar input[type="text"] { flex: 1; padding: 11px 18px; border: 1.5px solid rgba(59,42,26,0.15); border-radius: 999px; font-size: 0.92rem; color: var(--brown); background: var(--cream); font-family: inherit; outline: none; transition: border-color 0.2s; }
    .chat-input-bar input:focus { border-color: var(--brown); background: #fff; }

    .send-btn { background: var(--brown); color: #fff; border: none; border-radius: 50%; width: 42px; height: 42px; display: flex; align-items: center; justify-content: center; font-size: 1rem; cursor: pointer; flex-shrink: 0; transition: opacity 0.2s; }
    .send-btn:hover { opacity: 0.85; }
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

                <!-- Member nav -->
                <asp:Panel ID="pnlMemberNav" runat="server">
                    <a href="Modules.aspx"         class="nav-link"><span class="nav-icon">&#x1F4DA;</span> My Modules</a>
                    <a href="SlangDictionary.aspx"  class="nav-link"><span class="nav-icon">&#x1F4D6;</span> Dictionary</a>
                    <a href="CommunityChat.aspx"    class="nav-link active"><span class="nav-icon">&#x1F4AC;</span> Community Chat</a>
                    <a href="BookSession.aspx"      class="nav-link"><span class="nav-icon">&#x1F91D;</span> Book a Buddy</a>
                    <a href="SessionHistory.aspx"   class="nav-link"><span class="nav-icon">&#x1F550;</span> Session History</a>
                    <a href="SuggestSlang.aspx"     class="nav-link"><span class="nav-icon">&#x2728;</span> Suggest Slang</a>
                    <hr class="sidebar-divider" />
                    <a href="MemberProfile.aspx"    class="nav-link"><span class="nav-icon">&#x1F464;</span> My Profile</a>
                    <a href="ApplyBuddy.aspx"       class="nav-link"><span class="nav-icon">&#x1F64B;</span> Apply as Buddy</a>
                </asp:Panel>

                <!-- Buddy nav -->
                <asp:Panel ID="pnlBuddyNav" runat="server" Visible="false">
                    <a href="Modules.aspx"          class="nav-link"><span class="nav-icon">&#x1F4DA;</span> My Modules</a>
                    <a href="SlangDictionary.aspx"   class="nav-link"><span class="nav-icon">&#x1F4D6;</span> Dictionary</a>
                    <a href="CommunityChat.aspx"     class="nav-link active"><span class="nav-icon">&#x1F4AC;</span> Community Chat</a>
                    <a href="HostSession.aspx"       class="nav-link"><span class="nav-icon">&#x1F3A4;</span> Host Session</a>
                    <a href="ManageAvailability.aspx" class="nav-link"><span class="nav-icon">&#x1F4C5;</span> Manage Availability</a>
                    <a href="SessionHistory.aspx"    class="nav-link"><span class="nav-icon">&#x1F550;</span> Session History</a>
                    <a href="SuggestSlang.aspx"      class="nav-link"><span class="nav-icon">&#x2728;</span> Suggest Slang</a>
                    <hr class="sidebar-divider" />
                    <a href="BuddyProfile.aspx"      class="nav-link"><span class="nav-icon">&#x1F464;</span> My Profile</a>
                    <a href="WithdrawEarnings.aspx"  class="nav-link"><span class="nav-icon">&#x1F4B8;</span> Withdraw Earnings</a>
                </asp:Panel>

                <!-- Admin nav -->
                <asp:Panel ID="pnlAdminNav" runat="server" Visible="false">
                    <a href="ManageUsers.aspx"      class="nav-link"><span class="nav-icon">&#x1F465;</span> Manage users</a>
                    <a href="ManageContent.aspx"    class="nav-link"><span class="nav-icon">&#x1F4CB;</span> Manage content</a>
                    <a href="ApproveBuddy.aspx"     class="nav-link"><span class="nav-icon">&#x2705;</span> Approve buddies</a>
                    <a href="ApproveSlang.aspx"     class="nav-link"><span class="nav-icon">&#x1F4DD;</span> Approve slang</a>
                    <a href="SessionReports.aspx"   class="nav-link"><span class="nav-icon">&#x1F4CA;</span> Session reports</a>
                    <a href="SlangDictionary.aspx"  class="nav-link"><span class="nav-icon">&#x1F4D6;</span> Slang dictionary</a>
                </asp:Panel>
            </nav>

            <hr class="sidebar-divider" />
            <a href="Logout.aspx" class="nav-link signout"><span class="nav-icon">&#x1F6AA;</span> Sign Out</a>
        </aside>

        <!-- Main -->
        <div class="dashboard-main">

            <div class="topbar">
                <div class="topbar-left">
                    <div class="topbar-icon">&#x1F4AC;</div>
                    <div class="topbar-info">
                        <h2>Community Chat</h2>
                        <p>General &mdash; open to all members</p>
                    </div>
                </div>
                <div class="topbar-user">
                    <div class="topbar-avatar">&#x1F464;</div>
                    <span><%: UserDisplayName %></span>
                </div>
            </div>

            <!-- Messages -->
            <div class="chat-area" id="chatArea">

                <asp:Panel ID="pnlNoMessages" runat="server" Visible="false">
                    <div class="no-messages">
                        <div class="no-messages-icon">&#x1F4AC;</div>
                        No messages yet. Be the first to say something!
                    </div>
                </asp:Panel>

                <asp:Repeater ID="rptMessages" runat="server">
                    <ItemTemplate>
                        <div class='<%# GetWrapCss(Eval("UserID")) %>'>
                            <div class='<%# GetAvatarCss(Eval("UserID")) %>'>
                                <%# GetInitial(Eval("FirstName")) %>
                            </div>
                            <div class="msg-body">
                                <div class="msg-meta">
                                    <span class="msg-name"><%# Eval("FirstName") %></span>
                                    <span>&#64;<%# Eval("Username") %></span>
                                    <span>&#183; <%# FormatTime(Eval("SentAt")) %></span>
                                </div>
                                <div class='<%# GetBubbleCss(Eval("UserID")) %>'>
                                    <%# System.Web.HttpUtility.HtmlEncode(Eval("MessageText").ToString()) %>
                                </div>
                            </div>
                        </div>
                    </ItemTemplate>
                </asp:Repeater>

            </div>

            <!-- Input bar -->
            <div class="chat-input-bar">
                <asp:TextBox ID="txtMessage" runat="server"
                    placeholder="Type a message..."
                    MaxLength="500"
                    autocomplete="off" />
                <asp:Button ID="btnSend" runat="server" Text="&#x27A4;"
                    CssClass="send-btn" OnClick="btnSend_Click"
                    CausesValidation="false" />
            </div>

        </div>
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

        // Scroll chat to bottom on load
        function scrollToBottom() {
            var area = document.getElementById('chatArea');
            if (area) area.scrollTop = area.scrollHeight;
        }

        // Auto-refresh every 10 seconds, pause while typing
        var lastTyped = 0;
        var inputEl   = document.getElementById('<%= txtMessage.ClientID %>');
        if (inputEl) {
            inputEl.addEventListener('input', function () { lastTyped = Date.now(); });

            // Send on Enter key
            inputEl.addEventListener('keydown', function (e) {
                if (e.key === 'Enter' && !e.shiftKey) {
                    e.preventDefault();
                    document.getElementById('<%= btnSend.ClientID %>').click();
                }
            });
        }

        setInterval(function () {
            if (Date.now() - lastTyped > 4000) {
                location.reload();
            }
        }, 10000);

        window.addEventListener('load', scrollToBottom);
    </script>
</asp:Content>
