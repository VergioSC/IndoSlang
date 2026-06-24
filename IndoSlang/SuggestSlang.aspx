<%@ Page Title="Suggest Slang" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="SuggestSlang.aspx.cs" Inherits="IndoSlang.SuggestSlang" %>

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

    .dashboard-main { flex: 1; display: flex; flex-direction: column; height: 100vh; overflow: hidden; min-width: 0; }

    .topbar { background: #fff; border-bottom: 1px solid var(--cream-mid); padding: 20px 32px; display: flex; align-items: center; justify-content: space-between; flex-shrink: 0; }
    .topbar-title { font-family: var(--font-display); font-size: 1.55rem; color: var(--brown); font-weight: 700; }
    .topbar-user { display: flex; align-items: center; gap: 9px; color: var(--brown); font-weight: 700; font-size: 0.9rem; }
    .topbar-avatar { width: 36px; height: 36px; border-radius: 50%; background: var(--brown-mid); display: flex; align-items: center; justify-content: center; color: #fff; font-size: 1.1rem; }

    .page-content { flex: 1; overflow-y: auto; padding: 32px; background: var(--cream); }

    /* Form card */
    .form-card { background: #fff; border: 1.5px solid var(--cream-mid); border-radius: 20px; padding: 28px 32px; margin-bottom: 28px; box-shadow: 0 4px 16px rgba(59,42,26,0.07); }
    .form-card-title { font-family: var(--font-display); font-size: 1.3rem; color: var(--brown); margin: 0 0 6px; }
    .form-card-note { color: var(--brown-mid); font-size: 0.88rem; margin: 0 0 24px; }

    .form-grid { display: grid; grid-template-columns: repeat(3, 1fr); gap: 16px; margin-bottom: 16px; }
    .form-grid-2 { display: grid; grid-template-columns: repeat(2, 1fr); gap: 16px; margin-bottom: 16px; }
    .form-grid-1 { display: grid; grid-template-columns: 1fr; gap: 16px; margin-bottom: 16px; }

    .form-group { display: flex; flex-direction: column; gap: 5px; }
    .form-group label { font-size: 0.78rem; font-weight: 800; color: var(--brown-mid); text-transform: uppercase; letter-spacing: 0.05em; }
    .form-group input, .form-group textarea, .form-group select { padding: 10px 13px; border: 1.5px solid rgba(59,42,26,0.15); border-radius: 10px; font-size: 0.9rem; color: var(--brown); background: #fff; font-family: inherit; box-sizing: border-box; width: 100%; }
    .form-group input:focus, .form-group textarea:focus, .form-group select:focus { outline: none; border-color: var(--brown); }
    .form-group textarea { resize: vertical; min-height: 80px; }

    .submit-btn { background: var(--brown); color: #fff; border: none; border-radius: 999px; padding: 11px 28px; font-weight: 800; font-size: 0.95rem; cursor: pointer; margin-top: 4px; }
    .submit-btn:hover { opacity: 0.88; }

    .alert-success { background: rgba(74,124,89,0.12); border: 1.5px solid rgba(74,124,89,0.3); color: var(--green); border-radius: 12px; padding: 12px 18px; font-size: 0.9rem; margin-bottom: 18px; font-weight: 600; }

    /* Submissions table */
    .submissions-card { background: #fff; border: 1.5px solid var(--cream-mid); border-radius: 20px; padding: 24px 28px; box-shadow: 0 4px 16px rgba(59,42,26,0.07); }
    .submissions-title { font-family: var(--font-display); font-size: 1.15rem; color: var(--brown); margin: 0 0 18px; }

    .sub-table { width: 100%; border-collapse: separate; border-spacing: 0 8px; }
    .sub-table th { color: var(--brown-mid); font-size: 0.76rem; text-transform: uppercase; letter-spacing: 0.05em; text-align: left; padding: 0 14px 4px; }
    .sub-table td { background: var(--cream); padding: 13px 14px; color: var(--brown); border-top: 1px solid rgba(59,42,26,0.08); border-bottom: 1px solid rgba(59,42,26,0.08); font-size: 0.88rem; }
    .sub-table td:first-child { border-left: 1px solid rgba(59,42,26,0.08); border-radius: 12px 0 0 12px; font-weight: 700; }
    .sub-table td:last-child { border-right: 1px solid rgba(59,42,26,0.08); border-radius: 0 12px 12px 0; }

    .status-badge { display: inline-block; padding: 4px 12px; border-radius: 999px; font-size: 0.75rem; font-weight: 800; }
    .status-badge.pending  { background: rgba(217,123,43,0.15); color: var(--accent); }
    .status-badge.approved { background: rgba(74,124,89,0.15); color: var(--green); }
    .status-badge.rejected { background: rgba(200,50,50,0.13); color: #c43b3b; }

    .empty-note { text-align: center; padding: 32px; color: var(--brown-mid); font-size: 0.9rem; }

    @media (max-width: 900px) {
        .form-grid, .form-grid-2 { grid-template-columns: 1fr; }
    }
</style>
</asp:Content>

<asp:Content ID="MainContent" ContentPlaceHolderID="MainContent" runat="server">

    <button type="button" class="sidebar-toggle" onclick="toggleSidebar()" id="sidebarToggle">&lt;</button>

    <div class="dashboard-layout">

        <% if (!IsBuddy) { %>
        <aside class="sidebar" id="sidebar">
            <a runat="server" id="lnkDashboard" class="sidebar-logo">
                <img src="Images/OWI SPARKLE EYE BIG.png" alt="IndoSlang" />
                IndoSlang
            </a>
            <nav class="sidebar-nav">
                <a runat="server" id="lnkDashboard2" class="nav-link"><span class="nav-icon">&#x1F3E0;</span> Dashboard</a>
                <a href="Modules.aspx"          class="nav-link"><span class="nav-icon">&#x1F4DA;</span> My Modules</a>
                <a href="SlangDictionary.aspx"  class="nav-link"><span class="nav-icon">&#x1F4D6;</span> Dictionary</a>
                <a href="CommunityChat.aspx"    class="nav-link"><span class="nav-icon">&#x1F4AC;</span> Community Chat</a>
                <a href="BookSession.aspx"      class="nav-link"><span class="nav-icon">&#x1F91D;</span> Book a Buddy</a>
                <a href="SessionHistory.aspx"   class="nav-link"><span class="nav-icon">&#x1F550;</span> Session History</a>
                <a href="SuggestSlang.aspx"     class="nav-link active"><span class="nav-icon">&#x2728;</span> Suggest Slang</a>
                <hr class="sidebar-divider" />
                <a href="MemberProfile.aspx"    class="nav-link"><span class="nav-icon">&#x1F464;</span> My Profile</a>
                <a href="ApplyBuddy.aspx"       class="nav-link"><span class="nav-icon">&#x1F64B;</span> Apply as Buddy</a>
            </nav>
            <hr class="sidebar-divider" />
            <a href="Logout.aspx" class="nav-link signout"><span class="nav-icon">&#x1F6AA;</span> Sign Out</a>
        </aside>
        <% } else { %>
        <aside class="sidebar" id="sidebar">
            <a href="HomePage.aspx" class="sidebar-logo">
                <img src="Images/OWI SPARKLE EYE BIG.png" alt="IndoSlang" />
                IndoSlang
            </a>
            <nav class="sidebar-nav">
                <a href="BuddyDashboard.aspx"    class="nav-link"><span class="nav-icon">&#x1F3E0;</span> Dashboard</a>
                <a href="Modules.aspx"           class="nav-link"><span class="nav-icon">&#x1F4DA;</span> My Modules</a>
                <a href="SlangDictionary.aspx"   class="nav-link"><span class="nav-icon">&#x1F4D6;</span> Dictionary</a>
                <a href="CommunityChat.aspx"     class="nav-link"><span class="nav-icon">&#x1F4AC;</span> Community Chat</a>
                <a href="HostSession.aspx"       class="nav-link"><span class="nav-icon">&#x1F3A4;</span> Host Session</a>
                <a href="ManageAvailability.aspx" class="nav-link"><span class="nav-icon">&#x1F4C5;</span> Manage Availability</a>
                <a href="SessionHistory.aspx"    class="nav-link"><span class="nav-icon">&#x1F550;</span> Session History</a>
                <a href="SuggestSlang.aspx"      class="nav-link active"><span class="nav-icon">&#x2728;</span> Suggest Slang</a>
                <hr class="sidebar-divider" />
                <a href="BuddyProfile.aspx"      class="nav-link"><span class="nav-icon">&#x1F464;</span> My Profile</a>
                <a href="WithdrawEarnings.aspx"  class="nav-link"><span class="nav-icon">&#x1F4B8;</span> Withdraw Earnings</a>
            </nav>
            <hr class="sidebar-divider" />
            <a href="Logout.aspx" class="nav-link signout"><span class="nav-icon">&#x1F6AA;</span> Sign Out</a>
        </aside>
        <% } %>

        <div class="dashboard-main">

            <div class="topbar">
                <div class="topbar-title">&#x2728; Suggest a Slang Word</div>
                <div class="topbar-user">
                    <div class="topbar-avatar">&#x1F464;</div>
                    <span><%: UserDisplayName %></span>
                </div>
            </div>

            <div class="page-content">

                <!-- Success message -->
                <asp:Literal ID="litSuccess" runat="server" />

                <!-- Suggestion Form -->
                <div class="form-card">
                    <h3 class="form-card-title">Submit a New Word</h3>
                    <p class="form-card-note">Suggestions are reviewed by our admin team before being added to the dictionary.</p>

                    <div class="form-grid">
                        <div class="form-group">
                            <label>Word *</label>
                            <asp:TextBox ID="txtWord" runat="server" />
                        </div>
                        <div class="form-group">
                            <label>Pronunciation</label>
                            <asp:TextBox ID="txtPronunciation" runat="server" placeholder="e.g. MA-ger" />
                        </div>
                        <div class="form-group">
                            <label>Part of Speech</label>
                            <asp:DropDownList ID="ddlPartOfSpeech" runat="server">
                                <asp:ListItem Value="">-- Select --</asp:ListItem>
                                <asp:ListItem Value="Noun">Noun</asp:ListItem>
                                <asp:ListItem Value="Verb">Verb</asp:ListItem>
                                <asp:ListItem Value="Adjective">Adjective</asp:ListItem>
                                <asp:ListItem Value="Adverb">Adverb</asp:ListItem>
                                <asp:ListItem Value="Phrase">Phrase</asp:ListItem>
                                <asp:ListItem Value="Interjection">Interjection</asp:ListItem>
                                <asp:ListItem Value="Slang">Slang</asp:ListItem>
                            </asp:DropDownList>
                        </div>
                    </div>

                    <div class="form-grid-1">
                        <div class="form-group">
                            <label>Meaning *</label>
                            <asp:TextBox ID="txtMeaning" runat="server" TextMode="MultiLine" placeholder="Short definition in English" />
                        </div>
                        <div class="form-group">
                            <label>Full Explanation</label>
                            <asp:TextBox ID="txtFullExplanation" runat="server" TextMode="MultiLine" placeholder="More context, origin, or usage notes (optional)" />
                        </div>
                    </div>

                    <div class="form-grid-2">
                        <div class="form-group">
                            <label>Example Sentence (Indonesian)</label>
                            <asp:TextBox ID="txtExampleSentence" runat="server" placeholder="e.g. Gue lagi mager banget nih." />
                        </div>
                        <div class="form-group">
                            <label>Example Translation (English)</label>
                            <asp:TextBox ID="txtExampleTranslation" runat="server" placeholder="e.g. I'm so lazy to move right now." />
                        </div>
                    </div>

                    <div class="form-grid">
                        <div class="form-group">
                            <label>Level *</label>
                            <asp:DropDownList ID="ddlLevel" runat="server">
                                <asp:ListItem Value="">-- Select --</asp:ListItem>
                                <asp:ListItem Value="Beginner">Beginner</asp:ListItem>
                                <asp:ListItem Value="Intermediate">Intermediate</asp:ListItem>
                                <asp:ListItem Value="Advanced">Advanced</asp:ListItem>
                            </asp:DropDownList>
                        </div>
                    </div>

                    <asp:Button ID="btnSubmit" runat="server" Text="Submit Suggestion"
                        CssClass="submit-btn" OnClick="btnSubmit_Click" />
                </div>

                <!-- My Past Suggestions -->
                <div class="submissions-card">
                    <h4 class="submissions-title">My Submissions</h4>

                    <asp:Repeater ID="rptSuggestions" runat="server">
                        <HeaderTemplate>
                            <table class="sub-table">
                                <thead>
                                    <tr>
                                        <th>Word</th>
                                        <th>Level</th>
                                        <th>Status</th>
                                        <th>Submitted</th>
                                    </tr>
                                </thead>
                                <tbody>
                        </HeaderTemplate>
                        <ItemTemplate>
                            <tr>
                                <td><%# Eval("Word") %></td>
                                <td><%# Eval("DifficultyLevel") %></td>
                                <td>
                                    <span class='<%# GetStatusCss(Eval("Status")) %>'>
                                        <%# Eval("Status") %>
                                    </span>
                                </td>
                                <td><%# FormatDate(Eval("SubmittedAt")) %></td>
                            </tr>
                        </ItemTemplate>
                        <FooterTemplate>
                                </tbody>
                            </table>
                        </FooterTemplate>
                    </asp:Repeater>

                    <asp:Panel ID="pnlNoSuggestions" runat="server" Visible="false">
                        <div class="empty-note">You haven't submitted any suggestions yet.</div>
                    </asp:Panel>
                </div>

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

        // Scroll success message into view after postback
        window.addEventListener('load', function () {
            var msg = document.querySelector('.alert-success');
            if (msg) msg.scrollIntoView({ behavior: 'smooth' });
        });
    </script>
</asp:Content>
