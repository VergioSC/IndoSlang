<%@ Page Title="Module 7 — Advanced Conversation" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Module7.aspx.cs" Inherits="IndoSlang.Module7" %>

<asp:Content ID="HeadContent" ContentPlaceHolderID="HeadContent" runat="server">
    <style>
        .navbar { display: none !important; }
        .site-footer { display: none !important; }
        .site-main { padding: 0 !important; margin: 0 !important; }
        body { margin: 0; padding: 0; overflow: hidden; }

        .dashboard-layout {
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

        .sidebar-logo img {
            width: 38px;
            height: 38px;
            border-radius: 50%;
            flex-shrink: 0;
        }

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

        .nav-link.signout {
            color: rgba(255,255,255,0.45);
        }

        .nav-link.signout:hover {
            color: #ff8a8a;
            background: rgba(255,100,100,0.08);
        }

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

        .dashboard-main {
            flex: 1;
            display: flex;
            flex-direction: column;
            height: 100vh;
            overflow: hidden;
            min-width: 0;
        }

        .topbar {
            background: var(--cream);
            border-bottom: 2px solid var(--cream-mid);
            padding: 16px 34px;
            display: flex;
            align-items: center;
            justify-content: space-between;
            flex-shrink: 0;
        }

        .topbar-left {
            display: flex;
            align-items: center;
            gap: 14px;
        }

        .btn-back {
            display: inline-flex;
            align-items: center;
            gap: 6px;
            background: var(--cream-mid);
            border: none;
            border-radius: 10px;
            padding: 8px 15px;
            font-family: var(--font-body);
            font-size: 0.85rem;
            color: var(--brown);
            cursor: pointer;
            text-decoration: none;
            font-weight: 700;
            transition: background 0.2s;
        }

        .btn-back:hover { background: #e8ddd0; }

        .topbar-title {
            font-family: var(--font-display);
            font-size: 1.55rem;
            color: var(--brown);
            font-weight: 700;
        }

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
            font-size: 1.1rem;
        }

        .module-content {
            flex: 1;
            overflow-y: auto;
            padding: 38px 46px 70px;
            background: var(--cream);
            font-family: var(--font-body);
            color: var(--brown);
        }

        .module-header {
            margin-bottom: 28px;
        }

        .module-badge {
            display: inline-block;
            background: var(--brown);
            color: #fff;
            font-family: var(--font-display);
            font-size: 0.85rem;
            padding: 5px 15px;
            border-radius: 999px;
            margin-bottom: 10px;
        }

        .module-header h1 {
            font-family: var(--font-display);
            font-size: 2rem;
            margin: 0 0 6px;
            color: var(--brown);
        }

        .module-header p {
            color: var(--brown-mid);
            font-size: 0.94rem;
            margin: 0;
            line-height: 1.6;
        }

        .progress-bar-wrap {
            background: var(--cream-mid);
            border-radius: 999px;
            height: 10px;
            margin-bottom: 8px;
            overflow: hidden;
           
        }

        .progress-bar-fill {
            height: 100%;
            background: var(--brown);
            border-radius: 999px;
            transition: width 0.4s ease;
        }

        .progress-label {
            display: flex;
            justify-content: space-between;
            font-size: 0.82rem;
            color: var(--brown-mid);
            margin-bottom: 20px;
           
        }

        .score-tracker { display: none; }

        .score-dot {
            width: 18px;
            height: 18px;
            border-radius: 50%;
            border: 2px solid var(--cream-mid);
            background: #fff;
            transition: all 0.25s ease;
        }

        .score-dot.correct {
            background: var(--green);
            border-color: var(--green);
        }

        .score-dot.wrong {
            background: #c0392b;
            border-color: #c0392b;
        }

        .convo-card {
            background: #fff;
            border: 2px solid var(--cream-mid);
            border-radius: 22px;
            overflow: hidden;
            margin: 0 auto 20px;
            max-width: 780px;
            box-shadow: 0 6px 22px rgba(59,42,26,0.09);
        }

        .convo-header {
            background: var(--brown);
            padding: 15px 22px;
            display: flex;
            align-items: center;
            gap: 10px;
        }

        .convo-header-icon {
            font-size: 1.2rem;
        }

        .convo-header-title {
            font-family: var(--font-display);
            font-size: 1rem;
            color: #fff;
            font-weight: 700;
        }

        .chat-window {
            padding: 20px 24px;
            display: flex;
            flex-direction: column;
            gap: 7px;
            background: #fffdf8;
        }

        .convo-line {
            font-size: 0.93rem;
            line-height: 1.7;
            color: var(--brown);
        }

        .speaker-name {
            font-weight: 800;
            color: #c87133;
        }

        .question-area {
            padding: 24px 26px;
            border-top: 2px solid var(--cream-mid);
            background: #fff;
        }

        .question-type-tag {
            font-size: 0.75rem;
            font-weight: 800;
            text-transform: uppercase;
            letter-spacing: 1px;
            color: var(--accent);
            margin-bottom: 10px;
        }

        .question-text {
            font-family: var(--font-display);
            font-size: 1.22rem;
            margin-bottom: 20px;
            line-height: 1.45;
            color: var(--brown);
        }

        .mcq-options {
            display: flex;
            flex-direction: column;
            gap: 10px;
        }

        .mcq-option {
            background: var(--cream);
            border: 2px solid var(--cream-mid);
            border-radius: 14px;
            padding: 13px 18px;
            cursor: pointer;
            font-size: 0.95rem;
            transition: border-color 0.2s, background 0.2s;
            text-align: left;
            color: var(--brown);
            font-family: var(--font-body);
        }

        .mcq-option:hover {
            border-color: var(--accent);
            background: #fdf4ea;
        }

        .mcq-option.selected {
            border-color: var(--accent);
            background: #fce9d0;
        }

        .mcq-option.correct {
            border-color: var(--green);
            background: #d4edda;
        }

        .mcq-option.wrong {
            border-color: #c0392b;
            background: #fde8e8;
        }

        .fill-row {
            display: flex;
            gap: 10px;
            align-items: center;
        }

        .fill-blank-input {
            flex: 1;
            padding: 13px 16px;
            border: 2px solid var(--cream-mid);
            border-radius: 14px;
            font-family: var(--font-body);
            font-size: 1rem;
            color: var(--brown);
            background: var(--cream);
            outline: none;
            transition: border-color 0.2s;
        }

        .fill-blank-input:focus {
            border-color: var(--accent);
        }

        .fill-blank-input.correct {
            border-color: var(--green);
            background: #d4edda;
        }

        .fill-blank-input.wrong {
            border-color: #c0392b;
            background: #fde8e8;
        }

        .tf-options {
            display: flex;
            gap: 14px;
        }

        .tf-btn {
            flex: 1;
            padding: 14px;
            border-radius: 14px;
            border: 2px solid var(--cream-mid);
            background: var(--cream);
            font-family: var(--font-display);
            font-size: 1.05rem;
            cursor: pointer;
            color: var(--brown);
            transition: border-color 0.2s, background 0.2s;
        }

        .tf-btn:hover {
            border-color: var(--accent);
        }

        .tf-btn.selected {
            border-color: var(--accent);
            background: #fce9d0;
        }

        .tf-btn.correct {
            border-color: var(--green);
            background: #d4edda;
        }

        .tf-btn.wrong {
            border-color: #c0392b;
            background: #fde8e8;
        }

        .feedback-msg {
            margin-top: 14px;
            padding: 11px 16px;
            border-radius: 12px;
            font-size: 0.92rem;
            display: none;
            line-height: 1.5;
        }

        .feedback-msg.correct {
            background: #d4edda;
            color: #1a5c2a;
            display: block;
        }

        .feedback-msg.wrong {
            background: #fde8e8;
            color: #7b1515;
            display: block;
        }

        .check-btn,
        .next-btn {
            color: #fff;
            border: none;
            padding: 12px 28px;
            border-radius: 13px;
            font-family: var(--font-display);
            font-size: 1rem;
            cursor: pointer;
            transition: background 0.2s, transform 0.15s;
            margin-top: 14px;
        }

        .check-btn {
            background: var(--accent);
        }

        .check-btn:hover {
            background: var(--accent-light);
            transform: translateY(-2px);
        }

        .next-btn {
            background: var(--brown);
            display: none;
            margin-left: 8px;
        }

        .next-btn:hover {
            background: var(--brown-mid);
            transform: translateY(-2px);
        }

        .completion-card { display: none; text-align: center; background: #fff; border: 1.5px solid var(--cream-mid); border-radius: 18px; padding: 48px 40px 40px; max-width: 620px; margin: 0 auto; }
        .score-circle { width: 160px; height: 160px; border-radius: 50%; border: 3px solid var(--brown); display: flex; flex-direction: column; align-items: center; justify-content: center; margin: 0 auto 32px; }
        .score-circle-num { font-family: var(--font-display); font-size: 3.2rem; font-weight: 700; color: var(--brown); line-height: 1; }
        .score-circle-label { font-size: 0.85rem; color: var(--brown-mid); margin-top: 4px; }
        .completion-main-msg { font-family: var(--font-display); font-size: 1.4rem; font-weight: 700; color: var(--brown); margin: 0 0 12px; }
        .completion-sub-msg { font-size: 0.95rem; color: var(--brown-mid); line-height: 1.65; margin: 0 0 28px; }
        .result-actions { display: flex; justify-content: center; gap: 12px; flex-wrap: wrap; }

        .btn-next-module {
            background: var(--accent);
            color: #fff;
            padding: 13px 30px;
            border-radius: 13px;
            font-family: var(--font-display);
            font-size: 1rem;
            text-decoration: none;
            display: inline-block;
            border: none;
            cursor: pointer;
        }

        .btn-next-module:hover {
            background: var(--accent-light);
        }

        .btn-retry {
            background: var(--cream-mid);
            color: var(--brown);
            border: 2px solid var(--brown-mid);
            padding: 12px 26px;
            border-radius: 13px;
            font-family: var(--font-display);
            font-size: 1rem;
            cursor: pointer;
            margin-right: 12px;
        }

        .empty-card {
            background: #fff;
            border: 2px dashed var(--cream-mid);
            border-radius: 22px;
            padding: 36px 28px;
            max-width: 780px;
            margin: 0 auto;
            color: var(--brown-mid);
            line-height: 1.7;
            display: none;
        }

        .empty-card strong {
            color: var(--brown);
        }

        .hidden-server-control {
            display: none;
        }

        /* ── Welcome screen ── */
        .welcome-screen { display: flex; justify-content: center; padding-top: 30px; }
        .welcome-intro { max-width: 600px; text-align: center; }
        .welcome-intro h2 { font-family: var(--font-display); font-size: 1.9rem; color: var(--brown); margin: 0 0 14px; line-height: 1.35; }
        .welcome-intro-lead { font-family: var(--font-display); font-size: 1rem; font-weight: 700; color: var(--brown); margin-bottom: 18px; }
        .welcome-intro-body { color: var(--brown-mid); line-height: 1.7; margin-bottom: 14px; font-size: 0.95rem; }
        .btn-start { background: var(--cream); color: var(--brown); border: 2px solid var(--brown); border-radius: 999px; padding: 12px 32px; font-family: var(--font-display); font-size: 1rem; cursor: pointer; transition: background 0.2s; margin-top: 10px; }
        .btn-start:hover { background: var(--cream-mid); }

        /* ── Score circle ── */
        .score-circle { width: 140px; height: 140px; border-radius: 50%; border: 6px solid var(--green); display: flex; flex-direction: column; align-items: center; justify-content: center; margin: 16px auto 20px; }
        .score-circle.failed { border-color: #c0392b; }
        .score-circle-num { font-family: var(--font-display); font-size: 3.2rem; font-weight: 800; color: var(--brown); line-height: 1; }
        .score-circle-denom { font-size: 0.78rem; color: var(--brown-mid); margin-top: 3px; }

        /* ── Summary table ── */
        .summary-word-table { margin: 0 0 16px; }
        .summary-row { display: grid; grid-template-columns: 90px 1fr 90px 1fr; gap: 4px 16px; padding: 8px 0; border-bottom: 1px solid var(--cream-mid); align-items: baseline; }
        .sw-word { font-family: var(--font-display); font-size: 1rem; font-weight: 800; color: var(--brown); }
        .sw-def { font-size: 0.86rem; color: var(--brown-mid); font-style: italic; }
        .vocab-summary-note { text-align: center; font-size: 0.84rem; color: var(--brown-mid); margin: 16px 0 24px; font-style: italic; }

        /* ── Chat bubbles (iMessage-style) ── */
        .bubble-row {
            display: flex;
            flex-direction: column;
            max-width: 72%;
            margin-bottom: 10px;
        }

        .bubble-left { align-self: flex-start; align-items: flex-start; }
        .bubble-right { align-self: flex-end; align-items: flex-end; }

        .bubble-name {
            font-size: 0.73rem;
            font-weight: 700;
            color: var(--brown-mid);
            margin-bottom: 3px;
            padding: 0 10px;
        }

        .chat-bubble {
            padding: 9px 14px;
            font-size: 0.92rem;
            line-height: 1.55;
            max-width: 100%;
            word-break: break-word;
        }

        .bubble-left .chat-bubble {
            background: #fff;
            border: 1.5px solid var(--cream-mid);
            border-radius: 4px 18px 18px 18px;
            color: var(--brown);
        }

        .bubble-right .chat-bubble {
            background: var(--brown);
            border-radius: 18px 4px 18px 18px;
            color: #fff;
        }

        .chat-blank {
            display: inline-block;
            color: var(--accent);
            letter-spacing: 3px;
            padding: 0 6px;
            font-weight: 700;
        }

        .bubble-right .chat-blank {
            color: #ffd49e;
        }

        .highlighted-word {
            background: rgba(200,113,51,0.15);
            color: #c87133;
            padding: 1px 5px;
            border-radius: 4px;
            font-weight: 800;
        }

        .bubble-right .highlighted-word {
            background: rgba(255,255,255,0.2);
            color: #ffe0bc;
        }

        /* ── Question theme label ── */
        .question-theme {
            font-style: italic;
            font-size: 0.88rem;
            color: var(--brown-mid);
            font-family: var(--font-body);
            font-weight: 400;
            display: block;
            margin-top: 4px;
        }

        /* ── MCQ grid (2×2 for fill_chat) ── */
        .mcq-grid {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 10px;
        }

        .mcq-grid .mcq-option {
            text-align: center;
            padding: 12px 10px;
        }

        /* ── Unscramble drag-and-drop ── */
        .scramble-section-label {
            font-size: 0.8rem;
            font-weight: 700;
            text-transform: uppercase;
            letter-spacing: 0.5px;
            color: var(--brown-mid);
            margin-bottom: 8px;
        }

        .scramble-tiles {
            display: flex;
            flex-direction: column;
            gap: 8px;
            margin-bottom: 4px;
        }

        .msg-tile {
            background: #fff;
            border: 2px solid var(--cream-mid);
            border-radius: 12px;
            padding: 11px 16px;
            cursor: grab;
            font-size: 0.92rem;
            color: var(--brown);
            transition: border-color 0.2s, box-shadow 0.2s, opacity 0.2s;
            user-select: none;
        }

        .msg-tile:hover { border-color: var(--accent); box-shadow: 0 2px 8px rgba(200,113,51,0.15); }
        .msg-tile:active { cursor: grabbing; }
        .msg-tile.dragging { opacity: 0.45; }
        .msg-tile.placed { opacity: 0.35; pointer-events: none; background: #f5f0e8; }
        .msg-tile.correct { border-color: var(--green); background: #d4edda; cursor: default; }
        .msg-tile.wrong { border-color: #c0392b; background: #fde8e8; cursor: default; }

        .scramble-target {
            display: flex;
            flex-direction: column;
            gap: 8px;
        }

        .drop-zone {
            border: 2px dashed var(--cream-mid);
            border-radius: 12px;
            padding: 11px 14px;
            min-height: 46px;
            display: flex;
            align-items: center;
            background: #faf7f2;
            transition: border-color 0.2s, background 0.2s;
            cursor: default;
        }

        .drop-zone.drag-over { border-color: var(--accent); background: #fdf4ea; }
        .drop-zone.filled { background: #fff; border-style: solid; }
        .drop-zone.correct { border-color: var(--green); background: #d4edda; border-style: solid; }
        .drop-zone.wrong { border-color: #c0392b; background: #fde8e8; border-style: solid; }

        .drop-zone-label {
            font-size: 0.78rem;
            color: var(--brown-mid);
            font-weight: 700;
            min-width: 22px;
            margin-right: 10px;
        }

        .drop-zone-content { flex: 1; font-size: 0.91rem; color: var(--brown); }
        .drop-zone-placeholder { color: #c5b9ad; font-size: 0.87rem; }

        /* ── Vocab summary ── */
        .vocab-summary {
            background: #fff;
            border: 2px solid var(--cream-mid);
            border-radius: 22px;
            padding: 36px;
            max-width: 780px;
            margin: 0 auto;
            box-shadow: 0 6px 22px rgba(59,42,26,0.09);
        }

        .vocab-summary-title {
            font-family: var(--font-display);
            font-size: 1.7rem;
            color: var(--brown);
            margin-bottom: 6px;
            text-align: center;
        }

        .vocab-summary-sub {
            text-align: center;
            color: var(--brown-mid);
            margin-bottom: 24px;
            font-size: 0.93rem;
        }

        .vocab-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(190px, 1fr));
            gap: 14px;
            margin-bottom: 28px;
        }

        .vocab-card {
            background: var(--cream);
            border: 1.5px solid var(--cream-mid);
            border-radius: 14px;
            padding: 14px 16px;
        }

        .vocab-word {
            font-family: var(--font-display);
            font-size: 1.1rem;
            color: var(--accent);
            margin-bottom: 5px;
            font-weight: 700;
        }

        .vocab-def {
            font-size: 0.83rem;
            color: var(--brown-mid);
            line-height: 1.5;
        }
    </style>
</asp:Content>

<asp:Content ID="MainContent" ContentPlaceHolderID="MainContent" runat="server">

    <asp:HiddenField ID="hfScore" runat="server" />
    <asp:HiddenField ID="hfPassed" runat="server" />
    <asp:HiddenField ID="hfAnswersJson" runat="server" />
    <asp:Button ID="btnSaveResult" runat="server" Text="Save Result" CssClass="hidden-server-control" OnClick="btnSaveResult_Click" />

    <button type="button" class="sidebar-toggle" onclick="toggleSidebar()" id="sidebarToggle">&lt;</button>

    <div class="dashboard-layout">

        <aside class="sidebar" id="sidebar">
            <a runat="server" id="lnkLogo" class="sidebar-logo">
                <img src="Images/OWI SPARKLE EYE BIG.png" alt="IndoSlang" style="width:40px; height:40px;" />
                IndoSlang
            </a>

            <nav class="sidebar-nav">
                <a runat="server" id="lnkDashboard" class="nav-link"><span class="nav-icon">&#x1F3E0;</span> Dashboard</a>
                <a href="Modules.aspx" class="nav-link active"><span class="nav-icon">&#x1F4DA;</span> My Modules</a>
                <a href="SlangDictionary.aspx" class="nav-link"><span class="nav-icon">&#x1F4D6;</span> Dictionary</a>
                <a href="CommunityChat.aspx" class="nav-link"><span class="nav-icon">&#x1F4AC;</span> Community Chat</a>
                <a href="BookSession.aspx" class="nav-link"><span class="nav-icon">&#x1F91D;</span> Book a Buddy</a>
                <a href="SessionHistory.aspx" class="nav-link"><span class="nav-icon">&#x1F550;</span> Session History</a>
                <a href="SuggestSlang.aspx" class="nav-link"><span class="nav-icon">&#x2728;</span> Suggest Slang</a>

                <hr class="sidebar-divider" />

                <a href="MemberProfile.aspx" class="nav-link"><span class="nav-icon">&#x1F464;</span> My Profile</a>
                <a href="ApplyBuddy.aspx" class="nav-link"><span class="nav-icon">&#x1F64B;</span> Apply as Buddy</a>
            </nav>

            <hr class="sidebar-divider" />

            <a href="Logout.aspx" class="nav-link signout"><span class="nav-icon">&#x1F6AA;</span> Sign Out</a>
        </aside>

        <div class="dashboard-main">
            <div class="topbar">
                <div class="topbar-left">
                    <a href="Modules.aspx" class="btn-back">← Modules</a>
                    <span class="topbar-title">Module 7</span>
                </div>

                <div class="topbar-user">
                    <div class="topbar-avatar">&#x1F464;</div>
                    <span id="topbarName">Member</span>
                </div>
            </div>

            <div class="module-content">

                <div id="welcomeScreen" class="welcome-screen">
                    <div class="welcome-intro">
                        <h2>Welcome to<br />Level 4 - Advanced<br />Module 7 - Full Conversations</h2>
                        <p class="welcome-intro-lead">This is the final level. You&apos;ve made it to Advanced.</p>
                        <p class="welcome-intro-body">In this level, you&apos;ll stop learning individual words and start reading full conversations. You&apos;ll unscramble real chats, fill in missing slang mid-conversation, and figure out what slang means just from the context &mdash; exactly how locals do it naturally.</p>
                        <p class="welcome-intro-body">By the end of Level 4, you&apos;ll be able to follow and join real Indonesian slang conversations without missing a beat.</p>
                        <button type="button" class="btn-start" onclick="startQuiz()">Got it, let&apos;s start!</button>
                    </div>
                </div>

                <div class="empty-card" id="emptyCard">
                    <strong>No questions found for Module 7.</strong><br />
                    Insert rows into the <strong>Question</strong> table where ModuleID belongs to Module 7.
                </div>

                <div id="quizBlock" style="display:none;">
                    <div class="module-header">
                        <span class="module-badge">Module 7 &middot; Advanced</span>
                        <h1>Real Talk</h1>
                        <p>Understand Indonesian Gen Z slang through real conversation-based questions.</p>
                    </div>

                    <div class="progress-bar-wrap">
                        <div class="progress-bar-fill" id="progressFill" style="width:0%"></div>
                    </div>

                    <div class="progress-label">
                        <span id="progressLabel">Question 1 of 10</span>
                        <span id="progressPct">0%</span>
                    </div>

                    <div class="score-tracker" id="scoreDots"></div>

                    <div id="quizArea">
                        <div class="convo-card" id="convoCard">
                            <div class="convo-header">
                                <span class="convo-header-icon">&#x1F4AC;</span>
                                <span class="convo-header-title" id="convoTitle">Chat</span>
                            </div>

                            <div class="chat-window" id="chatWindow"></div>

                            <div class="question-area">
                                <div class="question-type-tag" id="qTypeTag"></div>
                                <div class="question-text" id="questionText"></div>
                                <div id="answerArea"></div>
                                <div class="feedback-msg" id="feedbackMsg"></div>

                                <div>
                                    <button type="button" class="check-btn" id="checkBtn" onclick="checkAnswer()">Check ✓</button>
                                    <button type="button" class="next-btn" id="nextBtn" onclick="nextQuestion()">Next →</button>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>

                <div class="completion-card" id="completionCard">
                    <div class="score-circle">
                        <div class="score-circle-num" id="scoreNum">0</div>
                        <div class="score-circle-label" id="scoreOutOf">out of 10</div>
                    </div>
                    <p class="completion-main-msg" id="completionTitle"></p>
                    <p class="completion-sub-msg" id="completionMsg"></p>
                    <div class="result-actions" id="completionActions"></div>
                </div>

                <div class="vocab-summary" id="vocabSummary" style="display:none;">
                    <h2 class="vocab-summary-title">You just completed Module 7!</h2>
                    <div class="summary-word-table">
                        <div class="summary-row"><span class="sw-word">Mager</span><span class="sw-def">Too lazy to move</span><span class="sw-word">PHP</span><span class="sw-def">Gives false hope</span></div>
                        <div class="summary-row"><span class="sw-word">Gaskeun</span><span class="sw-def">Let&apos;s go / just do it</span><span class="sw-word">Baper</span><span class="sw-def">Emotionally carried away</span></div>
                        <div class="summary-row"><span class="sw-word">Cuek</span><span class="sw-def">Cold / doesn&apos;t show feelings</span><span class="sw-word">Gercep</span><span class="sw-def">Moves fast / quick action</span></div>
                        <div class="summary-row"><span class="sw-word">Bucin</span><span class="sw-def">Budak cinta / love slave</span><span class="sw-word">Galau</span><span class="sw-def">Anxious / overthinking</span></div>
                        <div class="summary-row"><span class="sw-word">Gabut</span><span class="sw-def">Bored with nothing to do</span><span class="sw-word"></span><span class="sw-def"></span></div>
                    </div>
                    <p class="vocab-summary-note">9 slang words used in full real conversations &mdash; all in context</p>
                    <div style="text-align:center;" id="vocabSummaryActions"></div>
                </div>

            </div>
        </div>
    </div>
</asp:Content>

<asp:Content ID="ScriptContent" ContentPlaceHolderID="ScriptContent" runat="server">
    <script>
        var userName = '<%= UserDisplayName %>';
        var questions = <%= QuestionsJson %>;

        document.getElementById('topbarName').textContent = userName || 'Member';

        function toggleSidebar() {
            var sidebar = document.getElementById('sidebar');
            var toggle = document.getElementById('sidebarToggle');
            sidebar.classList.toggle('collapsed');
            toggle.classList.toggle('collapsed');
            toggle.textContent = sidebar.classList.contains('collapsed') ? '\u203A' : '\u2039';
        }

        var PASS_SCORE = 7;
        var currentQ = 0;
        var score = 0;
        var answered = false;
        var answerRecords = [];
        var draggedTileId = null;
        var passedModule = false;

        function normalise(v) { return (v || '').toString().trim().toLowerCase(); }

        function startQuiz() {
            document.getElementById('welcomeScreen').style.display = 'none';
            document.getElementById('quizBlock').style.display = 'block';
        }

        function buildDots() {
            var c = document.getElementById('scoreDots');
            c.innerHTML = '';
            for (var i = 0; i < questions.length; i++) {
                var d = document.createElement('div');
                d.className = 'score-dot';
                d.id = 'dot-' + i;
                c.appendChild(d);
            }
        }

        function renderQuestion(index) {
            if (!questions || questions.length === 0) {
                document.getElementById('quizBlock').style.display = 'none';
                document.getElementById('emptyCard').style.display = 'block';
                return;
            }
            var q = questions[index];
            var data = q.QuestionData || {};
            var qType = normalise(q.QuestionType);
            answered = false;
            document.getElementById('progressLabel').textContent = 'Question ' + (index + 1) + ' of ' + questions.length;
            var pct = Math.round((index / questions.length) * 100);
            document.getElementById('progressPct').textContent = pct + '%';
            document.getElementById('progressFill').style.width = pct + '%';
            document.getElementById('feedbackMsg').className = 'feedback-msg';
            document.getElementById('feedbackMsg').textContent = '';
            document.getElementById('checkBtn').style.display = 'inline-block';
            document.getElementById('nextBtn').style.display = 'none';
            var cw = document.getElementById('chatWindow');
            cw.innerHTML = '';
            cw.removeAttribute('style');
            document.getElementById('answerArea').innerHTML = '';
            document.getElementById('questionText').innerHTML = '';
            if (qType === 'unscramble') renderUnscramble(q, data);
            else if (qType === 'fill_chat') renderFillChat(q, data);
            else if (qType === 'mcq_chat') renderMcqChat(q, data);
            else renderLegacy(q, data);
        }

        function renderBubbles(chatItems) {
            var cw = document.getElementById('chatWindow');
            cw.innerHTML = '';
            cw.style.background = '#ede8e2';
            cw.style.padding = '16px 20px';
            chatItems.forEach(function (msg) {
                var row = document.createElement('div');
                row.className = 'bubble-row bubble-' + (msg.side || 'left');
                var nameEl = document.createElement('div');
                nameEl.className = 'bubble-name';
                nameEl.textContent = msg.name || '';
                var bubble = document.createElement('div');
                bubble.className = 'chat-bubble';
                var txt = (msg.text || '')
                    .replace(/\[BLANK\]/g, '<span class="chat-blank">______</span>')
                    .replace(/\*\*([^*]+)\*\*/g, '<strong class="highlighted-word">$1</strong>');
                bubble.innerHTML = txt;
                row.appendChild(nameEl);
                row.appendChild(bubble);
                cw.appendChild(row);
            });
        }

        function renderUnscramble(q, data) {
            document.getElementById('convoTitle').textContent = 'Unscramble the Chat';
            document.getElementById('qTypeTag').textContent = 'Unscramble the Chat';
            document.getElementById('questionText').innerHTML =
                (data.question || 'Put these messages in the correct order!') +
                (data.theme ? '<em class="question-theme">Theme: ' + data.theme + '</em>' : '');
            document.querySelector('.convo-header-icon').textContent = '\uD83D\uDD00';
            var cw = document.getElementById('chatWindow');
            cw.style.background = '#f5f0ea';
            cw.style.padding = '16px 20px';
            var srcLbl = document.createElement('div');
            srcLbl.className = 'scramble-section-label';
            srcLbl.textContent = 'Shuffled messages:';
            cw.appendChild(srcLbl);
            var tiles = document.createElement('div');
            tiles.id = 'scrambleTiles';
            tiles.className = 'scramble-tiles';
            (data.messages || []).forEach(function (msg) {
                var tile = document.createElement('div');
                tile.className = 'msg-tile';
                tile.id = 'tile-' + msg.id;
                tile.setAttribute('draggable', 'true');
                tile.setAttribute('data-id', msg.id);
                tile.innerHTML = '<strong>' + msg.id + ':</strong> "' + msg.text + '"';
                tile.addEventListener('dragstart', function (e) {
                    draggedTileId = this.getAttribute('data-id');
                    this.classList.add('dragging');
                    e.dataTransfer.effectAllowed = 'move';
                });
                tile.addEventListener('dragend', function () { this.classList.remove('dragging'); });
                tiles.appendChild(tile);
            });
            cw.appendChild(tiles);
            var tgtLbl = document.createElement('div');
            tgtLbl.className = 'scramble-section-label';
            tgtLbl.style.marginTop = '14px';
            tgtLbl.textContent = 'Your answer \u2014 drag messages here:';
            cw.appendChild(tgtLbl);
            var target = document.createElement('div');
            target.id = 'scrambleTarget';
            target.className = 'scramble-target';
            for (var i = 0; i < 4; i++) {
                (function (pos) {
                    var zone = document.createElement('div');
                    zone.className = 'drop-zone';
                    zone.id = 'zone-' + pos;
                    zone.setAttribute('data-pos', pos);
                    zone.setAttribute('data-placed', '');
                    var lbl = document.createElement('span');
                    lbl.className = 'drop-zone-label';
                    lbl.textContent = (pos + 1) + '.';
                    var content = document.createElement('span');
                    content.className = 'drop-zone-content';
                    content.innerHTML = '<span class="drop-zone-placeholder">drop here</span>';
                    zone.appendChild(lbl);
                    zone.appendChild(content);
                    zone.addEventListener('dragover', function (e) { e.preventDefault(); this.classList.add('drag-over'); });
                    zone.addEventListener('dragleave', function () { this.classList.remove('drag-over'); });
                    zone.addEventListener('drop', function (e) {
                        e.preventDefault();
                        this.classList.remove('drag-over');
                        if (!draggedTileId || answered) return;
                        var prevId = this.getAttribute('data-placed');
                        if (prevId) { var prev = document.getElementById('tile-' + prevId); if (prev) prev.classList.remove('placed'); }
                        document.querySelectorAll('.drop-zone').forEach(function (z) {
                            if (z.getAttribute('data-placed') === draggedTileId) {
                                z.setAttribute('data-placed', '');
                                z.classList.remove('filled');
                                z.querySelector('.drop-zone-content').innerHTML = '<span class="drop-zone-placeholder">drop here</span>';
                            }
                        });
                        var msgs = data.messages || [];
                        var found = null;
                        for (var k = 0; k < msgs.length; k++) { if (msgs[k].id === draggedTileId) { found = msgs[k]; break; } }
                        this.setAttribute('data-placed', draggedTileId);
                        this.classList.add('filled');
                        this.querySelector('.drop-zone-content').innerHTML = '<strong>' + draggedTileId + ':</strong> "' + (found ? found.text : '') + '"';
                        document.getElementById('tile-' + draggedTileId).classList.add('placed');
                        draggedTileId = null;
                    });
                    zone.addEventListener('click', function () {
                        if (answered) return;
                        var pid = this.getAttribute('data-placed');
                        if (pid) {
                            this.setAttribute('data-placed', '');
                            this.classList.remove('filled');
                            this.querySelector('.drop-zone-content').innerHTML = '<span class="drop-zone-placeholder">drop here</span>';
                            var t = document.getElementById('tile-' + pid);
                            if (t) t.classList.remove('placed');
                        }
                    });
                    target.appendChild(zone);
                })(i);
            }
            cw.appendChild(target);
        }

        function renderFillChat(q, data) {
            document.getElementById('convoTitle').textContent = 'Fill in the Chat';
            document.getElementById('qTypeTag').textContent = 'Fill in the Chat';
            document.getElementById('questionText').innerHTML =
                (data.question || 'Choose the word that best completes this conversation!') +
                (data.theme ? '<em class="question-theme">Theme: ' + data.theme + '</em>' : '');
            document.querySelector('.convo-header-icon').textContent = '\u270D\uFE0F';
            renderBubbles(data.chat || []);
            var aa = document.getElementById('answerArea');
            aa.innerHTML = '';
            var lbl = document.createElement('div');
            lbl.style.cssText = 'font-size:0.82rem;font-weight:700;color:var(--brown-mid);margin-bottom:10px;margin-top:4px;text-transform:uppercase;letter-spacing:0.5px;';
            lbl.textContent = 'Choose the best slang:';
            aa.appendChild(lbl);
            var grid = document.createElement('div');
            grid.className = 'mcq-grid';
            (data.options || []).forEach(function (opt, i) {
                var btn = document.createElement('button');
                btn.type = 'button'; btn.className = 'mcq-option'; btn.textContent = opt;
                btn.setAttribute('data-answer', opt);
                btn.setAttribute('data-letter', String.fromCharCode(65 + i));
                btn.onclick = function () {
                    if (!answered) { document.querySelectorAll('.mcq-option').forEach(function (b) { b.classList.remove('selected'); }); this.classList.add('selected'); }
                };
                grid.appendChild(btn);
            });
            aa.appendChild(grid);
        }

        function renderMcqChat(q, data) {
            document.getElementById('convoTitle').textContent = 'Chat';
            document.getElementById('qTypeTag').textContent = 'MCQ in Context';
            document.getElementById('questionText').innerHTML =
                (data.question || 'What does the bold word mean in this conversation?') +
                (data.theme ? '<em class="question-theme">Theme: ' + data.theme + '</em>' : '');
            document.querySelector('.convo-header-icon').textContent = '\uD83D\uDCAC';
            renderBubbles(data.chat || []);
            var aa = document.getElementById('answerArea');
            aa.innerHTML = '';
            var div = document.createElement('div');
            div.className = 'mcq-options';
            (data.options || []).forEach(function (opt, i) {
                var btn = document.createElement('button');
                btn.type = 'button'; btn.className = 'mcq-option'; btn.textContent = opt;
                btn.setAttribute('data-answer', opt);
                btn.setAttribute('data-letter', String.fromCharCode(65 + i));
                btn.onclick = function () {
                    if (!answered) { document.querySelectorAll('.mcq-option').forEach(function (b) { b.classList.remove('selected'); }); this.classList.add('selected'); }
                };
                div.appendChild(btn);
            });
            aa.appendChild(div);
        }

        function renderLegacy(q, data) {
            document.getElementById('convoTitle').textContent = data.convoTitle || 'Conversation';
            document.querySelector('.convo-header-icon').textContent = '\uD83D\uDCAC';
            var _tl = { mcq: 'Multiple Choice', fill: 'Fill in the Blank', tf: 'True / False', true_false: 'True / False' };
            document.getElementById('qTypeTag').textContent = _tl[normalise(q.QuestionType)] || q.QuestionType || 'Multiple Choice';
            document.getElementById('questionText').textContent = data.question || data.questionText || '';
            var cw = document.getElementById('chatWindow');
            (data.chat || []).forEach(function (msg) {
                var line = document.createElement('div');
                line.className = 'convo-line';
                line.innerHTML = '<span class="speaker-name">' + (msg.name || 'Speaker') + ':</span> ' + (msg.text || '');
                cw.appendChild(line);
            });
            var aa = document.getElementById('answerArea');
            var qType = normalise(q.QuestionType);
            if (qType === 'tf' || qType === 'true_false') {
                var tfDiv = document.createElement('div');
                tfDiv.className = 'tf-options';
                var trueBtn = document.createElement('button');
                trueBtn.type = 'button'; trueBtn.className = 'tf-btn'; trueBtn.textContent = 'True \u2713'; trueBtn.setAttribute('data-answer', 'true'); trueBtn.onclick = selectTfOption;
                var falseBtn = document.createElement('button');
                falseBtn.type = 'button'; falseBtn.className = 'tf-btn'; falseBtn.textContent = 'False \u2717'; falseBtn.setAttribute('data-answer', 'false'); falseBtn.onclick = selectTfOption;
                tfDiv.appendChild(trueBtn); tfDiv.appendChild(falseBtn);
                aa.appendChild(tfDiv);
            } else {
                var div = document.createElement('div');
                div.className = 'mcq-options';
                (data.options || []).forEach(function (opt, i) {
                    var btn = document.createElement('button');
                    btn.type = 'button'; btn.className = 'mcq-option'; btn.textContent = opt;
                    btn.setAttribute('data-answer', opt); btn.setAttribute('data-letter', String.fromCharCode(65 + i));
                    btn.onclick = function () {
                        if (!answered) { document.querySelectorAll('.mcq-option').forEach(function (b) { b.classList.remove('selected'); }); this.classList.add('selected'); }
                    };
                    div.appendChild(btn);
                });
                aa.appendChild(div);
            }
        }

        function selectTfOption() {
            if (answered) return;
            document.querySelectorAll('.tf-btn').forEach(function (b) { b.classList.remove('selected'); });
            this.classList.add('selected');
        }

        function isAnswerCorrect(txt, letter, correct) {
            return normalise(txt) === normalise(correct) || normalise(letter) === normalise(correct);
        }

        function checkAnswer() {
            if (answered) return;
            var q = questions[currentQ];
            var data = q.QuestionData || {};
            var qType = normalise(q.QuestionType);
            var fb = document.getElementById('feedbackMsg');
            var sel = '';
            var ok = false;

            if (qType === 'unscramble') {
                var zones = document.querySelectorAll('.drop-zone');
                var order = [];
                var full = true;
                zones.forEach(function (z) { var id = z.getAttribute('data-placed'); if (id) order.push(id); else full = false; });
                if (!full) { fb.className = 'feedback-msg wrong'; fb.textContent = 'Please drag all 4 messages into the numbered positions.'; return; }
                var correct = data.correctOrder || q.CorrectAnswer.split(',');
                ok = order.join(',') === correct.join(',');
                sel = order.join(',');
                zones.forEach(function (z, idx) { z.classList.add(z.getAttribute('data-placed') === correct[idx] ? 'correct' : 'wrong'); });
                fb.className = 'feedback-msg ' + (ok ? 'correct' : 'wrong');
                fb.innerHTML = ok
                    ? 'Correct! ' + (data.explanation || '')
                    : 'Incorrect. Correct order: <strong>' + correct.join(' \u2192 ') + '</strong>. ' + (data.explanation || '');
            } else if (qType === 'tf' || qType === 'true_false') {
                var stf = document.querySelector('.tf-btn.selected');
                if (!stf) { fb.className = 'feedback-msg wrong'; fb.textContent = 'Please choose True or False.'; return; }
                sel = stf.getAttribute('data-answer');
                ok = normalise(sel) === normalise(q.CorrectAnswer);
                document.querySelectorAll('.tf-btn').forEach(function (b) {
                    b.disabled = true;
                    if (normalise(b.getAttribute('data-answer')) === normalise(q.CorrectAnswer)) b.classList.add('correct');
                    else if (b.classList.contains('selected')) b.classList.add('wrong');
                });
                fb.className = 'feedback-msg ' + (ok ? 'correct' : 'wrong');
                fb.textContent = (ok ? 'Correct. ' : 'Incorrect. ') + (data.explanation || '');
            } else {
                var chosen = document.querySelector('.mcq-option.selected');
                if (!chosen) { fb.className = 'feedback-msg wrong'; fb.textContent = 'Please select an option first.'; return; }
                sel = chosen.getAttribute('data-answer');
                var chosenLetter = chosen.getAttribute('data-letter');
                ok = isAnswerCorrect(sel, chosenLetter, q.CorrectAnswer);
                document.querySelectorAll('.mcq-option').forEach(function (b) {
                    b.disabled = true;
                    if (isAnswerCorrect(b.getAttribute('data-answer'), b.getAttribute('data-letter'), q.CorrectAnswer)) b.classList.add('correct');
                    else if (b.classList.contains('selected')) b.classList.add('wrong');
                });
                fb.className = 'feedback-msg ' + (ok ? 'correct' : 'wrong');
                fb.textContent = (ok ? 'Correct. ' : 'Incorrect. ') + (data.explanation || '');
            }

            if (ok) score++;
            answerRecords.push({ questionId: q.QuestionID, selectedAnswer: sel, isCorrect: ok });
            var dot = document.getElementById('dot-' + currentQ);
            if (dot) dot.classList.add(ok ? 'correct' : 'wrong');
            answered = true;
            document.getElementById('checkBtn').style.display = 'none';
            document.getElementById('nextBtn').style.display = 'inline-block';
        }

        function nextQuestion() {
            currentQ++;
            if (currentQ >= questions.length) showCompletion();
            else renderQuestion(currentQ);
        }

        function showCompletion() {
            document.getElementById('quizArea').style.display = 'none';
            document.getElementById('progressFill').style.width = '100%';
            document.getElementById('progressPct').textContent = '100%';
            document.getElementById('progressLabel').textContent = 'Complete';

            passedModule = score >= PASS_SCORE;
            document.getElementById('completionCard').style.display = 'block';
            document.getElementById('scoreNum').textContent = score;
            document.getElementById('scoreOutOf').textContent = 'out of ' + questions.length;

            document.getElementById('completionTitle').textContent = passedModule
                ? 'Well done! You passed Module 7.'
                : 'Not quite there yet \u2014 give it another go!';
            document.getElementById('completionMsg').textContent = passedModule
                ? 'You got ' + score + ' out of ' + questions.length + ' correct. You\'re reading Indonesian slang in context like a local!'
                : 'You got ' + score + ' out of ' + questions.length + '. You need at least ' + PASS_SCORE + '/10 to unlock Module 8. Review the slang you missed and try again!';

            var actions = document.getElementById('completionActions');
            actions.innerHTML = '';

            var retryBtn = document.createElement('button');
            retryBtn.type = 'button'; retryBtn.className = 'btn-retry'; retryBtn.textContent = 'Try again';
            retryBtn.onclick = restartQuiz;
            actions.appendChild(retryBtn);

            var sumBtn = document.createElement('button');
            sumBtn.type = 'button'; sumBtn.className = 'btn-next-module'; sumBtn.textContent = 'Go to summary \u2192';
            sumBtn.onclick = showSummary;
            actions.appendChild(sumBtn);
        }

        function showSummary() {
            document.getElementById('completionCard').style.display = 'none';
            document.getElementById('vocabSummary').style.display = 'block';
            document.getElementById('progressLabel').textContent = 'Summary';

            var sa = document.getElementById('vocabSummaryActions');
            sa.innerHTML = '';
            var btn = document.createElement('button');
            btn.type = 'button';
            btn.className = 'btn-next-module';
            if (passedModule) {
                btn.textContent = 'Go to Module 8 \u2192';
                btn.onclick = saveModuleResult;
            } else {
                btn.textContent = 'Try Again';
                btn.onclick = restartQuiz;
            }
            sa.appendChild(btn);
        }

        function saveModuleResult() {
            document.getElementById('<%= hfScore.ClientID %>').value = score;
            document.getElementById('<%= hfPassed.ClientID %>').value = passedModule ? 'true' : 'false';
            document.getElementById('<%= hfAnswersJson.ClientID %>').value = JSON.stringify(answerRecords);
            document.getElementById('<%= btnSaveResult.ClientID %>').click();
        }

        function restartQuiz() {
            currentQ = 0; score = 0; answered = false; answerRecords = []; draggedTileId = null; passedModule = false;
            document.getElementById('quizArea').style.display = 'block';
            document.getElementById('completionCard').style.display = 'none';
            document.getElementById('vocabSummary').style.display = 'none';
            document.getElementById('welcomeScreen').style.display = 'none';
            document.getElementById('quizBlock').style.display = 'block';
            buildDots();
            renderQuestion(0);
        }

        buildDots();
        renderQuestion(0);
    </script>
</asp:Content>
