<%@ Page Title="Forgot Password" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="ForgotPassword.aspx.cs" Inherits="IndoSlang.ForgotPassword" %>

<asp:Content ID="HeadContent" ContentPlaceHolderID="HeadContent" runat="server">
    <style>
        /* page layout */
        .forgot-page {
            min-height: calc(100vh - 80px);
            background: var(--cream);
            display: flex;
            align-items: center;
            justify-content: center;
            padding: 42px 20px;
            font-family: var(--font-body);
        }

        /* main card */
        .forgot-card {
            width: 100%;
            max-width: 440px;
            background: #fff;
            border-radius: 26px;
            padding: 42px 42px 36px;
            box-shadow: 0 10px 35px rgba(59, 42, 26, 0.12);
            border: 2px solid rgba(59, 42, 26, 0.08);
            text-align: center;
        }

        .forgot-icon { font-size: 3rem; margin-bottom: 14px; }

        .forgot-title {
            font-family: var(--font-display);
            font-size: 1.9rem;
            color: var(--brown);
            margin: 0 0 8px;
        }

        .forgot-subtitle {
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
            transition: border-color 0.18s, box-shadow 0.18s;
        }

        .form-input:focus {
            border-color: var(--accent);
            background: #fff;
            box-shadow: 0 0 0 4px rgba(217, 123, 43, 0.12);
        }

        /* submit button */
        .btn-forgot {
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

        .btn-forgot:hover {
            background: var(--accent-light);
            transform: translateY(-2px);
        }

        .back-link {
            font-size: 0.85rem;
            color: var(--brown-mid);
        }

        .back-link a {
            color: var(--accent);
            font-weight: 700;
            text-decoration: none;
        }

        .back-link a:hover { text-decoration: underline; }
    </style>
</asp:Content>

<asp:Content ID="MainContent" ContentPlaceHolderID="MainContent" runat="server">
    <div class="forgot-page">
        <div class="forgot-card">

            <div class="forgot-icon">🔑</div>
            <h1 class="forgot-title">Forgot password?</h1>
            <p class="forgot-subtitle">No worries! Enter your email and we'll send you a verification code to reset your password.</p>

            <div class="message-box error" id="errorMsg">
                <asp:Literal ID="litError" runat="server" />
            </div>
            <div class="message-box success" id="successMsg">
                <asp:Literal ID="litSuccess" runat="server" />
            </div>

            <div class="form-group">
                <label class="form-label" for="<%= txtEmail.ClientID %>">Email address</label>
                <asp:TextBox ID="txtEmail" runat="server" CssClass="form-input" placeholder="you@email.com" TextMode="Email" />
            </div>

            <asp:Button ID="btnSendOtp" runat="server" Text="Send verification code" CssClass="btn-forgot" OnClick="btnSendOtp_Click" />

            <div class="back-link">
                Remembered it? <a href="Login.aspx">Back to sign in</a>
            </div>

        </div>
    </div>
</asp:Content>

<asp:Content ID="ScriptContent" ContentPlaceHolderID="ScriptContent" runat="server">
    <script>
        window.addEventListener('DOMContentLoaded', function () {
            var errorMsg = document.getElementById('errorMsg');
            var successMsg = document.getElementById('successMsg');

            if (errorMsg && errorMsg.innerText.trim() !== '')
                errorMsg.classList.add('visible');

            if (successMsg && successMsg.innerText.trim() !== '')
                successMsg.classList.add('visible');
        });
    </script>
</asp:Content>