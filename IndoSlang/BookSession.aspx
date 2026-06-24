<%@ Page Title="Book a Session" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="BookSession.aspx.cs" Inherits="IndoSlang.BookSession" %>

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

        .dashboard-main { flex: 1; display: flex; flex-direction: column; height: 100vh; overflow: hidden; min-width: 0; background: #f7f3ee; }

        .topbar { background: #fff; border-bottom: 1px solid var(--cream-mid); padding: 20px 32px; display: flex; align-items: center; justify-content: space-between; flex-shrink: 0; }
        .topbar-left h2 { font-family: var(--font-display); font-size: 1.5rem; color: var(--brown); margin: 0 0 2px; }
        .topbar-left p { font-size: 0.83rem; color: var(--brown-mid); margin: 0; }
        .topbar-user { display: flex; align-items: center; gap: 9px; color: var(--brown); font-weight: 700; font-size: 0.9rem; }
        .topbar-avatar { width: 36px; height: 36px; border-radius: 50%; background: var(--brown-mid); display: flex; align-items: center; justify-content: center; color: #fff; font-size: 1.1rem; }

        .dash-content { flex: 1; overflow-y: auto; padding: 28px 32px; }

        .msg-success { position: fixed; top: 0; left: 0; right: 0; z-index: 99999; background: #d4edda; color: #1a5c2a; padding: 10px 20px; font-size: 0.88rem; text-align: center; border-bottom: 1px solid #a5d6a7; }
        .msg-error   { position: fixed; top: 0; left: 0; right: 0; z-index: 99999; background: #fde8e8; color: #7b1515; padding: 10px 20px; font-size: 0.88rem; text-align: center; border-bottom: 1px solid #ef9a9a; }
        .hidden-control { display: none; }

        /* Two-column book layout */
        .book-layout { display: grid; grid-template-columns: 1fr 360px; gap: 24px; align-items: start; }

        /* Buddy list */
        .panel-title { font-family: var(--font-display); font-size: 1.05rem; color: var(--brown); font-weight: 700; margin: 0 0 16px; }

        .buddy-card { display: flex; gap: 16px; background: #fff; border: 2px solid var(--cream-mid); border-radius: 16px; padding: 18px 20px; margin-bottom: 14px; cursor: pointer; transition: border-color 0.15s, box-shadow 0.15s; }
        .buddy-card:hover { border-color: var(--brown-mid); }
        .buddy-card.selected { border-color: var(--brown); box-shadow: 0 0 0 3px rgba(59,42,26,0.1); }

        .buddy-avatar { width: 52px; height: 52px; border-radius: 50%; background: var(--cream-mid); display: flex; align-items: center; justify-content: center; color: var(--brown); font-size: 1.4rem; flex-shrink: 0; }

        .buddy-info { flex: 1; min-width: 0; }
        .buddy-header { display: flex; align-items: center; gap: 10px; margin-bottom: 4px; flex-wrap: wrap; }
        .buddy-name { font-weight: 700; font-size: 1.05rem; color: var(--brown); }
        .buddy-selected-badge { background: var(--brown); color: #fff; font-size: 0.75rem; font-weight: 700; padding: 2px 12px; border-radius: 999px; display: none; }
        .buddy-meta { font-size: 0.82rem; color: var(--brown-mid); margin-bottom: 6px; }
        .buddy-desc { font-size: 0.88rem; color: var(--brown); margin-bottom: 8px; line-height: 1.5; }
        .buddy-rate { font-weight: 700; font-size: 0.95rem; color: var(--brown); }

        .empty-buddies { text-align: center; padding: 48px 32px; color: var(--brown-mid); font-size: 0.9rem; font-style: italic; border: 1.5px dashed var(--cream-mid); border-radius: 14px; background: #fff; }

        /* Right panels */
        .right-panels { display: flex; flex-direction: column; gap: 20px; }

        .panel-card { background: #fff; border: 1.5px solid var(--cream-mid); border-radius: 16px; padding: 22px 24px; }
        .panel-card-title { font-family: var(--font-display); font-size: 1rem; font-weight: 700; color: var(--brown); margin: 0 0 4px; }
        .panel-card-sub { font-size: 0.82rem; color: var(--brown-mid); margin: 0 0 16px; }

        /* Time slot grid */
        .time-grid { display: grid; grid-template-columns: 1fr 1fr; gap: 10px; }
        .slot-btn { padding: 11px 8px; border: 1.5px solid var(--cream-mid); border-radius: 10px; background: #fff; color: var(--brown); font-size: 0.88rem; font-weight: 600; cursor: pointer; transition: all 0.15s; text-align: center; }
        .slot-btn:hover { border-color: var(--brown); }
        .slot-btn.selected { background: var(--brown); color: #fff; border-color: var(--brown); }

        /* Booking summary */
        .summary-rows { display: flex; flex-direction: column; gap: 10px; margin-bottom: 16px; }
        .summary-row { display: flex; justify-content: space-between; font-size: 0.9rem; }
        .summary-row span:first-child { color: var(--brown-mid); }
        .summary-row span:last-child { font-weight: 600; color: var(--brown); text-align: right; }
        .summary-divider { border: none; border-top: 1px solid var(--cream-mid); margin: 12px 0; }
        .summary-total { display: flex; justify-content: space-between; font-size: 1rem; font-weight: 700; color: var(--brown); margin-bottom: 18px; }

        /* Payment method */
        .payment-label { font-size: 0.82rem; font-weight: 700; color: var(--brown-mid); margin-bottom: 10px; }
        .payment-option { display: flex; align-items: center; gap: 10px; border: 1.5px solid var(--cream-mid); border-radius: 10px; padding: 11px 14px; margin-bottom: 8px; cursor: pointer; font-size: 0.9rem; color: var(--brown); transition: border-color 0.15s; }
        .payment-option input[type="radio"] { accent-color: var(--brown); width: 16px; height: 16px; flex-shrink: 0; }
        .payment-option.active { border-color: var(--brown); }

        .btn-confirm { width: 100%; padding: 13px; background: var(--brown); color: #fff; border: none; border-radius: 10px; font-family: var(--font-display); font-size: 1rem; font-weight: 700; cursor: pointer; margin-top: 4px; transition: opacity 0.15s; }
        .btn-confirm:hover { opacity: 0.88; }
        .btn-confirm:disabled { opacity: 0.45; cursor: not-allowed; }

        .placeholder-panel { text-align: center; padding: 32px 16px; color: var(--brown-mid); font-size: 0.88rem; }
        .placeholder-icon { font-size: 2rem; margin-bottom: 8px; }
    </style>
</asp:Content>

<asp:Content ID="MainContent" ContentPlaceHolderID="MainContent" runat="server">

    <asp:HiddenField ID="hfBookAvailId" runat="server" />
    <asp:Button ID="btnBookConfirm" runat="server" Text="Confirm" CssClass="hidden-control" OnClick="btnBookConfirm_Click" />
    <asp:Label ID="lblMessage" runat="server" CssClass="msg-success" Style="display:none" />

    <button type="button" class="sidebar-toggle" onclick="toggleSidebar()" id="sidebarToggle">&lt;</button>

    <div class="dashboard-layout">
        <aside class="sidebar" id="sidebar">
            <a href="HomePage.aspx" class="sidebar-logo">
                <img src="Images/OWI SPARKLE EYE BIG.png" alt="IndoSlang" />
                IndoSlang
            </a>
            <nav class="sidebar-nav">
                <a href="MemberDashboard.aspx" class="nav-link"><span class="nav-icon">&#x1F3E0;</span> Dashboard</a>
                <a href="Modules.aspx" class="nav-link"><span class="nav-icon">&#x1F4DA;</span> My Modules</a>
                <a href="SlangDictionary.aspx" class="nav-link"><span class="nav-icon">&#x1F4D6;</span> Dictionary</a>
                <a href="CommunityChat.aspx" class="nav-link"><span class="nav-icon">&#x1F4AC;</span> Community Chat</a>
                <a href="BookSession.aspx" class="nav-link active"><span class="nav-icon">&#x1F91D;</span> Book a Buddy</a>
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
                    <h2>Book a buddy session</h2>
                    <p>Practice live with a fluent speaker &bull; 85% goes to the buddy</p>
                </div>
                <div class="topbar-user">
                    <div class="topbar-avatar">&#x1F464;</div>
                    <span><%= System.Web.HttpUtility.HtmlEncode(MemberName) %></span>
                </div>
            </div>

            <div class="dash-content">

                <% if (Buddies.Count == 0) { %>
                <div class="empty-buddies">No available buddies right now. Check back later!</div>
                <% } else { %>

                <div class="book-layout">

                    <!-- Left: buddy list -->
                    <div>
                        <p class="panel-title">Available buddies</p>
                        <% foreach (var b in Buddies) { %>
                        <div class="buddy-card" id="buddy-<%= b.UserID %>" onclick="selectBuddy(<%= b.UserID %>)">
                            <div class="buddy-avatar">&#x1F464;</div>
                            <div class="buddy-info">
                                <div class="buddy-header">
                                    <span class="buddy-name"><%= System.Web.HttpUtility.HtmlEncode(b.Name) %></span>
                                    <span class="buddy-selected-badge" id="badge-<%= b.UserID %>">Selected</span>
                                </div>
                                <div class="buddy-meta">
                                    <%= System.Web.HttpUtility.HtmlEncode(b.Proficiency) %><% if (!string.IsNullOrWhiteSpace(b.City)) { %> &bull; <%= System.Web.HttpUtility.HtmlEncode(b.City) %><% } %> &bull; <%= b.SessionCount %> sessions
                                </div>
                                <% if (!string.IsNullOrWhiteSpace(b.Description)) { %>
                                <div class="buddy-desc"><%= System.Web.HttpUtility.HtmlEncode(b.Description) %></div>
                                <% } %>
                                <div class="buddy-rate">RM <%= b.HourlyRate.ToString("0") %> / 60 min</div>
                            </div>
                        </div>
                        <% } %>
                    </div>

                    <!-- Right: time picker + booking summary -->
                    <div class="right-panels">

                        <div class="panel-card" id="timePicker">
                            <p class="panel-card-title">Pick a time slot</p>
                            <p class="panel-card-sub" id="timePickerSub">Select a buddy to see available times</p>
                            <div id="timeGrid">
                                <div class="placeholder-panel">
                                    <div class="placeholder-icon">&#x1F4C5;</div>
                                    <div>Select a buddy first</div>
                                </div>
                            </div>
                        </div>

                        <div class="panel-card" id="bookingSummaryCard" style="display:none">
                            <p class="panel-card-title">Booking summary</p>
                            <div class="summary-rows">
                                <div class="summary-row"><span>Buddy</span><span id="sumBuddy">—</span></div>
                                <div class="summary-row"><span>Date</span><span id="sumDate">—</span></div>
                                <div class="summary-row"><span>Time</span><span id="sumTime">—</span></div>
                                <div class="summary-row"><span>Duration</span><span id="sumDuration">—</span></div>
                            </div>
                            <hr class="summary-divider" />
                            <div class="summary-total">
                                <span>Total</span><span id="sumTotal">—</span>
                            </div>
                            <p class="payment-label">Payment method</p>
                            <label class="payment-option active" id="payOpt1">
                                <input type="radio" name="payMethod" value="card" checked onchange="setPayActive('payOpt1')" /> Credit / Debit card
                            </label>
                            <label class="payment-option" id="payOpt2">
                                <input type="radio" name="payMethod" value="banking" onchange="setPayActive('payOpt2')" /> Online banking
                            </label>
                            <button type="button" class="btn-confirm" id="btnConfirmPay" onclick="confirmBooking()">Confirm &amp; pay</button>
                        </div>

                    </div>
                </div>

                <% } %>

            </div>
        </div>
    </div>

</asp:Content>

<asp:Content ID="ScriptContent" ContentPlaceHolderID="ScriptContent" runat="server">
    <script>
        var buddies = <%= BuddiesJson %>;
        var selectedBuddyId = null;
        var selectedBuddy = null;
        var selectedSlot = null;

        (function() {
            var banners = document.querySelectorAll('.msg-success, .msg-error');
            banners.forEach(function(b) {
                if (b.style.display !== 'none' && b.textContent.trim() !== '') {
                    setTimeout(function() {
                        b.style.transition = 'opacity 0.4s';
                        b.style.opacity = '0';
                        setTimeout(function() { b.style.display = 'none'; }, 400);
                    }, 3000);
                }
            });
        })();

        function toggleSidebar() {
            var sidebar = document.getElementById('sidebar');
            var toggle = document.getElementById('sidebarToggle');
            sidebar.classList.toggle('collapsed');
            toggle.classList.toggle('collapsed');
            toggle.textContent = sidebar.classList.contains('collapsed') ? '>' : '<';
        }

        function selectBuddy(id) {
            document.querySelectorAll('.buddy-card').forEach(function (c) { c.classList.remove('selected'); });
            document.querySelectorAll('.buddy-selected-badge').forEach(function (b) { b.style.display = 'none'; });

            document.getElementById('buddy-' + id).classList.add('selected');
            document.getElementById('badge-' + id).style.display = '';

            selectedBuddyId = id;
            selectedBuddy = null;
            for (var i = 0; i < buddies.length; i++) {
                if (buddies[i].UserID === id) { selectedBuddy = buddies[i]; break; }
            }

            selectedSlot = null;
            document.getElementById('bookingSummaryCard').style.display = 'none';
            renderTimeSlots();
        }

        function renderTimeSlots() {
            var sub = document.getElementById('timePickerSub');
            var grid = document.getElementById('timeGrid');

            sub.textContent = selectedBuddy.Name;
            grid.innerHTML = '';

            if (!selectedBuddy.Slots || selectedBuddy.Slots.length === 0) {
                grid.innerHTML = '<div class="placeholder-panel"><div>No available slots</div></div>';
                return;
            }

            selectedBuddy.Slots.forEach(function (slot) {
                var btn = document.createElement('button');
                btn.type = 'button';
                btn.className = 'slot-btn';
                btn.innerHTML = slot.Time + '<br><small style="font-weight:400;font-size:0.75em;opacity:0.7">' + slot.Date + '</small>';
                btn.onclick = (function (s, b) {
                    return function () { selectSlot(s, b); };
                })(slot, btn);
                grid.appendChild(btn);
            });
        }

        function selectSlot(slot, btn) {
            document.querySelectorAll('.slot-btn').forEach(function (b) { b.classList.remove('selected'); });
            btn.classList.add('selected');

            selectedSlot = slot;

            document.getElementById('sumBuddy').textContent = selectedBuddy.Name;
            document.getElementById('sumDate').textContent = slot.Date;
            document.getElementById('sumTime').textContent = slot.Time;
            document.getElementById('sumDuration').textContent = slot.Duration + ' min';

            var total = selectedBuddy.HourlyRate * slot.Duration / 60;
            document.getElementById('sumTotal').textContent = 'RM ' + total.toFixed(2);

            document.getElementById('bookingSummaryCard').style.display = '';
        }

        function setPayActive(activeId) {
            document.getElementById('payOpt1').classList.remove('active');
            document.getElementById('payOpt2').classList.remove('active');
            document.getElementById(activeId).classList.add('active');
        }

        function confirmBooking() {
            if (!selectedSlot) { alert('Please select a time slot first.'); return; }
            if (!confirm('Book a session with ' + selectedBuddy.Name + ' on ' + selectedSlot.Date + ' at ' + selectedSlot.Time + '?')) return;
            document.getElementById('<%= hfBookAvailId.ClientID %>').value = selectedSlot.AvailabilityID;
            document.getElementById('<%= btnBookConfirm.ClientID %>').click();
        }
    </script>
</asp:Content>
