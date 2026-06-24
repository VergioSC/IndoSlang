<%@ Page Title="Apply as Buddy" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="ApplyBuddy.aspx.cs" Inherits="IndoSlang.ApplyBuddy" %>

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

    /* main */
    .dashboard-main{flex:1;display:flex;flex-direction:column;height:100vh;overflow:hidden;min-width:0}
    .topbar{background:#fff;border-bottom:2px solid var(--cream-mid);padding:18px 32px;display:flex;align-items:center;justify-content:space-between;flex-shrink:0}
    .topbar h2{font-family:var(--font-display);font-size:1.5rem;color:var(--brown);margin:0}
    .topbar-user{display:flex;align-items:center;gap:9px;color:var(--brown);font-weight:700;font-size:.9rem}
    .topbar-avatar{width:36px;height:36px;border-radius:50%;background:var(--brown-mid);display:flex;align-items:center;justify-content:center;color:#fff;font-size:1.1rem}

    .page-content{flex:1;overflow-y:auto;padding:32px 36px;background:var(--cream)}
    .apply-layout{display:grid;grid-template-columns:1fr 300px;gap:24px;max-width:960px;margin:0 auto}

    /* message */
    .msg-box{border-radius:12px;padding:12px 16px;font-size:.88rem;font-weight:600;margin-bottom:18px;display:none}
    .msg-box.visible{display:block}
    .msg-box.error{background:#fde8e8;color:#7b1515;border:1.5px solid #f5c6c6}
    .msg-box.success{background:#d4edda;color:#1a5c2a;border:1.5px solid #b8dfc4}

    /* req card */
    .req-card{background:#fff;border:1.5px solid var(--cream-mid);border-radius:16px;padding:22px 24px;margin-bottom:20px}
    .req-card h3{font-family:var(--font-display);font-size:.95rem;color:var(--brown);margin:0 0 12px;text-transform:uppercase;letter-spacing:.04em}
    .req-list{list-style:none;margin:0;padding:0;display:flex;flex-direction:column;gap:8px}
    .req-list li{display:flex;align-items:center;gap:10px;font-size:.87rem;color:var(--brown-mid)}
    .req-list li::before{content:'✓';font-weight:700;color:var(--accent);flex-shrink:0}

    /* form card */
    .form-card{background:#fff;border:1.5px solid var(--cream-mid);border-radius:16px;padding:28px}
    .form-card h3{font-family:var(--font-display);font-size:1.05rem;color:var(--brown);margin:0 0 22px}
    .form-group{margin-bottom:18px}
    .form-label{display:block;font-size:.8rem;font-weight:700;color:var(--brown);margin-bottom:6px;text-transform:uppercase;letter-spacing:.04em}
    .form-input{width:100%;box-sizing:border-box;padding:10px 14px;border:1.5px solid var(--cream-mid);border-radius:10px;font-family:var(--font-body);font-size:.92rem;color:var(--brown);background:var(--cream);outline:none;transition:border-color .2s,background .2s}
    .form-input:focus{border-color:var(--accent);background:#fff}
    .form-textarea{width:100%;box-sizing:border-box;padding:10px 14px;border:1.5px solid var(--cream-mid);border-radius:10px;font-family:var(--font-body);font-size:.92rem;color:var(--brown);background:var(--cream);outline:none;resize:vertical;min-height:86px;transition:border-color .2s,background .2s}
    .form-textarea:focus{border-color:var(--accent);background:#fff}

    /* proficiency */
    .prof-group{display:flex;gap:8px;flex-wrap:wrap}
    .prof-btn{padding:8px 16px;border:2px solid var(--cream-mid);border-radius:999px;background:#fff;font-family:var(--font-display);font-size:.83rem;color:var(--brown-mid);cursor:pointer;transition:all .15s}
    .prof-btn.active{background:var(--brown);color:#fff;border-color:var(--brown)}
    .prof-btn:hover:not(.active){border-color:var(--brown);color:var(--brown)}

    .rate-note{font-size:.76rem;color:var(--brown-mid);margin-top:5px;font-style:italic}

    .btn-submit{width:100%;background:var(--accent);color:#fff;border:none;padding:13px;border-radius:12px;font-family:var(--font-display);font-size:1rem;font-weight:700;cursor:pointer;transition:background .2s,transform .15s}
    .btn-submit:hover{background:var(--accent-light);transform:translateY(-1px)}

    /* pending card */
    .pending-card{background:#fff8e1;border:1.5px solid #ffe082;border-radius:16px;padding:32px 24px;text-align:center}
    .pending-icon{font-size:2.8rem;margin-bottom:14px}
    .pending-card h3{font-family:var(--font-display);font-size:1.1rem;color:var(--brown);margin:0 0 10px}
    .pending-card p{font-size:.87rem;color:var(--brown-mid);margin:0;line-height:1.65}

    /* status card */
    .status-card{background:#fff;border:1.5px solid var(--cream-mid);border-radius:16px;padding:24px;position:sticky;top:0}
    .status-card h3{font-family:var(--font-display);font-size:.95rem;color:var(--brown);margin:0 0 16px;text-transform:uppercase;letter-spacing:.04em}
    .status-row{display:flex;align-items:center;justify-content:space-between;padding:10px 0;border-bottom:1px solid var(--cream-mid);margin-bottom:14px}
    .status-label{font-size:.82rem;font-weight:700;color:var(--brown-mid)}
    .status-pill{display:inline-block;padding:4px 14px;border-radius:999px;font-size:.78rem;font-weight:700}
    .status-not-submitted{background:var(--cream-mid);color:var(--brown-mid)}
    .status-pending{background:#fff3cd;color:#856404}
    .status-approved{background:#d4edda;color:#1a5c2a}
    .status-rejected{background:#fde8e8;color:#7b1515}
    .status-desc{font-size:.83rem;color:var(--brown-mid);line-height:1.65;margin:0}

    @media(max-width:820px){.apply-layout{grid-template-columns:1fr}.status-card{position:static}}
</style>
</asp:Content>

<asp:Content ID="MainContent" ContentPlaceHolderID="MainContent" runat="server">

    <asp:HiddenField ID="hfProficiency" runat="server" Value="Native speaker" />

    <button type="button" class="sidebar-toggle" onclick="toggleSidebar()" id="sidebarToggle">&#8249;</button>

    <div class="dashboard-layout">
        <aside class="sidebar" id="sidebar">
            <a href="HomePage.aspx" class="sidebar-logo">
                <img src="Images/OWI SPARKLE EYE BIG.png" alt="IndoSlang" />
                IndoSlang
            </a>
            <nav class="sidebar-nav">
                <a href="MemberDashboard.aspx" class="nav-link"><span class="nav-icon">&#x1F3E0;</span> Dashboard</a>
                <a href="Modules.aspx"          class="nav-link"><span class="nav-icon">&#x1F4DA;</span> My Modules</a>
                <a href="SlangDictionary.aspx"  class="nav-link"><span class="nav-icon">&#x1F4D6;</span> Dictionary</a>
                <a href="CommunityChat.aspx"    class="nav-link"><span class="nav-icon">&#x1F4AC;</span> Community Chat</a>
                <a href="BookSession.aspx"      class="nav-link"><span class="nav-icon">&#x1F91D;</span> Book a Buddy</a>
                <a href="SessionHistory.aspx"   class="nav-link"><span class="nav-icon">&#x1F550;</span> Session History</a>
                <a href="SuggestSlang.aspx"     class="nav-link"><span class="nav-icon">&#x2728;</span> Suggest Slang</a>
                <hr class="sidebar-divider" />
                <a href="MemberProfile.aspx"   class="nav-link"><span class="nav-icon">&#x1F464;</span> My Profile</a>
                <a href="ApplyBuddy.aspx"       class="nav-link active"><span class="nav-icon">&#x1F64B;</span> Apply as Buddy</a>
            </nav>
            <hr class="sidebar-divider" />
            <a href="Logout.aspx" class="nav-link signout"><span class="nav-icon">&#x1F6AA;</span> Sign Out</a>
        </aside>

        <div class="dashboard-main">
            <div class="topbar">
                <h2>Apply as a Buddy</h2>
                <div class="topbar-user">
                    <div class="topbar-avatar">&#x1F464;</div>
                    <span><%= System.Web.HttpUtility.HtmlEncode(Session["UserName"] != null ? Session["UserName"].ToString() : "Member") %></span>
                </div>
            </div>

            <div class="page-content">
                <div class="apply-layout">

                    <div>
                        <asp:Panel ID="pnlForm" runat="server">

                            <div class="req-card">
                                <h3>Requirements</h3>
                                <ul class="req-list">
                                    <li>Native or near-native Indonesian speaker</li>
                                    <li>Working camera &amp; mic for video sessions</li>
                                    <li>Earn 95% of every session fee you set</li>
                                </ul>
                            </div>

                            <!-- message rendered here, above form card -->
                            <div class="msg-box error" id="msgBox">
                                <asp:Literal ID="litMsg" runat="server" />
                            </div>

                            <div class="form-card">
                                <h3>Application form</h3>

                                <div class="form-group">
                                    <label class="form-label">Full name</label>
                                    <asp:TextBox ID="txtFullName" runat="server" CssClass="form-input" placeholder="Your full name" />
                                </div>

                                <div class="form-group">
                                    <label class="form-label">City / region (Indonesia)</label>
                                    <asp:TextBox ID="txtCity" runat="server" CssClass="form-input" placeholder="e.g. Jakarta, Bandung" />
                                </div>

                                <div class="form-group">
                                    <label class="form-label">Indonesian proficiency</label>
                                    <div class="prof-group">
                                        <button type="button" class="prof-btn active" onclick="selectProf(this,'Native speaker')">Native speaker</button>
                                        <button type="button" class="prof-btn" onclick="selectProf(this,'Near-native')">Near-native</button>
                                        <button type="button" class="prof-btn" onclick="selectProf(this,'Fluent')">Fluent</button>
                                    </div>
                                </div>

                                <div class="form-group">
                                    <label class="form-label">Topics you can teach</label>
                                    <asp:TextBox ID="txtTopics" runat="server" TextMode="MultiLine" CssClass="form-textarea"
                                        placeholder="e.g. Gen Z slang, social media language, everyday conversation..." />
                                </div>

                                <div class="form-group">
                                    <label class="form-label">Why do you want to be a buddy?</label>
                                    <asp:TextBox ID="txtReason" runat="server" TextMode="MultiLine" CssClass="form-textarea"
                                        placeholder="Tell us about yourself and your motivation..." />
                                </div>

                                <div class="form-group">
                                    <label class="form-label">Session rate (RM per 60 min)</label>
                                    <asp:TextBox ID="txtRate" runat="server" CssClass="form-input" placeholder="e.g. 25" 
                                        oninput="this.value=this.value.replace(/[^0-9.]/g,'').replace(/(\..*)\./g,'$1')" 
                                        inputmode="decimal" />
                                    <p class="rate-note">Platform takes 5% — you keep 95%</p>
                                </div>

                                <asp:Button ID="btnApply" runat="server" Text="Submit application"
                                    CssClass="btn-submit" OnClick="btnApply_Click" />
                            </div>

                        </asp:Panel>

                        <asp:Panel ID="pnlPending" runat="server" Visible="false">
                            <div class="pending-card">
                                <div class="pending-icon">&#x23F3;</div>
                                <h3>Application Under Review</h3>
                                <p><asp:Literal ID="litPendingMsg" runat="server" /></p>
                            </div>
                        </asp:Panel>
                    </div>

                    <div>
                        <div class="status-card">
                            <h3>Application status</h3>
                            <div class="status-row">
                                <span class="status-label">Status</span>
                                <span class="status-pill status-<%= ApplicationStatusClass %>">
                                    <%= System.Web.HttpUtility.HtmlEncode(ApplicationStatus) %>
                                </span>
                            </div>
                            <p class="status-desc">Once submitted, admin reviews within 2–3 days.</p>
                        </div>
                    </div>

                </div>
            </div>
        </div>
    </div>

</asp:Content>

<asp:Content ID="ScriptContent" ContentPlaceHolderID="ScriptContent" runat="server">
<script>
    function toggleSidebar() {
        var sb = document.getElementById('sidebar'), tg = document.getElementById('sidebarToggle');
        sb.classList.toggle('collapsed'); tg.classList.toggle('collapsed');
        tg.textContent = sb.classList.contains('collapsed') ? '\u203A' : '\u2039';
    }

    function selectProf(btn, value) {
        document.querySelectorAll('.prof-btn').forEach(function(b){ b.classList.remove('active'); });
        btn.classList.add('active');
        document.getElementById('<%= hfProficiency.ClientID %>').value = value;
    }

    window.addEventListener('DOMContentLoaded', function () {
        var box = document.getElementById('msgBox');
        if (box && box.innerText.trim() !== '') box.classList.add('visible');
    });
</script>
</asp:Content>
