<%@ Page Title="Manage Availability" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="ManageAvailability.aspx.cs" Inherits="IndoSlang.ManageAvailability" %>

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

        .form-card { background: #fff; border: 1.5px solid var(--cream-mid); border-radius: 14px; padding: 24px; margin-bottom: 28px; }
        .form-card h3 { font-family: var(--font-display); font-size: 1.05rem; color: var(--brown); margin: 0 0 20px; }
        .form-row { display: grid; grid-template-columns: 1fr 1fr 1fr; gap: 16px; margin-bottom: 16px; }
        .form-group { display: flex; flex-direction: column; gap: 6px; }
        .form-group label { font-size: 0.82rem; color: var(--brown-mid); font-weight: 700; }
        .form-input { padding: 10px 14px; border: 1.5px solid var(--cream-mid); border-radius: 10px; font-family: var(--font-body); font-size: 0.92rem; color: var(--brown); background: var(--cream); outline: none; transition: border-color 0.2s; width: 100%; box-sizing: border-box; }
        .form-input:focus { border-color: var(--accent); }
        .form-select { padding: 10px 14px; border: 1.5px solid var(--cream-mid); border-radius: 10px; font-family: var(--font-body); font-size: 0.92rem; color: var(--brown); background: var(--cream); outline: none; width: 100%; }

        .repeat-row { display: flex; gap: 10px; margin-bottom: 20px; align-items: center; }
        .repeat-label { font-size: 0.82rem; color: var(--brown-mid); font-weight: 700; }
        .repeat-btn { padding: 8px 20px; border: 1.5px solid var(--cream-mid); border-radius: 999px; background: #fff; color: var(--brown); font-size: 0.88rem; cursor: pointer; transition: background 0.15s, border-color 0.15s; }
        .repeat-btn.active { background: var(--brown); color: #fff; border-color: var(--brown); }

        .btn-add { padding: 10px 28px; background: var(--brown); color: #fff; border: none; border-radius: 10px; font-family: var(--font-display); font-size: 0.95rem; cursor: pointer; transition: background 0.2s; }
        .btn-add:hover { background: var(--brown-mid); }

        .msg-success { position: fixed; top: 0; left: 0; right: 0; z-index: 99999; background: #d4edda; color: #1a5c2a; padding: 10px 20px; font-size: 0.88rem; text-align: center; display: none; border-bottom: 1px solid #a5d6a7; }
        .msg-error { position: fixed; top: 0; left: 0; right: 0; z-index: 99999; background: #fde8e8; color: #7b1515; padding: 10px 20px; font-size: 0.88rem; text-align: center; display: none; border-bottom: 1px solid #ef9a9a; }

        .slots-table { width: 100%; border-collapse: collapse; }
        .slots-table th { text-align: left; font-size: 0.8rem; color: var(--brown-mid); font-weight: 700; padding: 8px 12px; border-bottom: 1.5px solid var(--cream-mid); }
        .slots-table td { padding: 12px; border-bottom: 1px solid var(--cream-mid); font-size: 0.9rem; color: var(--brown); vertical-align: middle; }
        .slots-table tr:last-child td { border-bottom: none; }

        .status-badge { display: inline-block; padding: 3px 12px; border-radius: 999px; font-size: 0.78rem; font-weight: 700; }
        .status-open { background: #d4edda; color: #1a5c2a; }
        .status-booked { background: var(--cream-mid); color: var(--brown-mid); }

        .btn-edit { padding: 5px 14px; border: 1.5px solid var(--brown-mid); border-radius: 8px; background: #fff; color: var(--brown); font-size: 0.82rem; cursor: pointer; margin-right: 6px; transition: background 0.15s; }
        .btn-edit:hover { background: var(--cream-mid); }
        .btn-delete { padding: 5px 14px; border: 1.5px solid #c0392b; border-radius: 8px; background: #fff; color: #c0392b; font-size: 0.82rem; cursor: pointer; transition: background 0.15s; }
        .btn-delete:hover { background: #fde8e8; }
        .btn-save-edit { padding: 5px 14px; border: none; border-radius: 8px; background: var(--brown); color: #fff; font-size: 0.82rem; cursor: pointer; margin-right: 6px; }
        .btn-cancel-edit { padding: 5px 14px; border: 1.5px solid var(--brown-mid); border-radius: 8px; background: #fff; color: var(--brown); font-size: 0.82rem; cursor: pointer; }

        .edit-row { background: var(--cream); }
        .edit-input { padding: 6px 10px; border: 1.5px solid var(--cream-mid); border-radius: 8px; font-size: 0.88rem; color: var(--brown); background: #fff; }

        .empty-slots { text-align: center; padding: 32px; color: var(--brown-mid); font-size: 0.9rem; font-style: italic; }
        .hidden-control { display: none; }
    </style>
</asp:Content>

<asp:Content ID="MainContent" ContentPlaceHolderID="MainContent" runat="server">

    <asp:HiddenField ID="hfDeleteId" runat="server" />
    <asp:HiddenField ID="hfEditId" runat="server" />
    <asp:HiddenField ID="hfRepeat" runat="server" Value="none" />
    <asp:Button ID="btnDeleteConfirm" runat="server" Text="Delete" CssClass="hidden-control" OnClick="btnDeleteConfirm_Click" />
    <asp:Button ID="btnEditConfirm" runat="server" Text="EditConfirm" CssClass="hidden-control" OnClick="btnEditConfirm_Click" />
    <asp:Label ID="lblSuccess" runat="server" CssClass="msg-success" />
    <asp:Label ID="lblError" runat="server" CssClass="msg-error" />

    <button type="button" class="sidebar-toggle" onclick="toggleSidebar()" id="sidebarToggle">&lt;</button>

    <div class="dashboard-layout">
        <aside class="sidebar" id="sidebar">
            <a href="HomePage.aspx" class="sidebar-logo">
                <img src="Images/OWI SPARKLE EYE BIG.png" alt="IndoSlang" />
                IndoSlang
            </a>
            <nav class="sidebar-nav">
                <a href="BuddyDashboard.aspx" class="nav-link"><span class="nav-icon">&#x1F3E0;</span> Dashboard</a>
                <a href="Modules.aspx" class="nav-link"><span class="nav-icon">&#x1F4DA;</span> My Modules</a>
                <a href="SlangDictionary.aspx" class="nav-link"><span class="nav-icon">&#x1F4D6;</span> Dictionary</a>
                <a href="CommunityChat.aspx" class="nav-link"><span class="nav-icon">&#x1F4AC;</span> Community Chat</a>
                <a href="HostSession.aspx" class="nav-link"><span class="nav-icon">&#x1F3A4;</span> Host Session</a>
                <a href="ManageAvailability.aspx" class="nav-link active"><span class="nav-icon">&#x1F4C5;</span> Manage Availability</a>
                <a href="SessionHistory.aspx" class="nav-link"><span class="nav-icon">&#x1F550;</span> Session History</a>
                <a href="SuggestSlang.aspx" class="nav-link"><span class="nav-icon">&#x2728;</span> Suggest Slang</a>
                <hr class="sidebar-divider" />
                <a href="BuddyProfile.aspx" class="nav-link"><span class="nav-icon">&#x1F464;</span> My Profile</a>
                <a href="WithdrawEarnings.aspx" class="nav-link"><span class="nav-icon">&#x1F4B8;</span> Withdraw Earnings</a>
            </nav>
            <hr class="sidebar-divider" />
            <a href="Logout.aspx" class="nav-link signout"><span class="nav-icon">&#x1F6AA;</span> Sign Out</a>
        </aside>

        <div class="dashboard-main">
            <div class="topbar">
                <div class="topbar-left">
                    <h2>Manage Availability</h2>
                    <p>Set open time slots for members to book</p>
                </div>
                <div class="topbar-user">
                    <div class="topbar-avatar">&#x1F464;</div>
                    <span><%= System.Web.HttpUtility.HtmlEncode(BuddyName) %></span>
                </div>
            </div>

            <div class="dash-content">

                <div class="form-card">
                    <h3>Add new time slot</h3>
                    <div class="form-row">
                        <div class="form-group">
                            <label>Date</label>
                            <asp:TextBox ID="txtDate" runat="server" CssClass="form-input" TextMode="Date" />
                        </div>
                        <div class="form-group">
                            <label>Start time</label>
                            <asp:TextBox ID="txtTime" runat="server" CssClass="form-input" TextMode="Time" />
                        </div>
                        <div class="form-group">
                            <label>Duration</label>
                            <asp:DropDownList ID="ddlDuration" runat="server" CssClass="form-select">
                                <asp:ListItem Value="60">60 min</asp:ListItem>
                                <asp:ListItem Value="90">90 min</asp:ListItem>
                                <asp:ListItem Value="120">120 min</asp:ListItem>
                            </asp:DropDownList>
                        </div>
                    </div>

                    <div class="repeat-row">
                        <span class="repeat-label">Repeat</span>
                        <button type="button" class="repeat-btn active" id="repeatNone" onclick="setRepeat('none')">None</button>
                        <button type="button" class="repeat-btn" id="repeatWeekly" onclick="setRepeat('weekly')">Weekly</button>
                        <button type="button" class="repeat-btn" id="repeatWeekdays" onclick="setRepeat('weekdays')">Weekdays</button>
                    </div>

                    <asp:Button ID="btnAddSlot" runat="server" Text="Add slot" CssClass="btn-add" OnClick="btnAddSlot_Click" />
                </div>

                <p class="section-title">My upcoming slots</p>

                <% if (Slots.Count == 0) { %>
                <div class="empty-slots">No upcoming slots yet. Add one above!</div>
                <% } else { %>
                <table class="slots-table">
                    <thead>
                        <tr>
                            <th>Date</th>
                            <th>Time</th>
                            <th>Duration</th>
                            <th>Status</th>
                            <th>Action</th>
                        </tr>
                    </thead>
                    <tbody>
                        <% foreach (var slot in Slots) { %>

                        <tr id="row-<%= slot.AvailabilityID %>">
                            <td><%= slot.DateDisplay %></td>
                            <td><%= slot.TimeDisplay %></td>
                            <td><%= slot.Duration %> min</td>
                            <td>
                                <span class="status-badge <%= slot.IsBooked ? "status-booked" : "status-open" %>">
                                    <%= slot.IsBooked ? "Booked" : "Open" %>
                                </span>
                            </td>
                            <td>
                                <% if (!slot.IsBooked) { %>
                                <button type="button" class="btn-edit"
                                    onclick="showEditRow(<%= slot.AvailabilityID %>)">Edit</button>
                                <button type="button" class="btn-delete"
                                    onclick="deleteSlot(<%= slot.AvailabilityID %>)">Delete</button>
                                <% } else { %>
                                <span style="color:var(--brown-mid);font-size:0.82rem;">&#8212;</span>
                                <% } %>
                            </td>
                        </tr>

                        <% if (!slot.IsBooked) { %>
                        <tr id="editrow-<%= slot.AvailabilityID %>" class="edit-row" style="display:none;">
                            <td>
                                <input type="date" class="edit-input"
                                    id="editDate_<%= slot.AvailabilityID %>"
                                    name="editDate_<%= slot.AvailabilityID %>"
                                    value="<%= slot.DateValue %>" />
                            </td>
                            <td>
                                <input type="time" class="edit-input"
                                    id="editTime_<%= slot.AvailabilityID %>"
                                    name="editTime_<%= slot.AvailabilityID %>"
                                    value="<%= slot.TimeValue %>" />
                            </td>
                            <td>
                                <select class="edit-input"
                                    id="editDur_<%= slot.AvailabilityID %>"
                                    name="editDur_<%= slot.AvailabilityID %>">
                                    <option value="60" <%= slot.Duration == 60 ? "selected" : "" %>>60 min</option>
                                    <option value="90" <%= slot.Duration == 90 ? "selected" : "" %>>90 min</option>
                                    <option value="120" <%= slot.Duration == 120 ? "selected" : "" %>>120 min</option>
                                </select>
                            </td>
                            <td></td>
                            <td>
                                <button type="button" class="btn-save-edit"
                                    onclick="saveEdit(<%= slot.AvailabilityID %>)">Save</button>
                                <button type="button" class="btn-cancel-edit"
                                    onclick="cancelEdit(<%= slot.AvailabilityID %>)">Cancel</button>
                            </td>
                        </tr>
                        <% } %>

                        <% } %>
                    </tbody>
                </table>
                <% } %>

            </div>
        </div>
    </div>
</asp:Content>

<asp:Content ID="ScriptContent" ContentPlaceHolderID="ScriptContent" runat="server">
    <script>
        // Auto-dismiss success/error banner after 3 seconds
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

        function setRepeat(val) {
            document.getElementById('repeatNone').classList.remove('active');
            document.getElementById('repeatWeekly').classList.remove('active');
            document.getElementById('repeatWeekdays').classList.remove('active');
            document.getElementById('repeat' + val.charAt(0).toUpperCase() + val.slice(1)).classList.add('active');
            document.getElementById('<%= hfRepeat.ClientID %>').value = val;
        }

        function deleteSlot(id) {
            if (!confirm('Delete this time slot?')) return;
            document.getElementById('<%= hfDeleteId.ClientID %>').value = id;
            document.getElementById('<%= btnDeleteConfirm.ClientID %>').click();
        }

        function showEditRow(id) {
            document.getElementById('row-' + id).style.display = 'none';
            document.getElementById('editrow-' + id).style.display = '';
        }

        function cancelEdit(id) {
            document.getElementById('editrow-' + id).style.display = 'none';
            document.getElementById('row-' + id).style.display = '';
        }

        function saveEdit(id) {
            document.getElementById('<%= hfEditId.ClientID %>').value = id;
            document.getElementById('<%= btnEditConfirm.ClientID %>').click();
        }
    </script>
</asp:Content>
