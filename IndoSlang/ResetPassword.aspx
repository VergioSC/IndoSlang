<%@ Page Title="Reset Password" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="ResetPassword.aspx.cs" Inherits="IndoSlang.ResetPassword" %>

<asp:Content ID="HeadContent" ContentPlaceHolderID="HeadContent" runat="server">
    <style>
        /* page layout */
        .reset-page {
            min-height: calc(100vh - 80px);
            background: var(--cream);
            display: flex;
            align-items: center;
            justify-content: center;
            padding: 42px 20px;
            font-family: var(--font-body);
        }

        /* main card */
        .reset-card {
            width: 100%;
            max-width: 440px;
            background: #fff;
            border-radius: 26px;
            padding: 42px 42px 36px;
            box-shadow: 0 10px 35px rgba(59, 42, 26, 0.12);
            border: 2px solid rgba(59, 42, 26, 0.08);
            text-align: center;
        }

        .reset-icon { font-size: 3rem; margin-bottom: 14px; }

        .reset-title {
            font-family: var(--font-display);
            font-size: 1.9rem;
            color: var(--brown);
            margin: 0 0 8px;
        }

        .reset-subtitle {
            color: var(--brown-mid);
            font-size: 0.9rem;
            margin: 0 0 28px;
        }

        /* message boxes */
        .message-box {
            display: none;
            border-radius: 12px;
            padding: 12px 15px;
            font-size: 0.88rem;
            margin-bottom: 18px;
            text-align: left;
        }

        .message-box.error { background: #fde8e8; color: #7b1515; }
        .message-box.success { background: #d4edda; color: #1a5c2a; }
        .message-box.visible { display: block; }

        /* form */
        .form-group { margin-bottom: 18px; text-align: left; }

        .form-label {
            display: block;
            font-size: 0.84rem;
            font-weight: 800;
            color: var(--brown);
            margin-bottom: 6px;
        }

        .password-wrap { position: relative; }

        .form-input {
            width: 100%;
            padding: 12px 46px 12px 15px;
            border: 2px solid var(--cream-mid);
            border-radius: 13px;
            background: var(--cream);
            color: var(--brown);
            font-family: var(--font-body);
            font-size: 0.95rem;
            outline: none;
            box-sizing: border-box;
            transition: border-color 0.18s, box-shadow 0.18s;
        }

        .form-input:focus {
            border-color: var(--accent);
            background: #fff;
            box-shadow: 0 0 0 4px rgba(217, 123, 43, 0.12);
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

        /* strength bar */
        .password-strength { margin-top: 7px; }

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
            transition: width 0.25s, background 0.25s;
        }

        .strength-label { color: var(--brown-mid); font-size: 0.76rem; }

        /* submit button */
        .btn-reset {
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
            transition: background 0.18s, transform 0.16s;
            margin-bottom: 20px;
        }

        .btn-reset:hover {
            background: var(--accent-light);
            transform: translateY(-2px);
        }
    </style>
</asp:Content>

<asp:Content ID="MainContent" ContentPlaceHolderID="MainContent" runat="server">
    <div class="reset-page">
        <div class="reset-card">

            <div class="reset-icon">🔒</div>
            <h1 class="reset-title">Reset your password</h1>
            <p class="reset-subtitle">Choose a strong new password for your account.</p>

            <div class="message-box error" id="errorMsg">
                <asp:Literal ID="litError" runat="server" />
            </div>
            <div class="message-box success" id="successMsg">
                <asp:Literal ID="litSuccess" runat="server" />
            </div>

            <div class="form-group">
                <label class="form-label" for="<%= txtPassword.ClientID %>">New password</label>
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
                <label class="form-label" for="<%= txtConfirmPassword.ClientID %>">Confirm new password</label>
                <div class="password-wrap">
                    <asp:TextBox ID="txtConfirmPassword" runat="server" CssClass="form-input" placeholder="Repeat your password" TextMode="Password" />
                    <button type="button" class="toggle-password" onclick="togglePassword('<%= txtConfirmPassword.ClientID %>', this)">👁</button>
                </div>
            </div>

            <asp:Button ID="btnReset" runat="server" Text="Reset password" CssClass="btn-reset" OnClick="btnReset_Click" />

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

            if (errorMsg && errorMsg.innerText.trim() !== '')
                errorMsg.classList.add('visible');

            if (successMsg && successMsg.innerText.trim() !== '')
                successMsg.classList.add('visible');
        }

        function togglePassword(clientId, btn) {
            var field = document.getElementById(clientId);
            if (!field) return;

            if (field.type === 'password') {
                field.type = 'text';
                btn.textContent = '🙈';
            } else {
                field.type = 'password';
                btn.textContent = '👁';
            }
        }

        function setupPasswordStrength() {
            var input = document.getElementById('<%= txtPassword.ClientID %>');
            if (!input) return;
            input.addEventListener('input', function () {
                updateStrength(input.value);
            });
        }

        function updateStrength(password) {
            var fill  = document.getElementById('pwStrengthFill');
            var label = document.getElementById('pwStrengthLabel');
            if (!fill || !label) return;

            var strength = 0;
            if (password.length >= 8) strength++;
            if (password.length >= 12) strength++;
            if (/[A-Z]/.test(password)) strength++;
            if (/[0-9]/.test(password)) strength++;
            if (/[^A-Za-z0-9]/.test(password)) strength++;

            fill.style.width = (strength / 5 * 100) + '%';

            if (password.length === 0) {
                fill.style.background = 'transparent';
                label.textContent = 'Password strength';
                return;
            }

            if (strength <= 1) { fill.style.background = '#c0392b'; label.textContent = 'Weak'; }
            else if (strength <= 3) { fill.style.background = 'var(--accent)'; label.textContent = 'Medium'; }
            else { fill.style.background = 'var(--green)'; label.textContent = 'Strong'; }
        }
    </script>
</asp:Content>