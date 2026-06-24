<%@ Page Title="Sign In" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Login.aspx.cs" Inherits="IndoSlang.Login" %>

<asp:Content ID="HeadContent" ContentPlaceHolderID="HeadContent" runat="server">
    <style>
        .login-wrapper {
            min-height: calc(100vh - 60px);
            display: flex;
            align-items: center;
            justify-content: center;
            background: var(--cream);
            padding: 40px 20px;
            font-family: var(--font-body);
        }

        .login-card {
            background: #fff;
            border-radius: 24px;
            padding: 48px 44px;
            width: 100%;
            max-width: 440px;
            box-shadow: 0 8px 40px rgba(59,42,26,0.12);
        }

        .login-logo {
            text-align: center;
            margin-bottom: 28px;
        }

        .login-logo .logo-icon {
            width: 64px;
            height: 64px;
            object-fit: contain;
            display: block;
            margin: 0 auto 6px;
        }

        .login-logo .logo-name {
            font-family: var(--font-display);
            font-size: 1.5rem;
            color: var(--brown);
        }

        .login-title {
            font-family: var(--font-display);
            font-size: 1.8rem;
            color: var(--brown);
            margin-bottom: 6px;
            text-align: center;
        }

        .login-subtitle {
            font-size: 0.88rem;
            color: var(--brown-mid);
            text-align: center;
            margin-bottom: 32px;
        }

        .form-group {
            margin-bottom: 18px;
        }

        .form-label {
            display: block;
            font-size: 0.85rem;
            font-weight: 700;
            color: var(--brown);
            margin-bottom: 6px;
        }

        .form-input {
            width: 100%;
            padding: 12px 16px;
            border: 2px solid var(--cream-mid);
            border-radius: 12px;
            font-family: var(--font-body);
            font-size: 0.95rem;
            color: var(--brown);
            background: var(--cream);
            outline: none;
            transition: border-color 0.2s;
            box-sizing: border-box;
        }

        .form-input:focus { border-color: var(--accent); }

        .form-input.error { border-color: #c0392b; }

        .forgot-link {
            text-align: right;
            margin-top: -10px;
            margin-bottom: 18px;
        }

        .forgot-link a {
            font-size: 0.82rem;
            color: var(--accent);
            text-decoration: none;
        }

        .forgot-link a:hover { text-decoration: underline; }

        .error-msg {
            background: #fde8e8;
            color: #7b1515;
            border-radius: 10px;
            padding: 10px 16px;
            font-size: 0.88rem;
            margin-bottom: 18px;
            display: none;
        }

        .error-msg.visible { display: block; }

        .btn-login {
            width: 100%;
            background: var(--brown);
            color: #fff;
            border: none;
            padding: 14px;
            border-radius: 12px;
            font-family: var(--font-display);
            font-size: 1.05rem;
            cursor: pointer;
            transition: background 0.2s, transform 0.15s;
            margin-bottom: 20px;
        }

        .btn-login:hover { background: var(--brown-mid); transform: translateY(-2px); }

        .divider {
            display: flex;
            align-items: center;
            gap: 12px;
            margin-bottom: 20px;
        }

        .divider-line {
            flex: 1;
            height: 1px;
            background: var(--cream-mid);
        }

        .divider-text {
            font-size: 0.8rem;
            color: var(--brown-mid);
        }

        .register-prompt {
            text-align: center;
            font-size: 0.88rem;
            color: var(--brown-mid);
        }

        .register-prompt a {
            color: var(--accent);
            font-weight: 700;
            text-decoration: none;
        }

        .register-prompt a:hover { text-decoration: underline; }

    </style>
</asp:Content>

<asp:Content ID="MainContent" ContentPlaceHolderID="MainContent" runat="server">
    <div class="login-wrapper">
        <div class="login-card">

            <div class="login-logo">
                <img class="logo-icon" src="Images/OWI SPARKLE EYE BIG.png" alt="IndoSlang" />
                <span class="logo-name">IndoSlang</span>
            </div>

            <h1 class="login-title">Welcome back!</h1>
            <p class="login-subtitle">Sign in to continue learning</p>

            <!-- Error message -->
            <div class="error-msg" id="errorMsg">
                <asp:Literal ID="litError" runat="server" />
            </div>

            <!-- Form -->
            <div class="form-group">
                <label class="form-label" for="txtEmail">Email address</label>
                <asp:TextBox ID="txtEmail" runat="server" CssClass="form-input" placeholder="you@email.com" TextMode="Email" />
            </div>

            <div class="form-group">
                <label class="form-label" for="txtPassword">Password</label>
                <asp:TextBox ID="txtPassword" runat="server" CssClass="form-input" placeholder="Enter your password" TextMode="Password" />
            </div>

            <div class="forgot-link">
                <a href="ForgotPassword.aspx">Forgot password?</a>
            </div>

            <asp:Button ID="btnLogin" runat="server" Text="Sign In →" CssClass="btn-login" OnClick="btnLogin_Click" />

            <div class="divider">
                <div class="divider-line"></div>
                <span class="divider-text">don't have an account?</span>
                <div class="divider-line"></div>
            </div>

            <div class="register-prompt">
                <a href="OnBoarding.aspx">Create a free account →</a>
            </div>

        </div>
    </div>
</asp:Content>

<asp:Content ID="ScriptContent" ContentPlaceHolderID="ScriptContent" runat="server">
    <script>
window.addEventListener('DOMContentLoaded', function () {
    var box = document.getElementById('errorMsg');
    if (box && box.innerText.trim() !== '') {
        box.classList.add('visible');
    }
});
</script>
</asp:Content>