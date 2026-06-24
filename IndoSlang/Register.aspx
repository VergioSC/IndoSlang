<%@ Page Title="Register" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Register.aspx.cs" Inherits="IndoSlang.Register" %>

<asp:Content ID="HeadContent" ContentPlaceHolderID="HeadContent" runat="server">
    <style>
        .register-page {
            min-height: calc(100vh - 80px);
            background: var(--cream);
            display: flex;
            align-items: center;
            justify-content: center;
            padding: 42px 20px;
            font-family: var(--font-body);
        }

        .register-card {
            width: 100%;
            max-width: 560px;
            background: #fff;
            border-radius: 26px;
            padding: 42px 42px 36px;
            box-shadow: 0 10px 35px rgba(59, 42, 26, 0.12);
            border: 2px solid rgba(59, 42, 26, 0.08);
        }

        .register-logo {
            text-align: center;
            margin-bottom: 24px;
        }

        .register-logo-icon {
            width: 64px;
            height: 64px;
            object-fit: contain;
            display: block;
            margin: 0 auto 10px;
        }

        .register-logo-name {
            display: block;
            font-family: var(--font-display);
            color: var(--brown);
            font-size: 1.5rem;
            font-weight: 700;
        }

        .register-title {
            font-family: var(--font-display);
            font-size: 1.9rem;
            color: var(--brown);
            text-align: center;
            margin: 0 0 6px;
        }

        .register-subtitle {
            color: var(--brown-mid);
            text-align: center;
            font-size: 0.9rem;
            margin: 0 0 28px;
        }

        .message-box {
            display: none;
            border-radius: 12px;
            padding: 12px 15px;
            font-size: 0.88rem;
            line-height: 1.45;
            margin-bottom: 18px;
        }

        .message-box.error {
            background: #fde8e8;
            color: #7b1515;
        }

        .message-box.success {
            background: #d4edda;
            color: #1a5c2a;
        }

        .message-box.visible {
            display: block;
        }

        .form-row {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 14px;
        }

        .form-group {
            margin-bottom: 17px;
        }

        .form-label {
            display: block;
            font-size: 0.84rem;
            font-weight: 800;
            color: var(--brown);
            margin-bottom: 6px;
        }

        .form-input {
            width: 100%;
            padding: 12px 15px;
            border: 2px solid var(--cream-mid);
            border-radius: 13px;
            background: var(--cream);
            color: var(--brown);
            font-family: var(--font-body);
            font-size: 0.95rem;
            outline: none;
            box-sizing: border-box;
            transition: border-color 0.18s ease, background 0.18s ease, box-shadow 0.18s ease;
        }

        .form-input:focus {
            border-color: var(--accent);
            background: #fff;
            box-shadow: 0 0 0 4px rgba(217, 123, 43, 0.12);
        }

        .form-input.input-error {
            border-color: #c0392b;
            background: #fff7f7;
        }

        .form-hint {
            font-size: 0.76rem;
            color: var(--brown-mid);
            margin-top: 5px;
        }

        .password-wrap {
            position: relative;
        }

        .password-wrap .form-input {
            padding-right: 46px;
        }

        .toggle-password {
            position: absolute;
            right: 13px;
            top: 50%;
            transform: translateY(-50%);
            border: none;
            background: transparent;
            color: var(--brown-mid);
            cursor: pointer;
            font-size: 1rem;
            padding: 4px;
        }

        .password-strength {
            margin-top: 7px;
        }

        .strength-track {
            height: 5px;
            border-radius: 999px;
            background: var(--cream-mid);
            overflow: hidden;
            margin-bottom: 5px;
        }

        .strength-fill {
            height: 100%;
            width: 0%;
            border-radius: 999px;
            transition: width 0.25s ease, background 0.25s ease;
        }

        .strength-label {
            color: var(--brown-mid);
            font-size: 0.76rem;
        }

        .terms-note {
            font-size: 0.78rem;
            color: var(--brown-mid);
            text-align: center;
            line-height: 1.5;
            margin: 20px 0;
        }

        .terms-note a {
            color: var(--accent);
            font-weight: 700;
            text-decoration: none;
        }

        .terms-note a:hover {
            text-decoration: underline;
        }

        .btn-register {
            width: 100%;
            border: none;
            border-radius: 14px;
            background: var(--accent);
            color: #fff;
            padding: 14px 18px;
            font-family: var(--font-display);
            font-size: 1.05rem;
            font-weight: 700;
            cursor: pointer;
            transition: background 0.18s ease, transform 0.16s ease, box-shadow 0.16s ease;
        }

        .btn-register:hover {
            background: var(--accent-light);
            transform: translateY(-2px);
            box-shadow: 0 8px 18px rgba(217, 123, 43, 0.22);
        }

        .divider {
            display: flex;
            align-items: center;
            gap: 12px;
            margin: 22px 0 18px;
        }

        .divider-line {
            flex: 1;
            height: 1px;
            background: var(--cream-mid);
        }

        .divider-text {
            color: var(--brown-mid);
            font-size: 0.78rem;
        }

        .login-link {
            text-align: center;
            font-size: 0.88rem;
            color: var(--brown-mid);
        }

        .login-link a {
            color: var(--accent);
            font-weight: 800;
            text-decoration: none;
        }

        .login-link a:hover {
            text-decoration: underline;
        }

        @media (max-width: 650px) {
            .register-card {
                padding: 34px 24px 30px;
            }

            .form-row {
                grid-template-columns: 1fr;
                gap: 0;
            }
        }
    </style>
</asp:Content>

<asp:Content ID="MainContent" ContentPlaceHolderID="MainContent" runat="server">
    <div class="register-page">
        <div class="register-card">

            <div class="register-logo">
                <img class="register-logo-icon" src="Images/OWI SPARKLE EYE BIG.png" alt="IndoSlang" />
                <span class="register-logo-name">IndoSlang</span>
            </div>

            <h1 class="register-title">Create your account</h1>
            <p class="register-subtitle">Free to join. Start learning right away!</p>

            <!--
                SERVER MESSAGE AREA

                Used by Register.aspx.cs:
                - litError.Text = "error message";
                - litSuccess.Text = "success message";

                JavaScript below will show the box only if the Literal has text.
            -->
            <div class="message-box error" id="errorMsg">
                <asp:Literal ID="litError" runat="server" />
            </div>

            <div class="message-box success" id="successMsg">
                <asp:Literal ID="litSuccess" runat="server" />
            </div>

            <!--
                DATABASE MAPPING:
                User.FirstName
                User.LastName
            -->
            <div class="form-row">
                <div class="form-group">
                    <label class="form-label" for="<%= txtFirstName.ClientID %>">First name</label>
                    <asp:TextBox ID="txtFirstName" runat="server" CssClass="form-input" placeholder="Your first name" />
                </div>

                <div class="form-group">
                    <label class="form-label" for="<%= txtLastName.ClientID %>">Last name</label>
                    <asp:TextBox ID="txtLastName" runat="server" CssClass="form-input" placeholder="Your last name" />
                </div>
            </div>

            <!--
                DATABASE MAPPING:
                User.Email

                Backend should check if email already exists before INSERT.
            -->
            <div class="form-group">
                <label class="form-label" for="<%= txtEmail.ClientID %>">Email address</label>
                <asp:TextBox ID="txtEmail" runat="server" CssClass="form-input" placeholder="you@email.com" TextMode="Email" />
            </div>

            <!--
                DATABASE MAPPING:
                User.Username

                Backend should check if username already exists before INSERT.
            -->
            <div class="form-group">
                <label class="form-label" for="<%= txtUsername.ClientID %>">Username</label>
                <asp:TextBox ID="txtUsername" runat="server" CssClass="form-input" placeholder="Choose a username" />
                <div class="form-hint">Use a simple username without spaces.</div>
            </div>

            <!--
                DATABASE MAPPING:
                User.PasswordHash

                Important:
                Do NOT store plain password.
                Register.aspx.cs should hash password first, then insert into PasswordHash.
            -->
            <div class="form-group">
                <label class="form-label" for="<%= txtPassword.ClientID %>">Password</label>

                <div class="password-wrap">
                    <asp:TextBox ID="txtPassword" runat="server" CssClass="form-input" placeholder="Min. 8 characters" TextMode="Password" />
                    <button type="button" class="toggle-password" onclick="togglePassword('<%= txtPassword.ClientID %>', this)">👁</button>
                </div>

                <div class="password-strength">
                    <div class="strength-track">
                        <div class="strength-fill" id="pwStrengthFill"></div>
                    </div>
                    <div class="strength-label" id="pwStrengthLabel">Password strength</div>
                </div>
            </div>

            <div class="form-group">
                <label class="form-label" for="<%= txtConfirmPassword.ClientID %>">Confirm password</label>

                <div class="password-wrap">
                    <asp:TextBox ID="txtConfirmPassword" runat="server" CssClass="form-input" placeholder="Repeat your password" TextMode="Password" />
                    <button type="button" class="toggle-password" onclick="togglePassword('<%= txtConfirmPassword.ClientID %>', this)">👁</button>
                </div>
            </div>

            <!--
                DEFAULT DATABASE VALUES TO SET IN Register.aspx.cs:
                RoleID = 2
                CurrentLevel = "Beginner"
                Status = "Active"
                CreatedAt = GETDATE()
                ProfileImage = NULL or empty string
            -->
            <p class="terms-note">
                By registering, you agree to use IndoSlang responsibly.
            </p>

            <asp:Button ID="btnRegister" runat="server" Text="Create account" CssClass="btn-register" OnClick="btnRegister_Click" />

            <div class="divider">
                <div class="divider-line"></div>
                <span class="divider-text">already have an account?</span>
                <div class="divider-line"></div>
            </div>

            <div class="login-link">
                <a href="Login.aspx">Sign in instead →</a>
            </div>

        </div>
    </div>
</asp:Content>

<asp:Content ID="ScriptContent" ContentPlaceHolderID="ScriptContent" runat="server">
    <script>
        window.addEventListener('DOMContentLoaded', function () {
            showServerMessages();
            setupPasswordStrength();
        });

        function showServerMessages() {
            var errorMsg = document.getElementById('errorMsg');
            var successMsg = document.getElementById('successMsg');

            if (errorMsg && errorMsg.innerText.trim() !== '') {
                errorMsg.classList.add('visible');
            }

            if (successMsg && successMsg.innerText.trim() !== '') {
                successMsg.classList.add('visible');
            }
        }

        function togglePassword(clientId, btn) {
            var field = document.getElementById(clientId);

            if (!field) {
                return;
            }

            if (field.type === 'password') {
                field.type = 'text';
                btn.textContent = '🙈';
            } else {
                field.type = 'password';
                btn.textContent = '👁';
            }
        }

        function setupPasswordStrength() {
            var passwordInput = document.getElementById('<%= txtPassword.ClientID %>');

            if (!passwordInput) {
                return;
            }

            passwordInput.addEventListener('input', function () {
                updatePasswordStrength(passwordInput.value);
            });
        }

        function updatePasswordStrength(password) {
            var fill = document.getElementById('pwStrengthFill');
            var label = document.getElementById('pwStrengthLabel');

            if (!fill || !label) {
                return;
            }

            var strength = 0;

            if (password.length >= 8) strength++;
            if (password.length >= 12) strength++;
            if (/[A-Z]/.test(password)) strength++;
            if (/[0-9]/.test(password)) strength++;
            if (/[^A-Za-z0-9]/.test(password)) strength++;

            var percentage = (strength / 5) * 100;
            fill.style.width = percentage + '%';

            if (password.length === 0) {
                fill.style.width = '0%';
                fill.style.background = 'transparent';
                label.textContent = 'Password strength';
                return;
            }

            if (strength <= 1) {
                fill.style.background = '#c0392b';
                label.textContent = 'Weak';
            } else if (strength <= 3) {
                fill.style.background = 'var(--accent)';
                label.textContent = 'Medium';
            } else {
                fill.style.background = 'var(--green)';
                label.textContent = 'Strong';
            }
        }
    </script>
</asp:Content>