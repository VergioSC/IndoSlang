<%@ Page Title="My Profile" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="MemberProfile.aspx.cs" Inherits="IndoSlang.MemberProfile" %>

<asp:Content ID="HeadContent" ContentPlaceHolderID="HeadContent" runat="server">
<style>
    .navbar { display: none !important; }
    .site-footer { display: none !important; }
    .site-main { padding: 0 !important; margin: 0 !important; }
    body { margin: 0; padding: 0; overflow: hidden; }

    .dashboard-layout { display: flex; height: 100vh; overflow: hidden; }

    /* Sidebar */
    .sidebar { width: 260px; min-width: 260px; background: var(--brown); color: #fff; display: flex; flex-direction: column; padding: 32px 0 24px; height: 100vh; overflow: hidden; overflow-x: hidden; flex-shrink: 0; transition: width 0.3s ease, min-width 0.3s ease; }
    .sidebar.collapsed { width: 0; min-width: 0; overflow: hidden; }
    .sidebar-logo { display: flex; align-items: center; gap: 10px; padding: 0 24px 32px; font-family: var(--font-display); font-size: 1.3rem; color: #fff; text-decoration: none; white-space: nowrap; }
    .sidebar-logo img { width: 38px; height: 38px; border-radius: 50%; flex-shrink: 0; }
    .sidebar-nav { flex: 1; overflow-y: auto; min-height: 0; }
    .nav-link { display: flex; align-items: center; gap: 10px; padding: 10px 24px; color: rgba(255,255,255,0.75); text-decoration: none; font-size: 0.92rem; border-left: 3px solid transparent; transition: background 0.15s, color 0.15s, border-color 0.15s; white-space: nowrap; }
    .nav-link:hover { background: rgba(255,255,255,0.08); color: #fff; }
    .nav-link.active { background: rgba(255,255,255,0.12); color: #fff; border-left-color: var(--accent); font-weight: 700; }
    .nav-link .nav-icon { font-size: 1rem; width: 20px; text-align: center; flex-shrink: 0; }
    .sidebar-divider { border: none; border-top: 1px solid rgba(255,255,255,0.12); margin: 16px 24px; }
    .nav-link.signout { color: rgba(255,255,255,0.45); }
    .nav-link.signout:hover { color: #ff8a8a; background: rgba(255,100,100,0.08); }

    /* Toggle */
    .sidebar-toggle { position: fixed; left: 244px; top: 50vh; transform: translateY(-50%); width: 28px; height: 28px; background: var(--brown); border: 2px solid rgba(255,255,255,0.25); border-radius: 50%; color: #fff; cursor: pointer; display: flex; align-items: center; justify-content: center; font-size: 0.8rem; z-index: 9999; transition: left 0.3s ease, background 0.2s; }
    .sidebar-toggle:hover { background: var(--brown-mid); }
    .sidebar-toggle.collapsed { left: 0; }

    /* Main */
    .dashboard-main { flex: 1; display: flex; flex-direction: column; height: 100vh; overflow: hidden; min-width: 0; }

    /* Topbar */
    .topbar { background: var(--cream); border-bottom: 2px solid var(--cream-mid); padding: 14px 28px; display: flex; align-items: center; justify-content: space-between; flex-shrink: 0; }
    .topbar-left { display: flex; align-items: center; gap: 14px; }
    .btn-back { display: inline-flex; align-items: center; gap: 6px; background: var(--cream-mid); border: none; border-radius: 8px; padding: 7px 14px; font-family: var(--font-body); font-size: 0.85rem; color: var(--brown); cursor: pointer; text-decoration: none; font-weight: 600; transition: background 0.2s; }
    .btn-back:hover { background: #e8ddd0; }
    .topbar-title { font-family: var(--font-display); font-size: 1.5rem; color: var(--brown); font-weight: 700; }
    .topbar-user { display: flex; align-items: center; gap: 10px; color: var(--brown); font-weight: 700; font-size: 0.92rem; }
    .topbar-avatar { width: 36px; height: 36px; border-radius: 50%; background: var(--brown-mid); display: flex; align-items: center; justify-content: center; color: #fff; font-size: 1.1rem; overflow: hidden; }
    .topbar-avatar img { width: 100%; height: 100%; object-fit: cover; }

    /* Page content */
    .page-content { flex: 1; overflow-y: auto; padding: 36px 48px 60px; background: var(--cream); font-family: var(--font-body); color: var(--brown); }

    /* Section cards */
    .profile-grid { display: grid; grid-template-columns: 300px 1fr; gap: 28px; max-width: 960px; }
    .profile-left { display: flex; flex-direction: column; gap: 24px; }
    .profile-right { display: flex; flex-direction: column; gap: 24px; }
    .section-card { background: #fff; border: 2px solid var(--cream-mid); border-radius: 20px; padding: 28px; box-shadow: 0 4px 16px var(--shadow); }
    .section-title { font-family: var(--font-display); font-size: 1.1rem; color: var(--brown); margin: 0 0 20px; display: flex; align-items: center; gap: 8px; }

    /* Avatar */
    .avatar-wrap { display: flex; flex-direction: column; align-items: center; gap: 14px; }
    .avatar-circle { width: 110px; height: 110px; border-radius: 50%; background: var(--cream-mid); border: 3px solid var(--cream-mid); overflow: hidden; display: flex; align-items: center; justify-content: center; font-size: 2.8rem; color: var(--brown-mid); }
    .avatar-circle img { width: 100%; height: 100%; object-fit: cover; }
    .avatar-name { font-family: var(--font-display); font-size: 1.2rem; color: var(--brown); text-align: center; }
    .avatar-level { display: inline-block; background: var(--accent); color: #fff; font-size: 0.78rem; font-family: var(--font-display); padding: 3px 12px; border-radius: 20px; }
    .btn-upload-wrap { position: relative; }
    .btn-upload { background: var(--cream-mid); color: var(--brown); border: 2px solid var(--brown-mid); padding: 9px 20px; border-radius: 10px; font-family: var(--font-display); font-size: 0.88rem; cursor: pointer; transition: background 0.2s; }
    .btn-upload:hover { background: #e8ddd0; }
    .file-input-hidden { position: absolute; inset: 0; opacity: 0; cursor: pointer; width: 100%; }

    /* Form fields */
    .form-group { margin-bottom: 16px; }
    .form-label { display: block; font-size: 0.82rem; font-weight: 700; color: var(--brown); margin-bottom: 6px; }
    .form-input { width: 100%; padding: 11px 14px; border: 2px solid var(--cream-mid); border-radius: 12px; font-family: var(--font-body); font-size: 0.93rem; color: var(--brown); background: var(--cream); outline: none; transition: border-color 0.2s; box-sizing: border-box; }
    .form-input:focus { border-color: var(--accent); }
    .form-input:disabled { background: var(--cream-mid); color: var(--brown-mid); cursor: not-allowed; }
    .form-input-row { display: grid; grid-template-columns: 1fr 1fr; gap: 14px; }

    /* Buttons */
    .btn-save { background: var(--accent); color: #fff; border: none; padding: 11px 26px; border-radius: 11px; font-family: var(--font-display); font-size: 0.95rem; cursor: pointer; transition: background 0.2s, transform 0.15s; }
    .btn-save:hover { background: var(--accent-light); transform: translateY(-2px); }
    .btn-secondary { background: var(--cream-mid); color: var(--brown); border: 2px solid var(--brown-mid); padding: 10px 22px; border-radius: 11px; font-family: var(--font-display); font-size: 0.95rem; cursor: pointer; transition: background 0.2s; }
    .btn-secondary:hover { background: #e8ddd0; }
    .btn-danger { background: #fde8e8; color: #7b1515; border: 2px solid #e8a0a0; padding: 10px 22px; border-radius: 11px; font-family: var(--font-display); font-size: 0.95rem; cursor: pointer; transition: background 0.2s; }
    .btn-danger:hover { background: #f9d0d0; }
    .btn-row { display: flex; gap: 10px; align-items: center; flex-wrap: wrap; }

    /* Message boxes */
    .msg-box { border-radius: 10px; padding: 10px 16px; font-size: 0.88rem; margin-bottom: 14px; display: none; }
    .msg-box.success { background: #d4edda; color: #1a5c2a; display: block; }
    .msg-box.error { background: #fde8e8; color: #7b1515; display: block; }

    /* OTP section */
    .otp-step { display: none; margin-top: 14px; }
    .otp-step.visible { display: block; }
    .otp-note { font-size: 0.82rem; color: var(--brown-mid); margin-bottom: 10px; }

    /* Danger zone */
    .danger-zone { border: 2px solid #e8a0a0; border-radius: 20px; padding: 24px 28px; background: #fff; }
    .danger-title { font-family: var(--font-display); font-size: 1rem; color: #7b1515; margin: 0 0 8px; }
    .danger-note { font-size: 0.85rem; color: var(--brown-mid); margin: 0 0 16px; }

    .hidden-ctrl { display: none; }
</style>
</asp:Content>

<asp:Content ID="MainContent" ContentPlaceHolderID="MainContent" runat="server">

    <%-- hidden fields --%>
    <asp:HiddenField ID="hfAction" runat="server" Value="" />
    <asp:HiddenField ID="hfNewEmail" runat="server" Value="" />

    <%-- hidden buttons --%>
    <asp:Button ID="btnSaveProfile" runat="server" CssClass="hidden-ctrl" OnClick="btnSaveProfile_Click" />
    <asp:Button ID="btnUploadPhoto" runat="server" CssClass="hidden-ctrl" OnClick="btnUploadPhoto_Click" />
    <asp:Button ID="btnDeletePhoto" runat="server" CssClass="hidden-ctrl" OnClick="btnDeletePhoto_Click" />
    <asp:Button ID="btnSendEmailOtp" runat="server" CssClass="hidden-ctrl" OnClick="btnSendEmailOtp_Click" />
    <asp:Button ID="btnVerifyEmailOtp" runat="server" CssClass="hidden-ctrl" OnClick="btnVerifyEmailOtp_Click" />
    <asp:Button ID="btnChangePassword" runat="server" CssClass="hidden-ctrl" OnClick="btnChangePassword_Click" />
    <asp:Button ID="btnCloseAccount" runat="server" CssClass="hidden-ctrl" OnClick="btnCloseAccount_Click" />
    <asp:FileUpload ID="fuPhoto" runat="server" CssClass="hidden-ctrl" />

    <button type="button" class="sidebar-toggle" onclick="toggleSidebar()" id="sidebarToggle">&lt;</button>

    <div class="dashboard-layout">

        <!-- Sidebar -->
        <aside class="sidebar" id="sidebar">
            <a runat="server" id="lnkLogo" class="sidebar-logo">
                <img src="Images/OWI SPARKLE EYE BIG.png" alt="IndoSlang" />
                IndoSlang
            </a>
            <nav class="sidebar-nav">
                <a runat="server" id="lnkDashboard" class="nav-link"><span class="nav-icon">&#x1F3E0;</span> Dashboard</a>
                <a href="Modules.aspx" class="nav-link"><span class="nav-icon">&#x1F4DA;</span> My Modules</a>
                <a href="SlangDictionary.aspx" class="nav-link"><span class="nav-icon">&#x1F4D6;</span> Dictionary</a>
                <a href="CommunityChat.aspx" class="nav-link"><span class="nav-icon">&#x1F4AC;</span> Community Chat</a>
                <a href="BookSession.aspx" class="nav-link"><span class="nav-icon">&#x1F91D;</span> Book a Buddy</a>
                <a href="SessionHistory.aspx" class="nav-link"><span class="nav-icon">&#x1F550;</span> Session History</a>
                <a href="SuggestSlang.aspx" class="nav-link"><span class="nav-icon">&#x2728;</span> Suggest Slang</a>
                <hr class="sidebar-divider" />
                <a href="MemberProfile.aspx" class="nav-link active"><span class="nav-icon">&#x1F464;</span> My Profile</a>
                <a href="ApplyBuddy.aspx" class="nav-link"><span class="nav-icon">&#x1F64B;</span> Apply as Buddy</a>
            </nav>
            <hr class="sidebar-divider" />
            <a href="Logout.aspx" class="nav-link signout"><span class="nav-icon">&#x1F6AA;</span> Sign Out</a>
        </aside>

        <!-- Main -->
        <div class="dashboard-main">
            <div class="topbar">
                <div class="topbar-left">
                    <a runat="server" id="lnkBackDash" class="btn-back">← Dashboard</a>
                    <span class="topbar-title">My Profile</span>
                </div>
                <div class="topbar-user">
                    <div class="topbar-avatar" id="topbarAvatarWrap">&#x1F464;</div>
                    <span id="topbarName">Member</span>
                </div>
            </div>

            <div class="page-content">
                <div class="profile-grid">

                    <!-- LEFT: avatar + password -->
                    <div class="profile-left">

                        <!-- avatar card -->
                        <div class="section-card">
                            <div class="avatar-wrap">
                                <div class="avatar-circle" id="avatarCircle">
                                    <asp:Image ID="imgAvatar" runat="server" Style="width:100%;height:100%;object-fit:cover;display:none;" />
                                    <span id="avatarInitial">&#x1F464;</span>
                                </div>
                                <div class="avatar-name"><asp:Literal ID="litFullName" runat="server" /></div>
                                <span class="avatar-level"><asp:Literal ID="litLevel" runat="server" /></span>

                                <%-- upload button --%>
                                <div class="btn-upload-wrap">
                                    <button type="button" class="btn-upload">📷 Change Photo</button>
                                    <input type="file" class="file-input-hidden" id="photoPickerInput" accept="image/*" onchange="handlePhotoSelect(this)" />
                                </div>

                                <%-- delete button shown only if photo exists --%>
                                <button type="button" class="btn-danger" id="btnDeletePhotoUI" style="display:none;" onclick="submitAction('deletePhoto')">🗑 Remove Photo</button>

                                <div class="msg-box" id="photoMsg"><asp:Literal ID="litPhotoMsg" runat="server" /></div>
                            </div>
                        </div>

                        <!-- change password card -->
                        <div class="section-card">
                            <div class="section-title">🔒 Change Password</div>
                            <div class="msg-box" id="pwdMsg"><asp:Literal ID="litPwdMsg" runat="server" /></div>
                            <div class="form-group">
                                <label class="form-label">Current Password</label>
                                <asp:TextBox ID="txtOldPassword" runat="server" CssClass="form-input" TextMode="Password" placeholder="Enter current password" />
                            </div>
                            <div class="form-group">
                                <label class="form-label">New Password</label>
                                <asp:TextBox ID="txtNewPassword" runat="server" CssClass="form-input" TextMode="Password" placeholder="Min 8 characters" />
                            </div>
                            <div class="form-group">
                                <label class="form-label">Confirm New Password</label>
                                <asp:TextBox ID="txtConfirmPassword" runat="server" CssClass="form-input" TextMode="Password" placeholder="Repeat new password" />
                            </div>
                            <button type="button" class="btn-save" onclick="submitAction('changePassword')">Update Password</button>
                        </div>

                    </div>

                    <!-- RIGHT: profile info + email + danger zone -->
                    <div class="profile-right">

                        <!-- profile info card -->
                        <div class="section-card">
                            <div class="section-title">👤 Profile Information</div>
                            <div class="msg-box" id="profileMsg"><asp:Literal ID="litProfileMsg" runat="server" /></div>
                            <div class="form-input-row">
                                <div class="form-group">
                                    <label class="form-label">First Name</label>
                                    <asp:TextBox ID="txtFirstName" runat="server" CssClass="form-input" placeholder="First name" />
                                </div>
                                <div class="form-group">
                                    <label class="form-label">Last Name</label>
                                    <asp:TextBox ID="txtLastName" runat="server" CssClass="form-input" placeholder="Last name" />
                                </div>
                            </div>
                            <div class="form-group">
                                <label class="form-label">Username</label>
                                <asp:TextBox ID="txtUsername" runat="server" CssClass="form-input" placeholder="@username" />
                            </div>
                            <div class="form-group">
                                <label class="form-label">Current Level</label>
                                <asp:TextBox ID="txtCurrentLevel" runat="server" CssClass="form-input" Enabled="false" />
                            </div>
                            <div class="btn-row">
                                <button type="button" class="btn-save" onclick="submitAction('saveProfile')">Save Changes</button>
                            </div>
                        </div>

                        <!-- email change card -->
                        <div class="section-card">
                            <div class="section-title">✉️ Email Address</div>
                            <div class="msg-box" id="emailMsg"><asp:Literal ID="litEmailMsg" runat="server" /></div>
                            <div class="form-group">
                                <label class="form-label">Current Email</label>
                                <asp:TextBox ID="txtCurrentEmail" runat="server" CssClass="form-input" Enabled="false" />
                            </div>
                            <div class="form-group">
                                <label class="form-label">New Email Address</label>
                                <asp:TextBox ID="txtNewEmail" runat="server" CssClass="form-input" placeholder="Enter new email" TextMode="Email" />
                            </div>
                            <div class="btn-row">
                                <button type="button" class="btn-save" onclick="submitSendOtp()">Send Verification Code →</button>
                            </div>

                            <!-- OTP step shown after send -->
                            <div class="otp-step" id="otpStep">
                                <p class="otp-note">Enter the 6-digit code sent to your new email.</p>
                                <div class="form-group">
                                    <label class="form-label">Verification Code</label>
                                    <asp:TextBox ID="txtEmailOtp" runat="server" CssClass="form-input" placeholder="6-digit code" MaxLength="6" />
                                </div>
                                <div class="btn-row">
                                    <button type="button" class="btn-save" onclick="submitAction('verifyEmailOtp')">Verify & Update Email</button>
                                    <button type="button" class="btn-secondary" onclick="cancelOtp()">Cancel</button>
                                </div>
                            </div>
                        </div>

                        <!-- danger zone -->
                        <div class="danger-zone">
                            <div class="danger-title">⚠️ Close Account</div>
                            <p class="danger-note">Closing your account is permanent. All your progress and data will be removed.</p>
                            <div class="msg-box" id="closeMsg"><asp:Literal ID="litCloseMsg" runat="server" /></div>
                            <div class="form-group">
                                <label class="form-label">Enter your password to confirm</label>
                                <asp:TextBox ID="txtClosePassword" runat="server" CssClass="form-input" TextMode="Password" placeholder="Your password" />
                            </div>
                            <button type="button" class="btn-danger" onclick="confirmClose()">Close My Account</button>
                        </div>

                    </div>
                </div>
            </div>
        </div>
    </div>
</asp:Content>

<asp:Content ID="ScriptContent" ContentPlaceHolderID="ScriptContent" runat="server">
<script>
    // set topbar name
    document.getElementById('topbarName').textContent = '<%= UserDisplayName %>';

    // sidebar toggle
    function toggleSidebar() {
        var sidebar = document.getElementById('sidebar');
        var toggle = document.getElementById('sidebarToggle');
        sidebar.classList.toggle('collapsed');
        toggle.classList.toggle('collapsed');
        toggle.textContent = sidebar.classList.contains('collapsed') ? '\u203A' : '\u2039';
    }

    // show message boxes on load
    window.onload = function () {
        showMsgIfNeeded('profileMsg');
        showMsgIfNeeded('pwdMsg');
        showMsgIfNeeded('emailMsg');
        showMsgIfNeeded('photoMsg');
        showMsgIfNeeded('closeMsg');

        // restore otp step if was in otp flow
        var action = '<%= hfAction.Value %>';
        if (action === 'otpSent') {
            document.getElementById('otpStep').classList.add('visible');
        }

        // set avatar preview and show delete button if photo exists
        var avatarSrc = '<%= AvatarSrc %>';
        if (avatarSrc && avatarSrc !== '') {
            var img = document.getElementById('<%= imgAvatar.ClientID %>');
            img.src = avatarSrc;
            img.style.display = 'block';
            document.getElementById('avatarInitial').style.display = 'none';
            document.getElementById('btnDeletePhotoUI').style.display = 'inline-block';

            // sync topbar avatar
            var topbarWrap = document.getElementById('topbarAvatarWrap');
            if (topbarWrap) topbarWrap.innerHTML = '<img src="' + avatarSrc + '" style="width:100%;height:100%;object-fit:cover;border-radius:50%;" />';
        }
    };

    function showMsgIfNeeded(id) {
        var el = document.getElementById(id);
        if (el && el.innerText.trim() !== '') el.style.display = 'block';
    }

    // set hidden action and trigger correct button
    function submitAction(action) {
        document.getElementById('<%= hfAction.ClientID %>').value = action;
        if (action === 'saveProfile') document.getElementById('<%= btnSaveProfile.ClientID %>').click();
        else if (action === 'changePassword') document.getElementById('<%= btnChangePassword.ClientID %>').click();
        else if (action === 'verifyEmailOtp') document.getElementById('<%= btnVerifyEmailOtp.ClientID %>').click();
        else if (action === 'closeAccount') document.getElementById('<%= btnCloseAccount.ClientID %>').click();
        else if (action === 'deletePhoto') document.getElementById('<%= btnDeletePhoto.ClientID %>').click();
    }

    // send OTP
    function submitSendOtp() {
        var newEmail = document.getElementById('<%= txtNewEmail.ClientID %>').value.trim();
        if (!newEmail) { alert('Please enter a new email address.'); return; }
        document.getElementById('<%= hfNewEmail.ClientID %>').value = newEmail;
        document.getElementById('<%= hfAction.ClientID %>').value = 'sendEmailOtp';
        document.getElementById('<%= btnSendEmailOtp.ClientID %>').click();
    }

    function cancelOtp() {
        document.getElementById('otpStep').classList.remove('visible');
        document.getElementById('<%= txtEmailOtp.ClientID %>').value = '';
    }

    // preview photo and trigger upload
    function handlePhotoSelect(input) {
        if (!input.files || !input.files[0]) return;
        var file = input.files[0];
        var reader = new FileReader();
        reader.onload = function(e) {
            var img = document.getElementById('<%= imgAvatar.ClientID %>');
            img.src = e.target.result;
            img.style.display = 'block';
            document.getElementById('avatarInitial').style.display = 'none';
        };
        reader.readAsDataURL(file);
        try {
            var dt = new DataTransfer();
            dt.items.add(file);
            document.getElementById('<%= fuPhoto.ClientID %>').files = dt.files;
        } catch(e) {}
        document.getElementById('<%= btnUploadPhoto.ClientID %>').click();
    }

    // confirm close account
    function confirmClose() {
        if (confirm('Are you sure? This action cannot be undone.')) {
            submitAction('closeAccount');
        }
    }
</script>
</asp:Content>
