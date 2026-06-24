<%@ Page Title="Manage Content" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="ManageContent.aspx.cs" Inherits="IndoSlang.ManageContent" %>

<asp:Content ID="HeadContent" ContentPlaceHolderID="HeadContent" runat="server">
    <style>
        .navbar { display: none !important; }
        .site-footer { display: none !important; }
        .site-main { padding: 0 !important; margin: 0 !important; }
        body { margin: 0; padding: 0; overflow: hidden; }

        .admin-layout {
            display: flex;
            height: 100vh;
            overflow: hidden;
        }

        .sidebar {
            width: 260px;
            min-width: 260px;
            background: var(--brown);
            color: #fff;
            display: flex;
            flex-direction: column;
            padding: 32px 0 24px;
            height: 100vh;
            overflow: hidden;
            overflow-x: hidden;
            flex-shrink: 0;
            transition: width 0.3s ease, min-width 0.3s ease;
        }

        .sidebar.collapsed {
            width: 0;
            min-width: 0;
            overflow: hidden;
        }

        .sidebar-logo {
            display: flex;
            align-items: center;
            gap: 10px;
            padding: 0 24px 32px;
            font-family: var(--font-display);
            font-size: 1.3rem;
            color: #fff;
            text-decoration: none;
            white-space: nowrap;
        }

        .sidebar-logo img { width: 38px; height: 38px; border-radius: 50%; flex-shrink: 0; }

        .sidebar-nav { flex: 1; overflow-y: auto; min-height: 0; }

        .nav-link {
            display: flex;
            align-items: center;
            gap: 10px;
            padding: 10px 24px;
            color: rgba(255,255,255,0.75);
            text-decoration: none;
            font-size: 0.92rem;
            border-left: 3px solid transparent;
            transition: background 0.15s, color 0.15s, border-color 0.15s;
            white-space: nowrap;
        }

        .nav-link:hover {
            background: rgba(255,255,255,0.08);
            color: #fff;
        }

        .nav-link.active {
            background: rgba(255,255,255,0.12);
            color: #fff;
            border-left-color: var(--accent);
            font-weight: 700;
        }

        .nav-icon {
            font-size: 1rem;
            width: 20px;
            text-align: center;
            flex-shrink: 0;
        }

        .sidebar-divider {
            border: none;
            border-top: 1px solid rgba(255,255,255,0.12);
            margin: 16px 24px;
        }

        .nav-link.signout { color: rgba(255,255,255,0.45); }
        .nav-link.signout:hover { color: #ff8a8a; background: rgba(255,100,100,0.08); }

        .sidebar-toggle {
            position: fixed;
            left: 244px;
            top: 50vh;
            transform: translateY(-50%);
            width: 28px;
            height: 28px;
            background: var(--brown);
            border: 2px solid rgba(255,255,255,0.25);
            border-radius: 50%;
            color: #fff;
            cursor: pointer;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 0.8rem;
            z-index: 9999;
            transition: left 0.3s ease, background 0.2s;
        }

        .sidebar-toggle:hover { background: var(--brown-mid); }
        .sidebar-toggle.collapsed { left: 0; }

        .admin-main {
            flex: 1;
            height: 100vh;
            overflow-y: auto;
            background: var(--cream);
        }

        .topbar {
            background: var(--cream);
            border-bottom: 2px solid var(--cream-mid);
            padding: 18px 36px;
            display: flex;
            align-items: center;
            justify-content: space-between;
            flex-shrink: 0;
        }

        .topbar-greeting h2 {
            font-family: var(--font-display);
            font-size: 1.6rem;
            color: var(--brown);
            margin: 0 0 2px;
        }

        .topbar-greeting p { font-size: 0.85rem; color: var(--brown-mid); margin: 0; }

        .topbar-user {
            display: flex;
            align-items: center;
            gap: 10px;
            color: var(--brown);
            font-weight: 700;
            font-size: 0.92rem;
        }

        .topbar-avatar {
            width: 38px;
            height: 38px;
            border-radius: 50%;
            background: var(--brown-mid);
            display: flex;
            align-items: center;
            justify-content: center;
            color: #fff;
            font-size: 1.2rem;
        }

        .content-wrap { padding: 32px 36px 70px; }

        .tabs { display: flex; gap: 10px; margin-bottom: 18px; flex-wrap: wrap; }

        .tab-btn {
            padding: 10px 18px;
            border-radius: 999px;
            border: 2px solid transparent;
            background: var(--cream-mid);
            color: var(--brown);
            font-weight: 800;
            cursor: pointer;
            transition: 0.16s ease;
        }

        .tab-btn:hover { transform: translateY(-1px); border-color: rgba(59,42,26,0.18); }
        .tab-btn.active { background: var(--brown); color: #fff; border-color: var(--brown); }

        .section-card {
            background: #fff;
            border: 2px solid rgba(59,42,26,0.10);
            border-radius: 22px;
            box-shadow: 0 8px 24px rgba(59,42,26,0.10);
            overflow: hidden;
            margin-bottom: 24px;
        }

        .section-head {
            padding: 24px 26px;
            background: #fff8eb;
            border-bottom: 1px solid rgba(59,42,26,0.10);
            display: flex;
            justify-content: space-between;
            gap: 16px;
            align-items: flex-start;
        }

        .section-title { font-family: var(--font-display); color: var(--brown); font-size: 1.45rem; margin: 0 0 4px; }
        .section-note { color: var(--brown-mid); font-size: 0.9rem; margin: 0; }

        .primary-btn {
            background: var(--brown);
            color: #fff;
            border: none;
            border-radius: 999px;
            padding: 10px 18px;
            font-weight: 800;
            cursor: pointer;
            white-space: nowrap;
            display: inline-block;
            font-size: 0.9rem;
        }

        .primary-btn:hover { opacity: 0.88; }

        .section-body { padding: 22px 26px 26px; }

        .content-table { width: 100%; border-collapse: separate; border-spacing: 0 8px; }

        .content-table th {
            color: var(--brown-mid);
            font-size: 0.78rem;
            text-transform: uppercase;
            letter-spacing: 0.05em;
            text-align: left;
            padding: 0 14px 6px;
        }

        .content-table td {
            background: #fff;
            padding: 14px;
            color: var(--brown);
            border-top: 1px solid rgba(59,42,26,0.10);
            border-bottom: 1px solid rgba(59,42,26,0.10);
            font-size: 0.9rem;
        }

        .content-table td:first-child {
            border-left: 1px solid rgba(59,42,26,0.10);
            border-radius: 14px 0 0 14px;
            font-weight: 800;
        }

        .content-table td:last-child {
            border-right: 1px solid rgba(59,42,26,0.10);
            border-radius: 0 14px 14px 0;
        }

        .badge {
            padding: 5px 11px;
            border-radius: 999px;
            background: var(--cream-mid);
            color: var(--brown);
            font-size: 0.76rem;
            font-weight: 800;
            display: inline-block;
        }

        .action-btn {
            padding: 7px 12px;
            border-radius: 999px;
            border: 1px solid rgba(59,42,26,0.18);
            background: #fff;
            color: var(--brown);
            font-weight: 800;
            cursor: pointer;
            margin-right: 5px;
            font-size: 0.78rem;
        }

        .action-btn:hover { background: var(--cream-mid); }

        .danger-btn {
            padding: 7px 12px;
            border-radius: 999px;
            border: 1px solid rgba(200,50,50,0.25);
            background: #fff;
            color: #c43b3b;
            font-weight: 800;
            cursor: pointer;
            font-size: 0.78rem;
        }

        .danger-btn:hover { background: rgba(200,50,50,0.07); }

        .hidden { display: none; }

        /* ── Form styles ── */
        .form-panel {
            background: #fff8eb;
            border: 2px solid rgba(59,42,26,0.12);
            border-radius: 18px;
            padding: 22px 24px;
            margin-bottom: 20px;
        }

        .form-panel-title {
            font-family: var(--font-display);
            color: var(--brown);
            font-size: 1.1rem;
            margin: 0 0 18px;
        }

        .form-grid {
            display: grid;
            grid-template-columns: repeat(2, 1fr);
            gap: 14px;
            margin-bottom: 16px;
        }

        .form-grid.cols-3 { grid-template-columns: repeat(3, 1fr); }
        .form-grid.cols-1 { grid-template-columns: 1fr; }

        .form-group { display: flex; flex-direction: column; gap: 5px; }

        .form-group label {
            font-size: 0.78rem;
            font-weight: 800;
            color: var(--brown-mid);
            text-transform: uppercase;
            letter-spacing: 0.05em;
        }

        .form-group input[type="text"],
        .form-group input[type="number"],
        .form-group textarea,
        .form-group select {
            padding: 9px 13px;
            border: 2px solid rgba(59,42,26,0.15);
            border-radius: 10px;
            font-size: 0.9rem;
            color: var(--brown);
            background: #fff;
            font-family: inherit;
            width: 100%;
            box-sizing: border-box;
        }

        .form-group input:focus,
        .form-group textarea:focus,
        .form-group select:focus {
            outline: none;
            border-color: var(--brown);
        }

        .form-group textarea { resize: vertical; min-height: 75px; }

        .form-actions { display: flex; gap: 10px; margin-top: 4px; }

        .secondary-btn {
            background: var(--cream-mid);
            color: var(--brown);
            border: 2px solid rgba(59,42,26,0.15);
            border-radius: 999px;
            padding: 9px 18px;
            font-weight: 800;
            cursor: pointer;
            font-size: 0.9rem;
        }

        .secondary-btn:hover { background: #e8ddd0; }

        .module-selector {
            margin-bottom: 20px;
            display: flex;
            align-items: center;
            gap: 12px;
        }

        .module-selector label { font-weight: 800; color: var(--brown); font-size: 0.9rem; }

        .module-selector select {
            padding: 9px 14px;
            border: 2px solid rgba(59,42,26,0.18);
            border-radius: 10px;
            font-size: 0.9rem;
            color: var(--brown);
            background: #fff;
            font-family: inherit;
            cursor: pointer;
        }

        .questions-header {
            display: flex;
            align-items: center;
            justify-content: space-between;
            margin-bottom: 16px;
        }

        .questions-header-title {
            font-family: var(--font-display);
            color: var(--brown);
            font-size: 1.1rem;
            margin: 0;
        }

        .module1-note {
            background: var(--cream);
            border-left: 5px solid var(--accent);
            border-radius: 12px;
            padding: 14px 18px;
            color: var(--brown-mid);
            font-size: 0.9rem;
        }

        .empty-state {
            text-align: center;
            padding: 36px;
            color: var(--brown-mid);
            font-size: 0.9rem;
        }

        .options-group { margin-top: 4px; }

        @media (max-width: 900px) {
            .form-grid { grid-template-columns: 1fr; }
            .form-grid.cols-3 { grid-template-columns: 1fr; }
            .section-head { flex-direction: column; }
        }
    </style>
</asp:Content>

<asp:Content ID="MainContent" ContentPlaceHolderID="MainContent" runat="server">

    <asp:HiddenField ID="hfActiveTab"         runat="server" Value="dictionaryTab" />
    <asp:HiddenField ID="hfSlangID"           runat="server" Value="0" />
    <asp:HiddenField ID="hfQuestionID"        runat="server" Value="0" />
    <asp:HiddenField ID="hfCurrentModuleOrder" runat="server" Value="0" />

    <button type="button" class="sidebar-toggle" onclick="toggleSidebar()" id="sidebarToggle">&lt;</button>

    <div class="admin-layout">

        <aside class="sidebar" id="sidebar">
            <a href="HomePage.aspx" class="sidebar-logo">
                <img src="Images/OWI SPARKLE EYE BIG.png" alt="IndoSlang" />
                IndoSlang
            </a>
            <nav class="sidebar-nav">
                <a href="AdminDashboard.aspx"  class="nav-link"><span class="nav-icon">&#x1F3E0;</span> Dashboard</a>
                <a href="ManageUsers.aspx"      class="nav-link"><span class="nav-icon">&#x1F465;</span> Manage users</a>
                <a href="ManageContent.aspx"    class="nav-link active"><span class="nav-icon">&#x1F4CB;</span> Manage content</a>
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
                    <h2>Manage Content</h2>
                    <p>Slang dictionary and module questions</p>
                </div>
                <div class="topbar-user">
                    <div class="topbar-avatar">&#128100;</div>
                    <span>Admin</span>
                </div>
            </div>

            <div class="content-wrap">

                <div class="tabs">
                    <button type="button" class="tab-btn active" onclick="showTab('dictionaryTab', this)">Dictionary</button>
                    <button type="button" class="tab-btn"        onclick="showTab('questionsTab', this)">Module Questions</button>
                </div>

                <!-- ══════════════════════════════════════════════════════════
                     TAB 1: SLANG DICTIONARY
                ══════════════════════════════════════════════════════════ -->
                <div id="dictionaryTab">
                    <section class="section-card">
                        <div class="section-head">
                            <div>
                                <h3 class="section-title">Slang Dictionary</h3>
                                <p class="section-note">Add, edit, or remove words from the public dictionary.</p>
                            </div>
                            <asp:Button ID="btnShowAddWord" runat="server" Text="+ Add Word"
                                CssClass="primary-btn" OnClick="btnShowAddWord_Click" />
                        </div>

                        <div class="section-body">

                            <!-- Word Form (Add / Edit) -->
                            <asp:Panel ID="pnlWordForm" runat="server" Visible="false" CssClass="form-panel">
                                <p class="form-panel-title">
                                    <asp:Label ID="lblWordFormTitle" runat="server" Text="Add New Word" />
                                </p>

                                <div class="form-grid cols-3">
                                    <div class="form-group">
                                        <label>Word *</label>
                                        <asp:TextBox ID="txtWord" runat="server" CssClass="form-input" />
                                    </div>
                                    <div class="form-group">
                                        <label>Pronunciation</label>
                                        <asp:TextBox ID="txtPronunciation" runat="server" />
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

                                <div class="form-grid cols-1">
                                    <div class="form-group">
                                        <label>Meaning *</label>
                                        <asp:TextBox ID="txtMeaning" runat="server" TextMode="MultiLine" />
                                    </div>
                                    <div class="form-group">
                                        <label>Full Explanation</label>
                                        <asp:TextBox ID="txtFullExplanation" runat="server" TextMode="MultiLine" />
                                    </div>
                                </div>

                                <div class="form-grid">
                                    <div class="form-group">
                                        <label>Example Sentence</label>
                                        <asp:TextBox ID="txtExampleSentence" runat="server" />
                                    </div>
                                    <div class="form-group">
                                        <label>Example Translation</label>
                                        <asp:TextBox ID="txtExampleTranslation" runat="server" />
                                    </div>
                                </div>

                                <div class="form-grid cols-3">
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

                                <div class="form-actions">
                                    <asp:Button ID="btnSaveWord" runat="server" Text="Save Word"
                                        CssClass="primary-btn" OnClick="btnSaveWord_Click" />
                                    <asp:Button ID="btnCancelWord" runat="server" Text="Cancel"
                                        CssClass="secondary-btn" OnClick="btnCancelWord_Click" CausesValidation="false" />
                                </div>
                            </asp:Panel>

                            <!-- Dictionary List -->
                            <asp:Repeater ID="rptDictionary" runat="server" OnItemCommand="rptDictionary_ItemCommand">
                                <HeaderTemplate>
                                    <table class="content-table">
                                        <thead>
                                            <tr>
                                                <th>Word</th>
                                                <th>Pronunciation</th>
                                                <th>Part of Speech</th>
                                                <th>Meaning</th>
                                                <th>Level</th>
                                                <th>Actions</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                </HeaderTemplate>
                                <ItemTemplate>
                                    <tr>
                                        <td><%# Eval("Word") %></td>
                                        <td><%# Eval("Pronunciation") %></td>
                                        <td><%# Eval("PartOfSpeech") %></td>
                                        <td><%# Eval("Meaning") %></td>
                                        <td><span class="badge"><%# Eval("Level") %></span></td>
                                        <td>
                                            <asp:Button runat="server" Text="Edit"
                                                CommandName="EditWord" CommandArgument='<%# Eval("SlangID") %>'
                                                CssClass="action-btn" CausesValidation="false" />
                                            <asp:Button runat="server" Text="Delete"
                                                CommandName="DeleteWord" CommandArgument='<%# Eval("SlangID") %>'
                                                CssClass="danger-btn" CausesValidation="false"
                                                OnClientClick="return confirm('Delete this word from the dictionary?');" />
                                        </td>
                                    </tr>
                                </ItemTemplate>
                                <FooterTemplate>
                                        </tbody>
                                    </table>
                                </FooterTemplate>
                            </asp:Repeater>

                            <asp:Panel ID="pnlDictionaryEmpty" runat="server" Visible="false">
                                <div class="empty-state">No words in the dictionary yet. Click <strong>+ Add Word</strong> to get started.</div>
                            </asp:Panel>

                        </div>
                    </section>
                </div>

                <!-- ══════════════════════════════════════════════════════════
                     TAB 2: MODULE QUESTIONS
                ══════════════════════════════════════════════════════════ -->
                <div id="questionsTab" class="hidden">
                    <section class="section-card">
                        <div class="section-head">
                            <div>
                                <h3 class="section-title">Module Questions</h3>
                                <p class="section-note">Select a module to view, add, edit, or delete its questions.</p>
                            </div>
                        </div>

                        <div class="section-body">

                            <div class="module-selector">
                                <label>Module:</label>
                                <asp:DropDownList ID="ddlModule" runat="server"
                                    AutoPostBack="true"
                                    OnSelectedIndexChanged="ddlModule_SelectedIndexChanged" />
                            </div>

                            <asp:Panel ID="pnlQuestionSection" runat="server" Visible="false">

                                <!-- Module 1 note -->
                                <asp:Panel ID="pnlModule1Note" runat="server" Visible="false">
                                    <div class="module1-note">
                                        Module 1 uses flashcards, not quiz questions &mdash; there are no questions to manage here.
                                    </div>
                                </asp:Panel>

                                <!-- Questions list + form (Module 2–8) -->
                                <asp:Panel ID="pnlQuestionList" runat="server" Visible="false">

                                    <div class="questions-header">
                                        <p class="questions-header-title">
                                            <asp:Label ID="lblQuestionsFor" runat="server" />
                                        </p>
                                        <asp:Button ID="btnShowAddQuestion" runat="server" Text="+ Add Question"
                                            CssClass="primary-btn" OnClick="btnShowAddQuestion_Click"
                                            CausesValidation="false" />
                                    </div>

                                    <!-- Question Form (Add / Edit) -->
                                    <asp:Panel ID="pnlQuestionForm" runat="server" Visible="false" CssClass="form-panel">
                                        <p class="form-panel-title">
                                            <asp:Label ID="lblQuestionFormTitle" runat="server" Text="Add New Question" />
                                        </p>

                                        <div class="form-grid cols-3">
                                            <div class="form-group">
                                                <label>Question No. *</label>
                                                <asp:TextBox ID="txtQuestionNumber" runat="server" TextMode="Number" />
                                            </div>
                                            <div class="form-group">
                                                <label>Question Type *</label>
                                                <asp:DropDownList ID="ddlQuestionType" runat="server"
                                                    onchange="toggleOptions(this.value)">
                                                    <asp:ListItem Value="mcq">MCQ (Multiple Choice)</asp:ListItem>
                                                    <asp:ListItem Value="fill">Fill in the Blank</asp:ListItem>
                                                    <asp:ListItem Value="truefalse">True / False</asp:ListItem>
                                                </asp:DropDownList>
                                            </div>
                                            <div class="form-group">
                                                <label>Correct Answer *</label>
                                                <asp:TextBox ID="txtCorrectAnswer" runat="server" />
                                            </div>
                                        </div>

                                        <div class="form-grid cols-1">
                                            <div class="form-group">
                                                <label>Question Text *</label>
                                                <asp:TextBox ID="txtQuestionText" runat="server" TextMode="MultiLine" />
                                            </div>
                                        </div>

                                        <!-- MCQ Options (shown only when type = mcq) -->
                                        <div id="optionsGroup" class="options-group">
                                            <div class="form-grid">
                                                <div class="form-group">
                                                    <label>Option A</label>
                                                    <asp:TextBox ID="txtOptionA" runat="server" />
                                                </div>
                                                <div class="form-group">
                                                    <label>Option B</label>
                                                    <asp:TextBox ID="txtOptionB" runat="server" />
                                                </div>
                                                <div class="form-group">
                                                    <label>Option C</label>
                                                    <asp:TextBox ID="txtOptionC" runat="server" />
                                                </div>
                                                <div class="form-group">
                                                    <label>Option D</label>
                                                    <asp:TextBox ID="txtOptionD" runat="server" />
                                                </div>
                                            </div>
                                        </div>

                                        <div class="form-grid cols-1">
                                            <div class="form-group">
                                                <label>Explanation (shown after answer)</label>
                                                <asp:TextBox ID="txtExplanation" runat="server" TextMode="MultiLine" />
                                            </div>
                                        </div>

                                        <div class="form-actions">
                                            <asp:Button ID="btnSaveQuestion" runat="server" Text="Save Question"
                                                CssClass="primary-btn" OnClick="btnSaveQuestion_Click" />
                                            <asp:Button ID="btnCancelQuestion" runat="server" Text="Cancel"
                                                CssClass="secondary-btn" OnClick="btnCancelQuestion_Click"
                                                CausesValidation="false" />
                                        </div>
                                    </asp:Panel>

                                    <!-- Questions List -->
                                    <asp:Repeater ID="rptQuestions" runat="server" OnItemCommand="rptQuestions_ItemCommand">
                                        <HeaderTemplate>
                                            <table class="content-table">
                                                <thead>
                                                    <tr>
                                                        <th>#</th>
                                                        <th>Type</th>
                                                        <th>Question</th>
                                                        <th>Correct Answer</th>
                                                        <th>Actions</th>
                                                    </tr>
                                                </thead>
                                                <tbody>
                                        </HeaderTemplate>
                                        <ItemTemplate>
                                            <tr>
                                                <td><%# Eval("QuestionNumber") %></td>
                                                <td><span class="badge"><%# GetTypeBadge(Eval("QuestionType")) %></span></td>
                                                <td><%# GetQuestionText(Eval("QuestionData")) %></td>
                                                <td><%# Eval("CorrectAnswer") %></td>
                                                <td>
                                                    <asp:Button runat="server" Text="Edit"
                                                        CommandName="EditQuestion" CommandArgument='<%# Eval("QuestionID") %>'
                                                        CssClass="action-btn" CausesValidation="false" />
                                                    <asp:Button runat="server" Text="Delete"
                                                        CommandName="DeleteQuestion" CommandArgument='<%# Eval("QuestionID") %>'
                                                        CssClass="danger-btn" CausesValidation="false"
                                                        OnClientClick="return confirm('Delete this question? Student answer history for this question will also be removed.');" />
                                                </td>
                                            </tr>
                                        </ItemTemplate>
                                        <FooterTemplate>
                                                </tbody>
                                            </table>
                                        </FooterTemplate>
                                    </asp:Repeater>

                                    <asp:Panel ID="pnlQuestionsEmpty" runat="server" Visible="false">
                                        <div class="empty-state">No questions yet for this module. Click <strong>+ Add Question</strong> to add one.</div>
                                    </asp:Panel>

                                </asp:Panel>
                            </asp:Panel>

                        </div>
                    </section>
                </div>

            </div>
        </main>
    </div>

</asp:Content>

<asp:Content ID="ScriptContent" ContentPlaceHolderID="ScriptContent" runat="server">
    <script>
        var tabIds = ['dictionaryTab', 'questionsTab'];

        function showTab(tabId, button) {
            tabIds.forEach(function (id) {
                document.getElementById(id).classList.add('hidden');
            });
            document.getElementById(tabId).classList.remove('hidden');

            document.querySelectorAll('.tab-btn').forEach(function (btn) {
                btn.classList.remove('active');
            });
            button.classList.add('active');

            document.getElementById('<%= hfActiveTab.ClientID %>').value = tabId;
        }

        function toggleSidebar() {
            var sidebar = document.getElementById('sidebar');
            var toggle  = document.getElementById('sidebarToggle');
            sidebar.classList.toggle('collapsed');
            toggle.classList.toggle('collapsed');
            toggle.textContent = sidebar.classList.contains('collapsed') ? '>' : '<';
        }

        function toggleOptions(type) {
            document.getElementById('optionsGroup').style.display = (type === 'mcq') ? 'block' : 'none';
        }

        window.addEventListener('load', function () {
            // Restore active tab after postback
            var activeTab = document.getElementById('<%= hfActiveTab.ClientID %>').value || 'dictionaryTab';
            var buttons   = document.querySelectorAll('.tab-btn');
            var index     = tabIds.indexOf(activeTab);
            if (index >= 0) showTab(activeTab, buttons[index]);

            // Set options visibility based on current question type selection
            var ddl = document.getElementById('<%= ddlQuestionType.ClientID %>');
            if (ddl) toggleOptions(ddl.value);
        });
    </script>
</asp:Content>
