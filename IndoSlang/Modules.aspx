<%@ Page Title="Modules" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Modules.aspx.cs" Inherits="IndoSlang.Modules" %>

<asp:Content ID="HeadContent" ContentPlaceHolderID="HeadContent" runat="server">
    <style>
        .navbar { display: none !important; }
        .site-footer { display: none !important; }
        .site-main { padding: 0 !important; margin: 0 !important; }
        body { margin: 0; padding: 0; overflow: hidden; }

        .dashboard-layout { display: flex; height: 100vh; overflow: hidden; }

        .sidebar { width: 260px; min-width: 260px; background: var(--brown); color: #fff; display: flex; flex-direction: column; padding: 32px 0 24px; height: 100vh; overflow-y: auto; overflow-x: hidden; flex-shrink: 0; transition: width 0.3s ease, min-width 0.3s ease; }
        .sidebar.collapsed { width: 0; min-width: 0; overflow: hidden; }
        .sidebar-logo { display: flex; align-items: center; gap: 10px; padding: 0 24px 32px; font-family: var(--font-display); font-size: 1.3rem; color: #fff; text-decoration: none; white-space: nowrap; }
        .sidebar-logo img { width: 38px; height: 38px; border-radius: 50%; flex-shrink: 0; }
        .sidebar-nav { flex: 1; }
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

        .topbar { background: var(--cream); border-bottom: 2px solid var(--cream-mid); padding: 18px 36px; display: flex; align-items: center; justify-content: space-between; flex-shrink: 0; }
        .topbar-greeting h2 { font-family: var(--font-display); font-size: 1.6rem; color: var(--brown); margin: 0 0 2px; }
        .topbar-greeting p { font-size: 0.85rem; color: var(--brown-mid); margin: 0; }
        .topbar-user { display: flex; align-items: center; gap: 10px; color: var(--brown); font-weight: 700; font-size: 0.92rem; }
        .topbar-avatar { width: 38px; height: 38px; border-radius: 50%; background: var(--brown-mid); display: flex; align-items: center; justify-content: center; color: #fff; font-size: 1.2rem; }

        .modules-wrap { flex: 1; overflow-y: auto; overflow-x: hidden; padding: 34px 36px 80px; background: var(--cream); }

        .module-legend { max-width: 940px; margin: 0 auto 20px; display: flex; gap: 22px; flex-wrap: wrap; }
        .legend-item { display: flex; align-items: center; gap: 8px; font-size: 0.82rem; color: var(--brown-mid); font-weight: 700; }
        .legend-dot { width: 14px; height: 14px; border-radius: 50%; }
        .legend-dot.current { background: var(--brown); }
        .legend-dot.unlocked { background: var(--accent); }
        .legend-dot.completed { background: var(--green); }
        .legend-dot.locked { background: #E0D2B9; border: 2px solid rgba(59,42,26,0.25); }

        .path-board { max-width: 940px; height: 1060px; margin: 0 auto; position: relative; background: linear-gradient(180deg, #F8EED8 0%, #F3E5C7 100%); border: 2px solid rgba(59,42,26,0.08); border-radius: 24px; box-shadow: 0 10px 28px rgba(59,42,26,0.12); overflow: hidden; }

        .level-title { position: absolute; left: 64px; right: 64px; height: 72px; background: #FFF8EB; border: 2px solid rgba(59,42,26,0.08); border-radius: 18px; color: var(--brown); font-family: var(--font-display); font-size: 1.45rem; font-weight: 700; display: flex; align-items: center; justify-content: center; z-index: 10; box-shadow: 0 5px 14px rgba(59,42,26,0.08); }
        .level-title.locked { color: rgba(59,42,26,0.62); background: #F1E2C2; }
        .level-title.locked::after { content: " 🔒"; }

        #level1Title { top: 24px; }
        #level2Title { top: 288px; }
        #level3Title { top: 552px; }
        #level4Title { top: 816px; }

        .module-node { position: absolute; width: 70px; height: 70px; border-radius: 50%; display: flex; align-items: center; justify-content: center; color: #fff; text-decoration: none; font-family: var(--font-display); font-size: 1.6rem; font-weight: 700; border: 4px solid #fff; box-shadow: 0 7px 18px rgba(59,42,26,0.22); z-index: 8; transition: transform 0.18s ease, box-shadow 0.18s ease; cursor: pointer; }
        .module-node:hover { transform: scale(1.08); box-shadow: 0 10px 24px rgba(59,42,26,0.28); }
        .module-node.current { background: var(--brown); border-color: var(--accent); box-shadow: 0 0 0 7px rgba(217,123,43,0.25); }
        .module-node.unlocked { background: var(--accent); border-color: #F2B56F; }
        .module-node.completed { background: var(--green); border-color: #3E7350; }
        .module-node.locked { background: #D8CBB4; color: rgba(59,42,26,0.42); border-color: #EFE2CA; box-shadow: none; cursor: default; }

        .path-line { position: absolute; z-index: 2; }
        .path-line.h { border-top: 3px dashed rgba(59,42,26,0.28); }
        .path-line.v { border-left: 3px dashed rgba(59,42,26,0.28); }
        .path-line.completed { border-color: var(--green) !important; }
        .path-line.current { border-color: var(--accent) !important; }

        #node1 { top: 134px; left: 150px; }
        #node2 { top: 164px; right: 150px; }
        #node3 { top: 398px; left: 150px; }
        #node4 { top: 428px; right: 150px; }
        #node5 { top: 662px; left: 150px; }
        #node6 { top: 692px; right: 150px; }
        #node7 { top: 926px; left: 150px; }
        #node8 { top: 956px; right: 150px; }

        .line-1 { top: 96px; left: 185px; height: 73px; }
        .line-2 { top: 169px; left: 185px; width: calc(100% - 370px); }
        .line-3 { top: 169px; right: 185px; height: 50px; }
        .line-4 { top: 219px; left: 185px; width: calc(100% - 370px); }
        .line-5 { top: 219px; left: 185px; height: 214px; }
        .line-6 { top: 433px; left: 185px; width: calc(100% - 370px); }
        .line-7 { top: 433px; right: 185px; height: 50px; }
        .line-8 { top: 483px; left: 185px; width: calc(100% - 370px); }
        .line-9 { top: 483px; left: 185px; height: 214px; }
        .line-10 { top: 697px; left: 185px; width: calc(100% - 370px); }
        .line-11 { top: 697px; right: 185px; height: 50px; }
        .line-12 { top: 747px; left: 185px; width: calc(100% - 370px); }
        .line-13 { top: 747px; left: 185px; height: 214px; }
        .line-14 { top: 961px; left: 185px; width: calc(100% - 370px); }
        .line-15 { top: 961px; right: 185px; height: 50px; }

        .locked-warning { position: fixed; right: 30px; bottom: 30px; background: var(--brown); color: white; padding: 14px 18px; border-radius: 12px; box-shadow: 0 8px 24px rgba(0,0,0,0.25); font-weight: 700; display: none; z-index: 10000; }

        @media (max-width: 900px) {
            .path-board { height: 1040px; }
            .level-title { left: 28px; right: 28px; }
            #node1, #node3, #node5, #node7 { left: 75px; }
            #node2, #node4, #node6, #node8 { right: 75px; }
            .line-1, .line-5, .line-9, .line-13 { left: 110px; }
            .line-3, .line-7, .line-11, .line-15 { right: 110px; }
            .line-2, .line-4, .line-6, .line-8, .line-10, .line-12, .line-14 { left: 110px; width: calc(100% - 220px); }
        }
    </style>
</asp:Content>

<asp:Content ID="MainContent" ContentPlaceHolderID="MainContent" runat="server">

    <button type="button" class="sidebar-toggle" onclick="toggleSidebar()" id="sidebarToggle">&#8249;</button>

    <div class="dashboard-layout">

        <% if (!IsBuddy) { %>
        <aside class="sidebar" id="sidebar">
            <a href="HomePage.aspx" class="sidebar-logo">
                <img src="Images/OWI SPARKLE EYE BIG.png" alt="IndoSlang" />
                IndoSlang
            </a>
            <nav class="sidebar-nav">
                <a href="MemberDashboard.aspx" class="nav-link"><span class="nav-icon">&#x1F3E0;</span> Dashboard</a>
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
        <% } else { %>
        <aside class="sidebar" id="sidebar">
            <a href="HomePage.aspx" class="sidebar-logo">
                <img src="Images/OWI SPARKLE EYE BIG.png" alt="IndoSlang" />
                IndoSlang
            </a>
            <nav class="sidebar-nav">
                <a href="BuddyDashboard.aspx" class="nav-link"><span class="nav-icon">&#x1F3E0;</span> Dashboard</a>
                <a href="Modules.aspx" class="nav-link active"><span class="nav-icon">&#x1F4DA;</span> My Modules</a>
                <a href="SlangDictionary.aspx" class="nav-link"><span class="nav-icon">&#x1F4D6;</span> Dictionary</a>
                <a href="CommunityChat.aspx" class="nav-link"><span class="nav-icon">&#x1F4AC;</span> Community Chat</a>
                <a href="HostSession.aspx" class="nav-link"><span class="nav-icon">&#x1F3A4;</span> Host Session</a>
                <a href="ManageAvailability.aspx" class="nav-link"><span class="nav-icon">&#x1F4C5;</span> Manage Availability</a>
                <a href="SessionHistory.aspx" class="nav-link"><span class="nav-icon">&#x1F550;</span> Session History</a>
                <a href="SuggestSlang.aspx" class="nav-link"><span class="nav-icon">&#x2728;</span> Suggest Slang</a>
                <hr class="sidebar-divider" />
                <a href="BuddyProfile.aspx" class="nav-link"><span class="nav-icon">&#x1F464;</span> My Profile</a>
                <a href="WithdrawEarnings.aspx" class="nav-link"><span class="nav-icon">&#x1F4B8;</span> Withdraw Earnings</a>
            </nav>
            <hr class="sidebar-divider" />
            <a href="Logout.aspx" class="nav-link signout"><span class="nav-icon">&#x1F6AA;</span> Sign Out</a>
        </aside>
        <% } %>

        <div class="dashboard-main">
            <div class="topbar">
                <div class="topbar-greeting">
                    <h2 id="greetingText">Good morning!</h2>
                    <p id="greetingSubtext">Welcome to IndoSlang</p>
                </div>
                <div class="topbar-user">
                    <div class="topbar-avatar">&#x1F464;</div>
                    <span id="topbarName">Member</span>
                </div>
            </div>

            <div class="modules-wrap">
                <div class="module-legend">
                    <div class="legend-item"><div class="legend-dot current"></div> Current</div>
                    <div class="legend-item"><div class="legend-dot unlocked"></div> Available</div>
                    <div class="legend-item"><div class="legend-dot completed"></div> Completed</div>
                    <div class="legend-item"><div class="legend-dot locked"></div> Locked</div>
                </div>

                <div class="path-board">
                    <div class="level-title" id="level1Title">Level 1 - Beginner</div>
                    <div class="level-title locked" id="level2Title">Level 2 - Elementary</div>
                    <div class="level-title locked" id="level3Title">Level 3 - Intermediate</div>
                    <div class="level-title locked" id="level4Title">Level 4 - Advanced</div>

                    <div class="path-line v line-1" id="line1"></div>
                    <div class="path-line h line-2" id="line2"></div>
                    <div class="path-line v line-3" id="line3"></div>
                    <div class="path-line h line-4" id="line4"></div>
                    <div class="path-line v line-5" id="line5"></div>
                    <div class="path-line h line-6" id="line6"></div>
                    <div class="path-line v line-7" id="line7"></div>
                    <div class="path-line h line-8" id="line8"></div>
                    <div class="path-line v line-9" id="line9"></div>
                    <div class="path-line h line-10" id="line10"></div>
                    <div class="path-line v line-11" id="line11"></div>
                    <div class="path-line h line-12" id="line12"></div>
                    <div class="path-line v line-13" id="line13"></div>
                    <div class="path-line h line-14" id="line14"></div>
                    <div class="path-line v line-15" id="line15"></div>

                    <!-- no href — JS controls navigation -->
                    <a class="module-node" id="node1">1</a>
                    <a class="module-node" id="node2">2</a>
                    <a class="module-node" id="node3">3</a>
                    <a class="module-node" id="node4">4</a>
                    <a class="module-node" id="node5">5</a>
                    <a class="module-node" id="node6">6</a>
                    <a class="module-node" id="node7">7</a>
                    <a class="module-node" id="node8">8</a>
                </div>
            </div>
        </div>
    </div>

    <div class="locked-warning" id="lockedWarning">Complete the previous module first.</div>

</asp:Content>

<asp:Content ID="ScriptContent" ContentPlaceHolderID="ScriptContent" runat="server">
<script>
    var userLevel = '<%= UserLevel %>';
    var userName = '<%= UserName %>';
    var startModule = '<%= StartModule %>';
    var completedModules = '<%= CompletedModulesCsv %>';

    var hrefs = [
        'Module1.aspx', 'Module2.aspx', 'Module3.aspx', 'Module4.aspx',
        'Module5.aspx', 'Module6.aspx', 'Module7.aspx', 'Module8.aspx'
    ];

    function toggleSidebar() {
        var sidebar = document.getElementById('sidebar');
        var toggle = document.getElementById('sidebarToggle');
        sidebar.classList.toggle('collapsed');
        toggle.classList.toggle('collapsed');
        toggle.textContent = sidebar.classList.contains('collapsed') ? '\u203A' : '\u2039';
    }

    function setGreeting() {
        var hour = new Date().getHours();
        var greeting = hour < 12 ? 'Good morning' : hour < 17 ? 'Good afternoon' : 'Good evening';
        document.getElementById('greetingText').textContent = greeting + ', ' + userName + '!';
        document.getElementById('topbarName').textContent = userName;
        document.getElementById('greetingSubtext').textContent = userLevel + ' level - keep going!';
    }

    function getUnlockedCount(completedList) {
        if (completedList.length === 0) return 1;
        var maxCompleted = Math.max.apply(null, completedList.map(Number));
        var next = maxCompleted + 1;
        return next > 8 ? 8 : next;
    }

    function applyModuleAccess() {
        var completedList = completedModules
            ? completedModules.split(',').map(function (x) { return x.trim(); }).filter(Boolean)
            : [];

        var unlockedCount = getUnlockedCount(completedList);

        for (var i = 1; i <= 8; i++) {
            var node = document.getElementById('node' + i);
            // default: locked, no navigation
            node.className = 'module-node locked';
            node.removeAttribute('href');
            node.onclick = null;

            if (i <= unlockedCount) {
                node.className = 'module-node unlocked';
                (function (url) {
                    node.onclick = function () { window.location.href = url; };
                })(hrefs[i - 1]);
            }

            if (completedList.indexOf(i.toString()) !== -1) {
                node.className = 'module-node completed';
                (function (url) {
                    node.onclick = function () { window.location.href = url; };
                })(hrefs[i - 1]);
            }
        }

        var currentIndex = hrefs.indexOf(startModule);
        if (currentIndex >= 0 && currentIndex < unlockedCount) {
            var currentNode = document.getElementById('node' + (currentIndex + 1));
            if (completedList.indexOf((currentIndex + 1).toString()) === -1) {
                currentNode.className = 'module-node current';
            }
        }

        updateLevelLocks(completedList);
        updatePathLines(completedList, currentIndex);
    }

    function updateLevelLocks(completedList) {
        var maxCompleted = completedList.length > 0
            ? Math.max.apply(null, completedList.map(Number))
            : 0;
        document.getElementById('level2Title').classList.toggle('locked', maxCompleted < 2);
        document.getElementById('level3Title').classList.toggle('locked', maxCompleted < 4);
        document.getElementById('level4Title').classList.toggle('locked', maxCompleted < 6);
    }

    function updatePathLines(completedList, currentIndex) {
        function isCompleted(n) { return completedList.indexOf(n.toString()) !== -1; }
        function isCurrent(n) { return (currentIndex + 1) === n; }

        function setLine(id, state) {
            var el = document.getElementById('line' + id);
            if (!el) return;
            el.classList.remove('completed', 'current');
            if (state === 'completed') el.classList.add('completed');
            else if (state === 'current') el.classList.add('current');
        }

        function lineState(fromNode, toNode) {
            if (isCompleted(fromNode) && isCompleted(toNode)) return 'completed';
            if (isCompleted(fromNode) && isCurrent(toNode)) return 'current';
            if (isCurrent(fromNode)) return 'current';
            return 'default';
        }

        setLine(1, isCompleted(1) ? 'completed' : isCurrent(1) ? 'current' : 'default');
        setLine(2, lineState(1, 2));
        setLine(3, isCompleted(2) ? 'completed' : isCurrent(2) ? 'current' : 'default');
        setLine(4, isCompleted(2) ? 'completed' : 'default');
        setLine(5, isCompleted(2) ? 'completed' : 'default');
        setLine(6, lineState(3, 4));
        setLine(7, isCompleted(4) ? 'completed' : isCurrent(4) ? 'current' : 'default');
        setLine(8, isCompleted(4) ? 'completed' : 'default');
        setLine(9, isCompleted(4) ? 'completed' : 'default');
        setLine(10, lineState(5, 6));
        setLine(11, isCompleted(6) ? 'completed' : isCurrent(6) ? 'current' : 'default');
        setLine(12, isCompleted(6) ? 'completed' : 'default');
        setLine(13, isCompleted(6) ? 'completed' : 'default');
        setLine(14, lineState(7, 8));
        setLine(15, isCompleted(8) ? 'completed' : isCurrent(8) ? 'current' : 'default');
    }

    function setupLockedClickWarning() {
        for (var i = 1; i <= 8; i++) {
            (function (node) {
                node.addEventListener('click', function () {
                    if (this.classList.contains('locked')) {
                        showLockedWarning();
                    }
                });
            })(document.getElementById('node' + i));
        }
    }

    function showLockedWarning() {
        var warning = document.getElementById('lockedWarning');
        warning.style.display = 'block';
        setTimeout(function () { warning.style.display = 'none'; }, 2200);
    }

    setGreeting();
    applyModuleAccess();
    setupLockedClickWarning();
</script>
</asp:Content>
