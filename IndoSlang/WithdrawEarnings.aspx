<%@ Page Title="Withdraw Earnings" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="WithdrawEarnings.aspx.cs" Inherits="IndoSlang.WithdrawEarnings" %>

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

    /* stat cards */
    .stats-row{display:grid;grid-template-columns:repeat(3,1fr);gap:18px;margin-bottom:32px}
    .stat-card{background:#fff;border:2px solid var(--cream-mid);border-radius:18px;padding:22px 24px;box-shadow:0 4px 16px rgba(59,42,26,.07)}
    .stat-label{font-size:.79rem;font-weight:700;color:var(--brown-mid);text-transform:uppercase;letter-spacing:.5px;margin-bottom:8px}
    .stat-value{font-family:var(--font-display);font-size:1.9rem;font-weight:700;color:var(--brown);line-height:1}
    .stat-sub{font-size:.8rem;color:var(--brown-mid);margin-top:6px}

    /* form card */
    .form-card{background:#fff;border:2px solid var(--cream-mid);border-radius:18px;padding:30px 34px;box-shadow:0 4px 16px rgba(59,42,26,.07);max-width:600px;margin-bottom:28px}
    .form-card-title{font-family:var(--font-display);font-size:1.15rem;font-weight:700;color:var(--brown);margin-bottom:22px}
    .form-group{margin-bottom:18px}
    .form-label{display:block;font-size:.85rem;font-weight:700;color:var(--brown);margin-bottom:6px}
    .form-input{width:100%;background:#fff;border:2px solid var(--cream-mid);border-radius:12px;padding:11px 16px;font-family:var(--font-body);font-size:.92rem;color:var(--brown);outline:none;transition:border-color .2s;box-sizing:border-box}
    .form-input:focus{border-color:var(--accent)}
    textarea.form-input{resize:vertical;min-height:80px}
    .method-grid{display:grid;grid-template-columns:repeat(3,1fr);gap:10px;margin-bottom:6px}
    .method-btn{background:#fff;border:2px solid var(--cream-mid);border-radius:12px;padding:14px 10px;font-family:var(--font-body);font-size:.88rem;font-weight:700;color:var(--brown-mid);cursor:pointer;text-align:center;transition:all .15s}
    .method-btn:hover{border-color:var(--brown-mid);color:var(--brown)}
    .method-btn.selected{background:var(--brown);border-color:var(--brown);color:#fff}
    .method-icon{font-size:1.4rem;display:block;margin-bottom:4px}
    .btn-submit{background:var(--brown);color:#fff;border:none;border-radius:12px;padding:13px 32px;font-family:var(--font-display);font-size:1rem;font-weight:700;cursor:pointer;transition:background .2s;width:100%}
    .btn-submit:hover{background:var(--accent)}

    /* notice */
    .notice-card{background:#fff3e0;border:2px solid #ffcc80;border-radius:14px;padding:16px 20px;max-width:600px;margin-bottom:28px;font-size:.88rem;color:#e65100;line-height:1.6}

    /* history table */
    .section-title{font-family:var(--font-display);font-size:1.1rem;font-weight:700;color:var(--brown);margin-bottom:14px}
    .table-card{background:#fff;border:2px solid var(--cream-mid);border-radius:18px;overflow:hidden;box-shadow:0 4px 16px rgba(59,42,26,.07);max-width:760px;margin-bottom:20px}
    .hist-table{width:100%;border-collapse:collapse}
    .hist-table th{background:var(--cream-mid);color:var(--brown);font-size:.8rem;font-weight:700;text-transform:uppercase;letter-spacing:.4px;padding:12px 18px;text-align:left;border-bottom:2px solid var(--cream-mid)}
    .hist-table td{padding:13px 18px;font-size:.9rem;color:var(--brown);border-bottom:1px solid var(--cream-mid);vertical-align:middle}
    .hist-table tr:last-child td{border-bottom:none}
    .status-pill{border-radius:999px;padding:4px 12px;font-size:.78rem;font-weight:700;white-space:nowrap}
    .status-pill.pending{background:var(--cream-mid);color:var(--brown);border:1.5px solid var(--brown-mid)}
    .status-pill.approved{background:#e8f5e9;color:#2e7d32;border:1.5px solid #a5d6a7}
    .status-pill.rejected{background:#fdecea;color:#c62828;border:1.5px solid #ef9a9a}

    /* alert */
    .alert{padding:13px 18px;border-radius:12px;margin-bottom:20px;font-size:.9rem;font-weight:700;max-width:600px}
    .alert.success{background:#e8f5e9;color:#2e7d32;border:1.5px solid #a5d6a7}
    .alert.error{background:#fdecea;color:#c62828;border:1.5px solid #ef9a9a}

    /* empty */
    .empty-row td{text-align:center;padding:40px;color:var(--brown-mid);font-size:.9rem}
</style>
</asp:Content>

<asp:Content ID="MainContent" ContentPlaceHolderID="MainContent" runat="server">

    <asp:HiddenField ID="hdnPaymentMethod" runat="server" />

    <button type="button" class="sidebar-toggle" onclick="toggleSidebar()" id="sidebarToggle">&lt;</button>

    <div class="dashboard-layout">
        <aside class="sidebar" id="sidebar">
            <a href="HomePage.aspx" class="sidebar-logo">
                <img src="Images/OWI SPARKLE EYE BIG.png" alt="IndoSlang" />
                IndoSlang
            </a>
            <nav class="sidebar-nav">
                <a href="BuddyDashboard.aspx"     class="nav-link"><span class="nav-icon">&#x1F3E0;</span> Dashboard</a>
                <a href="Modules.aspx"             class="nav-link"><span class="nav-icon">&#x1F4DA;</span> My Modules</a>
                <a href="SlangDictionary.aspx"     class="nav-link"><span class="nav-icon">&#x1F4D6;</span> Dictionary</a>
                <a href="CommunityChat.aspx"       class="nav-link"><span class="nav-icon">&#x1F4AC;</span> Community Chat</a>
                <a href="HostSession.aspx"         class="nav-link"><span class="nav-icon">&#x1F3A4;</span> Host Session</a>
                <a href="ManageAvailability.aspx"  class="nav-link"><span class="nav-icon">&#x1F4C5;</span> Manage Availability</a>
                <a href="SessionHistory.aspx"      class="nav-link"><span class="nav-icon">&#x1F550;</span> Session History</a>
                <a href="SuggestSlang.aspx"        class="nav-link"><span class="nav-icon">&#x2728;</span> Suggest Slang</a>
                <hr class="sidebar-divider" />
                <a href="BuddyProfile.aspx"        class="nav-link"><span class="nav-icon">&#x1F464;</span> My Profile</a>
                <a href="WithdrawEarnings.aspx"    class="nav-link active"><span class="nav-icon">&#x1F4B8;</span> Withdraw Earnings</a>
            </nav>
            <hr class="sidebar-divider" />
            <a href="Logout.aspx" class="nav-link signout"><span class="nav-icon">&#x1F6AA;</span> Sign Out</a>
        </aside>

        <div class="dashboard-main">
            <div class="topbar">
                <div class="topbar-left">
                    <span class="topbar-title">Withdraw earnings</span>
                    <span class="topbar-sub">Request a payout to your account</span>
                </div>
                <div class="topbar-user">
                    <div class="topbar-avatar">&#x1F464;</div>
                    <span id="topbarName">Buddy</span>
                </div>
            </div>

            <div class="module-content">

                <% if (!string.IsNullOrEmpty(AlertMessage)) { %>
                <div class="alert <%= AlertSuccess ? "success" : "error" %>"><%: AlertMessage %></div>
                <% } %>

                <div class="stats-row">
                    <div class="stat-card">
                        <div class="stat-label">Available balance</div>
                        <div class="stat-value">RM <%: AvailableBalance.ToString("N2") %></div>
                        <div class="stat-sub">Ready to withdraw</div>
                    </div>
                    <div class="stat-card">
                        <div class="stat-label">Total earned</div>
                        <div class="stat-value">RM <%: TotalEarned.ToString("N2") %></div>
                        <div class="stat-sub">All time</div>
                    </div>
                    <div class="stat-card">
                        <div class="stat-label">Last withdrawal</div>
                        <div class="stat-value" style="font-size:1.2rem"><%: LastWithdrawalDate %></div>
                        <div class="stat-sub">Most recent payout</div>
                    </div>
                </div>

                <div class="notice-card">
                    &#x26A0; Withdrawals are processed within 1&#x2013;3 business days. Minimum withdrawal is RM 10.00.
                    The platform retains 5% of session earnings; the balance shown is your 95% share.
                </div>

                <div class="form-card">
                    <div class="form-card-title">New withdrawal request</div>

                    <div class="form-group">
                        <label class="form-label">Payment method</label>
                        <div class="method-grid">
                            <button type="button" class="method-btn" onclick="selectMethod('Bank Transfer', this)">
                                <span class="method-icon">&#x1F3E6;</span>Bank Transfer
                            </button>
                            <button type="button" class="method-btn" onclick="selectMethod('Touch \'n Go', this)">
                                <span class="method-icon">&#x1F4F1;</span>Touch 'n Go
                            </button>
                            <button type="button" class="method-btn" onclick="selectMethod('PayPal', this)">
                                <span class="method-icon">&#x1F4B3;</span>PayPal
                            </button>
                        </div>
                    </div>

                    <div class="form-group">
                        <label class="form-label" for="<%= txtAmount.ClientID %>">Amount (RM)</label>
                        <asp:TextBox ID="txtAmount" runat="server" CssClass="form-input"
                            placeholder="e.g. 50.00" />
                    </div>

                    <div class="form-group">
                        <label class="form-label" for="<%= txtNotes.ClientID %>">Notes / account details</label>
                        <asp:TextBox ID="txtNotes" runat="server" CssClass="form-input"
                            TextMode="MultiLine" placeholder="e.g. Bank name, account number, or PayPal email" />
                    </div>

                    <asp:Button ID="btnSubmit" runat="server" Text="Submit withdrawal request"
                        CssClass="btn-submit" OnClick="btnSubmit_Click" />
                </div>

                <div class="section-title">Withdrawal history</div>
                <div class="table-card">
                    <table class="hist-table">
                        <thead>
                            <tr>
                                <th>Date</th>
                                <th>Method</th>
                                <th>Amount</th>
                                <th>Notes</th>
                                <th>Status</th>
                            </tr>
                        </thead>
                        <tbody>
                            <% if (Withdrawals.Count == 0) { %>
                            <tr class="empty-row"><td colspan="5">No withdrawal requests yet</td></tr>
                            <% } %>
                            <% foreach (var w in Withdrawals) { %>
                            <tr>
                                <td><%: w.RequestedAt.ToString("MMM d, yyyy") %></td>
                                <td><%: w.PaymentMethod %></td>
                                <td><strong>RM <%: w.Amount.ToString("N2") %></strong></td>
                                <td><%: w.Notes %></td>
                                <td><span class="status-pill <%: w.StatusClass %>"><%: w.Status %></span></td>
                            </tr>
                            <% } %>
                        </tbody>
                    </table>
                </div>

            </div>
        </div>
    </div>
</asp:Content>

<asp:Content ID="ScriptContent" ContentPlaceHolderID="ScriptContent" runat="server">
<script>
    var _userName = '<%= UserDisplayName %>';
    document.getElementById('topbarName').textContent = _userName || 'Buddy';

    function toggleSidebar() {
        var sb = document.getElementById('sidebar'), tg = document.getElementById('sidebarToggle');
        sb.classList.toggle('collapsed'); tg.classList.toggle('collapsed');
        tg.textContent = sb.classList.contains('collapsed') ? '›' : '‹';
    }

    function selectMethod(method, el) {
        document.querySelectorAll('.method-btn').forEach(function(b) { b.classList.remove('selected'); });
        el.classList.add('selected');
        document.getElementById('<%= hdnPaymentMethod.ClientID %>').value = method;
    }
</script>
</asp:Content>
